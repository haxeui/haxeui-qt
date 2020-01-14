package haxe.ui.backend;
import haxe.ui.core.Platform;
import qt.core.Application;
import qt.gui.Palette;

class PlatformImpl extends PlatformBase {
    public override function getMetric(id:String):Float {
        switch (id) {
            case Platform.METRIC_VSCROLL_WIDTH:
                return 16;
            case Platform.METRIC_HSCROLL_HEIGHT:
                return 16;
        }
        return 0;
    }
    
    public override function getColor(id:String):Null<Int> {
        switch (id) {
            case "window":              return Application.palette.color(Palette.Window).intValue;
            case "background":          return Application.palette.color(Palette.Background).intValue;
            case "windowtext":          return Application.palette.color(Palette.WindowText).intValue;
            case "foreground":          return Application.palette.color(Palette.Foreground).intValue;
            case "base":                return Application.palette.color(Palette.Base).intValue;
            case "alternatebase":       return Application.palette.color(Palette.AlternateBase).intValue;
            case "tooltipbase":         return Application.palette.color(Palette.ToolTipBase).intValue;
            case "tooltiptext":         return Application.palette.color(Palette.ToolTipText).intValue;
            case "placeholdertext":     return Application.palette.color(Palette.PlaceholderText).intValue;
            case "text":                return Application.palette.color(Palette.Text).intValue;
            case "button":              return Application.palette.color(Palette.Button).intValue;
            case "buttontext":          return Application.palette.color(Palette.ButtonText).intValue;
            case "brighttext":          return Application.palette.color(Palette.BrightText).intValue;
            case "light":               return Application.palette.color(Palette.Light).intValue;
            case "midlight":            return Application.palette.color(Palette.Midlight).intValue;
            case "dark":                return Application.palette.color(Palette.Dark).intValue;
            case "mid":                 return Application.palette.color(Palette.Mid).intValue;
            case "shadow":              return Application.palette.color(Palette.Shadow).intValue;
            case "highlight":           return Application.palette.color(Palette.Highlight).intValue;
            case "highlightedtext":     return Application.palette.color(Palette.HighlightedText).intValue;
            case "link":                return Application.palette.color(Palette.Link).intValue;
            case "linkvisited":         return Application.palette.color(Palette.LinkVisited).intValue;
        }
        
        return null;
    }
}