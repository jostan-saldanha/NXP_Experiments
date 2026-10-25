# Experiment 5: Implementation of Matter over Wi-Fi/Thread
## NXP FRDM-RW612 Dual-Endpoint Matter Light Switch & OTBR Combo

---

## 1. Files in this Package (Copy to Pen Drive)

Keep these files together in one folder (e.g., `FRDM_RW612_Matter_Exam/`):

| File Name | Purpose |
| :--- | :--- |
| **`chip-rw61x-light-switch-combo-example.srec`** | The compiled Matter firmware binary (8.07 MB). |
| **`commands_script`** | J-Link flashing command script. |
| **`flash_jlink.bat`** | 1-click terminal flashing script for Windows. |
| **`show_build_output.bat`** | Terminal script to display memory map & build output for examiners. |
| **`matter_qr_code.html`** | Offline QR code viewer for smartphone commissioning. |
| **`EXECUTION_README.md`** | This terminal execution guide. |

---

## 2. Hardware Setup

1. Connect the **FRDM-RW612** board to your laptop using a Micro-USB cable connected to the **J10 (Debug)** port.
2. Open Windows **Device Manager** $\rightarrow$ expand **Ports (COM & LPT)**:
   * Note your port number (typically **`COM6`** as `JLink CDC UART Port`).

---

## 3. Terminal Execution Instructions

### Step 3.1: Verify Build & Memory Output (For Lab Examiner / Manual)
Open your terminal (PowerShell or VS Code terminal) in this folder and run:

```powershell
.\show_build_output.bat
```

**Expected Output:**
```text
============================================================
       FRDM-RW612 MATTER OVER WI-FI/THREAD COMBO APP        
============================================================
Memory region         Used Size  Region Size  %age Used
  m_flash_config:          3 KB         3 KB    100.00%
    m_interrupts:         580 B        640 B     90.62%
          m_text:       2502 KB    4443520 B     57.66%
    m_nvm_region:         64 KB        64 KB    100.00%
          m_data:      677360 B      1216 KB     54.40%
[224/224 100%] BUILD SUCCESSFUL!
Firmware: chip-rw61x-light-switch-combo-example.srec (8.07 MB)
============================================================
```
*(Take Screenshot 2 for your lab manual here).*

---

### Step 3.2: Flash the Firmware to FRDM-RW612
Run the flashing command in terminal:

```powershell
.\flash_jlink.bat
```

*Or run directly via J-Link command line:*
```powershell
jlink -device RW612 -if SWD -speed 4000 -autoconnect 1 -CommanderScript commands_script
```

**Flashing Result:**
* SEGGER J-Link connects over SWD, erases flash sectors, programs `chip-rw61x-light-switch-combo-example.srec`, resets the processor, and starts execution.

---

### Step 3.3: Open Serial Terminal (COM6)
Connect to the board using any serial monitor (PuTTY, Tera Term, Arduino Serial Monitor, or VS Code):
* **Port:** `COM6` *(or your J-Link COM port)*
* **Baud Rate:** `115200`
* **Data bits:** `8`, **Parity:** `None`, **Stop bits:** `1`

Press the **RESET** button on the FRDM-RW612 board. You will see the CLI prompt:
```text
>
```

---

### Step 3.4: Matter Terminal Commands

Type these commands directly into the serial terminal prompt (`>`):

#### 1. Open Matter Commissioning Window (Start BLE Advertising):
```text
mattercommissioning on
```
*(The board turns on Bluetooth advertising so phones can discover it).*

#### 2. Close Commissioning Window:
```text
mattercommissioning off
```

#### 3. View All Available Commands:
```text
help
```

#### 4. Reset the Device:
```text
matterreset
```

#### 5. Factory Reset (Erases previous network pairings):
```text
matterfactoryreset
```

---

## 4. Matter Commissioning (Smartphone Pairing)

### Pairing Parameters:
* **Manual Setup Code (11 digits):** `34970112332` *(or `34970112337`)*
* **Setup Passcode (PIN):** `20202021`
* **Discriminator:** `3840` (`0x0F00`)
* **QR Code Payload:** `MT:Y.K9042C00KA0648G00`

### Commissioning Steps:
1. In terminal or browser, open `matter_qr_code.html`:
   ```powershell
   Start-Process matter_qr_code.html
   ```
2. In the terminal, ensure BLE advertising is active:
   ```text
   mattercommissioning on
   ```
3. Open **nRF Matter** (or **Google Home**) on your smartphone.
4. Select **Add Device / Commission Device** $\rightarrow$ Scan the QR code on your computer screen (or manually type `34970112332`).
5. Select your 2.4 GHz Wi-Fi SSID and enter your password.
6. The phone configures the FRDM-RW612 over BLE and transitions communication to Wi-Fi.
7. Once paired, the **Light Switch** control panel will appear on your phone screen *(Take Screenshot 3 here)*.

---

## 5. Lab Manual Submission Screenshots

1. **Screenshot 1 (VS Code Workspace):** VS Code open showing `AppTaskBase.cpp` or `main.cpp` and project explorer.
2. **Screenshot 2 (Build & Memory Table):** Terminal output from running `.\show_build_output.bat`.
3. **Screenshot 3 (Hardware Output):** Serial terminal showing COM6 connected with `> Done` / `mattercommissioning on`, or the phone app showing the paired Matter Light Switch.

