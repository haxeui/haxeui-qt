package haxe.ui.backend.qt;

import haxe.ui.backend.ComponentImpl;
import haxe.ui.components.Button;
import haxe.ui.styles.Style;

typedef StyleResult = {
    var styleString:String;
    var adjustSize:Bool;
}

@:access(haxe.ui.backend.ComponentBase)
class StyleHelper {
    public static function buildStyleString(style:Style, component:ComponentImpl):StyleResult {
        if (style == null) {
            return null;
        }

        var s = new StringBuf();
        var adjustSize:Bool = false;
        
        if (style.backgroundColor != null && (style.backgroundColor == style.backgroundColorEnd || style.backgroundColorEnd == null)) { // block colour
            s.add("background-color:#");
            s.add(StringTools.hex(style.backgroundColor, 6));
            s.add(";");
        } else if (style.backgroundColor != null && style.backgroundColorEnd != null) { // gradient
            var gradientStyle = style.backgroundGradientStyle;
            if (gradientStyle == null) {
                gradientStyle = "vertical";
            }
            
            s.add("background:");
            
            switch (gradientStyle) {
                case "vertical":
                    s.add("qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #");
                    s.add(StringTools.hex(style.backgroundColor, 6));
                    s.add(", stop: 1 #");
                    s.add(StringTools.hex(style.backgroundColorEnd, 6));
                    s.add(")");
                case "horizontal":
                    s.add("qlineargradient(x1: 0, y1: 0, x2: 1, y2: 0,stop: 0 #");
                    s.add(StringTools.hex(style.backgroundColor, 6));
                    s.add(", stop: 1 #");
                    s.add(StringTools.hex(style.backgroundColorEnd, 6));
                    s.add(")");
            }
            
            s.add(";");
        }
        
        if (style.fontSize != null) {
            s.add("font-size:");
            s.add(style.fontSize);
            s.add("px;");
            adjustSize = true;
        }
        
        if (style.borderColor != null && style.borderLeftSize != null && style.borderLeftSize > 0) {
            s.add("border:");
            s.add(style.borderLeftSize);
            s.add("px solid #");
            s.add(StringTools.hex(style.borderColor, 6));
            s.add(";");            
        }
        
        if (style.borderRadius != null) {
            s.add("border-radius:");
            s.add(style.borderRadius);
            s.add("px;");
        }
        
        if (style.color != null) {
            s.add("color:#");
            s.add(StringTools.hex(style.color, 6));
            s.add(";");            
        }
        
        var allowPadding = component.getNativeConfigPropertyBool(".@allowPadding");
        if (style.paddingLeft != null && allowPadding == true) {
            s.add("padding-left:");
            s.add(style.paddingLeft);
            s.add("px;"); 
            adjustSize = true;
        }
        if (style.paddingRight != null && allowPadding == true) {
            s.add("padding-right:");
            s.add(style.paddingRight);
            s.add("px;"); 
            adjustSize = true;
        }
        if (style.paddingTop != null && allowPadding == true) {
            s.add("padding-top:");
            s.add(style.paddingTop);
            s.add("px;"); 
            adjustSize = true;
        }
        if (style.paddingBottom != null && allowPadding == true) {
            s.add("padding-bottom:");
            s.add(style.paddingBottom);
            s.add("px;"); 
            adjustSize = true;
        }
        
        return {
            styleString: s.toString(),
            adjustSize: adjustSize
        }
    }
}