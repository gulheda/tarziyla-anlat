import 'package:flutter/material.dart';

import '../data/contents.dart';
import '../l10n/app_localizations.dart';
import '../logic/game.dart';
import '../services/settings.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import 'game_screen.dart';

/// Oyuncu adlarını temizler: boşlukları kırpar, boş olanlara varsayılan ad
/// verir, aynı adları ayırır ("Kaptan", "Kaptan 2", ...).
List<String> sanitizeNames(List<String> raw, List<String> defaults) {
  final result = <String>[];
  final used = <String>{};
  for (var i = 0; i < raw.length; i++) {
    var name = raw[i].replaceAll(RegExp(r'\s+'), ' ').trim();
    if (name.isEmpty) name = defaults[i % defaults.length];
    var candidate = name;
    var n = 2;
    while (!used.add(candidate.toLowerCase())) {
      candidate = '$name $n';
      n++;
    }
    result.add(candidate);
  }
  return result;
}

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key, required this.mode});

  final GameMode mode;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  static const _maxPlayers = 8;

  final List<TextEditingController> _names = [];
  int _rounds = 3;
  late int _seconds;
  late GameContent _content;
  bool _ready = false;

  bool get _competitive => widget.mode == GameMode.competitive;
  List<String> get _defaults =>
      _competitive ? _content.teamNicknames : _content.playerNicknames;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    _ready = true;
    _content = contentFor(Localizations.localeOf(context).languageCode);
    final memory = SettingsScope.of(context).setupFor(widget.mode);
    _seconds = memory?.seconds ?? (_competitive ? 60 : 90);
    _rounds = memory?.rounds ?? 3;
    final names =
        memory?.names ?? _defaults.take(_competitive ? 2 : 3).toList();
    for (final n in names) {
      _names.add(TextEditingController(text: n));
    }
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
      _names.add(TextEditingController(text: _defaults[_names.length]));
    });
  }

  void _remove(int i) {
    if (_names.length <= 2) return;
    setState(() => _names.removeAt(i).dispose());
  }

  void _start() {
    final names = sanitizeNames([for (final c in _names) c.text], _defaults);
    final isDefault = _listEquals(names, _defaults.take(names.length).toList());
    SettingsScope.of(context).saveSetup(
      widget.mode,
      SetupMemory(
        names: isDefault ? null : names,
        rounds: _rounds,
        seconds: _seconds,
      ),
    );
    final game = Game(
      GameConfig(
        mode: widget.mode,
        names: names,
        rounds: _rounds,
        seconds: _seconds,
        languageCode: _content.code,
      ),
    );
    Navigator.of(context)
        .pushReplacement(fadeSlideRoute(GameScreen(game: game)));
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GradientScaffold(
      title: _competitive ? l10n.setupCompetitiveTitle : l10n.setupClassicTitle,
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
                        text: _competitive ? l10n.teams : l10n.players,
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
                                  textCapitalization: TextCapitalization.words,
                                  style: AppText.display(17),
                                  decoration: InputDecoration(
                                    hintText: _defaults[i % _defaults.length],
                                    counterText: '',
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: l10n.removeEntry,
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
                              _competitive ? l10n.addTeam : l10n.addPlayer,
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
                      _Heading(emoji: '🔁', text: l10n.roundsLabel(_rounds)),
                      const SizedBox(height: 2),
                      Text(
                        l10n.roundsHint(_rounds),
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
                      _Heading(emoji: '⏱️', text: l10n.timeLabel),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<int>(
                          showSelectedIcon: false,
                          segments: [
                            for (final s in const [30, 60, 90])
                              ButtonSegment(
                                value: s,
                                label: Text(l10n.secondsShort(s)),
                              ),
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
              label: l10n.startGame,
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
        Flexible(child: Text(text, style: AppText.display(20))),
      ],
    );
  }
}
