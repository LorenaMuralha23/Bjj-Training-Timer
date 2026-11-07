import 'package:flutter/material.dart';
import 'package:jj_timer/core/timer/stopwatch_engine.dart';
import 'package:flutter/cupertino.dart';

class TimerEditModeDialog extends StatefulWidget {
  const TimerEditModeDialog({super.key});

  @override
  State<TimerEditModeDialog> createState() => _TimerEditModeDialogState();
}

class _TimerEditModeDialogState extends State<TimerEditModeDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        width: 390,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF292929), Color(0xFF080808)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título e separador
            const Text(
              'EDITAR TIMER',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Antonio',
                fontSize: 42,
                fontWeight: FontWeight.normal,
                letterSpacing: 4,
                color: Colors.white,
              ),
            ),

            Image.asset(
              'lib/assets/images/separator.png',
              width: 310,
              height: 48,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 42),

            // Controle visual do tempo
            TimeAdjuster(),

            const SizedBox(height: 48),

            // Controle de som
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SOM',
                    style: TextStyle(
                      fontFamily: 'Antonio',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),

                  // Apenas visual por enquanto.
                  Container(
                    width: 94,
                    height: 46,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFC40000), Color(0xFF730202)],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE7E7E7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 52),

            // Botões inferiores
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 13,
                      ),
                      side: const BorderSide(color: Colors.white, width: 2.5),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'CANCELAR',
                      style: TextStyle(
                        fontFamily: 'Antonio',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFC40000), Color(0xFF730202)],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('SALVAR pressionado');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 13,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'SALVAR',
                        style: TextStyle(
                          fontFamily: 'Antonio',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeAdjuster extends StatefulWidget {
  const TimeAdjuster({super.key});

  @override
  State<TimeAdjuster> createState() => _TimeAdjusterState();
}

class _TimeAdjusterState extends State<TimeAdjuster> {
  int _minutes = 1;
  int _seconds = 0;

  final StopwatchEngine stopwatchEngine = StopwatchEngine();

  late final FixedExtentScrollController _minutesController;
  late final FixedExtentScrollController _secondsController;

  @override
  void initState() {
    super.initState();
    _minutesController = FixedExtentScrollController(initialItem: _minutes);
    _secondsController = FixedExtentScrollController(initialItem: _seconds);
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // faixa de seleção central
          Positioned(
            left: 18,
            right: 18,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF6E717A).withAlpha(90),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    brightness: Brightness.dark,
                  ),
                  child: CupertinoPicker(
                    scrollController: _minutesController,
                    itemExtent: 44,
                    diameterRatio: 1.35,
                    squeeze: 1.05,
                    useMagnifier: true,
                    magnification: 1.12,
                    selectionOverlay: const SizedBox.shrink(),
                    backgroundColor: Colors.transparent,
                    onSelectedItemChanged: (int value) {
                      setState(() {
                        _minutes = value;
                      });
                    },
                    children: List.generate(
                      60,
                      (index) => Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontFamily: 'Antonio',
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    brightness: Brightness.dark,
                  ),
                  child: CupertinoPicker(
                    scrollController: _secondsController,
                    itemExtent: 44,
                    diameterRatio: 1.35,
                    squeeze: 1.05,
                    useMagnifier: true,
                    magnification: 1.12,
                    selectionOverlay: const SizedBox.shrink(),
                    backgroundColor: Colors.transparent,
                    onSelectedItemChanged: (int value) {
                      setState(() {
                        _seconds = value;
                      });
                    },
                    children: List.generate(
                      60,
                      (index) => Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontFamily: 'Antonio',
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Duration get selectedDuration => Duration(
        minutes: _minutes,
        seconds: _seconds,
      );

  String get formattedTime => stopwatchEngine.formatDuration(selectedDuration);
}
