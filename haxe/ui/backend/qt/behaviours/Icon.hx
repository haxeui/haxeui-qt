package haxe.ui.backend.qt.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import qt.gui.Pixmap;
import qt.widgets.AbstractButton;

class Icon extends DataBehaviour {
    public override function validateData() {
        if (_component.widget == null) {
            return;
        }
        
        if (Std.is(_component.widget, AbstractButton)) {
            var button = cast(_component.widget, AbstractButton);
            var pixmap = Pixmap.fromResource(_value);
            var icon = new qt.gui.Icon(pixmap);
            button.icon = icon;
        }
        trace(_value);
    }
}