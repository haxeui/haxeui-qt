package haxe.ui.backend.qt.size;

import haxe.ui.layouts.DelegateLayout.DelegateLayoutSize;

class WidgetSize extends DelegateLayoutSize {
    private override function get_width():Float {
        var cx = component.widget.width;
        if (component.widget.childrenRect.width != 0) {
            //cx = component.widget.childrenRect.width;
        }
        return cx;
    }

    private override function get_height():Float {
        var cy = component.widget.height;
        if (component.widget.childrenRect.height != 0) {
            //cy = component.widget.childrenRect.height;
        }
        return cy;
    }
}