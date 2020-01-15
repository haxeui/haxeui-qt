package haxe.ui.backend;

import haxe.ui.backend.qt.EventMapper;
import haxe.ui.backend.qt.StyleHelper;
import haxe.ui.backend.qt.initializers.Initializer;
import haxe.ui.core.Component;
import haxe.ui.core.Screen;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.styles.Style;
import qt.core.Event;
import qt.core.Object;
import qt.proxy.EventFilterProxy;
import qt.widgets.Menu;
import qt.widgets.MenuBar;
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
                //cast(parentComponent.widget, ScrollArea).widget.adjustSize();
            } else if (Std.is(parentComponent.widget, TabWidget)) { // special case for tab
                createWidget(parentComponent.widget, false);
                cast(this, Component).addClass("tabview-content");
                cast(parentComponent.widget, TabWidget).addTab(this.widget, this.text);
            } else {
                createWidget(parentComponent.widget);
            }
        }
    }
    
    private override function get_isNativeScroller():Bool {
        return Std.is(widget, ScrollArea);
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
        
        // TODO: make all this flexible (like it is in haxeui-hxwidgets)
        var initializers:String = null;
        if (className == "haxe.ui.containers.ListView" && (cast(this, Component).native == false || cast(this, Component).native == null)) {
            nativeComponentClass = "qt.widgets.ScrollArea";
            initializers = "haxe.ui.backend.qt.initializers.ScrollAreaInitializer";
        }
        
        // TODO: make all this flexible (like it is in haxeui-hxwidgets)
        if (className == "haxe.ui.containers.menus.MenuBar") {
            widget = Screen.instance.mainWindow.menuBar;
            Screen.instance.hasMenuBar = true;
        } else if (className == "haxe.ui.containers.menus.Menu") {
            if (parentComponent != null && Std.is(parentComponent.widget, MenuBar)) {
                widget = cast(parentComponent.widget, MenuBar).addMenu(this.text);
                setParent = false;
            } else if (parentComponent != null && Std.is(parentComponent.widget, Menu)) {
                widget = cast(parentComponent.widget, Menu).addMenu(this.text);
                setParent = false;
            }
        } else if (className == "haxe.ui.containers.menus.MenuItem") {
            if (parentComponent != null && Std.is(parentComponent.widget, Menu)) {
                cast(parentComponent.widget, Menu).addAction(this.text);
                setParent = false;
                nativeComponentClass = null;
            }
        } else if (className == "haxe.ui.containers.menus.MenuSeparator") {
            if (parentComponent != null && Std.is(parentComponent.widget, Menu)) {
                cast(parentComponent.widget, Menu).addSeparator();
                setParent = false;
                nativeComponentClass = null;
            }
        }
        
        if (widget == null && nativeComponentClass != null) {
            var params = [];
            widget = Type.createInstance(Type.resolveClass(nativeComponentClass), params);
            if (setParent == true) {
                widget.parent = parent;
            }
            
            initializers = Toolkit.nativeConfig.query('component[id=${className}].@initializers', initializers, this);       
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
        if (parentComponent != null && Std.is(parentComponent.widget, ScrollArea)) {
            haxe.ui.util.Timer.delay(function() {
                if (parentComponent != null) {
                    parentComponent.invalidateComponentLayout();
                }
                //invalidateComponentLayout();
            }, 50);
        }
    }
    
    private override function handlePosition(left:Null<Float>, top:Null<Float>, style:Style):Void {
        if (widget == null) {
            return;
        }
        
        if (Std.is(widget, MenuBar)) {
            return;
        }
        
        widget.move(Std.int(left), Std.int(top));
    }
    
    private override function handleVisibility(show:Bool) {
        if (widget == null) {
            return;
        }
        
        widget.visible = show;
    }
    
    private override function handleSize(width:Null<Float>, height:Null<Float>, style:Style) {
        if (width == null || height == null || width <= 0 || height <= 0) {
            return;
        }

        if (widget == null) {
            return;
        }

        if (Std.is(widget, MenuBar)) {
            return;
        }
        
        var w:Int = Std.int(width);
        var h:Int = Std.int(height);
        
        widget.resize(w, h);
        // This is to stop qt resizing things again (like when you click a big button) - may be ill concieved
        widget.setFixedSize(w, h);
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
        
        var className:String = Type.getClassName(Type.getClass(this));
        var slot:String = Toolkit.nativeConfig.query('component[id=${className}].signal[id=${type}].@slot', null, this); 
        if (slot != null) {
            var mapTo:String = Toolkit.nativeConfig.query('component[id=${className}].signal[id=${type}].@mapTo', null, this); 
            if (mapTo != null) {
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    Reflect.callMethod(widget, Reflect.field(widget, slot), [Reflect.field(this, mapTo)]);
                }
            }
        }
        
        switch (type) {
            case MouseEvent.CLICK:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    addEventFilterMapping(MouseEvent.MOUSE_DOWN, __onMouseDown);
                    addEventFilterMapping(MouseEvent.MOUSE_UP, __onMouseUp);
                }
                
            case MouseEvent.MOUSE_OVER:    
                addEventFilterMapping(MouseEvent.MOUSE_OVER, listener);
                
            case MouseEvent.MOUSE_OUT:    
                addEventFilterMapping(MouseEvent.MOUSE_OUT, listener);
                
            case MouseEvent.MOUSE_DOWN:    
                addEventFilterMapping(MouseEvent.MOUSE_DOWN, listener);
                
            case MouseEvent.MOUSE_UP:    
                addEventFilterMapping(MouseEvent.MOUSE_UP, listener);
        }
    }
    
    private var __mouseDown:Bool = false;
    private function __onMouseDown(event:UIEvent) {
        __mouseDown = true;
    }
    
    private function __onMouseUp(event:UIEvent) {
        if (__mouseDown == false) {
            return;
        }
        __mouseDown = false;
        var fn = _eventMap.get(MouseEvent.CLICK);
        if (fn != null) {
            var mouseEvent = new MouseEvent(MouseEvent.CLICK);
            fn(mouseEvent);
        }
    }
    
    private var _eventFilter:EventFilterProxy;
    private var _filteredEventMap:Map<Int, String> = null;
    private function addEventFilterMapping(event:String, listener:UIEvent->Void) {
        if (widget == null) {
            return;
        }
        if (_eventFilter == null) {
            _eventFilter = new EventFilterProxy();
            _eventFilter.onEvent = onEventFilterEvent;
            widget.eventFilter = _eventFilter;
        }
        if (_filteredEventMap == null) {
            _filteredEventMap = new Map<Int, String>();
        }
        
        if (EventMapper.HAXEUI_TO_QT.exists(event) == false) {
            trace("WARNING: Event '" + event + "' is not mapped to Qt");
            return;
        }
        
        if (_eventMap.exists(event) == true) {
            return;
        }
        
        var qtEventType = EventMapper.HAXEUI_TO_QT.get(event);
        _filteredEventMap.set(qtEventType, event);
        _eventMap.set(event, listener);
    }
    
    private function onEventFilterEvent(obj:Object, event:Event):Bool {
        if (_filteredEventMap == null) {
            return false;
        }
        
        if (_filteredEventMap.exists(event.type) == false) {
            return false;
        }
        
        var type = _filteredEventMap.get(event.type);
        var fn = _eventMap.get(type);
        if (fn != null) {
            switch (type) {
                case MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP:
                    var mouseEvent = new MouseEvent(type);
                    fn(mouseEvent);
            }
        }
        
        return false;
    }
    
    private function onMouseClickedSlot() {
        var fn = _eventMap.get(MouseEvent.CLICK);
        if (fn != null) {
            var newMouseEvent = new MouseEvent(MouseEvent.CLICK);
            fn(newMouseEvent);
        }
    }
}