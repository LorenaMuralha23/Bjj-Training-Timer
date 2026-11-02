import 'package:flutter/material.dart';
import 'choose_mode.dart';

//Aqui eu crio a definição do Widget da Home.
class ScaffoldHome extends StatelessWidget {
  const ScaffoldHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/home_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/images/logo_png.png', width: 450),
                Text(
                  'BJJ TRAINING TIMER',
                  style: TextStyle(
                    fontFamily: 'Antonio',
                    fontSize: 36,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 5,
                    color: Colors.white,
                  ),
                ),
                Image.asset(
                  'lib/assets/images/separator.png',
                  width: 500,
                  height: 100,
                ),
                Text(
                  'Clique para iniciar.',
                  style: TextStyle(
                    fontFamily: 'Antonio',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 2,
                    color: Colors.white,
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
                          debugPrint('START pressionado!');
                            // Navegar para a tela ChooseMode
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(builder: (context) => const ChooseMode()),
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
                          'START',
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
