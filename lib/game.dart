import 'dart:io';

import 'package:nyet_hack/creature.dart';
import 'package:nyet_hack/navigator.dart';
import 'package:nyet_hack/player.dart';
import 'package:nyet_hack/room.dart';
import 'package:nyet_hack/utils.dart';

void runGame() => Game().play();

class Game {
  factory Game() => _game;
  Game._internal() {
    print('Welcome, adventurer.\n');
    _player.castFireball();
  }

  static final Game _game = Game._internal();
  //final _player = Player.onlyName('Madrigal');
  final _player = Player(name: 'Madrigal', isBlessed: false);
  Room currentRoom = TownSquare();
  late final List<List<Room>> worldMap = [
    [
      currentRoom,
      Room('Tavern'),
      Room('Back Room'),
    ],
    [
      Room('Long Corridor'),
      Room('Generic Room'),
    ]
  ];

  Future<void> play() async {
    while (true) {
      print(currentRoom.description());
      print(currentRoom.load());

      printPlayerStatus(_player);

      final command = readLine('\n> Enter your command: ');
      print('${await GameInput(command).processCommand()}\n');
    }
  }

  void printPlayerStatus(Player player) {
    final blessed = player.isBlessed ? 'YES' : 'NO';
    print('(Aura: ${player.auraColor()}) (Blessed: $blessed)');
    print('${player.name} ${player.formatHealthStatus()}');
  }

  String _move(String directionInput) {
    final clearDirectionInput = directionInput.toLowerCase();
    try {
      final direction = Direction.valueOf(clearDirectionInput);
      final newPosition = _player.currentPosition.updateCoordinate(direction);
      // if (!newPosition.isInBounds) {
      //   throw StateError('$direction is out of bounds.');
      // }
      final newRoom = worldMap[newPosition.y][newPosition.x];
      _player.currentPosition = newPosition;
      currentRoom = newRoom;
      return 'OK, you move $clearDirectionInput to the ${newRoom.name}. '
          '${newRoom.load()}';
    } catch (e) {
      return 'Invalid direction: $directionInput';
    }
  }

  Future<String> _fight() async {
    final monster = currentRoom.monster;
    if (monster != null) {
      while (_player.healthPoints > 0 && monster.healthPoints > 0) {
        _slay(monster);
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      return 'Combat Complete';
    } else {
      return "There's nothing here to figth.";
    }
  }

  void _slay(Monster monster) {
    print('${monster.name} did ${monster.attack(_player)} damage!');
    print('${_player.name} did ${_player.attack(monster)} damage!');

    if (_player.healthPoints <= 0) {
      print('>>>> You have been defeated! Thanks for playing. <<<<');
      exit(0);
    }

    if (monster.healthPoints <= 0) {
      print('>>>> ${monster.name} has been defated! <<<<');
      currentRoom.monster = null;
    }
  }

  Never _quit() {
    const quitMessage =
        'Thank you for playing, the secrets of the dungeons will be '
        'waiting for you again!';
    print(quitMessage);
    exit(0);
  }
}

class GameInput {
  GameInput(String? arg) : _input = arg ?? '' {
    final inputParts = _input.split(' ');
    command = inputParts[0];
    argument = inputParts.length > 1 ? inputParts[1] : '';
  }
  final String _input;
  late final String command;
  late final String argument;

  String _commandNotFound() => "I'm not quite sure what you're trying to do!";

  Future<String> processCommand() async {
    switch (command.toLowerCase()) {
      case 'fight':
        return Game._game._fight();
      case 'move':
        return Game._game._move(argument);
      case 'quit':
        return Game._game._quit();
      default:
        return _commandNotFound();
    }
  }
}
