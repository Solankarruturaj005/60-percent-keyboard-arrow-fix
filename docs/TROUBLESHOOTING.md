# 🔧 60% Keyboard Navigation Fix – Troubleshooting & Diagnostic Guide

This document contains a complete technical analysis of the issues encountered with the 60% keyboard AutoHotkey navigation script, all root causes diagnosed, the fixes applied to the codebase, and a **step-by-step checklist to test and resolve the hardware state tomorrow**.

---

## 📌 Executive Summary of the Problem

When using the 60% keyboard (specifically the **Ant Esports MK1500 Mini**):
1. Pressing **`Win + CapsLock`** either caused the script to stop responding after some time or behave erratically.
2. When the keyboard disconnected, went into Bluetooth power-saving sleep, or reconnects, keystroke navigation stopped functioning entirely.
3. Navigation keys (`CapsLock + I/J/K/L`) were not responding or typing standard letters.

---

## 🔍 Root Cause Analysis (What Went Wrong)

### 1. Hook Chain Corruption on Reconnect / Sleep Wake
* **Mechanism:** When a Bluetooth keyboard sleeps (after 2–5 minutes of inactivity) or the USB cable is unplugged/replugged, Windows broadcasts `WM_DEVICECHANGE` (`0x0219`).
* **The Bug:** The script was calling `InstallKeybdHook(true, true)` 5–6 times in rapid succession while Windows was still re-enumerating the PnP device stack.
* **Result:** Calling `InstallKeybdHook(true, true)` in the middle of driver re-enumeration severed the low-level Windows keyboard hook (`WH_KEYBOARD_LL`). Once severed, AutoHotkey became completely deaf to keyboard input until the process was restarted.

### 2. Script Started in Dormant Mode (`isLayerActive := false`)
* **Mechanism:** A recent commit had introduced a master switch that defaulted `isLayerActive := false` on boot.
* **Result:** Every time the script started or restarted, navigation was **turned OFF by default**. Users had to manually trigger `Win + CapsLock` before arrow keys would work. If the keyboard had Win-lock (`Fn + Win`) enabled, the Windows key was blocked in hardware, preventing the master switch from ever firing.

### 3. CapsLock Toggle State Lockout
* **Mechanism:** `ToggleCapsState()` previously checked `if GetKeyState("CapsLock", "T")`.
* **The Bug:** Because `SetCapsLockState "AlwaysOff"` was enforced by the layer, Windows virtual toggle state stayed permanently at `0`.
* **Result:** The condition was never met; the script always thought CapsLock was OFF and executed `SetCapsLockState "AlwaysOn"`, making it impossible to toggle CapsLock back OFF.

### 4. Word Selection Shortcut Collision (`Ctrl + Shift + CapsLock`)
* **Mechanism:** The alternate master toggle was set to `*^+CapsLock` (`Ctrl + Shift + CapsLock`).
* **The Bug:** When programmers navigate code, the universal Windows shortcut for selecting whole words left/right is **`Ctrl + Shift + Left / Right`** (mapped in this script to **`Ctrl + Shift + CapsLock + J / L`**).
* **Result:** Every time word selection was attempted during typing, the alternate toggle fired and shut down the navigation layer mid-sentence.

### 5. 32-Bit AHK on 64-Bit Windows 11
* **Mechanism:** AutoHotkey was executing under `AutoHotkey32.exe`.
* **Result:** Running a 32-bit low-level keyboard hook on a 64-bit operating system requires WOW64 message translation. Windows enforces a strict `LowLevelHooksTimeout` (200–1000ms), silently removing 32-bit hooks when 64-bit applications have focus.

---

## 🛠️ Code & System Fixes Applied

All fixes have been implemented in [`60percent_navigation.ahk`](../60percent_navigation.ahk) and pushed to GitHub:

