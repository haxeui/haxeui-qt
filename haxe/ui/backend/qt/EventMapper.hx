package haxe.ui.backend.qt;

import qt.core.EventType;

class EventMapper {
    public static var HAXEUI_TO_QT:Map<String, Int> = [
        haxe.ui.events.MouseEvent.MOUSE_OVER => EventType.Enter,
        haxe.ui.events.MouseEvent.MOUSE_OUT => EventType.Leave,
        haxe.ui.events.MouseEvent.MOUSE_DOWN => EventType.MouseButtonPress,
        haxe.ui.events.MouseEvent.MOUSE_UP => EventType.MouseButtonRelease
    ];
    
    public static var QT_TO_HAXEUI:Map<Int, String> = [
        EventType.Enter => haxe.ui.events.MouseEvent.MOUSE_OVER,
        EventType.Leave => haxe.ui.events.MouseEvent.MOUSE_OUT,
        EventType.MouseButtonPress => haxe.ui.events.MouseEvent.MOUSE_DOWN,
        EventType.MouseButtonRelease => haxe.ui.events.MouseEvent.MOUSE_UP
    ];
}