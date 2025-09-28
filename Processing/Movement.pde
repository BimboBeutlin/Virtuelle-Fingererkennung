// ===== GRAD ZU RADIANS KONVERTIERUNG =====
// Arduino sendet Winkel in Grad, Processing braucht Radians
float degToRad(float degrees) {
  return degrees * 0.0174533;  // Multiplikation ist schneller als PI/180
}

// ===== FINGER-POSITIONEN AKTUALISIEREN =====
// Wird jeden Frame aufgerufen um Arduino-Werte zu übernehmen
void updateFingerPositions() {
  // ===== ARDUINO-GESTEUERTE FINGER (Index 3) =====
  // Konvertiere Arduino-Winkel von Grad zu Radians
  fingerJoynt1[3]     = degToRad(joint1Angle);   // Erstes Gelenk
  fingerJoynt2and3[3] = degToRad(joint2Angle);   // Zweites Gelenk

  // ===== STATISCHE FINGER-POSITIONEN =====
  // Andere Finger bleiben in festen Positionen
  fingerJoynt1[0] = 0.3; fingerJoynt2and3[0] = 0.4;  // Zeigefinger
  fingerJoynt1[1] = 0.3; fingerJoynt2and3[1] = 0.4;  // Mittelfinger
  fingerJoynt1[2] = 0.3; fingerJoynt2and3[2] = 0.4;  // Ringfinger
  fingerJoynt1[4] = 0.4; fingerJoynt2and3[4] = 0.5;  // Daumen
}

// ===== EINZELNEN FINGER ZEICHNEN =====
// Wrapper-Funktion für Finger an bestimmter Position
void drawFinger(float x, float y, float z, float joint1, float joint2, int len1, int len2, boolean controlled) {
  pushMatrix();                    // Speichere Koordinaten
  translate(x, y, z);              // Bewege zu Fingerposition
  drawFingerSegments(joint1, joint2, len1, len2, controlled);  // Zeichne Finger
  popMatrix();                     // Koordinaten zurücksetzen
}

// ===== FINGER-SEGMENTE ZEICHNEN =====
// Zeichnet die einzelnen Fingerglieder mit Gelenken
void drawFingerSegments(float joint1, float joint2, int len1, int len2, boolean controlled) {
  pushMatrix();
  // ===== ERSTES GELENK DREHEN =====
  rotateZ(joint1);               // Rotation um Z-Achse
  
  // ===== FINGER-FARBE SETZEN =====
  if (controlled) fill(255, 100, 100);  // Rot für Arduino-gesteuerten Finger
  else fill(200, 160, 120);              // Hautfarbe für normale Finger

  // ===== ERSTES GELENK ZEICHNEN =====
  sphere(6);                     // Runde Gelenkkugel
  translate(len1/2, 0, 0);       // Bewege zur Mitte des ersten Segments
  box(len1, 10, 10);             // Erstes Fingersegment (Quader)

  // ===== ZWEITES GELENK VORBEREITEN =====
  translate(len1/2, 0, 0);       // Bewege zum Ende des ersten Segments
  rotateZ(joint2);               // Rotation für PIP (Proximal Interphalangeal)
  
  // ===== PIP GELENK ZEICHNEN =====
  sphere(6);                     // PIP Gelenkkugel
  translate(len2/2, 0, 0);       // Bewege zur Mitte des zweiten Segments (Medial Phalanx)
  box(len2, 10, 10);             // Medial Phalanx Segment

  // ===== DIP GELENK (AUTOMATISCH BERECHNET) =====
  translate(len2/2, 0, 0);       // Bewege zum Ende der Medial Phalanx
  // ===== BIOMECHANISCHE KOPPLUNG: ∡DIP ≈ 0.88 * ∡PIP =====
  // DIP wird NICHT gemessen, sondern aus PIP berechnet
  float dipAngle = joint2 * 0.88; // Wissenschaftlich korrekte Ratio
  rotateZ(dipAngle);             // DIP (Distal Interphalangeal) folgt PIP automatisch
  sphere(6);                     // DIP Gelenkkugel
  translate(len2/2, 0, 0);       // Bewege zur Mitte der Fingerkuppe (Distal Phalanx)
  box(len2, 9, 9);               // Distal Phalanx (Fingerkuppe - etwas kleiner)
  popMatrix();                   // Koordinaten zurücksetzen
}