| Fix | Implementation Details |
| :--- | :--- |
| **Clean Reload on Device Change** | Replaced `InstallKeybdHook(true, true)` with a **1.2-second debounced `Reload()`** on `WM_DEVICECHANGE` (`0x8000` / `0x0007`). This guarantees a fresh hook connection from Windows after the hardware driver settles. |
| **Layer Active by Default** | Initialized `global isLayerActive := true` on startup with visual OSD feedback (`⚡ 60% Layer: ENABLED`). No manual activation required on boot. |
| **Dual-State Key Detection** | Added internal tracking variable `isCapsHeld`. The navigation layer now activates if **`isCapsHeld OR GetKeyState("CapsLock", "P")`**, making it immune to Bluetooth driver physical-state reporting delays. |
| **Explicit CapsLock State Tracking** | Introduced `global isCapsLocked := false` to cleanly alternate between `SetCapsLockState "AlwaysOn"` and `SetCapsLockState "AlwaysOff"`. |
| **Collision-Free Alternate Toggle** | Changed alternate master switch from `Ctrl + Shift + CapsLock` to **`Ctrl + Alt + CapsLock`**, fully protecting `Ctrl + Shift + CapsLock + J/L` word selection. |
| **64-Bit AutoHotkey v2 Restored** | Restored official `AutoHotkey64.exe` binary in `%LOCALAPPDATA%\Programs\AutoHotkey\v2\` and updated `install.ps1`. |
| **Start Menu Masking** | Added `A_MenuMaskKey := "vkE8"` to prevent Windows from opening the Start Menu when pressing `Win + CapsLock`. |
| **Live Key Logger** | Added non-blocking `InputHook("V L0 I0")` logging to `nav_trace.log` on Desktop to verify hardware keycodes. |

---

## 📋 Step-by-Step Checklist for Tomorrow Morning

When you pick this up tomorrow, follow these steps to test and verify:

### Step 1: Verify the Script is Running
Look at the Windows taskbar system tray (bottom-right near the clock):
* You should see a green **`H`** icon.
* Hovering over it should display: `60% Keyboard Navigation Layer (Active)`.
* If missing, launch it by double-clicking:
  `shell:startup` -> `60percent_navigation.ahk`

### Step 2: Check Physical Keyboard Connectivity
The Ant Esports MK1500 Mini transmits over **Bluetooth even while plugged into USB**:
1. Check the physical toggle switch on the **bottom of the keyboard** – ensure it is switched to **`ON`**.
2. Press **`Fn + Q`** (Bluetooth Channel 1) to ensure the keyboard is connected to your PC.
3. If not pairing, hold **`Fn + Q` for 3–5 seconds** until the backlight flashes rapidly, then connect via Windows Bluetooth Settings.

### Step 3: Check Hardware Mode Locks (Crucial for 60% Boards)
Budget 60% keyboards have hardware shortcut modes that can hijack keys before Windows sees them:
* **`Fn + Left Ctrl` (Ctrl / CapsLock Swap):**  
  On many 60% boards (including MK1500 Mini and Royal Kludge), pressing `Fn + Left Ctrl` swaps the physical `CapsLock` and `Left Ctrl` keys.  
  *Test:* Try holding **`Left Ctrl` + `I / J / K / L`**. If that moves the cursor, press **`Fn + Left Ctrl` once** to swap them back to standard layout.
* **`Fn + O` (Hardware Arrow Mode):**  
  Holding `Fn + O` for 3 seconds locks arrow keys onto `/?`, `Alt`, and `Ctrl`. Ensure this is **OFF** (hold `Fn + O` for 3 seconds to toggle off if needed).
* **`Fn + Win` (Windows Key Lock):**  
  If pressing the Windows key does not open the Start menu, press **`Fn + Win`** to unlock the Windows key.

### Step 4: Test Navigation in Notepad
1. Open Windows Notepad.
2. Type a few lines of text.
3. **Hold `Caps Lock` and tap `I`, `J`, `K`, `L`** -> The cursor should move Up, Left, Down, and Right.
4. **Hold `Caps Lock` and tap `Backspace`** -> Should forward-delete characters.
5. **Hold `Caps Lock` and tap `U` / `O`** -> Should jump to start/end of line.
6. **Tap `Caps Lock` quickly alone** -> Should toggle CapsLock ON/OFF and show the pill notification.

### Step 5: Check `nav_trace.log` on Desktop
Open [`nav_trace.log`](file:///C:/Users/hp/Desktop/nav_trace.log) on your Desktop:
* Whenever you press keys, it will log the exact key name and virtual keycode (`KEY: CapsLock (vk=20, sc=58)`).
* If the file remains completely blank after typing, Windows is not sending keystrokes to the user session (check Bluetooth connection or admin privilege).

---

## ⌨️ Complete Navigation Cheatsheet

### 1. Arrow Navigation (While Holding `Caps Lock`)
| Key Combination | Action | Hand Position |
| :--- | :--- | :--- |
| **`CapsLock` + `I`** | **Up Arrow** | Right Hand (Home Row) |
| **`CapsLock` + `K`** | **Down Arrow** | Right Hand (Home Row) |
| **`CapsLock` + `J`** | **Left Arrow** | Right Hand (Home Row) |
| **`CapsLock` + `L`** | **Right Arrow** | Right Hand (Home Row) |
| **`CapsLock` + `W / A / S / D`** | **Up / Left / Down / Right** | Left Hand (WASD) |

### 2. Line & Document Navigation
| Key Combination | Action | Use Case |
| :--- | :--- | :--- |
| **`CapsLock` + `U`** | **Home** | Jump to start of line |
| **`CapsLock` + `O`** | **End** | Jump to end of line |
| **`CapsLock` + `H`** | **Page Up** | Scroll up |
| **`CapsLock` + `N`** | **Page Down** | Scroll down |
| **`CapsLock` + `Backspace`** | **Delete** | Forward delete key |
| **`CapsLock` + `Esc`** | **`` ` `` (Backtick) / `~` (Tilde)** | Code block backtick |

### 3. Selection & Word Jumps
| Key Combination | Action |
| :--- | :--- |
| **`Shift` + `CapsLock` + `[I / J / K / L]`** | **Select text** character-by-character / line-by-line |
| **`Ctrl` + `CapsLock` + `[J / L]`** | **Jump whole words** left or right |
| **`Ctrl` + `Shift` + `CapsLock` + `[J / L]`** | **Select whole words** across lines |

### 4. Master On/Off Switch & System Tray
* **`Win` + `CapsLock`** (or **`Ctrl` + `Alt` + `CapsLock`**): Toggles navigation layer ON / OFF.
* **Tray Icon:** Right-click the green **`H`** icon near the clock -> **Reload Script** or **Toggle Layer**.
