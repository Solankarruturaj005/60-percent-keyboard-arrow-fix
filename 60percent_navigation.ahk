#Requires AutoHotkey v2.0
#SingleInstance Force

; Force keyboard hook and keep running
InstallKeybdHook(true, true)
A_MenuMaskKey := "vkE8" ; Mask Win key to prevent Windows Start Menu interruptions
Persistent(true)

; ==============================================================================
; 60% Keyboard Navigation & Productivity Layer (Universal & MK1500 Mini Fix)
; ==============================================================================
; MASTER KEYBOARD TOGGLE:
;   Press Win + CapsLock (or Ctrl + Alt + CapsLock) to toggle the layer ON / OFF.
;   - When DISABLED (default on boot): Script is dormant. 100% normal stock keyboard.
;   - When ENABLED: CapsLock navigation, smart tap, F-keys, and media layer are active.
;
; SHORTCUTS (While Layer is ENABLED & HOLDING CapsLock):
; ------------------------------------------------------------------------------
;   I / J / K / L       -->  Up / Left / Down / Right  (Right-hand Home Row)
;   W / A / S / D       -->  Up / Left / Down / Right  (Left-hand / Mouse mode)
;   U / O               -->  Home / End               (Start / End of line)
;   H / N               -->  PageUp / PageDown
;   Backspace           -->  Delete
;   Esc                 -->  ` (Backtick) / ~ (Tilde with Shift)
;
; FUNCTION KEYS:
;   1 .. 0, -, =        -->  F1 .. F12
;
; MEDIA & VOLUME:
;   [ / ]               -->  Volume Down / Volume Up
;   \                   -->  Mute Volume
;
; SELECTION & WORD JUMPS (Fully Native):
;   Shift + CapsLock + [I/J/K/L]      -->  Select text while moving
;   Ctrl + CapsLock + [J/L]           -->  Jump whole words left/right
;   Ctrl + Shift + CapsLock + [J/L]   -->  Select whole words
;
; NORMAL CAPSLOCK FUNCTION (While Layer is ENABLED):
;   - Quick tap of CapsLock toggles CAPS LOCK ON / OFF.
;   - Or press Shift + CapsLock to toggle CAPS LOCK.
;   - Displays a Windows 11 translucent pill navbar at bottom-center of screen.
; ==============================================================================

; --- State & Sizing ---
global isLayerActive := false
global lastToggleTick := 0
global pillGui := ""
global textCtrl := ""
global pillWidth := 250
global pillHeight := 46

InitPillGui() {
    global pillGui, textCtrl, pillWidth, pillHeight
    pillGui := Gui("-Caption +AlwaysOnTop +ToolWindow +Owner +E0x20 -DPIScale")
    pillGui.BackColor := "1c1c1c"
    
    ; Native Windows 11 Rounded Corners (DWMWA_WINDOW_CORNER_PREFERENCE = 33, DWMWCP_ROUND = 2)
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", pillGui.Hwnd, "UInt", 33, "Int*", 2, "UInt", 4)
    
    ; Native Acrylic Backdrop (DWMWA_SYSTEMBACKDROP_TYPE = 38, DWMSBT_TRANSIENTWINDOW = 3)
    DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", pillGui.Hwnd, "UInt", 38, "Int*", 3, "UInt", 4)
    
    ; Translucent dark glass opacity
    WinSetTransparent(225, pillGui.Hwnd)
    
    pillGui.SetFont("s11 bold cWhite", "Segoe UI")
    textCtrl := pillGui.Add("Text", "Center x0 y12 w" . pillWidth . " h" . (pillHeight - 12))
}

ShowPillOSD(text, colorHex := "38bdf8", durationMs := 1300) {
    global pillGui, textCtrl, pillWidth, pillHeight
    if (!pillGui)
        InitPillGui()
        
    textCtrl.SetFont("c" . colorHex)
    textCtrl.Value := text
    
    posX := (A_ScreenWidth - pillWidth) // 2
    posY := A_ScreenHeight - pillHeight - 90 ; Bottom-centered above taskbar
    
    pillGui.Show("x" . posX . " y" . posY . " w" . pillWidth . " h" . pillHeight . " NoActivate")
    SetTimer(() => pillGui.Hide(), -durationMs)
}

ToggleMasterLayer() {
    global isLayerActive, lastToggleTick
    lastToggleTick := A_TickCount
    
    ; Mask Windows key to prevent Windows Start Menu from popping up
    SendInput("{Blind}{vkE8}")
    
    isLayerActive := !isLayerActive
    if (isLayerActive) {
        ; Explicitly ensure CapsLock state is OFF when activating
        SetCapsLockState "AlwaysOff"
        ShowPillOSD("⚡ 60% Layer: ENABLED", "38bdf8")
    } else {
        ; Restore normal keyboard mode, clean CapsLock state
        SetCapsLockState "Off"
        ShowPillOSD("💤 60% Layer: DISABLED", "94a3b8")
    }
    
    ; Force re-bind hook cleanly on every toggle
    InstallKeybdHook(true, true)
    SendInput("{Blind}{vkE8}")
}

ToggleCapsState() {
    if GetKeyState("CapsLock", "T") {
        SetCapsLockState "AlwaysOff"
        ShowPillOSD("🔓  CapsLock: OFF", "94a3b8")
    } else {
        SetCapsLockState "AlwaysOn"
        ShowPillOSD("🔒  CapsLock: ON", "38bdf8")
    }
}

; --- Custom System Tray Menu ---
SetupTrayMenu() {
    tray := A_TrayMenu
    tray.Delete()
    tray.Add("60% Keyboard Navigation Layer", (*) => OpenGitHub())
    tray.Disable("60% Keyboard Navigation Layer")
    tray.Add()
    tray.Add("Toggle Layer (Win + CapsLock)", (*) => ToggleMasterLayer())
    tray.Add("Re-sync Keyboard Hook", (*) => RecoverHardwareState())
    tray.Add("View Cheatsheet / GitHub", (*) => OpenGitHub())
    tray.Add()
    tray.Add("Reload Script", (*) => Reload())
    tray.Add("Exit", (*) => ExitApp())
}

OpenGitHub() {
    Run("https://github.com/Solankarruturaj005/60-percent-keyboard-arrow-fix")
}

SetupTrayMenu()
A_IconTip := "60% Keyboard Navigation Layer`nPress Win + CapsLock to Toggle ON/OFF"

