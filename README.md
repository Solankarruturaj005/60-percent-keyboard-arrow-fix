# ⌨️ 60% Keyboard Arrow Keys & Productivity Fix

[![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2.0+-334455?logo=autohotkey&logoColor=white)](https://www.autohotkey.com/)
[![Platform](https://img.shields.io/badge/Platform-Windows-blue?logo=windows&logoColor=white)](#)
[![Keyboard Layout](https://img.shields.io/badge/Layout-60%25%20Form%20Factor-brightgreen)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A lightweight, zero-latency navigation and productivity layer for **60% form factor keyboards** (including **Ant Esports MK1500 Mini**, **Royal Kludge RK61**, **MageGee MK-Box**, **Redragon K530/K617**, and other compact keyboards).

Solves the classic 60% keyboard flaw where accessing arrow keys requires clumsy hardware toggles (like holding `Fn + O` for 3 seconds) that lock out essential programming keys like **`/?`**, **`Alt`**, and **`Ctrl`**.

Includes a **Windows 11-style translucent acrylic pill navbar** centered at the bottom of the screen (matching the native volume flyout design) so you always know your Caps Lock status at a glance without image dependencies.

---

## ⚡ Instant 1-Command Install (PowerShell)

Open Windows PowerShell (Run as regular user) and paste:

```powershell
irm https://raw.githubusercontent.com/Solankarruturaj005/60-percent-keyboard-arrow-fix/main/install.ps1 | iex
```

> **What this does:**
> 1. Detects or automatically installs AutoHotkey v2 via `winget`.
> 2. Adds the navigation script to your Windows Startup folder.
> 3. Starts the script immediately—it works in seconds without restarting!

---

## 🎯 The Problem with 60% Keyboards for Programmers

Most 60% keyboards lack dedicated arrow keys. Manufacturers attempt to solve this with a hardware toggle mode (e.g., holding **`Fn + O` for 3 seconds** on the Ant Esports MK1500 Mini or **`Fn + Enter`** on RK61):

| Action | Factory 60% Toggle Method | Why it's a Headache for Developers |
| :--- | :--- | :--- |
| **Arrow Navigation** | Hold `Fn + O` for 3 seconds to toggle arrow mode | **3-second delay** breaks typing flow |
| **Code Comments (`//`) & Regex** | Requires exiting arrow mode first | **`/?` is disabled** because it becomes `Up Arrow` |
| **Shortcuts (`Ctrl + Z`, `Alt + Tab`)** | Requires exiting arrow mode first | **`Ctrl` and `Alt` are disabled** because they become `Left / Right` |
| **Missing F1–F12 & Media** | Requires awkward two-handed `Fn` combos | Interrupts coding and debugging sessions |
| **Caps Lock Confusion** | Budget 60% boards often lack a Caps Lock LED | You never know whether Caps Lock is ON or OFF |

---

## 💡 The Solution: CapsLock Momentary Navigation Layer

Keep your keyboard in **NORMAL MODE permanently** (never toggle `Fn + O` again). Your **`/?`**, **`Ctrl`**, and **`Alt`** keys remain 100% functional at all times.

This script transforms the rarely-used **`Caps Lock`** key into an intuitive momentary modifier:

```
+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-------+
| Esc |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  |  0  |  -  |  =  |Backsp |
|  `  | F1  | F2  | F3  | F4  | F5  | F6  | F7  | F8  | F9  | F10 | F11 | F12 |  DEL  |
+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-------+
| Tab   |  Q  |  W  |  E  |  R  |  T  |  Y  |  U  |  I  |  O  |  P  |  [  |  ]  |  \    |
|       |     |  ▲  |     |     |     |     |Home |  ▲  | End |     |Vol- |Vol+ | Mute  |
+-------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-------+
| CAPS  |  A  |  S  |  D  |  F  |  G  |  H  |  J  |  K  |  L  |  ;  |  '  |   Enter   |
|[HOLD] |  ◀  |  ▼  |  ▶  |     |     |PgUp |  ◀  |  ▼  |  ▶  |     |     |           |
+-------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+---+---------+
| Shift   |  Z  |  X  |  C  |  V  |  B  |  N  |  M  |  ,  |  .  |  /  |     Shift     |
|         |     |     |     |     |     |PgDn |     |     |     |     |               |
+---------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----------+
```

---

## 🎮 Navigation Cheatsheet

### 1. Directional Navigation (While HOLDING `Caps Lock`)

| Key Combination | Action | Use Case |
| :--- | :--- | :--- |
| **`Caps Lock` + `I`** | **Up Arrow** | Right-hand home row navigation |
| **`Caps Lock` + `K`** | **Down Arrow** | Right-hand home row navigation |
| **`Caps Lock` + `J`** | **Left Arrow** | Right-hand home row navigation |
| **`Caps Lock` + `L`** | **Right Arrow** | Right-hand home row navigation |
| **`Caps Lock` + `W / A / S / D`** | **Up / Left / Down / Right** | Left-hand arrows (convenient when right hand is on your mouse) |
| **`Caps Lock` + `U`** | **Home** | Jump to start of line |
| **`Caps Lock` + `O`** | **End** | Jump to end of line |
| **`Caps Lock` + `H`** | **Page Up** | Scroll up |
| **`Caps Lock` + `N`** | **Page Down** | Scroll down |
| **`Caps Lock` + `Backspace`** | **Delete** | Forward delete key |

### 2. Function Row, Media & Backtick Fix (While HOLDING `Caps Lock`)

| Key Combination | Action | Use Case |
| :--- | :--- | :--- |
| **`Caps Lock` + `1` .. `=`** | **`F1` .. `F12`** | Instant function keys (F5 run/debug, F12 dev tools) |
| **`Caps Lock` + `[` / `]`** | **Volume Down / Up** | Media volume adjustment |
| **`Caps Lock` + `\`** | **Mute Volume** | Instant audio mute |
| **`Caps Lock` + `Esc`** | **`` ` `` (Backtick) / `~` (Tilde)** | Solves the missing backtick on 60% keyboards |

### 3. Developer Selection & Word Jumps

| Combination | Action |
| :--- | :--- |
| **`Shift` + `Caps Lock` + `[I / J / K / L]`** | **Select text** by character or line |
| **`Ctrl` + `Caps Lock` + `[J / L]`** | **Jump whole words** left or right |
| **`Ctrl` + `Shift` + `Caps Lock` + `[J / L]`** | **Select whole words** across lines |

### 4. Smart Caps Lock & Windows 11 Translucent Navbar

* **Quick tap** on `Caps Lock` alone toggles CAPS LOCK ON / OFF.
* Or press **`Shift` + `Caps Lock`** to toggle CAPS LOCK.
* **Translucent Acrylic Pill Navbar:** When toggled, a sleek translucent acrylic navbar pops up at the bottom-center of your screen (matching the Windows 11 system flyout design):
  * **ON:** `🔒 CapsLock: ON` (crisp cyan accent text)
  * **OFF:** `🔓 CapsLock: OFF` (muted silver text)
* Completely click-through (`+E0x20`), zero-focus stealing (`+NA`), and auto-dismisses after 1.2s.

---

## 🛠️ Ant Esports MK1500 Mini Reference Guide

If you are using this specifically on the **Ant Esports MK1500 Mini**, check out our complete hardware documentation in [`docs/MK1500_Mini_Hardware_Guide.md`](docs/MK1500_Mini_Hardware_Guide.md).

### Quick MK1500 Mini Summary:
* **Why does plugging in USB only charge the keyboard?**  
  The Type-C port on the MK1500 Mini is wired for **power charging only**; keystrokes are transmitted via **Bluetooth**, even while connected to a PC USB port.
* **Bluetooth Device Switching:**  
  `Fn + Q` (Profile 1) | `Fn + W` (Profile 2) | `Fn + E` (Profile 3).  
  *Hold for 3-5 seconds to initiate pairing.*
* **RGB Controls:**  
  * `Fn + Spacebar`: Toggle Backlight ON / OFF *(saves battery from ~15 hrs to ~100 hrs!)*  
  * `Fn + \`: Cycle RGB modes & effects  
  * `Fn + ]` / `Fn + [`: Increase / Decrease Brightness  
  * `Fn + '` / `Fn + ;`: Increase / Decrease Animation Speed  

---

## ⚙️ Customization & System Tray

Right-click the green **`H`** icon in your Windows taskbar notification area (near the clock) to:
* **View Cheatsheet / GitHub Repo**
* **Toggle CapsLock Notification Pill** (enable or disable)
* **Suspend Hotkeys** (temporarily disable navigation layer)
* **Reload Script**

Want to edit shortcuts? Simply open [`60percent_navigation.ahk`](60percent_navigation.ahk) in VS Code or Notepad, edit any mapping, and select **Reload Script** from the tray icon.

---

## 🗑️ Uninstallation

Paste this in PowerShell:

```powershell
irm https://raw.githubusercontent.com/Solankarruturaj005/60-percent-keyboard-arrow-fix/main/uninstall.ps1 | iex
```

Or manually remove `60percent_navigation.ahk` from `shell:startup` and exit the AutoHotkey tray icon.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) – feel free to use, modify, and distribute it.
