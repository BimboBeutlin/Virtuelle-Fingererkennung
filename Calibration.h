static const int NUM_STEPS = 3;   // 0°, 45°, 90°
int calibrationAngles[NUM_STEPS] = {0, 45, 90};

// Rohwerte-Speicher
int baseRaw;               
int joint1Raw[NUM_STEPS];  
int joint2Raw[NUM_STEPS];  

bool calibrationStarted = false;
int currentStep = 0;   // 0 = Base Nullpunkt, 1–6 = abwechselnd Joint1/Joint2

// Hilfsfunktion für Ausgabe
void printCalibrationMsg(const char* jointName, int angle, int value) {
  Serial.print(jointName);
  Serial.print(" bei ");
  Serial.print(angle);
  Serial.print("° = ");
  Serial.println(value);
}

// Start
void startCalibration() {
  calibrationStarted = true;
  currentStep = 0;

  Serial.println("=== STARTE KALIBRIERUNG ===");
  Serial.println("Schritt 0: Base auf Nullposition stellen und 'n' drücken.");
}

// Base Nullpunkt
void calibrationBase(int rawBase) {
  baseRaw = rawBase;
  Serial.print("Base Nullpunkt gespeichert: ");
  Serial.println(baseRaw);

  Serial.println("→ Stelle Joint1 auf 0° und drücke 'n'.");
  currentStep = 1;
}

// Ergebnisse ausgeben (JETZT VOR calibrationStep)
void printResults() {
  Serial.println("\n=== KALIBRIERUNGSERGEBNISSE ===");
  Serial.print("Base Nullpunkt -> Raw "); Serial.println(baseRaw);

  for (int i = 0; i < NUM_STEPS; i++) {
    Serial.print("Joint1 Winkel ");
    Serial.print(calibrationAngles[i]);
    Serial.print("° -> Raw ");
    Serial.println(joint1Raw[i]);
  }
  for (int i = 0; i < NUM_STEPS; i++) {
    Serial.print("Joint2 Winkel ");
    Serial.print(calibrationAngles[i]);
    Serial.print("° -> Raw ");
    Serial.println(joint2Raw[i]);
  }
  Serial.println("================================");
}

// Gemeinsame Routine für Joint1 & Joint2
void calibrationStep(int rawValue) {
  int idx = (currentStep - 1) / 2; // 0,1,2 für 0°,45°,90°

  if (currentStep % 2 == 1) { // ungerade → Joint1
    joint1Raw[idx] = rawValue;
    printCalibrationMsg("Joint1", calibrationAngles[idx], rawValue);
    Serial.print("→ Stelle Joint2 auf ");
    Serial.print(calibrationAngles[idx]);
    Serial.println("° und drücke 'n'.");
  } else { // gerade → Joint2
    joint2Raw[idx] = rawValue;
    printCalibrationMsg("Joint2", calibrationAngles[idx], rawValue);

    if (idx < NUM_STEPS - 1) {
      Serial.print("→ Stelle Joint1 auf ");
      Serial.print(calibrationAngles[idx+1]);
      Serial.println("° und drücke 'n'.");
    } else {
      Serial.println("Joint-Kalibrierung fertig!");
      printResults();
      currentStep = 7; // beendet
      return;
    }
  }
  currentStep++;
}