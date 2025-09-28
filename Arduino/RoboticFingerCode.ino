#include "Calibration.h"
#include "mathFunction.h"

// ===== Pinbelegung =====
const int pinBase   = A1;
const int pinJoint1 = A2;
const int pinJoint2 = A3;

// ===== Globale Variablen (Definition) =====
int x1, x2, x3;   // Joint1 Rohwerte
int y1, y2, y3;   // Joint2 Rohwerte
float a1, b1, c1; // Koeffizienten Joint1
float a2, b2, c2; // Koeffizienten Joint2
bool liveMode = false;

// ===== Timing für Live-Ausgabe =====
unsigned long lastPrint = 0;
const unsigned long printInterval = 50; // ms - Reduziert von 100ms für responsiveres Feedback

// ===== Hilfsfunktionen =====
int getBaseAngle(int rawBase) {
  int corrected = rawBase - baseRaw;
  return (int)(((float)corrected / 1023.0f) * 330.0f);
}

void handleCalibrationStep(int rawJoint1, int rawJoint2) {
  if (currentStep == 0) {
    calibrationBase(analogRead(pinBase));
  } else {
    calibrationStep((currentStep % 2 == 1) ? rawJoint1 : rawJoint2);
  }

  if (currentStep == 7) {
    // Werte übernehmen für Polynom-Berechnung
    x1 = joint1Raw[0]; x2 = joint1Raw[1]; x3 = joint1Raw[2];
    y1 = joint2Raw[0]; y2 = joint2Raw[1]; y3 = joint2Raw[2];

    getPolynomialEquationJoint1();
    getPolynomialEquationJoint2();

    Serial.println("Kalibrierung abgeschlossen → Koeffizienten berechnet!");
  }
}

void printLiveAngles() {
  // ADC-Referenz stabilisieren und alle Werte auf einmal lesen
  static int rawValues[3];
  
  // Optimiertes Sampling: alle Pins sequenziell ohne Delay
  rawValues[0] = analogRead(pinBase);
  rawValues[1] = analogRead(pinJoint1);
  rawValues[2] = analogRead(pinJoint2);

  // Winkel berechnen
  int angleBase = getBaseAngle(rawValues[0]);
  int angle1    = getJoint1Angle(rawValues[1]);
  int angle2    = getJoint2Angle(rawValues[2]);

  // Optimierte String-Ausgabe (weniger Print-Calls)
  Serial.print("Base: "); Serial.print(angleBase); Serial.print("° | Joint1: "); 
  Serial.print(angle1); Serial.print("° | Joint2: "); Serial.print(angle2); Serial.println("°");
}

// ===== Arduino Setup =====
void setup() {
  Serial.begin(115200);
  // Reduziertes Delay für schnelleren Start
  delay(100);

  Serial.println("Robotic Finger Controller gestartet.");
  Serial.println("Drücke 'c' für Kalibrierung.");
  Serial.println("Drücke 'l' für Live-Winkelanzeige.");
  Serial.println("Drücke 'q' um Live-Winkelanzeige zu beenden.");
}

// ===== Arduino Loop (Optimiert) =====
void loop() {
  // Nicht-blockierende Eingabeverarbeitung
  while (Serial.available()) {
    char cmd = Serial.read();

    if (cmd == 'c') {
      startCalibration();
    } 
    else if (cmd == 'n' && calibrationStarted) {
      int rawJoint1 = analogRead(pinJoint1);
      int rawJoint2 = analogRead(pinJoint2);
      handleCalibrationStep(rawJoint1, rawJoint2);
    }
    else if (cmd == 'l') {
      liveMode = true;
      Serial.println("Live-Modus gestartet. Drücke 'q' zum Beenden.");
    }
    else if (cmd == 'q') {
      liveMode = false;
      Serial.println("Live-Modus beendet.");
    }
  }

  // Live-Ausgabe mit optimiertem Timing
  if (liveMode && millis() - lastPrint >= printInterval) {
    lastPrint = millis();
    printLiveAngles();
  }
}
