#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; 60% Keyboard Navigation & Productivity Layer (Universal & MK1500 Mini Fix)
; ==============================================================================
; Solves the classic 60% keyboard limitations for programmers:
;   1. Missing arrow keys (without toggling Fn+O or locking '/ ?', 'Alt', 'Ctrl')
;   2. Missing F1-F12 function row
;   3. Missing media/volume controls
;   4. Missing forward Delete, Home, End, PageUp, PageDown
;   5. Esc vs. Backtick / Tilde conflict
;   6. Lack of CapsLock status LED on budget 60% keyboards
;
; SHORTCUTS (While HOLDING CapsLock):
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
; NORMAL CAPSLOCK FUNCTION:
;   - Quick tap of CapsLock toggles CAPS LOCK ON / OFF.
;   - Or press Shift + CapsLock to toggle CAPS LOCK.
;   - Displays a clean floating on-screen badge showing CAPS LOCK state.
; ==============================================================================

; --- Settings & State ---
global showNotification := true

ShowCapsNotification(state) {
    if (!showNotification)
        return
    text := state ? "  CAPS LOCK: ON  " : "  CAPS LOCK: OFF  "
    CoordMode "ToolTip", "Screen"
    ; Position near bottom-right corner of main display
    ToolTip(text, A_ScreenWidth - 200, A_ScreenHeight - 110)
    SetTimer(() => ToolTip(), -1200)
}

ToggleCapsState() {
    if GetKeyState("CapsLock", "T") {
        SetCapsLockState "AlwaysOff"
        ShowCapsNotification(false)
    } else {
        SetCapsLockState "AlwaysOn"
        ShowCapsNotification(true)
    }
}

; --- Custom System Tray Menu ---
SetupTrayMenu() {
    tray := A_TrayMenu
    tray.Delete()
    tray.Add("60% Keyboard Navigation Layer (Active)", (*) => OpenGitHub())
    tray.Disable("60% Keyboard Navigation Layer (Active)")
    tray.Add()
    tray.Add("View Cheatsheet / GitHub", (*) => OpenGitHub())
    tray.Add("Toggle CapsLock On-Screen Badge", (*) => ToggleNotificationOption())
    tray.Add()
    tray.Add("Suspend Hotkeys", (*) => Suspend(-1))
    tray.Add("Reload Script", (*) => Reload())
    tray.Add("Exit", (*) => ExitApp())
}

OpenGitHub() {
    Run("https://github.com/Solankarruturaj005/60-percent-keyboard-arrow-fix")
}

ToggleNotificationOption() {
    global showNotification := !showNotification
    statusText := showNotification ? "Enabled" : "Disabled"
    ToolTip("Caps Lock Badge: " . statusText)
    SetTimer(() => ToolTip(), -1000)
}

SetupTrayMenu()
A_IconTip := "60% Keyboard Navigation Layer`nHold CapsLock + IJKL for Arrows`nHold CapsLock + 1..= for F1..F12"

; Prevent accidental toggling of CapsLock when starting to hold it
SetCapsLockState "AlwaysOff"

; Shift + CapsLock toggles original CapsLock state
+CapsLock::ToggleCapsState()

; Suppress default CapsLock press on key-down
*CapsLock::Return

; Tap CapsLock alone without pressing any other key -> Toggles CapsLock
*CapsLock up:: {
    if (A_PriorKey = "CapsLock")
        ToggleCapsState()
}

; ------------------------------------------------------------------------------
; Navigation Layer: Active only while CapsLock is physically held down
; ------------------------------------------------------------------------------
#HotIf GetKeyState("CapsLock", "P")

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
