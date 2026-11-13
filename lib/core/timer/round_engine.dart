import 'package:jj_timer/core/timer/stopwatch_engine.dart';
import 'package:jj_timer/ui/widget/round_info.dart';

enum RoundPhase { ready, work, rest, finished }

/// Não depende de Flutter e não cria Timer.periodic.
/// A tela chama update() periodicamente, apenas enquanto estiver em execução.
class RoundEngine {
  final RoundInfo roundInfo;
  final StopwatchEngine _stopwatch = StopwatchEngine();

  RoundPhase _phase = RoundPhase.ready;
  int _currentRound = 1;
  bool _isRunning = false;

  RoundEngine(RoundInfo info)
      : roundInfo = RoundInfo(
          info.roundDuration,
          info.restDuration,
          info.rounds,
          info.autoRestartEnabled,
          info.soundEnabled,
        ) {
    _validate();
  }

  void _validate() {
    if (roundInfo.roundDuration <= Duration.zero ||
        roundInfo.restDuration <= Duration.zero) {
      throw ArgumentError('Tempos de round e descanso devem ser positivos.');
    }
    if (roundInfo.roundDuration >= const Duration(hours: 1) ||
        roundInfo.restDuration >= const Duration(hours: 1)) {
      throw ArgumentError('Cada duração deve ser menor que uma hora.');
    }
    if (roundInfo.rounds < 1 || roundInfo.rounds > 30) {
      throw ArgumentError('A quantidade de rounds deve estar entre 1 e 30.');
    }
  }

  RoundPhase get phase => _phase;
  int get currentRound => _currentRound;
  int get totalRounds => roundInfo.rounds;
  bool get isRunning => _isRunning;
  bool get isFinished => _phase == RoundPhase.finished;

  Duration get phaseDuration {
    switch (_phase) {
      case RoundPhase.ready:
      case RoundPhase.work:
        return roundInfo.roundDuration;
      case RoundPhase.rest:
        return roundInfo.restDuration;
      case RoundPhase.finished:
        return Duration.zero;
    }
  }

  Duration get remaining {
    if (_phase == RoundPhase.finished) return Duration.zero;
    return _stopwatch.remainingCalculator(phaseDuration);
  }

  /// PLAY tanto inicia quanto retoma uma fase pausada.
  void start() {
    if (_isRunning || isFinished) return;
    if (_phase == RoundPhase.ready) _phase = RoundPhase.work;
    _stopwatch.start();
    _isRunning = true;
  }

  void pause() {
    if (!_isRunning) return;
    _stopwatch.stop();
    _isRunning = false;
  }

  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    _phase = RoundPhase.ready;
    _currentRound = 1;
    _isRunning = false;
  }

  /// Retorna true quando a fase mudou; útil para UI, sons ou analytics.
  bool update() {
    if (!_isRunning || isFinished || _phase == RoundPhase.ready) {
      return false;
    }
    if (remaining > Duration.zero) return false;

    // Zera a referência temporal ANTES de preparar a fase seguinte.
    _stopwatch.stop();
    _stopwatch.reset();
    _isRunning = false;
    _advancePhase();

    if (!isFinished && roundInfo.autoRestartEnabled) {
      start();
    }
    return true;
  }

  void _advancePhase() {
    switch (_phase) {
      case RoundPhase.ready:
        _phase = RoundPhase.work;
        break;
      case RoundPhase.work:
        _phase = _currentRound < roundInfo.rounds
            ? RoundPhase.rest
            : RoundPhase.finished;
        break;
      case RoundPhase.rest:
        _currentRound++;
        _phase = RoundPhase.work;
        break;
      case RoundPhase.finished:
        break;
    }
  }
}
