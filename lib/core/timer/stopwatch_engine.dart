class StopwatchEngine {
  StopwatchEngine();

  final Stopwatch _stopwatch = Stopwatch();

  void start() {
    _stopwatch.start();
  }

  void stop() {
    _stopwatch.stop();
  }

  void reset() {
    _stopwatch.reset();
  }

  Duration get elapsed => _stopwatch.elapsed;
}