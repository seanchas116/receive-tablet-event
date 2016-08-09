import {EventEmitter} from "events";

type PointerTypes = "eraser" | "pen" | "cursor" | "unknown";

export interface ProximityEvent {
  pointerType: PointerTypes;
  pointerId: number;
}

export interface TabletEvent {
  altKey: boolean;
  ctrlKey: boolean;
  metaKey: boolean;
  shiftKey: boolean;
  clientX: number;
  clientY: number;
  screenX: number;
  screenY: number;
  pressure: number;
  // TODO
  // tiltX: number;
  // tiltY: number;
  pointerType: PointerTypes;
  pointerId: number;
}

export declare class TabletEventReceiver extends EventEmitter {
  constructor(windowHandle: Buffer);
  on(name: "enterProximity", callback: (event: ProximityEvent) => void): void;
  on(name: "leaveProximity", callback: (event: ProximityEvent) => void): void;
  on(name: "down", callback: (event: TabletEvent) => void): void;
  on(name: "up", callback: (event: TabletEvent) => void): void;
  on(name: "move", callback: (event: TabletEvent) => void): void;
  dispose(): void;
}
