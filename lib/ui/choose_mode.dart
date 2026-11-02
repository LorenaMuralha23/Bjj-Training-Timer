import 'package:flutter/material.dart';
import 'round_mode.dart';
import 'timer_mode.dart';

class ChooseMode extends StatelessWidget {
  const ChooseMode({super.key});

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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ESCOLHA O MODO INICIAL',
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
                  height: 100,
                ),

                Text(
                  'Isso pode ser modificado posteriormente',
                  style: TextStyle(
                    fontFamily: 'Antonio',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 5,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 35),
                SizedBox(
                  width: 310,
                  height: 65,
                  child: Material(
                    color: Colors.transparent,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFC40000), Color(0xFF730202)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint('ROUND MODE pressionado!');
                            // Navegar para a tela ChooseMode
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(builder: (context) => const RoundMode()),
                            );
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
                        child: const Text(
                          'ROUND',
                          style: TextStyle(
                            fontFamily: 'Antonio',
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),
                SizedBox(
                  width: 310,
                  height: 65,
                  child: Material(
                    color: Colors.transparent,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFC40000), Color(0xFF730202)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint('TIMER MODE pressionado!');
                            // Navegar para a tela ChooseMode
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(builder: (context) => const TimerMode()),
                            );
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
                        child: const Text(
                          'TIMER',
                          style: TextStyle(
                            fontFamily: 'Antonio',
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}