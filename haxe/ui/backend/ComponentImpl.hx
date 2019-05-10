package haxe.ui.backend;

import haxe.ui.backend.qt.StyleHelper;
import haxe.ui.backend.qt.initializers.Initializer;
import haxe.ui.core.Screen;
import haxe.ui.styles.Style;
import qt.widgets.ScrollArea;
import qt.widgets.TabWidget;
import qt.widgets.Widget;

class ComponentImpl extends ComponentBase {
    public var widget:Widget;
    
    public override function handleReady() {
        if (parentComponent == null) {
            createWidget();
        } else {
            if (Std.is(parentComponent.widget, ScrollArea)) { // special case for scrollarea
                createWidget(cast(parentComponent.widget, ScrollArea).widget);
                cast(parentComponent.widget, ScrollArea).widget.adjustSize();
            } else if (Std.is(parentComponent.widget, TabWidget)) { // special case for tab
                createWidget(parentComponent.widget);
                cast(parentComponent.widget, TabWidget).addTab(this.widget, this.text);
            } else {
                createWidget(parentComponent.widget);
            }
        }
    }
    
    public function createWidget(parent:Widget = null) {
        if (widget != null) {
            return;
        }
        if (parent == null) {
            parent = Screen.instance.centralWidget;
        }
        var className:String = Type.getClassName(Type.getClass(this));
        var nativeComponentClass:String = Toolkit.nativeConfig.query('component[id=${className}].@class', 'qt.widgets.Widget', this);
        
        var params = [];
        widget = Type.createInstance(Type.resolveClass(nativeComponentClass), params);
        widget.parent = parent;
        
        var initializers:String = Toolkit.nativeConfig.query('component[id=${className}].@initializers', null, this);       
        if (initializers != null) {
            for (i in initializers.split(";")) {
                i = StringTools.trim(i);
                if (i.length == 0) {
                    continue;
                }
                var instance:Initializer = Type.createInstance(Type.resolveClass(i), []);
                instance.run(this);
            }
        }
        
        widget.show();
    }
    
    private override function handlePosition(left:Null<Float>, top:Null<Float>, style:Style):Void {
        if (widget == null) {
            return;
        }
        
        widget.move(Std.int(left), Std.int(top));
    }
    
    private override function handleSize(width:Null<Float>, height:Null<Float>, style:Style) {
        if (width == null || height == null || width <= 0 || height <= 0) {
            return;
        }

        if (widget == null) {
            return;
        }

        var w:Int = Std.int(width);
        var h:Int = Std.int(height);
        
        widget.resize(w, h);
        
        if (Std.is(this.widget, ScrollArea)) { // special case for scrollarea
            cast(this.widget, ScrollArea).widget.adjustSize();
        }
    }

    private override function applyStyle(style:Style) {
        if (widget != null) {
            var result = StyleHelper.buildStyleString(style, this);
            if (result != null) {
                widget.styleSheet = result.styleString;
                if (result.adjustSize == true) {
                    widget.adjustSize();
                }
            }
        }
    }
}