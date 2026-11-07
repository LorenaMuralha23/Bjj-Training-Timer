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

  Duration remainingCalculator(Duration configuredDuration){
      final remainingDuration = configuredDuration - _stopwatch.elapsed;

       return remainingDuration.isNegative
      ? Duration.zero
      : remainingDuration;
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Duration get elapsed => _stopwatch.elapsed;
  
}