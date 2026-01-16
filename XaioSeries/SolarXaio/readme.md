# SolarXaio Infrastructure Node

The **SolarXaio** was designed to consolidate and optimize the components required for a high-power (1W or higher) solar node deployment into a robust integrated platform. It eliminates common reliability issues inherent in discrete component builds, provides a strong emphasis on energy efficiency, and ensures robust RF performance.

Every SolarXaio version shares a common feature set:

* **Core Processor:** A power-efficient **Seeed NRF52840 CPU/Bluetooth** module, compatible with popular amateur radio and open-source mesh projects.

* **Low-Voltage Protection:** An integrated **battery protection module** featuring a critical **2.9V low-voltage cutoff** to prevent system brownouts.

* **Regulated 5.1V Output:** An integrated **5.1V boost converter** providing stable voltage delivery for full radio power transmission, independent of battery state of charge (SoC).

* **Dedicated Solar Charging:** A circuit architectures designed specifically for PV applications, not as an afterthought addon to USB charging to check a capability box.

## Variants

| Variant | Charger Technology | Max Charge Rate | Key Feature Differentiators | 
 | ----- | ----- | ----- | ----- | 
| **Base** | CN3791 Vmpp | 1.2A | A direct Vmpp charging solution for standard deployments. | 
| **Advanced** | TI BQ24650 Vmpp | 2.0A | High-efficiency charging featuring thermal protection and optional **4.0V max charge mode** for extended calendar life. | 
| **MPPT** | True MPPT | 3.2A | **Maximum Power Point Tracking** (MPPT) actively sweeps the panel to find the optimal operating point multiple times per hour. Includes **active temperature compensation** for improved cell lifespan. |

## Lora Radio Versions

### E22P-915M30S - "+" 1W Boards
  * **Useage:** FCC certified rado module, usable on Meshtastic, Meshcore, Lora APRS, ect
  * **Frontend:** FEM with intigrated PA and LNA.
  * **Filtering:** 902-926MHz Bandpass built-in (RX: SAW filter pre-LNA, SAW filter post-LNA; TX: SAW filter pre-PA, Lowpass filter post-PA).
  * **Power Setting:** Set to 18dbm for optimal 30dbm output. 22dbm won't damage it, but will be less efficient.

### E22-900M30S - Legacy 1W Boards
  * **Useage:** Not part 15 certified, ham use only. Meshtastic HAM mode, lora APRS, ect.
  * **Frontend:** Descrete PA and LNA.
  * **Power Setting:** Set to 22dbm for optimal 30dbm output.

### E22-900M33S - 2W 33CM Ham Boards
  * **Useage:** Not part 15 certified, ham use only. Meshtastic HAM mode, lora APRS, ect.
  * **Frontend:** Descrete PA and LNA.
  * **Power Setting:** Set to 8 dbm for optimaly 33dmb output. **WARNING** Failue to set the power level it 8 or lower **WILL DESTORY THE RADIO**.
  * **Power Output Table:** https://github.com/wehooper4/Meshtastic-Hardware/tree/main/NewtPi#sx1262-power-setting-to-output-power-table

### E22-400M33S - 2W 70CM Ham Boards
  * **Useage:** HAM ONLY, for use on Meshtastic HAM mode, lora APRS, ect.
  * **Frontend:** Descrete PA and LNA.
  * **Power Setting:** Set to 8 dbm for optimaly 33dmb output. **WARNING** Failue to set the power level it 8 or lower **WILL DESTORY THE RADIO**.

## Accessories

The SolarXaio has kept the same physical footprint from the orginal version. As such accessories have been made by other makers to work with them.


rak unify enclosure mount:  https://www.printables.com/model/1552936-rak-unify-enclosure-solarxaio-mounting-plate
