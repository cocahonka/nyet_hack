import 'package:meta/meta.dart';
import 'package:nyet_hack/creature.dart';

class Room {
  Room(this.name);
  @protected
  final int dangerLevel = 5;
  final String name;

  Monster? monster = Goblin();

  @nonVirtual
  String description() => 'Room: $name\n'
      'Danger level: $dangerLevel\n'
      'Creature: ${monster?.description ?? 'none'}';

  String load() => 'Nothing much to see here...';
}

class TownSquare extends Room {
  TownSquare() : super('Town Square');

  final _bellSound = 'GWONG';

  @override
  int get dangerLevel => super.dangerLevel - 3;

  @override
  @nonVirtual
  String load() =>
      'The villagers rally and cheer as you enter!\n${_ringBell()}';

  String _ringBell() => 'The bell tower announces your arrival. $_bellSound';
}
