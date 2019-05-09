package haxe.ui.backend;

import haxe.ui.core.Component;
import qt.widgets.Widget;

class ScreenImpl extends ScreenBase {
    public var centralWidget:Widget = new Widget();
    
    public function new() {
    }
    
    public override function get_width():Float {
        return options.mainWindow.width;
    }
    
    public override function get_height():Float {
        return return centralWidget.height;
    }
    
    public override function addComponent(component:Component) {
        trace(width);
        _topLevelComponents.push(component);
        //component.ready();
        resizeComponent(component);
        trace("TRYING TO ADD: " + component);
        if (options.mainWindow.onResize == null) {
            options.mainWindow.onResize = onMainWindowResized;
        }
    }
    
    private function onMainWindowResized() {
        for (c in _topLevelComponents) {
            resizeComponent(c);
        }
    }
}