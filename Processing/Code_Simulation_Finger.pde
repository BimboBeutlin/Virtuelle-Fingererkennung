// ===== BIBLIOTHEK IMPORTIEREN =====
// Processing Serial Bibliothek für Arduino-Kommunikation
import processing.serial.*;

// ===== SERIELLE VERBINDUNG =====
Serial port;  // Objekt für Serial-Port Kommunikation

// ===== HAND POSITION UND ROTATION =====
// Variables für 3D-Hand Steuerung mit Tastatur
float handPosX = 0.0;   // X-Position (aktuell ungenutzt)
float handPosY = 0.0;   // Y-Position (aktuell ungenutzt)
float handPosZ = 0.0;   // Z-Position (aktuell ungenutzt)
float gRotateX = 2.0;   // X-Rotation (Pfeiltasten hoch/runter)
float gRotateY = 0.0;   // Y-Rotation (Pfeiltasten links/rechts)
float gRotateZ = 4.0;   // Z-Rotation (R/T Tasten)

// ===== KAMERA POSITION =====
// 3D-Kamera Position für optimale Sicht auf Hand
float camX = 600;       // Kamera X-Position
float camY = -20;       // Kamera Y-Position
float camZ = 600;       // Kamera Z-Position

// ===== ARDUINO WINKEL-WERTE =====
// Empfangene Motorwinkel vom Arduino
int baseAngle = 0;      // Basis-Motor (Links-Rechts Bewegung)
int joint1Angle = 0;    // Erstes Fingergelenk
int joint2Angle = 0;    // Zweites Fingergelenk

// ===== FINGER-GELENK WINKEL =====
// Arrays für alle 5 Finger (Index 3 = Arduino-gesteuert)
float[] fingerJoynt1 = new float[5];      // Erste Gelenke aller Finger
float[] fingerJoynt2and3 = new float[5];  // Zweite/Dritte Gelenke aller Finger

// ===== VERBINDUNGSSTATUS =====
boolean connected = false;  // True wenn Arduino verbunden ist

// ===== SERIELLE KONSOLE UI =====
// Datenstrukturen für das HUD und die Konsole
ArrayList<String> serialLog = new ArrayList<String>();  // Log aller seriellen Nachrichten
final int MAX_LOG_LINES = 6;                           // Maximale Zeilen in der Konsole
String serialInput = "";                               // Aktuelle Eingabe des Users
boolean isTyping = false;                              // True wenn User in Konsole tippt

// ===== SETUP FUNKTION =====
// Wird einmal beim Programmstart aufgerufen
void setup() {
  fullScreen(P3D);    // Vollbild mit 3D-Rendering
  
  // ===== HÖHERE FRAMERATE FÜR FLÜSSIGE ANIMATION =====
  frameRate(120);     // 120 FPS für beste Performance
  
  // ===== VERFÜGBARE SERIAL PORTS AUFLISTEN =====
  println("Available serial ports:");
  printArray(Serial.list());
  
  // ===== AUTOMATISCHE ARDUINO-ERKENNUNG =====
  try {
    if (Serial.list().length > 0) {
      String portName = null;
      // ===== SUCHE NACH ARDUINO-TYPISCHEN PORT-NAMEN =====
      for (String p : Serial.list()) {
        // Mac: usbmodem, Windows: COM, Linux: ttyUSB
        if (p.contains("usbmodem") || p.contains("tty.usbmodem") || p.contains("COM")) {
          portName = p;
          break;
        }
      }
      // ===== FALLBACK AUF LETZTEN PORT =====
      if (portName == null) portName = Serial.list()[Serial.list().length - 1];
      
      // ===== SERIELLE VERBINDUNG HERSTELLEN =====
      port = new Serial(this, portName, 115200);  // 115200 Baud für Arduino
      port.bufferUntil('\n');                     // Buffer bis Zeilenende
      port.clear();                               // Buffer leeren
      connected = true;                           // Verbindung erfolgreich
    } else {
      connected = false;                          // Keine Ports verfügbar
    }
  } catch (Exception e) {
    // ===== FEHLERBEHANDLUNG =====
    port = null;
    connected = false;                            // Verbindung fehlgeschlagen
  }

  fullScreen(P3D);  // Nochmals sicherstellen
  
  // ===== FINGER-ARRAYS INITIALISIEREN =====
  // Alle Finger auf 0-Position setzen
  for (int i = 0; i < 5; i++) {
    fingerJoynt1[i] = 0.0;
    fingerJoynt2and3[i] = 0.0;
  }
}

// ===== HAUPT-RENDER-SCHLEIFE =====
// Wird 120x pro Sekunde aufgerufen
void draw() {
  background(20, 20, 40);  // Dunkler Hintergrund
  
  // ===== OPTIMIERTE UPDATES =====
  // Finger-Positionen mit Arduino-Daten aktualisieren
  updateFingerPositions();
  // 3D-Kamera Position aktualisieren
  updateCamera();
  
  // ===== 3D-BELEUCHTUNG SETUP =====
  // Weniger intensive Beleuchtung für bessere Performance
  ambientLight(100, 100, 120);                        // Allgemeine Beleuchtung
  directionalLight(200, 200, 200, -0.5, 0.5, -1);     // Gerichtetes Licht

  // ===== 3D-HAND RENDERING =====
  pushMatrix();                                        // Speichere Koordinaten
  translate(300, 0, 0);                               // Hand nach rechts verschieben (für bessere Sicht)
  scale(3.0);                                         // Hand 3x größer machen
  drawHand();                                         // Zeichne komplette Hand
  popMatrix();                                        // Koordinaten zurücksetzen
  
  // ===== HUD ANZEIGEN =====
  // Zeichne das komplette Benutzerinterface über die 3D-Szene
  displayHUD();
}
