// ===== HAUPTFUNKTION FÜR DAS HUD-DISPLAY =====
// Diese Funktion wird jeden Frame aufgerufen und zeichnet das komplette Interface
void displayHUD() {
  // Tiefentest deaktivieren für 2D-HUD-Elemente über der 3D-Szene
  hint(DISABLE_DEPTH_TEST);
  // Kamera auf 2D-Modus zurücksetzen für HUD-Zeichnung
  camera();

  // ===== HINTERGRUND-EFFEKTE =====
  // Scanlines entfernt für sauberes Interface
  // drawFireScanlines(); // DEAKTIVIERT
  
  // ===== HAUPT-HUD-RAHMEN DEFINIEREN =====
  // Position und Größe des Hauptfensters oben links
  int hudX = 15, hudY = 15, hudWidth = 520, hudHeight = 300;
  
  // ===== DREIFACH-RAHMEN FÜR 3D-TIEFENEFFEKT =====
  // Zeichnet 3 Rahmen übereinander für visuellen Tiefeneffekt
  for (int i = 0; i < 3; i++) {
    // Farbverlauf von Rot zu Schwarz, Transparenz nimmt ab
    stroke(255 - i * 60, i * 30, 0, 255 - i * 80);
    strokeWeight(6 - i * 2);  // Rahmen werden dünner nach innen
    noFill();                 // Nur Umrisse, keine Füllung
    // Rahmen werden nach außen größer für Tiefeneffekt
    rect(hudX - i * 3, hudY - i * 3, hudWidth + i * 6, hudHeight + i * 6, 15 + i * 3);
  }

  // ===== ANIMIERTER NEON-GLOW HAUPTRAHMEN =====
  // Pulsierende Außenlinie mit Sinus-Welle Animation
  float aggressiveGlow = sin(radians(frameCount * 1)) * 80 + 175; // Pulsiert zwischen 95-255
  stroke(255, aggressiveGlow, 0, 150); // Gelb-Orange mit pulsierender Intensität
  strokeWeight(10);                    // Dicker Strich für Glow-Effekt
  noFill();
  rect(hudX, hudY, hudWidth, hudHeight, 15);

  // ===== SCHWARZES HAUPTPANEL =====
  // Dunkler Hintergrund für bessere Lesbarkeit des Inhalts
  noStroke();
  fill(10, 10, 10, 220); // Fast schwarz mit leichter Transparenz
  rect(hudX + 10, hudY + 10, hudWidth - 20, hudHeight - 20, 10);
  
  // ===== BEWEGENDE PARTIKEL IM PANEL =====
  // Fügt lebendige Partikel-Animation im Hintergrund hinzu
  drawAggressiveParticles(hudX + 10, hudY + 10, hudWidth - 20, hudHeight - 20);

  // ===== HAUPTTITEL MIT FEUEREFFEKT =====
  // Aggressive rote Grundfarbe für maximalen Impact
  fill(255, 0, 0);
  textSize(42);
  
  // ===== GLITCH-EFFEKT FÜR CYBER-LOOK =====
  // 1% Chance pro Frame für zufälligen Störeffekt (noch langsamer gemacht)
  if (random(100) < 0.5) { 
    fill(255, 255, 0);  // Gelber Glitch-Text
    text("ROBOTIC FINGER! 🔥", hudX + 25, hudY + 45); // Nach oben verschoben
  }
  
  // ===== HAUPT-TITEL MIT FEUER-GLOW =====
  // Orangeroter Haupttext für Feuereffekt
  fill(255, 50, 0);
  text("ROBOTIC FINGER! 🔥", hudX + 20, hudY + 40); // Nach oben verschoben
  
  // ===== GELBER NEON-UMRISS =====
  // Gelber Outline-Text für Neon-Glow-Effekt
  fill(255, 255, 0, 180);
  text("ROBOTIC FINGER! 🔥", hudX + 22, hudY + 42); // Nach oben verschoben

  // ===== STATUS-INDIKATOR MIT FEUER-ANIMATION =====
  // Doppelte Sinus-Welle für komplexere Pulsierung
  float megaPulse = sin(radians(frameCount * 1)) * 0.5 + 0.5; // Haupt-Pulsrhythmus
  float firePulse = sin(radians(frameCount * 1)) * 0.4 + 0.6; // Feuer-Pulsation
  
  // ===== ÄUßERER FEUER-RING =====
  // Orange pulsierender Ring um Status-Indikator
  stroke(255, 100 * megaPulse, 0, 200); // Orange mit variabler Intensität
  strokeWeight(6);                       // Dicker Ring-Umriss
  noFill();                              // Nur Umriss, keine Füllung
  ellipse(hudX + 35, hudY + 110, 35 * firePulse, 35 * firePulse);
  
  // ===== INNERER VERBINDUNGS-KERN =====
  // Zeigt Arduino-Verbindungsstatus an
  noStroke();
  fill(connected ? color(255, 255, 0) : color(255, 0, 0)); // Gelb = verbunden, Rot = getrennt
  // ===== STATUS-KERN ZEICHNEN =====
  // Gefüllter Kreis zeigt Verbindungsstatus an
  ellipse(hudX + 35, hudY + 110, 25, 25);
  
  // ===== STATUS-TEXT MIT SCHREIBMASCHINEN-EFFEKT =====
  // Gelber Text für gute Sichtbarkeit
  fill(255, 255, 0);
  textSize(18);
  String statusText = connected ? "ONLINE!" : "OFFLINE!";
  // Schreibmaschinen-Effekt: Text erscheint Buchstabe für Buchstabe
  String displayStatus = typewriterEffect(statusText, frameCount / 8);
  text(displayStatus, hudX + 65, hudY + 115);

  // ===== MOTOR-WINKEL ANZEIGEN MIT FEUER-STYLE =====
  // Vier Winkelanzeigen: 3 gemessene + 1 berechnetes Gelenk (mehr Abstand)
  drawFireAngleIndicator("BASE", baseAngle, hudX + 30, hudY + 150);
  drawFireAngleIndicator("JOINT1 (MCP)", joint1Angle, hudX + 30, hudY + 180);
  drawFireAngleIndicator("JOINT2 (PIP)", joint2Angle, hudX + 30, hudY + 210);
  
  // ===== BERECHNETES DIP GELENK =====
  // DIP wird automatisch aus PIP berechnet (∡DIP ≈ 0.88 * ∡PIP)
  int dipAngle = (int)(joint2Angle * 0.88);
  drawFireAngleIndicatorCalculated("DIP (CALC)", dipAngle, hudX + 30, hudY + 240);

  // ===== STEUERUNGSANWEISUNGEN =====
  // Gelber Text erklärt die Tastatursteuerung
  fill(255, 255, 0);
  textSize(16);
  text("Pfeile: Rotation | R/T: Z-Dreh | SPACE: Reset", hudX + 30, hudY + 275);

  // ===== SERIELLE KONSOLE UNTEN =====
  // Position und Größe der Konsole am unteren Bildschirmrand
  int consoleX = 20, consoleY = height - 300;
  int consoleWidth = 560, consoleHeight = 300;
  
  // ===== AGGRESSIVE KONSOLEN-RAHMEN =====
  // Dreifach-Rahmen für 3D-Tiefeneffekt der Konsole
  for (int i = 0; i < 3; i++) {
    stroke(255 - i * 80, i * 20, 0, 220 - i * 60); // Rot-Gelb Verlauf
    strokeWeight(4 - i);                            // Rahmendicke nimmt ab
    fill(i * 5, i * 5, i * 5, 200 - i * 50);      // Dunkler werdender Hintergrund
    // Rahmen werden nach außen größer
    rect(consoleX - i * 2, consoleY - i * 2, consoleWidth + i * 4, consoleHeight + i * 4, 12 + i * 2);
  }

  // ===== TERMINAL HINTERGRUND-EFFEKT =====
  // Subtiler Grid-Pattern anstatt Feuer-Regen
  drawTerminalGrid(consoleX + 15, consoleY + 50, consoleWidth - 30, consoleHeight - 100);

  // ===== KONSOLEN-KOPFZEILE =====
  // Gelber Titel für die serielle Konsole
  fill(255, 255, 0);
  textSize(22);
  // ===== KONSOLEN-TITEL MIT FEUER-EMOJI =====
  text("  TERMINAL", consoleX + 20, consoleY + 35);
  
  // ===== BLINKENDE FEUER-LICHTER =====
  // Vier orange blinkende LEDs für Cyber-Effekt
  for (int i = 0; i < 4; i++) {
    // Jede LED blinkt mit verschiedener Geschwindigkeit (langsamer gemacht)
    float fireBlink = sin(radians(frameCount * (2 + i * 1))) * 0.5 + 0.5; // Reduziert von 4+i*2 auf 2+i*1
    fill(255 * fireBlink, 100 * fireBlink, 0); // Orange mit variabler Helligkeit
    ellipse(consoleX + consoleWidth - 80 + i * 18, consoleY + 25, 12, 12);
  }

  // ===== SERIELLE LOG-ANZEIGE =====
  // Zeigt empfangene Arduino-Nachrichten in verschiedenen Farben an
  fill(255, 255, 0);
  textSize(15);
  textAlign(LEFT, TOP);
  float logY = consoleY + 65;
  
  // ===== DURCHLAUFE ALLE LOG-NACHRICHTEN =====
  for (int i = 0; i < serialLog.size(); i++) {
    String msg = serialLog.get(i);
    
    // ===== FARBKODIERUNG FÜR NACHRICHTENTYPEN =====
    // Verschiedene Farben für verschiedene Nachrichtentypen
    if (msg.startsWith(">>")) {
      fill(255, 255, 0, 230);    // Gelb für ausgehende Commands
    } else if (msg.contains("ERROR")) {
      fill(255, 0, 0, 255);      // Knallrot für Fehlermeldungen
    } else if (msg.contains("OK")) {
      fill(255, 150, 0, 230);    // Orange für Erfolgsmeldungen
    } else {
      fill(255, 200, 100, 200);  // Hell für Standard-Nachrichten
    }
    
    // ===== SCHREIBMASCHINEN-EFFEKT FÜR NEUESTE NACHRICHT =====
    // Nur die letzte Nachricht wird mit Schreibeffekt angezeigt
    if (i == serialLog.size() - 1) {
      String displayMsg = typewriterEffect(msg, frameCount / 2);
      text(displayMsg, consoleX + 20, logY + i * 25);
    } else {
      // Ältere Nachrichten werden komplett angezeigt
      text(msg, consoleX + 20, logY + i * 25);
    }
  }

  // ===== EINGABEFELD MIT FEUER-DESIGN =====
  // Dunkler Hintergrund für Eingabefeld
  fill(20, 5, 0, 250);
  stroke(255, 100, 0);
  strokeWeight(4);
  rect(consoleX + 15, consoleY + consoleHeight - 55, consoleWidth - 30, 45, 10);
  
  // ===== AKTIVES EINGABE-GLOW =====
  // Gelber Rahmen wenn User tippt
  if (isTyping) {
    stroke(255, 255, 0, 200);
    strokeWeight(6);
    noFill();
    rect(consoleX + 15, consoleY + consoleHeight - 55, consoleWidth - 30, 45, 10);
  }
  
  // ===== EINGABETEXT MIT FEUER-CURSOR =====
  // Weißer Text für die Eingabe
  noStroke();
  fill(255, 255, 255);
  textSize(18);
  String displayText = serialInput;
  
  // ===== BLINKENDER FEUER-CURSOR =====
  // Alle 600ms blinkt ein Feuer-Emoji als Cursor
  if (isTyping && millis() % 600 < 300) {
    fill(255, 255, 0);
    displayText += "🔥"; // Feuer-Cursor blinkt
  }
  text(displayText, consoleX + 25, consoleY + consoleHeight - 35);

  // ===== EINGABE-PROMPT WENN NICHT AKTIV =====
  // Zeigt Anweisung wenn User nicht tippt
  if (!isTyping) {
    fill(255, 150, 0);
    textSize(14);
    text(">>>Command! 🔥", consoleX + 25, consoleY + consoleHeight - 35);
  }

  // ===== TIEFENTEST WIEDER AKTIVIEREN =====
  // Wichtig: 3D-Rendering für Hand wieder einschalten
  hint(ENABLE_DEPTH_TEST);
}

