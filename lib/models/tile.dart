class Tile {
  int x;
  int y;
  int value;
  bool isWhiteSpace;
  bool removed;

  Tile({
    required this.x,
    required this.y,
    required this.value,
    this.isWhiteSpace = false,
    this.removed = false,
  });
}
