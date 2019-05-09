package haxe.ui.backend.qt;

import qt.core.Orientation;

class EnumHelper {
    public static function parse(s:String):Dynamic {
        switch (s) {
            case "Orientation.Horizontal":
                return Orientation.Horizontal;
            case "Orientation.Vertical":
                return Orientation.Vertical;
        }
        return null;
    }
}