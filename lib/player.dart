import 'dart:io';
import 'package:nyet_hack/creature.dart';
import 'package:nyet_hack/navigator.dart';
import 'package:nyet_hack/utils.dart';

class Player extends Creature with FightableDamageMixin {
  Player({
    String? name,
    int? healthPoints,
    bool? isBlessed,
    bool? isImortal,
  })  : _name = name?.trim() ?? 'madrigal',
        isBlessed = isBlessed ?? true,
        _isImmortal = isImortal ?? false,
        super(
          healthPoints:
              healthPoints ?? ((name?.toLowerCase() == 'kar') ? 40 : 100),
        ) {
    assert(this.healthPoints > 0, 'healthPoints must be greater than zero.');
    assert(this.name.isNotEmpty, 'Player must have a name.');
  }

  Player.onlyName(String name) : this(name: name);

  final bool isBlessed;
  final bool _isImmortal;
  late final String hometown = _selectHometown();
  Coordinate currentPosition = const Coordinate(0, 0);

  String _name;
  @override
  String get name => '${_name.capitalize()} of $hometown';
  set name(String newName) => _name = newName.trim();

  void castFireball([int numFireballs = 2]) =>
      print('A glass of Fireball springs into existence. (x$numFireballs)');

  String auraColor() {
    final auraVisible = isBlessed && healthPoints > 50 || _isImmortal;
    final auraColor = auraVisible ? 'GREEN' : 'NONE';
    return auraColor;
  }

  String formatHealthStatus() {
    return When.when(
      healthPoints,
      {
        When.eq(100): 'is in excellent condition!',
        When.range(90, 99): 'has a few scratches.',
        When.range(75, 89): isBlessed
            ? 'has some minor wounds but is healing quite quickly!'
            : 'has some minor wounds.',
        When.range(15, 74): 'looks pretty hurt.',
      },
      standart: 'is in awful condition',
    );

    // if (healthPoints == 100) {
    //   return 'is in excellent condition!';
    // } else if (healthPoints >= 90) {
    //   return 'has a few scratches.';
    // } else if (healthPoints >= 75) {
    //   if (isBlessed) {
    //     return 'has some minor wounds but is healing quite quickly!';
    //   } else {
    //     return 'has some minor wounds.';
    //   }
    // } else if (healthPoints >= 15) {
    //   return 'looks pretty hurt.';
    // } else {
    //   return 'is in awful condition!';
    // }
  }

  String _selectHometown() =>
      (File('assets/text/hometown.txt').readAsLinesSync()..shuffle()).first;

  @override
  final int diceCount = 3;

  @override
  final int diceSides = 6;

  @override
  int attack(Fightable opponent) {
    final damageRoll = this.damageRoll;
    final damageDealt = isBlessed ? damageRoll * 2 : damageRoll;
    opponent.getDamage(damageDealt);
    return damageDealt;
  }
}

String toDragonSpeak(String phrase) {
  return phrase.replaceAllMapped(
    RegExp('[aeiou]'),
    (match) => When.when(
      match.group(0)!,
      {
        When.eq('a'): '4',
        When.eq('e'): '3',
        When.eq('i'): '1',
        When.eq('o'): '0',
        When.eq('u'): '|_|',
      },
      standart: match.group(0)!,
    ),
  );
}
