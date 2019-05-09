package haxe.ui.backend.qt.builders;

import haxe.ui.core.Component;
import haxe.ui.core.CompositeBuilder;
import qt.widgets.TabWidget;

class TabViewBuilder extends CompositeBuilder {
    public override function create() {
        trace("create");
    }
    
    public override function addComponent(child:Component):Component {
        var tabWidget:TabWidget = cast(_component.widget);
        trace(tabWidget);
        return null;
        
    }
    
    public override function addComponentAt(child:Component, index:Int):Component {
        return null;
    }
    
    public override function removeComponent(child:Component, dispose:Bool = true, invalidate:Bool = true):Component {
        return null;
    }
    
    public override function getComponentIndex(child:Component):Int {
        return -1;
    }
    
    public override function setComponentIndex(child:Component, index:Int):Component {
        return null;
    }
    
    public override function getComponentAt(index:Int):Component {
        return null;
    }
}