package haxe.ui.backend.qt.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.data.DataSource;
import qt.gui.Icon;
import qt.gui.Pixmap;
import qt.widgets.ListWidget;
import qt.widgets.ListWidgetItem;

class ListWidgetDataSource extends DataBehaviour {
    public override function validateData() {
        if (_component.widget == null) {
            return;
        }
return;
        var widget:ListWidget = cast(_component.widget, ListWidget);
        widget.clear();
        
        if (_value.isNull) {
            return;
        }

        var ds:DataSource<Dynamic> = _value;
        for (n in 0...ds.size) {
            var item = ds.get(n);
            if (item.value != null) {
                var listItem = new ListWidgetItem();
                listItem.text = item.value;
                if (item.icon != null) {
                    var pixmap = Pixmap.fromResource(item.icon);
                    var icon = new Icon(pixmap);
                    listItem.icon = icon;
                }
                
                widget.addItem(listItem);
            }
        }
    }
}