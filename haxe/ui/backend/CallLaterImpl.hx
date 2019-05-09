package haxe.ui.backend;

import haxe.ui.core.Screen;
import qt.core.Event;
import qt.core.Object;

class CallLaterImpl extends Object {
    private var _fn:Void->Void;
    public function new(fn:Void->Void) {
        super();
        _fn = fn;
        Screen.instance.options.app.postEvent(this, new Event(1234));
        //fn();
    }
    
    public override function event(event:Event) {
        if (event.type == 1234) {
            _fn();
        }
    }
}