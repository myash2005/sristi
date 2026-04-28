import 'dart:math';

class PassiveDetectionEngine {
  int _keystrokes = 0;
  int _backspaces = 0;
  DateTime? _startTime;
  
  void registerKeystroke(String key) {
    if (_startTime == null) {
      _startTime = DateTime.now();
    }
    
    if (key == 'backspace') {
      _backspaces++;
    } else {
      _keystrokes++;
    }
  }
  
  double calculateCognitiveLoad() {
    if (_startTime == null || _keystrokes == 0) return 0.0;
    
    final elapsedMinutes = DateTime.now().difference(_startTime!).inSeconds / 60.0;
    if (elapsedMinutes <= 0) return 0.0;
    
    // Average word length ~ 5 characters
    final wpm = (_keystrokes / 5) / elapsedMinutes;
    final backspaceRatio = _backspaces / max(1, _keystrokes);
    
    // Low WPM and high backspace ratio indicates high cognitive load / stress
    double loadScore = (backspaceRatio * 0.6) + (1.0 - min(1.0, wpm / 60.0)) * 0.4;
    return min(1.0, loadScore);
  }
  
  void reset() {
    _keystrokes = 0;
    _backspaces = 0;
    _startTime = null;
  }
}
