package haxe.ui.backend;

import qt.core.Timer;

class TimerImpl {
    private var _timer:Timer;
    private var _callback:Void->Void;

    public function new(delay:Int, callback:Void->Void) {
        _callback = callback;
        _timer = new Timer();
        _timer.connectTimeout(onTimer);
        _timer.start(delay);
    }

    private function onTimer() {
        if (_callback != null) {
            _callback();
        }
    }
    
    public function stop() {
        _callback = null;
        _timer.stop();
        _timer.destroy();
    }
}
