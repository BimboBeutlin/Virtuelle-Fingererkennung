# Virtuelle-Fingererkennung

# 📂 Projektstruktur

## Ordnerübersicht
- **3D Modell**  
  Enthält die CAD-Dateien (STEP) für den mechanischen Aufbau des Prototypen.  
  → Hier ist die Konstruktion des Fingermechanismus dokumentiert.

- **Arduino**  
  Beinhaltet den Quellcode für den Arduino Nano (`RoboticFingerCode.ino`) sowie Header-Dateien (`Calibration.h`, `mathFunction.h`).  
  → Aufgabe: Einlesen der analogen Sensordaten von drei Potentiometern, Kalibrierung und Umrechnung in Winkelwerte, serielle Übertragung an den PC.

- **Processing**  
  Beinhaltet mehrere `.pde`-Dateien (`Model.pde`, `Movement.pde`, `HUD.pde`, `Camera.pde`, `Code_Simulation_Finger.pde`).  
  → Aufgabe: Empfang der Sensordaten über die serielle Schnittstelle, Aufbereitung und Echtzeitvisualisierung in einem 3D-Fingermodell.  
  - `Model.pde`: Definition des 3D-Handmodells  
  - `Movement.pde`: Umsetzung der Gelenkwinkel in Fingerbewegungen  
  - `HUD.pde`: Anzeige zusätzlicher Infos (z. B. Messwerte)  
  - `Camera.pde`: Kamerasteuerung und Perspektive  
  - `Code_Simulation_Finger.pde`: Einstiegspunkt zur Ausführung der Simulation

---

## Ablauf
1. Der Arduino erfasst die analogen Werte der Potentiometer.  
2. Die Werte werden kalibriert und über die serielle Schnittstelle ausgegeben.  
3. Processing empfängt den Datenstrom, wandelt ihn in Gelenkwinkel um und visualisiert die Bewegung in einem interaktiven 3D-Modell.  
