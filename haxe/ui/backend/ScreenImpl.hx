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
        _topLevelComponents.push(component);
        resizeComponent(component);
        if (options.mainWindow.onResize == null) {
            options.mainWindow.onResize = onMainWindowResized;
        }
    }
    
    private function onMainWindowResized() {
        for (c in _topLevelComponents) {
            trace("----------------------------- RESIZE");
            resizeComponent(c);
        }
    }
}