// ===== FEUER-STIL WINKELANZEIGE FUNKTION =====
// Zeichnet einen einzelnen Motorwinkel mit aggressiver Feuer-Animation
void drawFireAngleIndicator(String label, int angle, float x, float y) {
  // ===== DUNKLER HINTERGRUND FÜR WINKELANZEIGE =====
  // Schwarzer Balken als Basis für die Anzeige
  noStroke();
  fill(0, 0, 0, 200);
  rect(x, y - 20, 220, 24, 8);
  
  // ===== DYNAMISCHE FEUER-FARBBALKEN =====
  // Breite des Balkens basiert auf Winkelwert
  float barWidth = angle * 1.2;
  
  // ===== AMPEL-FARBSYSTEM FÜR WINKEL =====
  // Farbe ändert sich je nach Winkelbereich
  if (angle < 60) {
    fill(255, 255, 0);        // Gelb für sichere Bereiche (0-60°)
  } else if (angle < 120) {
    fill(255, 150, 0);        // Orange für Warnbereich (60-120°)
  } else {
    fill(255, 0, 0);          // Rot für Gefahrenbereich (120°+)
  }
  
  // ===== HAUPTBALKEN ZEICHNEN =====
  rect(x + 3, y - 17, barWidth, 18, 6);
  
  // ===== FEUER-GLOW OBENDRAUF =====
  // Orangener Glow-Effekt für mehr Feuer-Look
  fill(255, 100, 0, 150);
  rect(x + 3, y - 17, barWidth, 6, 6);
  
  // ===== WINKEL-TEXT MIT SCHATTEN =====
  // Schwarzer Schatten für bessere Lesbarkeit
  fill(0, 0, 0);
  textSize(16);
  text(label + ": " + angle + "°", x + 5, y - 5);
  // Gelber Haupttext
  fill(255, 255, 0);
  text(label + ": " + angle + "°", x + 3, y - 7);
  
  // ===== KRITISCHE WINKEL WARNUNG =====
  // Blinkende Warnung wenn Winkel zu hoch wird
  if (angle > 160) {
    // Sinus-Welle für pulsierendes Blinken
    fill(255, 0, 0, sin(radians(frameCount * 15)) * 150 + 105);
    textSize(14);
    text("🔥 CRITICAL!", x + 180, y - 25);
  }
}

