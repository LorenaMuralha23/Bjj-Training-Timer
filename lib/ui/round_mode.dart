import 'package:flutter/material.dart';

class RoundMode extends StatelessWidget {
  const RoundMode({super.key});

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
                      'ROUND MODE',
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
                      'Escolha a quantidade de rolas, o tempo de ação e o tempo de descanso',
                      style: TextStyle(
                        fontFamily: 'Antonio',
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
                        "ROLA ATIVO",
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
                      '05:00',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'ROUND 1 DE ',
                                  style: TextStyle(
                                    fontFamily: 'Antonio',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: '5',
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

                          Text(
                            'DESCANSO 2:00',
                            style: TextStyle(
                              fontFamily: 'Antonio',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Colors.white,
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
                                  onPressed: () {
                                    debugPrint('START pressionado!');
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
                                    'lib/assets/images/play_btn.png',
                                    width: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          OutlinedButton(
                            onPressed: () {
                              debugPrint('RESET BUTTON PRESSED');
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