; ------------------------------------------------------------------------------
; Master Keyboard Toggle Shortcuts (Always Active)
; ------------------------------------------------------------------------------
; Win + CapsLock (Master on-demand switch)
*#CapsLock::ToggleMasterLayer()

; Ctrl + Alt + CapsLock (Alternate toggle that does NOT collide with word selection)
*!^CapsLock::ToggleMasterLayer()

; ------------------------------------------------------------------------------
; Navigation Layer Hotkeys (Only active when layer is ENABLED)
; ------------------------------------------------------------------------------
#HotIf isLayerActive

; Shift + CapsLock toggles original CapsLock state
+CapsLock::ToggleCapsState()

; Suppress default CapsLock press on key-down
*CapsLock::Return

; Tap CapsLock alone without pressing any other key -> Toggles CapsLock
*CapsLock up:: {
    global lastToggleTick
    ; Debounce if master layer was just toggled
    if (A_TickCount - lastToggleTick < 400)
        return
    if (A_PriorKey = "CapsLock")
        ToggleCapsState()
}

#HotIf isLayerActive and GetKeyState("CapsLock", "P")

; --- Right-hand Arrow Keys (Home Row) ---
*i::SendInput("{Blind}{Up}")
*j::SendInput("{Blind}{Left}")
*k::SendInput("{Blind}{Down}")
*l::SendInput("{Blind}{Right}")

; --- Left-hand Arrow Keys (WASD) ---
*w::SendInput("{Blind}{Up}")
*a::SendInput("{Blind}{Left}")
*s::SendInput("{Blind}{Down}")
*d::SendInput("{Blind}{Right}")

; --- Extended Navigation ---
*u::SendInput("{Blind}{Home}")
*o::SendInput("{Blind}{End}")
*h::SendInput("{Blind}{PgUp}")
*n::SendInput("{Blind}{PgDn}")
*Backspace::SendInput("{Blind}{Delete}")

; --- Backtick & Tilde Fix ---
*Esc::SendInput("{Blind}``")

; --- Function Keys (F1 - F12) ---
*1::SendInput("{Blind}{F1}")
*2::SendInput("{Blind}{F2}")
*3::SendInput("{Blind}{F3}")
*4::SendInput("{Blind}{F4}")
*5::SendInput("{Blind}{F5}")
*6::SendInput("{Blind}{F6}")
*7::SendInput("{Blind}{F7}")
*8::SendInput("{Blind}{F8}")
*9::SendInput("{Blind}{F9}")
*0::SendInput("{Blind}{F10}")
*-::SendInput("{Blind}{F11}")
*=::SendInput("{Blind}{F12}")

; --- Media & Volume Controls ---
*[::SendInput("{Blind}{Volume_Down}")
*]::SendInput("{Blind}{Volume_Up}")
*\::SendInput("{Blind}{Volume_Mute}")

#HotIf

; ------------------------------------------------------------------------------
; Hardware Disconnect / Reconnect / Bluetooth Sleep Auto-Recovery
; ------------------------------------------------------------------------------
; WM_DEVICECHANGE (0x0219) notification listener
; Re-registers low-level keyboard hook whenever USB or Bluetooth keyboard reconnects
OnMessage(0x0219, OnDeviceChange)

OnDeviceChange(wParam, lParam, msg, hwnd) {
    ; DBT_DEVNODES_CHANGED = 0x0007, DBT_DEVICEARRIVAL = 0x8000, DBT_DEVICEREMOVECOMPLETE = 0x8004
    ; Debounce by 400ms to let Windows driver & PnP stack settle before re-hooking
    SetTimer(RecoverHardwareState, -400)
    return true
}

RecoverHardwareState() {
    global isLayerActive
    ; Force re-installation of low-level keyboard hook
    InstallKeybdHook(true, true)
    
    ; Re-sync CapsLock state
    if (isLayerActive) {
        SetCapsLockState "AlwaysOff"
    } else {
        SetCapsLockState "Off"
    }
}

; ------------------------------------------------------------------------------
; Periodic Keep-Alive Heartbeat Watchdog
; ------------------------------------------------------------------------------
; Checks every 15 seconds to ensure Windows does not silently drop WH_KEYBOARD_LL
; after prolonged idle time (LowLevelHooksTimeout)
SetTimer(WatchdogKeepAlive, 15000)

WatchdogKeepAlive() {
    InstallKeybdHook(true, false)
}
