# Ant Esports MK1500 Mini – Hardware & Feature Reference Guide

Comprehensive guide for the **Ant Esports MK1500 Mini** (60% Wireless Bluetooth Keyboard), covering hardware switches, connectivity, battery management, RGB backlighting, and factory hotkeys.

---

## 1. Power Switch & USB Type-C Behavior

### Physical Power Switch
* Located on the **bottom casing** of the keyboard.
* **`ON`**: Wireless Bluetooth mode active.
* **`OFF`**: Completely powers off wireless transmission. Keyboard will only charge when connected to USB.

### USB Type-C Port (Charge vs Data)
* **Design Purpose:** The USB Type-C port on the MK1500 Mini is primarily designed for **recharging the internal 1000 mAh battery**.
* **Why keystrokes don't transmit over wire:** On this model, data lines are not routed as a wired USB HID device in standard firmware revisions. Communication with your PC occurs over **Bluetooth**, even while plugged in and charging.
* **Charging Time:** ~2 hours to full charge.
* **Battery Endurance:**
  * RGB Backlight **ON (Max Brightness)**: ~15 to 20 hours
  * RGB Backlight **OFF / Dimmed**: Up to **100 hours** of continuous typing (over 250 hours standby).

---

## 2. Bluetooth Pairing & 3-Device Switching

The MK1500 Mini supports pairing up to 3 distinct host devices (PC, Laptop, Smartphone, Tablet, Mac).

| Action | Shortcut | Description |
| :--- | :--- | :--- |
| **Switch to Channel 1** | `Fn + Q` | Selects Bluetooth profile 1 |
| **Switch to Channel 2** | `Fn + W` | Selects Bluetooth profile 2 |
| **Switch to Channel 3** | `Fn + E` | Selects Bluetooth profile 3 |
| **Enter Pairing Mode** | **Hold `Fn + Q`** (or W/E) for **3–5 sec** | Backlight flashes rapidly. Open Bluetooth settings on your host device and connect to `Ant Esports MK1500 Mini`. |

---

## 3. On-Board RGB Backlight Controls

The keyboard has no external driver application; all lighting controls are handled directly by on-board microcontroller shortcuts:

| Function | Shortcut | Note |
| :--- | :--- | :--- |
| **Backlight ON / OFF** | **`Fn + Spacebar`** | Quickly toggles LEDs on/off to save battery |
| **Cycle Effects / Modes** | **`Fn + \`** *(Backslash)* | Loops through animated RGB effects and static colors |
| **Increase Brightness** | **`Fn + ]`** *(or `Fn + L`)* | Increments LED brightness |
| **Decrease Brightness** | **`Fn + [`** *(or `Fn + ;`)* | Decrements LED brightness |
| **Increase Animation Speed**| **`Fn + '`** *(Quote)* | Speeds up RGB flow pattern |
| **Decrease Animation Speed**| **`Fn + ;`** *(Semicolon)* | Slows down RGB flow pattern |

---

## 4. Factory Hotkeys & Quirks

* **Windows Key Lock:** `Fn + Win` (Disables Windows key so accidental presses don't minimize full-screen games).
* **Factory Reset:** Hold `Fn + Spacebar` for ~3 seconds (resets profile & RGB).
* **Factory Arrow Key Toggle (`Fn + O`):**
  * *Hold for 3 seconds* to convert bottom-right cluster into arrow keys.
  * **The Problem:** Disables `/`, `?`, `Alt`, and `Ctrl`.
  * **Recommendation:** **Never use `Fn + O`.** Instead, use the included AutoHotkey script (`60percent_navigation.ahk`) which provides home-row navigation without sacrificing standard keys.
