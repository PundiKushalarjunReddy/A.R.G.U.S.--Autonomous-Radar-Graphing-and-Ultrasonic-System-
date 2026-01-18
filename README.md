# A.R.G.U.S. (Autonomous Radar Graphing and Ultrasonic System)
A.R.G.U.S. is a real-time sonar-inspired environment mapping system. It utilizes an ultrasonic sensor mounted on a servo motor to scan a 180-degree field, visualizing the data through a custom-built Processing GUI and archiving detection events for post-scan analysis.

## 🚀 Features
- **Real-time Radar GUI:** High-fidelity HUD with motion blur and persistence mapping.
- **Precision Detection:** Optimized signal processing to narrow ultrasonic beam-width signatures.
- **Live Logging Table:** Real-time data feed showing Timestamp, Angle, and Distance.
- **Data Persistence:** Automatic export of detection history to `argus_log.csv` upon system exit.

## 🛠️ Hardware Requirements
- Arduino Uno (or compatible)
- HC-SR04 Ultrasonic Sensor
- SG90 Micro Servo Motor
- Jumper Wires & Breadboard

## 💻 Software Requirements
- [Arduino IDE](https://www.arduino.cc/en/software)
- [Processing 4.x](https://processing.org/download)

## 🔧 Installation & Usage
1. **Arduino:** Upload the provided `.ino` code to your board.
2. **Wiring:** - Servo Signal -> Pin 12
   - HC-SR04 Trig -> Pin 10, Echo -> Pin 11
3. **Processing:** Open the `.pde` sketch. Ensure the `COM` port in the code matches your Arduino port.
4. **Run:** Execute the Processing sketch to begin the ARGUS sweep.
5. **Archive:** Close the application window to save the session log to `/data/argus_log.csv`.
