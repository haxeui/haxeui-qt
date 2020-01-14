package haxe.ui.backend.qt.size;
import qt.widgets.TabWidget;

class TabWidgetSize extends WidgetSize {
    private override function get_usableWidthModifier():Float {
        return 3; // TODO: calc
    }
    
    private override function get_usableHeightModifier():Float {
        return 28; // TODO: calc
    }
}