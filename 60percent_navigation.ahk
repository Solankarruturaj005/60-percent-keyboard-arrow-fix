#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; 60% Keyboard Navigation & Arrow Key Layer (Universal & MK1500 Mini Fix)
; ==============================================================================
; Solves the classic 60% keyboard flaw for programmers:
; On 60% keyboards (like Ant Esports MK1500 Mini, RK61, MageGee, etc.), toggling
; arrow key mode locks out critical programming keys like '/', '?', 'Alt', and 'Ctrl'.
;
; This script keeps your keyboard in NORMAL MODE permanently and turns
; CAPSLOCK into a momentary navigation modifier layer.
;
; SHORTCUTS (While HOLDING CapsLock):
; ------------------------------------------------------------------------------
;   I / J / K / L       -->  Up / Left / Down / Right  (Right-hand Home Row)
;   W / A / S / D       -->  Up / Left / Down / Right  (Left-hand / Mouse mode)
;   U / O               -->  Home / End               (Line start / end)
;   H / N               -->  PageUp / PageDown
;   Backspace           -->  Delete
;
; SELECTION & WORD JUMPS (Fully Native):
;   Shift + CapsLock + [I/J/K/L]      -->  Select text while moving
;   Ctrl + CapsLock + [J/L]           -->  Jump whole words left/right
;   Ctrl + Shift + CapsLock + [J/L]   -->  Select whole words
;
; NORMAL CAPSLOCK FUNCTION:
;   - Tap CapsLock quickly alone to toggle Caps Lock ON / OFF.
;   - OR press Shift + CapsLock to toggle Caps Lock.
; ==============================================================================

A_IconTip := "60% Keyboard Navigation Layer (Active)`nHold CapsLock + IJKL/WASD for Arrows"

; Prevent accidental toggling of CapsLock when starting to hold it
SetCapsLockState "AlwaysOff"

; Shift + CapsLock toggles original CapsLock state
+CapsLock:: {
    if GetKeyState("CapsLock", "T")
        SetCapsLockState "AlwaysOff"
    else
        SetCapsLockState "AlwaysOn"
}

; Suppress default CapsLock press on key-down
*CapsLock::Return

; Tap CapsLock alone without pressing any other key -> Toggles CapsLock
*CapsLock up:: {
    if (A_PriorKey = "CapsLock") {
        if GetKeyState("CapsLock", "T")
            SetCapsLockState "AlwaysOff"
        else
            SetCapsLockState "AlwaysOn"
    }
}

; ------------------------------------------------------------------------------
; Navigation Layer: Active only while CapsLock is physically held down
; ------------------------------------------------------------------------------
#HotIf GetKeyState("CapsLock", "P")

; Right-hand Arrow Keys (Home Row)
*i::SendInput("{Blind}{Up}")
*j::SendInput("{Blind}{Left}")
*k::SendInput("{Blind}{Down}")
*l::SendInput("{Blind}{Right}")

; Left-hand Arrow Keys (WASD - handy when right hand is on the mouse)
*w::SendInput("{Blind}{Up}")
*a::SendInput("{Blind}{Left}")
*s::SendInput("{Blind}{Down}")
*d::SendInput("{Blind}{Right}")

; Navigation Enhancements
*u::SendInput("{Blind}{Home}")
*o::SendInput("{Blind}{End}")
*h::SendInput("{Blind}{PgUp}")
*n::SendInput("{Blind}{PgDn}")

; Delete key shortcut (missing on 60% keyboards)
*Backspace::SendInput("{Blind}{Delete}")

#HotIf
