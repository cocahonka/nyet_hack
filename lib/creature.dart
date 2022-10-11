import 'dart:math';
import 'package:meta/meta.dart';

abstract class Fightable {
  int get damageRoll;
  int get healthPoints;

  abstract final int diceCount;
  abstract final int diceSides;

  int attack(Fightable opponent);

  @protected
  void getDamage(int damage);
}

mixin FightableDamageMixin on Fightable {
  static final _random = Random.secure();

  @override
  int get healthPoints => _healthPoints;
  late int _healthPoints = super.healthPoints;

  @override
  @protected
  void getDamage(int damage) => _healthPoints -= damage;

  @override
  int get damageRoll =>
      _random.nextInt((diceSides - 1) * diceCount + 1) + diceCount;
}

abstract class Creature implements Fightable {
  Creature({
    required this.healthPoints,
  });
  @override
  final int healthPoints;
  String get name;
}

abstract class Monster extends Creature {
  Monster({
    required this.name,
    required this.description,
    required super.healthPoints,
  });

  @override
  final String name;
  final String description;

  @override
  int attack(Fightable opponent) {
    final damageDealt = damageRoll;
    opponent.getDamage(damageDealt);
    return damageDealt;
  }
}

class Goblin extends Monster with FightableDamageMixin {
  Goblin()
      : super(
          name: 'Goblin',
          description: 'A nasty-looking goblin',
          healthPoints: 30,
        );

  @override
  final int diceCount = 2;

  @override
  final int diceSides = 8;
}
