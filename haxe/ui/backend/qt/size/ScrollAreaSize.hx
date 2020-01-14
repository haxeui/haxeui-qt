package haxe.ui.backend.qt.size;

import haxe.ui.core.Platform;
import qt.widgets.AbstractScrollArea;

class ScrollAreaSize extends WidgetSize {
    private override function get_usableWidthModifier():Float {
        if (cast(component.widget, AbstractScrollArea).hasVerticalScrollBar == true) {
            return Platform.vscrollWidth; // TODO: calc
        }
        return 2; // TODO: calc
    }
    
    private override function get_usableHeightModifier():Float {
        if (cast(component.widget, AbstractScrollArea).hasHorizontalScrollBar == true) {
            return Platform.hscrollHeight;  // TODO: calc
        }
        
        return 2; // TODO: calc
    }
}