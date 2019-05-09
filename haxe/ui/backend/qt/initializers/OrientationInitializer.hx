package haxe.ui.backend.qt.initializers;
import qt.core.Orientation;
import qt.widgets.ProgressBar;
import qt.widgets.Slider;

class OrientationInitializer extends Initializer {
    public override function run(component:ComponentImpl) {
        var className:String = Type.getClassName(Type.getClass(component));
        var value = Toolkit.nativeConfig.query('component[id=${className}].@orientation', null, this);
        if (value == null) {
            return;
        }
        if (Std.is(component.widget, Slider)) {
            cast(component.widget, Slider).orientation = orientation(value);
        } else if (Std.is(component.widget, ProgressBar)) {
            cast(component.widget, ProgressBar).orientation = orientation(value);
        }
    }
    
    private inline function orientation(value:String):Orientation {
        if (value == "vertical") {
            return Orientation.Vertical;
        }
        return Orientation.Horizontal;
    }
}