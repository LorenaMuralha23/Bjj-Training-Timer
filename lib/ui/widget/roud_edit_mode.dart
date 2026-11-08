import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Janela visual de configuração do modo Round.
///
/// A interação com as roletas e os switches está implementada.
/// A integração com a lógica do RoundMode fica para uma etapa posterior.
class RoundEditModeDialog extends StatefulWidget {
  const RoundEditModeDialog({super.key});

  @override
  State<RoundEditModeDialog> createState() => _RoundEditModeDialogState();
}

class _RoundEditModeDialogState extends State<RoundEditModeDialog> {
  Duration _roundDuration = const Duration(minutes: 5);
  Duration _restDuration = const Duration(minutes: 1);
  int _rounds = 1;
  bool _autoRestartEnabled = true;
  bool _soundEnabled = true;

  static const _gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF292929), Color(0xFF080808)],
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 390,
          maxHeight: MediaQuery.sizeOf(context).height - 40,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 26),
          decoration: BoxDecoration(
            gradient: _gradient,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'EDITAR ROUND',
                    style: TextStyle(
                      fontFamily: 'Antonio',
                      fontSize: 40,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                  ),
                ),
                Image.asset(
                  'lib/assets/images/separator.png',
                  width: 310,
                  height: 48,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 22),
                _settingsRow(
                  label: 'TEMPO DO\nROUND',
                  valueWidget: _ValueCapsule(
                    text: _formatDuration(_roundDuration),
                    onTap: () async {
                      final selected = await _showDurationWheelDialog(
                        context: context,
                        initialDuration: _roundDuration,
                        title: 'TEMPO DO ROUND',
                      );
                      if (!mounted) return;
                      if (selected != null) {
                        setState(() => _roundDuration = selected);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 18),
                _settingsRow(
                  label: 'TEMPO DE\nDESCANSO',
                  valueWidget: _ValueCapsule(
                    text: _formatDuration(_restDuration),
                    onTap: () async {
                      final selected = await _showDurationWheelDialog(
                        context: context,
                        initialDuration: _restDuration,
                        title: 'TEMPO DE DESCANSO',
                      );
                      if (!mounted) return;
                      if (selected != null) {
                        setState(() => _restDuration = selected);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 18),
                _settingsRow(
                  label: 'ROLAS',
                  valueWidget: _ValueCapsule(
                    text: '$_rounds',
                    onTap: () async {
                      final selected = await _showRoundsWheelDialog(
                        context: context,
                        initialValue: _rounds,
                      );
                      if (!mounted) return;
                      if (selected != null) {
                        setState(() => _rounds = selected);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 26),
                _settingsRow(
                  label: 'RESTART\nAUTOMÁTICO',
                  valueWidget: _CustomSwitch(
                    value: _autoRestartEnabled,
                    onChanged: (value) {
                      setState(() => _autoRestartEnabled = value);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _settingsRow(
                  label: 'SOM',
                  valueWidget: _CustomSwitch(
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() => _soundEnabled = value);
                    },
                  ),
                ),
                const SizedBox(height: 34),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.white, width: 2.5),
                          shape: const StadiumBorder(),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'CANCELAR',
                            style: TextStyle(
                              fontFamily: 'Antonio',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: _GradientButton(
                        label: 'SALVAR',
                        onPressed: () {
                          // TODO: devolver a configuração ao RoundMode.
                          debugPrint('Round: ${_formatDuration(_roundDuration)}');
                          debugPrint('Descanso: ${_formatDuration(_restDuration)}');
                          debugPrint('Rolas: $_rounds');
                          debugPrint('Restart automático: $_autoRestartEnabled');
                          debugPrint('Som: $_soundEnabled');
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _settingsRow({
    required String label,
    required Widget valueWidget,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // O texto recebe mais espaço, evitando que palavras sejam
        // quebradas em linhas inesperadas em celulares compactos.
        Expanded(
          flex: 6,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: false,
              style: const TextStyle(
                fontFamily: 'Antonio',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.white,
                height: 1.08,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(flex: 7, child: valueWidget),
      ],
    );
  }
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class _ValueCapsule extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _ValueCapsule({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Antonio',
              fontSize: 21,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CustomSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 94,
          height: 46,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: value
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFC40000), Color(0xFF730202)],
                  )
                : null,
            color: value ? null : const Color(0xFF454545),
            borderRadius: BorderRadius.circular(40),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
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
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _GradientButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFC40000), Color(0xFF730202)],
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Antonio',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

Future<Duration?> _showDurationWheelDialog({
  required BuildContext context,
  required Duration initialDuration,
  required String title,
}) {
  return showDialog<Duration>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (context) => _DurationWheelDialog(
      title: title,
      initialDuration: initialDuration,
    ),
  );
}

class _DurationWheelDialog extends StatefulWidget {
  final String title;
  final Duration initialDuration;

  const _DurationWheelDialog({
    required this.title,
    required this.initialDuration,
  });

  @override
  State<_DurationWheelDialog> createState() => _DurationWheelDialogState();
}

class _DurationWheelDialogState extends State<_DurationWheelDialog> {
  late int _minutes;
  late int _seconds;
  late final FixedExtentScrollController _minutesController;
  late final FixedExtentScrollController _secondsController;

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialDuration.inMinutes.remainder(60);
    _seconds = widget.initialDuration.inSeconds.remainder(60);
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
    return _WheelDialogShell(
      title: widget.title,
      picker: SizedBox(
        height: 190,
        child: Row(
          children: [
            Expanded(
              child: _NumberWheel(
                controller: _minutesController,
                itemCount: 60,
                itemBuilder: (index) => index.toString().padLeft(2, '0'),
                onChanged: (value) => _minutes = value,
              ),
            ),
            const Text(
              ':',
              style: TextStyle(
                fontFamily: 'Antonio',
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: _NumberWheel(
                controller: _secondsController,
                itemCount: 60,
                itemBuilder: (index) => index.toString().padLeft(2, '0'),
                onChanged: (value) => _seconds = value,
              ),
            ),
          ],
        ),
      ),
      onCancel: () => Navigator.pop(context),
      onSave: () => Navigator.pop(
        context,
        Duration(minutes: _minutes, seconds: _seconds),
      ),
    );
  }
}

Future<int?> _showRoundsWheelDialog({
  required BuildContext context,
  required int initialValue,
}) {
  return showDialog<int>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (context) => _RoundsWheelDialog(initialValue: initialValue),
  );
}

class _RoundsWheelDialog extends StatefulWidget {
  final int initialValue;

  const _RoundsWheelDialog({required this.initialValue});

  @override
  State<_RoundsWheelDialog> createState() => _RoundsWheelDialogState();
}

class _RoundsWheelDialogState extends State<_RoundsWheelDialog> {
  late int _selectedRounds;
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _selectedRounds = widget.initialValue;
    _controller = FixedExtentScrollController(initialItem: _selectedRounds - 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _WheelDialogShell(
      title: 'ROLAS',
      picker: SizedBox(
        height: 190,
        child: _NumberWheel(
          controller: _controller,
          itemCount: 20,
          itemBuilder: (index) => '${index + 1}',
          onChanged: (value) => _selectedRounds = value + 1,
        ),
      ),
      onCancel: () => Navigator.pop(context),
      onSave: () => Navigator.pop(context, _selectedRounds),
    );
  }
}

class _NumberWheel extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int itemCount;
  final String Function(int) itemBuilder;
  final ValueChanged<int> onChanged;

  const _NumberWheel({
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(brightness: Brightness.dark),
      child: CupertinoPicker(
        scrollController: controller,
        itemExtent: 48,
        diameterRatio: 1.4,
        squeeze: 1.05,
        useMagnifier: true,
        magnification: 1.1,
        backgroundColor: Colors.transparent,
        selectionOverlay: const SizedBox.shrink(),
        onSelectedItemChanged: onChanged,
        children: List.generate(
          itemCount,
          (index) => Center(
            child: Text(
              itemBuilder(index),
              style: const TextStyle(
                fontFamily: 'Antonio',
                fontSize: 34,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WheelDialogShell extends StatelessWidget {
  final String title;
  final Widget picker;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _WheelDialogShell({
    required this.title,
    required this.picker,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF292929), Color(0xFF080808)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Antonio',
                  fontSize: 28,
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 18),
            picker,
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: const StadiumBorder(),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(
                          fontFamily: 'Antonio',
                          fontSize: 16,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _GradientButton(label: 'SALVAR', onPressed: onSave)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
