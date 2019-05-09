package haxe.ui.backend;
import qt.core.Application;
import qt.proxy.MainWindowProxy;
import qt.widgets.MainWindow;

typedef ToolkitOptions = {
	?app:Application,
	?mainWindow:MainWindowProxy
}
