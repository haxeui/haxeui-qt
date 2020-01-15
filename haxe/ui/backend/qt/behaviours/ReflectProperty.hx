package haxe.ui.backend.qt.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;

class ReflectProperty extends DataBehaviour {
    public override function validateData() {
        var targetProp = getConfigValue("targetProperty");
        if (targetProp == null) {
            targetProp = this.id;
        }
        
        try {
            Reflect.setProperty(_component.widget, targetProp, Variant.toDynamic(_value));
            _component.widget.adjustSize();
        } catch (e:Dynamic) {
            trace("WARNING: problem setting " + Type.getClassName(Type.getClass(_component.widget)) + "." + targetProp + " property (" + e + ")");
        }
    }
    
    public override function get():Variant {
        if (_component.native == true) {
            var targetProp = getConfigValue("targetProperty");
            if (targetProp == null) {
                targetProp = this.id;
            }
            
            var r = null;
            try {
                r = Variant.fromDynamic(Reflect.getProperty(_component.widget, targetProp));
            } catch (e:Dynamic) {
                trace("WARNING: problem getting " + Type.getClassName(Type.getClass(_component.widget)) + "." + targetProp + " property (" + e + ")");
            }
            
            return r;
        }
        
        return super.get();
    }
}