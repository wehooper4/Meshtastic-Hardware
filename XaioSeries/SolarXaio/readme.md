# SolarXaio Client Node

The **SolarXaio Client Node** was developed to address limitations in existing solutions for 1W solar node builds. We designed a fully integrated platform from the ground up, emphasizing component integration and hardware stability.

Every SolarXaio version shares a foundational feature set:

* **Core Processor:** A power-efficient **Seeed NRF52840 CPU/Bluetooth** module, compatible with popular amateur radio and open-source mesh projects.

* **Low-Voltage Protection:** An integrated **battery protection module** featuring a critical **2.9V low-voltage cutoff** to prevent system brownouts.

* **Regulated 5.1V Output:** An integrated **5.1V boost converter** providing stable voltage delivery for full radio power transmission, independent of battery state of charge (SoC).

* **Dedicated Solar Charging:** A circuit architecture designed specifically for PV applications, not as an afterthought of USB charging to check a box.

## Variants

| Variant | Charger Technology | Max Charge Rate | Key Feature Differentiators | 
 | ----- | ----- | ----- | ----- | 
| **Base** | CN3791 Vmpp | 1.2A | A direct Vmpp charging solution for standard deployments. | 
| **Advanced** | TI BQ24650 Vmpp | 2.0A | High-efficiency charging featuring thermal protection and optional **4.0V max charge mode** for extended calendar life. | 
| **MPPT** | True MPPT | 3.2A | **Maximum Power Point Tracking** (MPPT) actively sweeps the panel to find the optimal operating point multiple times per hour. Includes **active temperature compensation** for improved cell lifespan and charging stability. |

