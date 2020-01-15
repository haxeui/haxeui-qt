package haxe.ui.backend;

import haxe.ui.core.Screen;
import qt.core.Application;
import qt.proxy.MainWindowProxy;
import qt.styles.StyleFactory;
import qt.widgets.MainWindow;

class AppImpl extends AppBase {
    private var _app:Application;
    private var _mainWindow:MainWindowProxy;
    private var _onEnd:Void->Void;
    
    public function new() {
    }
    
    private override function build() {
        var theme = Toolkit.backendProperties.getProp("haxe.ui.qt.theme", "Fusion");
        if (theme != null) {
            Application.style = StyleFactory.create(theme);
        }
        _app = new Application();
        _mainWindow = new MainWindowProxy();
    }
    
    private override function init(onReady:Void->Void, onEnd:Void->Void = null) {
        _onEnd = onEnd;
        var fit = Toolkit.backendProperties.getPropBool("haxe.ui.qt.main.window.fit", false);
        if (fit == true) {
            haxe.ui.util.Timer.delay(function() {
                Screen.instance.resizeToContents();
            }, 0);
        } else {
            var windowWidth:Int = Toolkit.backendProperties.getPropInt("haxe.ui.qt.main.window.width", 800);
            var windowHeight:Int = Toolkit.backendProperties.getPropInt("haxe.ui.qt.main.window.height", 600);
            _mainWindow.resize(windowWidth, windowHeight);
        }
        
        var title = Toolkit.backendProperties.getProp("haxe.ui.qt.main.window.title");
        if (title != null) {
            _mainWindow.windowTitle = title;
        }
        
        onReady();
    }
    
    private override function getToolkitInit():ToolkitOptions {
        return {
            app: _app,
            mainWindow: _mainWindow
        };
    }
    
    public override function start() {
        _mainWindow.centralWidget = Screen.instance.centralWidget;
        _mainWindow.show();
        _app.exec();
    } 
 }
