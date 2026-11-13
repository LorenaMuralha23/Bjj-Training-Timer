import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jj_timer/ui/widget/round_info.dart';

const _redGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFFC40000), Color(0xFF730202)],
);
const _darkGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF292929), Color(0xFF080808)],
);

String _formatDuration(Duration value) {
  return '${value.inMinutes.remainder(60).toString().padLeft(2, '0')}'
      ':${value.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}

/// Retorna RoundInfo ao salvar, ou null ao cancelar/tocar fora.
class RoundEditModeDialog extends StatefulWidget {
  final RoundInfo initialInfo;

  const RoundEditModeDialog({super.key, required this.initialInfo});

  @override
  State<RoundEditModeDialog> createState() => _RoundEditModeDialogState();
}

class _RoundEditModeDialogState extends State<RoundEditModeDialog> {
  late Duration _roundDuration;
  late Duration _restDuration;
  late int _rounds;
  late bool _autoRestart;
  late bool _soundEnabled;

  @override
  void initState() {
    super.initState();
    _roundDuration = widget.initialInfo.roundDuration;
    _restDuration = widget.initialInfo.restDuration;
    _rounds = widget.initialInfo.rounds;
    _autoRestart = widget.initialInfo.autoRestartEnabled;
    _soundEnabled = widget.initialInfo.soundEnabled;
  }

  Future<void> _editDuration({required bool isRound}) async {
    final initial = isRound ? _roundDuration : _restDuration;
    final result = await showDialog<Duration>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => _DurationWheelDialog(
        title: isRound ? 'TEMPO DO ROUND' : 'TEMPO DE DESCANSO',
        initial: initial,
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (isRound) {
        _roundDuration = result;
      } else {
        _restDuration = result;
      }
    });
  }

  Future<void> _editRounds() async {
    final result = await showDialog<int>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => _RoundsWheelDialog(initial: _rounds),
    );
    if (!mounted || result == null) return;
    setState(() => _rounds = result);
  }

  void _save() {
    final result = RoundInfo(
      _roundDuration,
      _restDuration,
      _rounds,
      _autoRestart,
      _soundEnabled,
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 390),
        decoration: BoxDecoration(
          gradient: _darkGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('EDITAR ROUND', style: TextStyle(
                  fontFamily: 'Antonio', fontSize: 40,
                  letterSpacing: 4, color: Colors.white,
                )),
              ),
              Image.asset(
                'lib/assets/images/separator.png',
                width: 300,
                height: 42,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Divider(color: Color(0xFFC40000)),
              ),
              const SizedBox(height: 16),
              _settingRow('TEMPO DO\nROUND',
                  _ValueCapsule(value: _formatDuration(_roundDuration), onTap: () => _editDuration(isRound: true))),
              const SizedBox(height: 13),
              _settingRow('TEMPO DE\nDESCANSO',
                  _ValueCapsule(value: _formatDuration(_restDuration), onTap: () => _editDuration(isRound: false))),
              const SizedBox(height: 13),
              _settingRow('ROLAS',
                  _ValueCapsule(value: '$_rounds', onTap: _editRounds)),
              const SizedBox(height: 23),
              _settingRow('RESTART\nAUTOMÁTICO',
                  _CustomSwitch(value: _autoRestart, onChanged: (v) => setState(() => _autoRestart = v))),
              const SizedBox(height: 16),
              _settingRow('SOM',
                  _CustomSwitch(value: _soundEnabled, onChanged: (v) => setState(() => _soundEnabled = v))),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(child: _ActionButton(label: 'CANCELAR', onTap: () => Navigator.pop(context), filled: false)),
                  const SizedBox(width: 10),
                  Expanded(child: _ActionButton(label: 'SALVAR', onTap: _save, filled: true)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingRow(String label, Widget control) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(
            label,
            textAlign: TextAlign.center,
            softWrap: false,
            style: const TextStyle(
              fontFamily: 'Antonio', fontSize: 17,
              fontWeight: FontWeight.bold, letterSpacing: 1,
              color: Colors.white, height: 1.1,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(flex: 7, child: control),
      ],
    );
  }
}

