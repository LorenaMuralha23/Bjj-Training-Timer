import 'package:flutter/material.dart';
import 'package:jj_timer/ui/round_mode.dart';
import 'package:jj_timer/ui/timer_mode.dart';

/// Menu de navegação do JJ Timer.
///
/// Usa a mesma base visual das outras telas do projeto (430 x 932)
/// e mantém o conteúdo proporcional em dispositivos menores.
class MenuMode extends StatelessWidget {
  const MenuMode({super.key});

  void _openMode(BuildContext context, Widget destination) {
    // Substitui a pilha de navegação até a rota inicial (Home).
    // Assim, não deixa várias telas Timer/Round empilhadas.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => destination),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 430,
                  height: 932,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'lib/assets/images/home_background.png',
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Fechar menu
                      Positioned(
                        top: 12,
                        right: 12,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                          iconSize: 30,
                          tooltip: 'Fechar menu',
                        ),
                      ),

                      // Título
                      const Positioned(
                        top: 278,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            'MENU',
                            style: TextStyle(
                              fontFamily: 'Antonio',
                              fontSize: 39,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 4,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Separador já utilizado nas telas do JJ Timer
                      Positioned(
                        top: 344,
                        left: 78,
                        right: 78,
                        child: Image.asset(
                          'lib/assets/images/separator.png',
                          height: 47,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Positioned(
                        top: 438,
                        left: 52,
                        right: 52,
                        child: _ModeButton(
                          label: 'ROUNDS',
                          onPressed: () => _openMode(
                            context,
                            const RoundMode(),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 559,
                        left: 52,
                        right: 52,
                        child: _ModeButton(
                          label: 'TIMER',
                          onPressed: () => _openMode(
                            context,
                            const TimerMode(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 326,
      height: 65,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: Colors.white, width: 1),
          shape: const StadiumBorder(),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Antonio',
            fontSize: 38,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
