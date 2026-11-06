import 'package:flutter/material.dart';
import 'package:jj_timer/core/timer/pause_and_play_engine.dart';
import 'package:jj_timer/core/timer/stopwatch_engine.dart';

import 'dart:async';

class TimerMode extends StatefulWidget {
  const TimerMode({super.key});

  @override
  State<TimerMode> createState() => _TimerModeState();
}

class _TimerModeState extends State<TimerMode> {
  final StopwatchEngine _stopwatchEngine = StopwatchEngine();
  Timer? _updateTimer;
  String _formattedTime = '00:00';
  PlayButtonController _playButtonController = PlayButtonController();
  String _playButtonImage = 'lib/assets/images/play_btn.png';
  bool mode = false;

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/normal_background.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                //Menu hamburguer button
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Image.asset(
                          'lib/assets/images/menu_hamburguer.png',
                          width: 40,
                        ),
                        onPressed: () {
                          debugPrint('Menu button pressed');
                        },
                      ),
                    ),
                  ],
                ),

                //Título, separado e o subtítulo
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TIMER MODE',
                      style: TextStyle(
                        fontFamily: 'Antonio',
                        fontSize: 48,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 5,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    Image.asset(
                      'lib/assets/images/separator.png',
                      width: 500,
                      height: 60,
                    ),

                    Text(
                      'Defina o tempo do timer',
                      style: TextStyle(
                        fontFamily: 'Rjdhani',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFC40000), Color(0xFF730202)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(top: 50.0, bottom: 10.0),
                      width: 250.0,
                      height: 50.0,
                      child: Text(
                        "TEMPO",
                        style: TextStyle(
                          fontFamily: 'Antonio',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    //Cronômetro
                    Text(
                      _formattedTime,
                      style: TextStyle(
                        fontFamily: 'Antonio',
                        fontSize: 128,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'TIMER DE ',
                                  style: TextStyle(
                                    fontFamily: 'Antonio',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: '5:00',
                                  style: TextStyle(
                                    fontFamily: 'Antonio',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Color(0xFFDD0000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              debugPrint('RESET BUTTON PRESSED');

                              mode = false;
                              _playButtonImage = _playButtonController.playOrPause(mode);

                              _stopwatchEngine.reset();
                              _stopwatchEngine.stop();

                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              'RESET',
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Material(
                              color: Colors.transparent,
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFC40000),
                                      Color(0xFF730202),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ElevatedButton(
                                  //play e timer = false (não está rodando)
                                  //pause e timer = true (está rodando)
                                  onPressed: () {
                                    debugPrint('START pressionado!');
                                    
                                    if (mode) {
                                      _stopwatchEngine.stop();
                                      _updateTimer?.cancel();
                                    } else {
                                      _stopwatchEngine.start();
                                    }
                                    mode = !mode;

                                    _playButtonImage = _playButtonController.playOrPause(mode);

                                    if (_updateTimer?.isActive != true) {
                                      _updateTimer = Timer.periodic(
                                        const Duration(milliseconds: 100),
                                        (timer) {
                                          setState(() {
                                            _formattedTime = _stopwatchEngine
                                                .formatDuration(
                                                  _stopwatchEngine.elapsed,
                                                );
                                          });
                                        },
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Image.asset(
                                    _playButtonImage,
                                    width: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          OutlinedButton(
                            onPressed: () {
                              debugPrint('EDIT BUTTON PRESSED');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              'EDITAR',
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
