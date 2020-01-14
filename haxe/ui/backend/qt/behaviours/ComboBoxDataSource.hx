package haxe.ui.backend.qt.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.data.DataSource;
import qt.widgets.ComboBox;

class ComboBoxDataSource extends DataBehaviour {
    public override function validateData() {
        if (_component.widget == null) {
            return;
        }

        var widget:ComboBox = cast(_component.widget, ComboBox);
        widget.clear();
        
        if (_value.isNull) {
            return;
        }

        var ds:DataSource<Dynamic> = _value;
        for (n in 0...ds.size) {
            var item = ds.get(n);
            if (item.value != null) {
                widget.addItem(item.value);
            }
        }
    }
}