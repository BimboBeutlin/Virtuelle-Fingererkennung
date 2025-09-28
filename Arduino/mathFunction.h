// ===== Globale Kalibrierwerte =====
extern int x1, x2, x3;   // Joint1 Rohwerte
extern int y1, y2, y3;   // Joint2 Rohwerte

// ===== Globale Koeffizienten =====
extern float a1, b1, c1;   // Joint1
extern float a2, b2, c2;   // Joint2

// ===== Hilfsfunktion: Quadratische Interpolation =====
// Berechnet Koeffizienten für eine Parabel durch drei Punkte (p,theta)
void solveQuadratic(float p1, float theta1,
                    float p2, float theta2,
                    float p3, float theta3,
                    float &a, float &b, float &c) 
{
  float denom = (p1 - p2) * (p1 - p3) * (p2 - p3);
  a = ( (theta1*(p2 - p3)) + (theta2*(p3 - p1)) + (theta3*(p1 - p2)) ) / denom;
  b = ( (theta1*(p3*p3 - p2*p2)) + (theta2*(p1*p1 - p3*p3)) + (theta3*(p2*p2 - p1*p1)) ) / denom;
  c = ( (theta1*(p2*p3*(p2 - p3))) + (theta2*(p3*p1*(p3 - p1))) + (theta3*(p1*p2*(p1 - p2))) ) / denom;
}

// ===== Funktionen zum Berechnen der Koeffizienten =====
void getPolynomialEquation(int p1, int p2, int p3,
                           int theta1, int theta2, int theta3,
                           float &a, float &b, float &c) {
  solveQuadratic(p1, theta1, p2, theta2, p3, theta3, a, b, c);
}

void getPolynomialEquationJoint1() {
  getPolynomialEquation(x1, x2, x3, 0, 45, 90, a1, b1, c1);
}

void getPolynomialEquationJoint2() {
  getPolynomialEquation(y1, y2, y3, 0, 45, 90, a2, b2, c2);
}

// ===== Funktionen zum Berechnen der Winkel (Optimiert) =====
// Verwendung von integer-basierten Operationen zur Geschwindigkeitssteigerung
inline int getJointAngle(float a, float b, float c, int potValue) {
  // Optimiert: Reduziere Floating-Point Multiplikationen
  float temp = a * potValue;
  return (int)(temp * potValue + b * potValue + c);
}

// Alternative: Für extrem hohe Performance könnte man Fixed-Point Arithmetik verwenden
// Hier eine vereinfachte Version die casting minimiert:
inline int getJointAngleFast(float a, float b, float c, int potValue) {
  int pv = potValue;  // Lokale Kopie für bessere Compiler-Optimierung
  return (int)(a * pv * pv + b * pv + c);
}

inline int getJoint1Angle(int potValue) {
  return getJointAngleFast(a1, b1, c1, potValue);
}

inline int getJoint2Angle(int potValue) {
  return getJointAngleFast(a2, b2, c2, potValue);
}
