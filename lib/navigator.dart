class Coordinate {
  const Coordinate(this.x, this.y) /*: isInBounds = x >= 0 && y >= 0*/;
  final int x;
  final int y;
  //final bool isInBounds;

  Coordinate updateCoordinate(Coordinate other) => other + this;

  Coordinate operator +(Coordinate other) => Coordinate(
        x + other.x,
        y + other.y,
      );
}

abstract class Direction {
  static const north = Coordinate(0, -1);
  static const east = Coordinate(1, 0);
  static const south = Coordinate(0, 1);
  static const west = Coordinate(-1, 0);
  static const _enumFields = {
    'north': north,
    'east': east,
    'south': south,
    'west': west
  };
  static Coordinate valueOf(String value) => _enumFields[value]!;
}
