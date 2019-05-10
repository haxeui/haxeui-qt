package haxe.ui.backend.qt.size;

class TabWidgetSize extends WidgetSize {
    private override function get_usableWidthModifier():Float {
        return component.widget.childrenRect.width;
    }
    
    private override function get_usableHeightModifier():Float {
        return component.widget.childrenRect.height;
    }
}