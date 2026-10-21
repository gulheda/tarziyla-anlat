import 'package:flutter/material.dart';

import '../data/funny.dart';
import '../logic/game.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import 'game_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key, required this.mode});

  final GameMode mode;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  static const _maxPlayers = 8;

  late final List<TextEditingController> _names;
  int _rounds = 3;
  late int _seconds;

  bool get _competitive => widget.mode == GameMode.competitive;
  String get _unit => _competitive ? 'Takım' : 'Oyuncu';
  List<String> get _nicknames => _competitive ? teamNicknames : playerNicknames;

  @override
  void initState() {
    super.initState();
    _seconds = _competitive ? 60 : 90;
    _names = List.generate(
      _competitive ? 2 : 3,
      (i) => TextEditingController(text: _nicknames[i]),
    );
  }

  @override
  void dispose() {
    for (final c in _names) {
      c.dispose();
    }
    super.dispose();
  }

  void _add() {
    if (_names.length >= _maxPlayers) return;
    setState(() {
      _names.add(TextEditingController(text: _nicknames[_names.length]));
    });
  }

  void _remove(int i) {
    if (_names.length <= 2) return;
    setState(() => _names.removeAt(i).dispose());
  }

  void _start() {
    final names = [
      for (var i = 0; i < _names.length; i++)
        _names[i].text.trim().isEmpty ? _nicknames[i] : _names[i].text.trim(),
    ];
    final game = Game(
      GameConfig(
        mode: widget.mode,
        names: names,
        rounds: _rounds,
        seconds: _seconds,
      ),
    );
    Navigator.of(context)
        .pushReplacement(fadeSlideRoute(GameScreen(game: game)));
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: _competitive ? 'Rekabetçi mod' : 'Klasik mod',
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              children: [
                GlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Heading(
                        emoji: _competitive ? '🛡️' : '👥',
                        text: _competitive ? 'Takımlar' : 'Oyuncular',
                      ),
                      const SizedBox(height: 12),
                      for (var i = 0; i < _names.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Avatar(
                                emoji: avatars[i % avatars.length],
                                size: 48,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _names[i],
                                  maxLength: 16,
                                  style: AppText.display(17),
                                  decoration: InputDecoration(
                                    hintText: '$_unit ${i + 1}',
                                    counterText: '',
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _names.length > 2
                                    ? () => _remove(i)
                                    : null,
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        ),
                      if (_names.length < _maxPlayers)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: _add,
                            icon: const Icon(Icons.add_circle_outline),
                            label: Text(
                              '$_unit ekle',
                              style: AppText.display(
                                16,
                                color: AppColors.yellow,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Heading(emoji: '🔁', text: 'Tur sayısı: $_rounds'),
                      const SizedBox(height: 2),
                      Text(
                        'Herkes $_rounds kez sahneye çıkar.',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                      Slider(
                        value: _rounds.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: '$_rounds',
                        onChanged: (v) => setState(() => _rounds = v.round()),
                      ),
                      const SizedBox(height: 4),
                      const _Heading(emoji: '⏱️', text: 'Süre'),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<int>(
                          showSelectedIcon: false,
                          segments: const [
                            ButtonSegment(value: 30, label: Text('30 sn')),
                            ButtonSegment(value: 60, label: Text('60 sn')),
                            ButtonSegment(value: 90, label: Text('90 sn')),
                          ],
                          selected: {_seconds},
                          onSelectionChanged: (s) =>
                              setState(() => _seconds = s.first),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Başlat butonu her zaman görünsün diye listenin dışında, altta sabit.
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.bg2.withValues(alpha: 0),
                  AppColors.bg2.withValues(alpha: 0.95),
                ],
              ),
            ),
            child: BigButton(
              label: 'Perde açılsın!',
              icon: Icons.play_arrow_rounded,
              onPressed: _start,
              colors: const [AppColors.green, AppColors.greenDark],
              foreground: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.emoji, required this.text});

  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Text(text, style: AppText.display(20)),
      ],
    );
  }
}
