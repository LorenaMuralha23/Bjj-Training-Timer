import 'package:flutter_test/flutter_test.dart';
import 'package:jj_timer/core/timer/stopwatch_engine.dart';

void main() {
  test('Deve iniciar com o tempo zerado', () {
    final engine = StopwatchEngine();

    expect(engine.elapsed, Duration.zero);
  });

  test('Deve iniciar a contagem e retornar um tempo maior que zero', () async {
    final engine = StopwatchEngine();

    engine.start();

    await Future.delayed(const Duration(milliseconds: 100));

    engine.stop();

    expect(engine.elapsed, greaterThan(Duration.zero));
  });

  test('Deve zerar o tempo e interromper a contagem após o reset', () async {
    final engine = StopwatchEngine();

    engine.start();

    await Future.delayed(const Duration(milliseconds: 100));

    expect(engine.elapsed, greaterThan(Duration.zero));

    engine.reset();

    // Verifica se o tempo foi zerado
    expect(engine.elapsed, Duration.zero);

    // Aguarda para verificar se permanece parado
    await Future.delayed(const Duration(milliseconds: 100));

    expect(engine.elapsed, Duration.zero);
  });

  test('Deve interromper a contagem após o stop', () async {
    final engine = StopwatchEngine();

    engine.start();

    await Future.delayed(const Duration(milliseconds: 100));

    engine.stop();

    // Armazena o tempo no momento da interrupção
    final elapsedAfterStop = engine.elapsed;

    // Aguarda para verificar se o tempo continua parado
    await Future.delayed(const Duration(milliseconds: 100));

    expect(engine.elapsed, elapsedAfterStop);
  });

  test('Deve continuar a contagem após ser pausado', () async {
    final engine = StopwatchEngine();

    engine.start();

    await Future.delayed(const Duration(milliseconds: 100));

    engine.stop();

    final elapsedBeforeResume = engine.elapsed;

    // Retoma a contagem
    engine.start();

    // Verifica se não perdeu o tempo acumulado
    expect(engine.elapsed, greaterThanOrEqualTo(elapsedBeforeResume));

    await Future.delayed(const Duration(milliseconds: 100));

    engine.stop();

    final elapsedAfterResume = engine.elapsed;

    expect(elapsedAfterResume, greaterThan(elapsedBeforeResume));
  });
}