// ===== AGGRESSIVE SCANLINES FUNKTION =====
// Zeichnet animierte horizontale Linien über den ganzen Bildschirm
void drawFireScanlines() {
  stroke(255, 50, 0, 40);  // Rote semi-transparente Linien
  strokeWeight(2);
  
  // ===== DURCHLAUFE ALLE BILDSCHIRMZEILEN =====
  for (int i = 0; i < height; i += 6) {
    // ===== SINUS-WELLE FÜR DYNAMISCHE INTENSITÄT =====
    // Jede Linie hat verschiedene Helligkeit basiert auf Position und Zeit
    float intensity = sin(radians(frameCount * 2 + i)) * 30 + 50;
    stroke(255, intensity, 0, intensity);
    line(0, i, width, i);  // Horizontale Linie über ganze Breite
  }
}

// ===== AGGRESSIVE PARTIKEL FUNKTION =====
// Zeichnet bewegende orange Punkte im HUD-Hintergrund
void drawAggressiveParticles(float x, float y, float w, float h) {
  // ===== 10 PARTIKEL FÜR PERFORMANCE =====
  // Reduziert von 25 auf 10 für bessere Framerate
  for (int i = 0; i < 10; i++) {
    // ===== SINUS-COSINUS BEWEGUNG =====
    // Jeder Partikel bewegt sich in komplexen Kreisen
    float px = x + (sin(radians(frameCount * 2 + i * 25)) * w/2) + w/2;  // X-Position
    float py = y + (cos(radians(frameCount * 1.5 + i * 30)) * h/2) + h/2; // Y-Position
    
    // ===== PULSIERENDE ORANGE FARBE =====
    // Helligkeit ändert sich mit Sinus-Welle
    fill(255, 100 + sin(radians(frameCount * 3 + i * 20)) * 100, 0, 150);
    noStroke();
    ellipse(px, py, 4, 4);  // Kleine 4x4 Pixel Kreise
  }
}

