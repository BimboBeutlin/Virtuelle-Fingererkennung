// ===== HAUPT-HAND ZEICHENFUNKTION =====
// Zeichnet komplette Hand mit 5 Fingern
void drawHand() {
  pushMatrix();  // Speichere aktuelle Koordinaten
  
  // ===== NUR HAND-ROTATION ANWENDEN =====
  // Globale Rotationswerte von der Tastatursteuerung
  rotateZ(gRotateZ);  // Z-Achse: Rolle
  rotateX(gRotateX);  // X-Achse: Nick
  rotateY(gRotateY);  // Y-Achse: Gier

  // ===== HAND-BASIS ZEICHNEN =====
  // Rechteckiger Handrücken in Hautfarbe
  fill(210, 160, 120);  // Hautfarbe (RGB)
  noStroke();           // Ohne Umrisse
  box(70, 15, 60);      // 3D-Quader als Handrücken

  // ===== VIER NORMALE FINGER =====
  // Position: (x, y, z), Winkel, Größe, etc.
  drawFinger(35, 0, 20, fingerJoynt1[0], fingerJoynt2and3[0], 12, 10, false);  // Zeigefinger
  drawFinger(35, 0, 7,  fingerJoynt1[1], fingerJoynt2and3[1], 15, 12, false);  // Mittelfinger
  drawFinger(35, 0, -7, fingerJoynt1[2], fingerJoynt2and3[2], 16, 14, false);  // Ringfinger
  
  // ===== KONTROLLIERTER FINGER (KLEINER FINGER) =====
  // Dieser Finger verwendet Arduino-Daten mit umgekehrter Base-Rotation
  drawControlledFinger(35, 0, -20, degToRad(-baseAngle), fingerJoynt1[3], fingerJoynt2and3[3], 17, 14);

  // ===== DAUMEN (SPEZIELLE POSITION) =====
  pushMatrix();          // Neue Koordinaten für Daumen
  translate(-28, 0, -15); // Position seitlich versetzt
  rotateY(1.9);          // Daumen-typische Y-Rotation
  rotateX(0.6);          // Daumen-typische X-Rotation
  drawFingerSegments(fingerJoynt1[4], fingerJoynt2and3[4], 14, 12, false);
  popMatrix();           // Koordinaten zurücksetzen

  popMatrix();  // Hand-Koordinaten zurücksetzen
}

// ===== SPEZIELLER KONTROLLIERTER FINGER =====
// Für den Finger der von Arduino gesteuert wird
void drawControlledFinger(float x, float y, float z, float baseRotation, float joint1, float joint2, int len1, int len2) {
  pushMatrix();              // Speichere Koordinaten
  translate(x, y, z);        // Bewege zu Fingerposition
  
  // ===== BASE-ROTATION ANWENDEN =====
  // Links-Rechts Bewegung des ganzen Fingers (von Arduino)
  rotateY(baseRotation);
  
  // ===== NORMALE GELENK-ROTATIONEN =====
  // Finger-Beugung (ebenfalls von Arduino)
  drawFingerSegments(joint1, joint2, len1, len2, true);
  popMatrix();               // Koordinaten zurücksetzen
}
