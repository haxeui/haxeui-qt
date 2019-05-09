package haxe.ui.backend;
import haxe.ui.core.Platform;

class PlatformImpl extends PlatformBase {
    public override function getMetric(id:String):Float {
        switch (id) {
            case Platform.METRIC_VSCROLL_WIDTH:
                return 16;
            case Platform.METRIC_HSCROLL_HEIGHT:
                return 16;
        }
        return 0;
    }
}