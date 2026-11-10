# ⌨️ 60% Keyboard Arrow Keys & Navigation Fix

[![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2.0+-334455?logo=autohotkey&logoColor=white)](https://www.autohotkey.com/)
[![Platform](https://img.shields.io/badge/Platform-Windows-blue?logo=windows&logoColor=white)](#)
[![Keyboard Layout](https://img.shields.io/badge/Layout-60%25%20Form%20Factor-brightgreen)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A lightweight, zero-latency navigation solution for **60% form factor keyboards** (such as **Ant Esports MK1500 Mini**, **Royal Kludge RK61**, **MageGee MK-Box**, **Redragon K530/K617**, and other compact keyboards).

Solves the classic 60% dilemma where accessing arrow keys requires clumsy toggles that lock out essential programming keys like **`/?`**, **`Alt`**, and **`Ctrl`**.

---

## 🎯 The Problem with 60% Keyboards for Programmers

Most budget and standard 60% keyboards lack dedicated arrow keys. Manufacturers attempt to solve this with a hardware toggle mode (e.g., holding **`Fn + O` for 3 seconds** on the Ant Esports MK1500 Mini or **`Fn + Enter`** on RK61):

| Action | Factory 60% Toggle Method | Why it's a Headache for Developers |
| :--- | :--- | :--- |
| **Arrow Navigation** | Hold `Fn + O` for 3 seconds to toggle arrow mode | **3-second delay** breaks typing flow |
| **Code Comments (`//`) & Regex** | Requires exiting arrow mode first | **`/?` is disabled** because it becomes `Up Arrow` |
| **Shortcuts (`Ctrl + Z`, `Alt + Tab`)** | Requires exiting arrow mode first | **`Ctrl` and `Alt` are disabled** because they become `Left / Right` |
| **Hand Travel** | Right hand moves to bottom-right corner | Slower typing; leaves home row |

---

## 💡 The Solution: CapsLock Momentary Navigation Layer

Keep your keyboard in **NORMAL MODE permanently** (never toggle `Fn + O` again). Your **`/?`**, **`Ctrl`**, and **`Alt`** keys remain 100% functional at all times.

This script transforms the rarely-used **`Caps Lock`** key into an intuitive momentary modifier:

```
[Caps Lock] (HOLD) + [ I ]  -->  Up Arrow
[Caps Lock] (HOLD) + [ J ]  -->  Left Arrow
[Caps Lock] (HOLD) + [ K ]  -->  Down Arrow
[Caps Lock] (HOLD) + [ L ]  -->  Right Arrow
```

* **Zero Delay:** Instant response—no waiting for mode switches.
* **Home Row Stays Put:** Your fingers never leave the typing position.
* **Full IDE Selection:** `Shift + CapsLock + Arrows` highlights text; `Ctrl + CapsLock + Arrows` jumps words.
* **Normal CapsLock Preserved:** A single quick tap of `CapsLock` (or `Shift + CapsLock`) toggles standard CAPS LOCK on/off!
* **Ultra Lightweight:** Uses ~3 MB of RAM and 0% CPU via AutoHotkey v2.

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
| **`Caps Lock` + `Backspace`** | **Delete** | Forward delete (often omitted on 60% layouts) |

### 2. Developer Selection & Word Jumps

| Combination | Action |
| :--- | :--- |
| **`Shift` + `Caps Lock` + `[I / J / K / L]`** | **Select text** by character or line |
| **`Ctrl` + `Caps Lock` + `[J / L]`** | **Jump whole words** left or right |
| **`Ctrl` + `Shift` + `Caps Lock` + `[J / L]`** | **Select whole words** across lines |

### 3. Standard Caps Lock Toggling

* **Quick tap** on `Caps Lock` alone toggles CAPS LOCK ON / OFF.
* Or press **`Shift` + `Caps Lock`** to toggle CAPS LOCK.

---

## 🚀 Quick Start & Installation

### Option A: 1-Click Automated PowerShell Install (Recommended)

Clone this repository and run the included installer:

```powershell
git clone https://github.com/Solankarruturaj005/60-percent-keyboard-arrow-fix.git
cd 60-percent-keyboard-arrow-fix
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

**What the installer does automatically:**
1. Checks for [AutoHotkey v2](https://www.autohotkey.com/). If missing, it installs it silently via `winget`.
2. Copies `60percent_navigation.ahk` to your **Windows Startup** folder (`shell:startup`).
3. Launches the script immediately—it starts working in 1 second and automatically boots with Windows.

---

### Option B: Manual Setup

1. Install **[AutoHotkey v2](https://www.autohotkey.com/)** (v2.0 or newer).
2. Download [`60percent_navigation.ahk`](60percent_navigation.ahk).
3. Press `Win + R`, type `shell:startup`, and hit **Enter**.
4. Paste `60percent_navigation.ahk` into the folder.
5. Double-click the script to run it immediately.

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
  * `Fn + Spacebar`: Toggle Backlight ON / OFF *(saves substantial battery!)*  
  * `Fn + \`: Cycle RGB modes & effects  
  * `Fn + ]` / `Fn + [`: Increase / Decrease Brightness  
  * `Fn + '` / `Fn + ;`: Increase / Decrease Animation Speed  

---

## ⚙️ Customization

Want to tweak hotkeys or add custom shortcuts?  
Open [`60percent_navigation.ahk`](60percent_navigation.ahk) in any code editor (VS Code, Notepad, etc.). All mappings are clean AutoHotkey v2 functions:

```autohotkey
; Example: Add CapsLock + M as Enter key
#HotIf GetKeyState("CapsLock", "P")
*m::SendInput("{Blind}{Enter}")
#HotIf
```

After modifying, save the file and right-click the green **`H`** icon in the Windows taskbar system tray > **Reload Script**.

---

## 🗑️ Uninstallation

Run the included uninstaller script:

```powershell
powershell -ExecutionPolicy Bypass -File .\uninstall.ps1
```

Or manually delete `60percent_navigation.ahk` from `shell:startup` and exit the AutoHotkey tray icon.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) – feel free to use, modify, and distribute it.
