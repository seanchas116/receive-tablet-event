#include <nan.h>
#include <iostream>
#include <set>
#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>

std::set<NSWindow *> targetWindows;

@implementation NSWindow(InterceptTabletEvent)

-(void)sendEventIntercept:(NSEvent *)event
{
  CGPoint pos = event.locationInWindow;
  std::cout << "event at (" << pos.x << "," << pos.y << ")" << std::endl;
  [self sendEventIntercept:event];
}

+(void)switchSendEvent
{
  [self switchMethodFrom:@selector(sendEvent:) to:@selector(sendEventIntercept:)];
}

+(void)switchMethodFrom:(SEL)from to:(SEL)to
{
  Method fromMethod = class_getInstanceMethod(self, from);
  Method toMethod = class_getInstanceMethod(self, to);
  method_exchangeImplementations(fromMethod, toMethod);
}

@end

void intercept(const Nan::FunctionCallbackInfo<v8::Value> &info) {
  if (info.Length() != 1) {
    Nan::ThrowTypeError("Wrong number of arguments");
    return;
  }

  char *buf = node::Buffer::Data(info[0]);
  NSView *view = *reinterpret_cast<NSView **>(buf);
  NSWindow *window = view.window;

  std::cout << window << std::endl;

  targetWindows.insert(window);

  info.GetReturnValue().Set(Nan::Undefined());
}

void init(v8::Local<v8::Object> exports) {
  [NSWindow switchSendEvent];

  exports->Set(Nan::New("intercept").ToLocalChecked(),
               Nan::New<v8::FunctionTemplate>(intercept)->GetFunction());
}

NODE_MODULE(intercept_tablet_event, init)
