package haxe.ui.backend;

import haxe.ui.backend.qt.StyleHelper;
import haxe.ui.backend.qt.initializers.Initializer;
import haxe.ui.core.Component;
import haxe.ui.core.Screen;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.styles.Style;
import qt.widgets.ScrollArea;
import qt.widgets.TabWidget;
import qt.widgets.Widget;

class ComponentImpl extends ComponentBase {
    private var _eventMap:Map<String, UIEvent->Void>;
    public var widget:Widget = null;
    
    public function new() {
        super();
        _eventMap = new Map<String, UIEvent->Void>();
    }
    
    public override function handleReady() {
        if (widget != null) {
            return;
        }
        
        if (parentComponent == null) {
            createWidget();
        } else {
            if (Std.is(parentComponent.widget, ScrollArea)) { // special case for scrollarea
                createWidget(cast(parentComponent.widget, ScrollArea).widget, false);
                cast(parentComponent.widget, ScrollArea).widget = widget;
                cast(parentComponent.widget, ScrollArea).widget.adjustSize();
            } else if (Std.is(parentComponent.widget, TabWidget)) { // special case for tab
                createWidget(parentComponent.widget, false);
                cast(this, Component).addClass("tabview-content");
                cast(parentComponent.widget, TabWidget).addTab(this.widget, this.text);
            } else {
                createWidget(parentComponent.widget);
            }
        }
    }
    
    public function createWidget(parent:Widget = null, setParent:Bool = true) {
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
        if (setParent == true) {
            widget.parent = parent;
        }
        
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
        
        if (__eventsToMap != null) {
            for (type in __eventsToMap.keys()) {
                mapEvent(type, __eventsToMap.get(type));
            }
            __eventsToMap = null;
        }
        
        if (setParent == true) {
            widget.show();
        }
        
        // TODO: not good at all! Need to work out when a widget is "ready" from a qt perspective
        haxe.ui.util.Timer.delay(function() {
            if (parentComponent != null) {
                parentComponent.invalidateComponentLayout();
            }
            //invalidateComponentLayout();
        }, 50);
        
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

        //trace(">>>> setting " + this + "(" + this.id + ")" + " to " + width + "x" + height);
        
        var w:Int = Std.int(width);
        var h:Int = Std.int(height);
        
        widget.resize(w, h);

        if (this.parentComponent != null && Std.is(this.parentComponent.widget, ScrollArea)) { // special case for scrollarea
            //cast(this.parentComponent.widget, ScrollArea).widget.adjustSize();
            //this.parentComponent.invalidateComponent();
        }
        if (Std.is(this.widget, ScrollArea)) { // special case for scrollarea
            //cast(this.widget, ScrollArea).widget.adjustSize();
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
    
    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private var __eventsToMap:Map<String, UIEvent->Void>;
    private override function mapEvent(type:String, listener:UIEvent->Void) {
        if (widget == null) {
            if (__eventsToMap == null) {
                __eventsToMap = new Map<String, UIEvent->Void>();
            }
            __eventsToMap.set(type, listener);
            return;
        }
        
        switch (type) {
            case MouseEvent.CLICK:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    if (Std.is(widget, qt.widgets.PushButton)) {
                        cast(widget, qt.widgets.PushButton).connectClicked(onWidgetClicked);
                    }
                }
        }
    }
    
    private function onWidgetClicked() {
        var fn = _eventMap.get(MouseEvent.CLICK);
        if (fn != null) {
            var newMouseEvent = new MouseEvent(MouseEvent.CLICK);
            fn(newMouseEvent);
        }
    }
}