class _ValueCapsule extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  const _ValueCapsule({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(40),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value, style: const TextStyle(
            fontFamily: 'Antonio', fontSize: 23,
            fontWeight: FontWeight.bold, letterSpacing: 2,
            color: Colors.white,
          )),
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
    return Center(
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 88,
          height: 44,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: value ? _redGradient : null,
            color: value ? null : const Color(0xFF454545),
            borderRadius: BorderRadius.circular(30),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFE7E7E7), shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;
  const _ActionButton({required this.label, required this.onTap, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: filled ? _redGradient : null,
        border: filled ? null : Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 46),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          shape: const StadiumBorder(),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label, style: const TextStyle(
            fontFamily: 'Antonio', fontSize: 18,
            fontWeight: FontWeight.bold, letterSpacing: 1.4,
          )),
        ),
      ),
    );
  }
}

class _DurationWheelDialog extends StatefulWidget {
  final String title;
  final Duration initial;
  const _DurationWheelDialog({required this.title, required this.initial});

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
    _minutes = widget.initial.inMinutes.remainder(60);
    _seconds = widget.initial.inSeconds.remainder(60);
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
      onSave: (_minutes == 0 && _seconds == 0)
          ? null
          : () => Navigator.pop(context, Duration(minutes: _minutes, seconds: _seconds)),
      child: SizedBox(
        height: 180,
        child: Row(
          children: [
            Expanded(child: _wheel(
              _minutesController,
              (value) => setState(() => _minutes = value),
            )),
            const Text(':', style: TextStyle(fontSize: 30, color: Colors.white)),
            Expanded(child: _wheel(
              _secondsController,
              (value) => setState(() => _seconds = value),
            )),
          ],
        ),
      ),
    );
  }

  Widget _wheel(FixedExtentScrollController controller, ValueChanged<int> changed) {
    return CupertinoTheme(
      data: const CupertinoThemeData(brightness: Brightness.dark),
      child: CupertinoPicker(
        scrollController: controller,
        itemExtent: 48,
        diameterRatio: 1.4,
        squeeze: 1.05,
        useMagnifier: true,
        magnification: 1.1,
        selectionOverlay: const SizedBox.shrink(),
        backgroundColor: Colors.transparent,
        onSelectedItemChanged: changed,
        children: List.generate(60, (index) => Center(
          child: Text(index.toString().padLeft(2, '0'),
              style: const TextStyle(fontFamily: 'Antonio', fontSize: 32, color: Colors.white)),
        )),
      ),
    );
  }
}

class _RoundsWheelDialog extends StatefulWidget {
  final int initial;
  const _RoundsWheelDialog({required this.initial});

  @override
  State<_RoundsWheelDialog> createState() => _RoundsWheelDialogState();
}

class _RoundsWheelDialogState extends State<_RoundsWheelDialog> {
  late int _rounds;
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _rounds = widget.initial;
    _controller = FixedExtentScrollController(initialItem: _rounds - 1);
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
      onSave: () => Navigator.pop(context, _rounds),
      child: SizedBox(
        height: 180,
        child: CupertinoTheme(
          data: const CupertinoThemeData(brightness: Brightness.dark),
          child: CupertinoPicker(
            scrollController: _controller,
            itemExtent: 48,
            diameterRatio: 1.4,
            squeeze: 1.05,
            useMagnifier: true,
            magnification: 1.1,
            selectionOverlay: const SizedBox.shrink(),
            backgroundColor: Colors.transparent,
            onSelectedItemChanged: (index) => setState(() => _rounds = index + 1),
            children: List.generate(30, (index) => Center(
              child: Text('${index + 1}', style: const TextStyle(
                fontFamily: 'Antonio', fontSize: 32, color: Colors.white,
              )),
            )),
          ),
        ),
      ),
    );
  }
}

class _WheelDialogShell extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onSave;
  const _WheelDialogShell({required this.title, required this.child, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: _darkGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(fit: BoxFit.scaleDown, child: Text(title, style: const TextStyle(
              fontFamily: 'Antonio', fontSize: 28, letterSpacing: 2,
              color: Colors.white,
            ))),
            const SizedBox(height: 12),
            child,
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _ActionButton(
                  label: 'CANCELAR', filled: false,
                  onTap: () => Navigator.pop(context),
                )),
                const SizedBox(width: 10),
                Expanded(child: Opacity(
                  opacity: onSave == null ? 0.45 : 1,
                  child: _ActionButton(
                    label: 'SALVAR', filled: true,
                    onTap: onSave ?? () {},
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
