package haxe.ui.backend.qt.size;

import qt.widgets.AbstractScrollArea;

class ScrollAreaSize extends WidgetSize {
    private override function get_usableWidthModifier():Float {
        trace("------------------------------------------------ here w");
        if (cast(component.widget, AbstractScrollArea).hasVerticalScrollBar == true) {
            return 16; // TODO: calc
        }
        return 2; // TODO: calc
    }
    
    private override function get_usableHeightModifier():Float {
        trace("------------------------------------------------ here h");
        if (cast(component.widget, AbstractScrollArea).hasHorizontalScrollBar == true) {
            return 16;  // TODO: calc
        }
        
        return 2; // TODO: calc
    }
}