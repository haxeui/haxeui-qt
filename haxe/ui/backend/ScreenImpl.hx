package haxe.ui.backend;

import haxe.ui.core.Component;
import qt.proxy.MainWindowProxy;
import qt.widgets.Widget;

class ScreenImpl extends ScreenBase {
    public var centralWidget:Widget = new Widget();
    public var hasMenuBar:Bool = false;
    
    public function new() {
    }
    
    public override function get_width():Float {
        return mainWindow.width;
    }
    
    public override function get_height():Float {
        if (hasMenuBar == true) {
            return mainWindow.height - 20; // TODO: calc
        }
        return mainWindow.height;
    }
    
    public override function addComponent(component:Component) {
        _topLevelComponents.push(component);
        resizeComponent(component);
        if (mainWindow.onResize == null) {
            mainWindow.onResize = onMainWindowResized;
        }
    }
    
    public var mainWindow(get, null):MainWindowProxy;
    private function get_mainWindow() {
        return options.mainWindow;
    }
    
    private function onMainWindowResized() {
        for (c in _topLevelComponents) {
            resizeComponent(c);
        }
    }
}