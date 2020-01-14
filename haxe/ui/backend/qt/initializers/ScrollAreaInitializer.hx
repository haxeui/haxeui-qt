package haxe.ui.backend.qt.initializers;

import qt.widgets.ScrollArea;
import qt.widgets.Widget;

class ScrollAreaInitializer extends Initializer {
    public override function run(component:ComponentImpl) {
        trace(component.widget);
        var scrollArea:ScrollArea = cast(component.widget);
        trace(scrollArea);
        //scrollArea.widgetResizable = true;
        var widget = new Widget();
        scrollArea.widget = widget;
        widget.adjustSize();
    }
}