// ===== FEUER-REGEN EFFEKT =====
// Matrix-Style fallende Zahlen in der Konsole
void drawFireRain(float x, float y, float w, float h) {
  // ===== 15 VERTIKALE REGENSTRAHLEN =====
  // Reduziert von 30 auf 15 für Performance
  for (int i = 0; i < 15; i++) {
    // ===== GLEICHMÄSS VERTEILTE X-POSITIONEN =====
    float rainX = x + (i * w/15);
    // ===== FALLENDE Y-POSITION MIT WIEDERHOLUNG (VIEL LANGSAMER) =====
    float rainY = y + ((frameCount * 0.5 + i * 60) % (h * 2)) - h; // Von 2 auf 0.5 reduziert = 4x langsamer
    
    // ===== 4 ZAHLEN PRO STRAHL =====
    // Reduziert von 6 auf 4 Zeichen pro Spalte
    for (int j = 0; j < 4; j++) {
      // ===== FARBVERLAUF VON ORANGE ZU TRANSPARENT =====
      fill(255, 150 - j * 25, 0, 255 - j * 40);
      textSize(12);
      // ===== ZUFÄLLIGE ZAHLEN 0-9 =====
      char c = (char)(48 + (int)random(10));
      text(c, rainX, rainY + j * 18);  // Versetzter Y-Abstand
    }
  }
}

