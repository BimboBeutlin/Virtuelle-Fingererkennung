// ===== KAMERA UPDATE FUNKTION =====
// Wird jeden Frame aufgerufen um die 3D-Kamera zu positionieren
void updateCamera() {
  // ===== FESTE KAMERA POSITION =====
  // Kamera bleibt statisch für optimale Handsicht
  camera(600, -20, 600,   // Kamera-Position (x,y,z) - schräg von oben-rechts
         0, 0, 0,          // Zielpunkt (0,0,0) - Hand-Zentrum
         0, 1, 0);         // Up-Vektor (y-Achse nach oben)
}
