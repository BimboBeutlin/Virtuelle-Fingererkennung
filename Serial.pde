// ===== TASTATUR-EINGABE VERARBEITUNG =====
// Wird bei jedem Tastendruck aufgerufen
void keyPressed() {
  // ===== HAND-ROTATION MIT PFEILTASTEN =====
  // Nur Pfeiltasten werden für 3D-Rotation verwendet
  if (key == CODED) {
    if (keyCode == UP) gRotateX -= 0.1;      // Pfeil hoch: X-Achse nach oben
    if (keyCode == DOWN) gRotateX += 0.1;    // Pfeil runter: X-Achse nach unten  
    if (keyCode == LEFT) gRotateY -= 0.1;    // Pfeil links: Y-Achse nach links
    if (keyCode == RIGHT) gRotateY += 0.1;   // Pfeil rechts: Y-Achse nach rechts
  }
  
  // ===== Z-ACHSEN ROTATION MIT R/T TASTEN =====
  // Für Drehung um die Tiefenachse
  if (key == 'r' || key == 'R') gRotateZ -= 0.1;  // R: Z-Achse gegen Uhrzeiger
  if (key == 't' || key == 'T') gRotateZ += 0.1;  // T: Z-Achse im Uhrzeiger
  
  // ===== ROTATION ZURÜCKSETZEN =====
  // Leertaste: Alle Rotationswerte auf Standardposition
  if (key == ' ') {
    gRotateX = 2.0; gRotateY = 0.0; gRotateZ = 4.0;
  }
  
  // ===== SERIELLE EINGABE VERARBEITUNG =====
  // Wenn User in Konsole tippt
  if (isTyping) {
    // ===== ENTER: NACHRICHT SENDEN =====
    if (key == ENTER || key == RETURN) {
      if (connected && port != null && serialInput.length() > 0) {
        port.write(serialInput + '\n');        // Sende an Arduino
        logSerial(">> " + serialInput);        // Zeige in Konsole  
        serialInput = "";                      // Leere Eingabefeld
      }
      // Bleibe in der Konsole aktiv nach Enter - kein isTyping = false;
    // ===== BACKSPACE: ZEICHEN LÖSCHEN =====
    } else if (key == BACKSPACE) {
      if (serialInput.length() > 0) serialInput = serialInput.substring(0, serialInput.length() - 1);
    // ===== NORMALES ZEICHEN HINZUFÜGEN =====
    } else if (key != CODED) {
      serialInput += key;                      // Füge Buchstabe zur Eingabe hinzu
    }
  }
}

// ===== MAUSKLICK VERARBEITUNG =====
// Wird bei jedem Mausklick aufgerufen
void mousePressed() {
  // ===== EINGABEFELD-KOORDINATEN DEFINIEREN =====
  int inputBoxX = 20;
  int inputBoxY = height - 300;
  int inputBoxWidth = 560;
  int inputBoxHeight = 300;
  
  // ===== PRÜFE OB KLICK IM EINGABEFELD =====
  // Unterer Bereich der Konsole (Eingabefeld)
  if (mouseX > inputBoxX + 15 && mouseX < inputBoxX + inputBoxWidth - 15 &&
      mouseY > inputBoxY + inputBoxHeight - 55 && mouseY < inputBoxY + inputBoxHeight - 10) {
    isTyping = true;   // Aktiviere Eingabemodus
  } else {
    isTyping = false;  // Deaktiviere Eingabemodus
  }
}

// ===== SERIELLE DATEN EMPFANGEN =====
// Wird automatisch aufgerufen wenn Arduino Daten sendet
void serialEvent(Serial port) {
  // ===== PRÜFE OB DATEN VERFÜGBAR =====
  if (port.available() > 0) {
    // ===== LESE KOMPLETTE NACHRICHT BIS ZEILENENDE =====
    String message = port.readStringUntil('\n');
    if (message != null) {
      message = message.trim();               // Entferne Leerzeichen/Zeilenumbrüche
      logSerial("<< " + message);             // Zeige in Konsole
      
      // ===== PARSE MOTOR-WINKEL NACHRICHTEN =====
      // Erwarte Format: "Base:123 Joint1:45 Joint2:67"
      if (message.contains("Base:") && message.contains("Joint1:") && message.contains("Joint2:")) {
        try {
          // ===== EXTRAHIERE WERTE MIT HILFSFUNKTION =====
          // Suche nach Zahlen nach den Schlüsselwörtern
          String baseStr = extractValue(message, "Base:");
          String joint1Str = extractValue(message, "Joint1:");
          String joint2Str = extractValue(message, "Joint2:");
          
          // ===== KONVERTIERE ZU GANZZAHLEN =====
          // Nur wenn Werte erfolgreich extrahiert wurden
          if (baseStr != null) baseAngle = parseInt(baseStr);
          if (joint1Str != null) joint1Angle = parseInt(joint1Str);
          if (joint2Str != null) joint2Angle = parseInt(joint2Str);
          
        } catch (Exception e) {
          // ===== FEHLERBEHANDLUNG =====
          logSerial("Error parsing: " + message);
        }
      }
    }
  }
}

// ===== LOGGING FUNKTION =====
// Fügt Nachricht zur seriellen Konsole hinzu
void logSerial(String message) {
  serialLog.add(message);                               // Füge neue Nachricht hinzu
  if (serialLog.size() > MAX_LOG_LINES) serialLog.remove(0); // Lösche älteste wenn zu viele
}

// ===== WERT-EXTRAKTIONS HILFSFUNKTION =====
// Sucht nach Schlüsselwort und extrahiert die folgende Zahl
String extractValue(String message, String key) {
  // ===== FINDE POSITION DES SCHLÜSSELWORTS =====
  int keyIndex = message.indexOf(key);
  if (keyIndex == -1) return null;        // Schlüsselwort nicht gefunden
  
  // ===== STARTE NACH DEM SCHLÜSSELWORT =====
  int startIndex = keyIndex + key.length();
  String remainder = message.substring(startIndex);
  
  // ===== EXTRAHIERE ZAHL ZEICHEN FÜR ZEICHEN =====
  // Unterstützt auch negative Zahlen
  String numberStr = "";
  boolean foundNumber = false;
  
  for (int i = 0; i < remainder.length(); i++) {
    char c = remainder.charAt(i);
    // ===== MINUS-ZEICHEN AM ANFANG ERLAUBT =====
    if (c == '-' && !foundNumber) {
      numberStr += c;
      foundNumber = true;
    // ===== ZIFFERN SAMMELN =====
    } else if (c >= '0' && c <= '9') {
      numberStr += c;                       // Füge Ziffer hinzu
      foundNumber = true;
    } else if (foundNumber) {
      break;                               // Stoppe bei erstem Nicht-Ziffer nach Zahl
    }
  }
  
  // ===== GEBE GEFUNDENE ZAHL ZURÜCK =====
  return foundNumber ? numberStr : null;   // Null wenn keine Zahl gefunden
}