// ===== SCHREIBMASCHINEN-EFFEKT FUNKTION =====
// Lässt Text Buchstabe für Buchstabe erscheinen
String typewriterEffect(String fullText, float progress) {
  // ===== BERECHNE ANZAHL SICHTBARER ZEICHEN =====
  // Progress bestimmt wie viele Buchstaben schon gezeigt werden
  int chars = (int)(progress % (fullText.length() * 3));
  // ===== BEGRENZE AUF MAXIMALE TEXTLÄNGE =====
  if (chars > fullText.length()) chars = fullText.length();
  // ===== GEBE TEILSTRING ZURÜCK =====
  // Zeigt nur die ersten 'chars' Buchstaben
  return fullText.substring(0, chars);
}

// ===== TERMINAL GRID HINTERGRUND =====
// Zeichnet ein subtiles Raster-Pattern im Terminal
void drawTerminalGrid(float x, float y, float w, float h) {
  stroke(255, 100, 0, 30);  // Sehr transparentes Orange
  strokeWeight(1);
  
  // ===== VERTIKALE LINIEN =====
  for (int i = 0; i < w; i += 25) {
    line(x + i, y, x + i, y + h);
  }
  
  // ===== HORIZONTALE LINIEN =====  
  for (int i = 0; i < h; i += 25) {
    line(x, y + i, x + w, y + i);
  }
  
  // ===== SUBTILE PARTIKEL =====
  noStroke();
  for (int i = 0; i < 8; i++) {
    float px = x + random(w);
    float py = y + random(h);
    float pulse = sin(radians(frameCount * 3 + i * 45)) * 0.5 + 0.5;
    fill(255, 150, 0, pulse * 60);
    ellipse(px, py, 3, 3);
  }
}

// ===== FEUER-STIL WINKELANZEIGE FÜR BERECHNETE WERTE =====
// Spezielle Anzeige für automatisch berechnete Winkel (wie DIP)
void drawFireAngleIndicatorCalculated(String label, int angle, float x, float y) {
  // ===== DUNKLER HINTERGRUND FÜR WINKELANZEIGE =====
  noStroke();
  fill(0, 0, 0, 200);
  rect(x, y - 20, 220, 24, 8);
  
  // ===== DYNAMISCHE FEUER-FARBBALKEN (BLAU FÜR BERECHNET) =====
  float barWidth = angle * 1.2;
  
  // ===== BLAUES FARBSYSTEM FÜR BERECHNETE WINKEL =====
  if (angle < 60) {
    fill(100, 200, 255);        // Hellblau für sichere Bereiche
  } else if (angle < 120) {
    fill(50, 150, 255);         // Blau für Warnbereich  
  } else {
    fill(0, 100, 255);          // Dunkelblau für hohe Werte
  }
  
  // ===== HAUPTBALKEN ZEICHNEN =====
  rect(x + 3, y - 17, barWidth, 18, 6);
  
  // ===== BLAUER GLOW OBENDRAUF =====
  fill(150, 200, 255, 150);
  rect(x + 3, y - 17, barWidth, 6, 6);
  
  // ===== WINKEL-TEXT MIT SCHATTEN =====
  fill(0, 0, 0);
  textSize(16);
  text(label + ": " + angle + "° (0.88×PIP)", x + 5, y - 5);
  // Cyan Haupttext für berechnete Werte
  fill(100, 255, 255);
  text(label + ": " + angle + "° (0.88×PIP)", x + 3, y - 7);
  
  // ===== BERECHNUNGS-HINWEIS =====
  if (angle > 160) {
    fill(0, 150, 255, sin(radians(frameCount * 15)) * 150 + 105);
    textSize(14);
    text("🔹 CALC!", x + 180, y - 25);
  }
}
