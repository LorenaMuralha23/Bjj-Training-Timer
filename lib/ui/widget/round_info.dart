class RoundInfo {

  Duration _roundDuration;
  Duration _restDuration;
  int _rounds;
  bool _autoRestartEnabled;
  bool _soundEnabled;  


  RoundInfo(this._roundDuration, this._restDuration, this._rounds, this._autoRestartEnabled, this._soundEnabled);
  
  Duration get roundDuration {
    return _roundDuration;
  }

  Duration get restDuration {
    return _restDuration;
  }

  int get rounds {
    return _rounds;
  }

  bool get autoRestartEnabled {
    return _autoRestartEnabled;
  }

  bool get soundEnabled {
    return _soundEnabled;
  }

  set roundDuration (Duration roundDuration) {
    _roundDuration = roundDuration;
  }

  set restDuration (Duration restDuration) {
    _restDuration = restDuration;
  }

  set rounds (int rounds) {
    _rounds = rounds;
  }

  set autoRestartEnabled (bool autoRestartEnabled) {
    _autoRestartEnabled = autoRestartEnabled;
  }

  set soundEnabled (bool soundEnabled) {
    _soundEnabled = soundEnabled;
  }

  
}