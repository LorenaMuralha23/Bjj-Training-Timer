import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jj_timer/core/timer/round_engine.dart';
import 'package:jj_timer/ui/menu_mode.dart';
import 'package:jj_timer/ui/widget/roud_edit_mode.dart';
import 'package:jj_timer/ui/widget/round_info.dart';

/// Mantém a identidade visual do protótipo original do Round Mode.
/// O relógio central é exibido como roletas sincronizadas com a contagem.
class RoundMode extends StatefulWidget {
  const RoundMode({super.key});

  @override
  State<RoundMode> createState() => _RoundModeState();
}

class _RoundModeState extends State<RoundMode> {
  RoundInfo _roundInfo = RoundInfo(
    const Duration(minutes: 5),
    const Duration(minutes: 1),
    5,
    true,
    true,
  );

  late RoundEngine _engine;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _engine = RoundEngine(_roundInfo);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _engine.update();
      if (!mounted) return;
      setState(() {});
      if (!_engine.isRunning) {
        _ticker?.cancel();
        _ticker = null;
      }
    });
  }

  void _togglePlayPause() {
    if (_engine.isFinished) return;
    if (_engine.isRunning) {
      _engine.pause();
      _ticker?.cancel();
      _ticker = null;
    } else {
      _engine.start();
      if (_engine.isRunning) _startTicker();
    }
    setState(() {});
  }

  void _reset() {
    _ticker?.cancel();
    _ticker = null;
    _engine.reset();
    setState(() {});
  }

  Future<void> _edit() async {
    if (_engine.isRunning) return;

    final RoundInfo? result = await showDialog<RoundInfo>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (_) => RoundEditModeDialog(initialInfo: _roundInfo),
    );

    if (!mounted || result == null) return;

    _ticker?.cancel();
    _ticker = null;
    setState(() {
      _roundInfo = result;
      _engine = RoundEngine(_roundInfo);
    });
  }

  String _durationText(Duration duration) {
    final totalSeconds = (duration.inMilliseconds + 999) ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get _phaseText {
    switch (_engine.phase) {
      case RoundPhase.ready:
      case RoundPhase.work:
        return 'ROLA ATIVO';
      case RoundPhase.rest:
        return 'DESCANSO';
      case RoundPhase.finished:
        return 'FINALIZADO';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reprodução do layout de referência (430 x 932). O FittedBox
    // escala o conjunto proporcionalmente, sem alterar as posições.
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'lib/assets/images/normal_background.png',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: 430,
                    height: 932,
                    child: Stack(
                      children: [
                        // MENU (mesma posição da referência)
                        Positioned(
                          left: 14,
                          top: 16,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                        return const MenuMode();
                                      },
                                  transitionDuration: const Duration(
                                    milliseconds: 350,
                                  ),
                                  reverseTransitionDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        final offsetAnimation =
                                            Tween<Offset>(
                                              begin: const Offset(-1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(
                                              CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeInOutCubic,
                                                reverseCurve:
                                                    Curves.easeInOutCubic,
                                              ),
                                            );

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                ),
                              );
                            },
                            icon: const Icon(Icons.menu, size: 34),
                            color: Colors.white,
                            iconSize: 34,
                          ),
                        ),

                        // TÍTULO
                        const Positioned(
                          left: 0,
                          right: 0,
                          top: 91,
                          child: Center(
                            child: Text(
                              'ROUND MODE',
                              style: TextStyle(
                                fontFamily: 'Antonio',
                                fontSize: 51,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // SEPARADOR (asset original do projeto)
                        Positioned(
                          left: 65,
                          top: 158,
                          child: Image.asset(
                            'lib/assets/images/separator.png',
                            width: 300,
                            height: 52,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // SUBTÍTULO
                        const Positioned(
                          top: 217,
                          left: 14,
                          right: 14,
                          child: Text(
                            'Escolha a quantidade de rolas, o tempo de\n'
                            'ação e o tempo de descanso',
                            textAlign: TextAlign.center,
                            softWrap: false,
                            style: const TextStyle(
                              fontFamily: 'Antonio',
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.5,
                              height: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // INDICADOR VERMELHO ROLA ATIVO / DESCANSO
                        Positioned(
                          top: 335,
                          left: 121,
                          child: Container(
                            width: 201,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFCA0000), Color(0xFF820000)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _phaseText,
                              style: const TextStyle(
                                fontFamily: 'Antonio',
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // RELÓGIO CENTRAL: somente os números grandes,
                        // como na imagem. A roleta de edição fica no Dialog.
                        Positioned(
                          top: 393,
                          left: 24,
                          right: 24,
                          height: 130,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              _durationText(_engine.remaining),
                              style: const TextStyle(
                                fontFamily: 'Antonio',
                                fontSize: 113,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                                height: 1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // INFORMAÇÕES EM UMA ÚNICA LINHA
                        Positioned(
                          top: 544,
                          left: 32,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: 'ROUND '),
                                TextSpan(text: '${_engine.currentRound}'),
                                const TextSpan(text: ' DE '),
                                TextSpan(
                                  text: '${_engine.totalRounds}',
                                  style: const TextStyle(
                                    color: Color(0xFFCE0000),
                                  ),
                                ),
                              ],
                            ),
                            style: const TextStyle(
                              fontFamily: 'Antonio',
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 544,
                          right: 27,
                          child: Text(
                            'DESCANSO ${_durationText(_roundInfo.restDuration)}',
                            style: const TextStyle(
                              fontFamily: 'Antonio',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // RESET / PLAY-PAUSE / EDITAR
                        Positioned(
                          left: 34,
                          top: 709,
                          child: _OutlinedRoundControl(
                            label: 'RESET',
                            onPressed: _reset,
                          ),
                        ),
                        Positioned(
                          left: 152,
                          top: 680,
                          child: _PlayPauseCircle(
                            playing: _engine.isRunning,
                            enabled: !_engine.isFinished,
                            onPressed: _togglePlayPause,
                          ),
                        ),
                        Positioned(
                          left: 304,
                          top: 709,
                          child: _OutlinedRoundControl(
                            label: 'EDITAR',
                            onPressed: _engine.isRunning ? null : _edit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OutlinedRoundControl extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _OutlinedRoundControl({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white38,
        side: const BorderSide(color: Colors.white, width: 1),
        shape: const StadiumBorder(),
        minimumSize: const Size(92, 58),
        padding: const EdgeInsets.symmetric(horizontal: 7),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Antonio',
          fontSize: 22,
          fontWeight: FontWeight.normal,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _PlayPauseCircle extends StatelessWidget {
  final bool playing;
  final bool enabled;
  final VoidCallback onPressed;

  const _PlayPauseCircle({
    required this.playing,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: Container(
          width: 126,
          height: 126,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFC80000), Color(0xFF850000)],
            ),
          ),
          child: Icon(
            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.black,
            size: 83,
          ),
        ),
      ),
    );
  }
}
