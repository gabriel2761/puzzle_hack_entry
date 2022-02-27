import 'dart:math';

import 'package:puzzle_hack_slider/models/tile.dart';

class Puzzle {
  final dimensions = 6;
  final tiles = <Tile>[];

  Puzzle() {
    for (var x = 0; x < dimensions; x++) {
      for (var y = 0; y < (dimensions * 2) + 1; y++) {
        if (x == dimensions - 1 && y == (dimensions * 2)) {
          tiles.add(Tile(x: x, y: y, value: -1, isWhiteSpace: true));
        } else {
          tiles.add(Tile(x: x, y: y, value: Random().nextInt(4) + 1));
        }
      }
    }
  }

  void move(Tile tile) {
    var whitespace = tiles.singleWhere((e) {
      return (e.y == tile.y || e.x == tile.x) && e.isWhiteSpace;
    }, orElse: () => tile);

    if (whitespace.x == tile.x) {
      if (whitespace.y > tile.y) {
        var tiles = this.tiles.where((e) {
          return e.y >= tile.y && e.y <= whitespace.y && e.x == tile.x;
        }).toList();

        tiles.sort((a, b) => a.y.compareTo(b.y));

        var tempY = tile.y;
        for (var i = 0; i < tiles.length - 1; i++) {
          tiles[i].y = tiles[i + 1].y;
        }

        whitespace.y = tempY;
      } else if (whitespace.y < tile.y) {
        var tiles = this.tiles.where((e) {
          return e.y <= tile.y && e.y >= whitespace.y && e.x == tile.x;
        }).toList();

        tiles.sort((a, b) => b.y.compareTo(a.y));

        var tempY = tile.y;
        for (var i = 0; i < tiles.length - 1; i++) {
          print(tiles[i].y);
          tiles[i].y = tiles[i + 1].y;
        }

        whitespace.y = tempY;
      }
    } else if (whitespace.y == tile.y) {
      if (whitespace.x > tile.x) {
        var tiles = this.tiles.where((e) {
          return e.x >= tile.x && e.x <= whitespace.x && e.y == tile.y;
        }).toList();

        tiles.sort((a, b) => a.x.compareTo(b.x));

        var tempX = tile.x;
        for (var i = 0; i < tiles.length - 1; i++) {
          tiles[i].x = tiles[i + 1].x;
        }

        whitespace.x = tempX;
      } else if (whitespace.x < tile.x) {
        var tiles = this.tiles.where((e) {
          return e.x <= tile.x && e.x >= whitespace.x && e.y == tile.y;
        }).toList();

        tiles.sort((a, b) => b.x.compareTo(a.x));

        var tempX = tile.x;
        for (var i = 0; i < tiles.length - 1; i++) {
          tiles[i].x = tiles[i + 1].x;
        }

        whitespace.x = tempX;
      }
    }
  }

  List<Tile> getSurroundingTiles(Tile tile) {
    var positions = [
      [1, 0],
      [0, 1],
      [-1, 0],
      [0, -1]
    ];

    return tiles.where((e) {
      if (e.y <= dimensions) {
        return false;
      }

      for (var p in positions) {
        if (e.y == tile.y + p[0] && e.x == tile.x + p[1]) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  List<Tile> findMatches() {
    var explored = <Tile>{};

    var tiles = this.tiles.where((e) => e.y > dimensions);

    for (var tile in tiles) {
      if (explored.contains(tile)) {
        continue;
      }

      var stack = [tile];
      var matches = [tile];

      while (stack.isNotEmpty) {
        var current = stack.removeLast();
        explored.add(current);

        var surroundings = getSurroundingTiles(current)
            .where((e) => e.value == current.value)
            .where((e) => !e.isWhiteSpace)
            .where((e) => !explored.contains(e))
            .where((e) => !e.removed)
            .toList();

        matches.addAll(surroundings);
        stack.addAll(surroundings);
      }

      if (matches.length >= 4) {
        return matches;
      }
    }

    return [];
  }

  bool popMatches() {
    var matches = findMatches();

    if (matches.isEmpty) {
      return false;
    }

    for (var tile in matches) {
      tile.removed = true;
    }

    return true;
  }

  void dropTiles() {
    for (var tile in tiles) {
      if (tile.removed) {
        while (tile.y > 0) {
          var swap = tiles.singleWhere((e) {
            return e.x == tile.x && e.y == tile.y - 1;
          });

          var tempY = swap.y;
          var tempX = swap.x;

          swap.y = tile.y;
          swap.x = tile.x;

          tile.y = tempY;
          tile.x = tempX;
        }
      }
    }
  }

  void resetRemoveTiles() {
    for (var tile in tiles) {
      if (tile.removed) {
        tile.removed = false;
        tile.value = Random().nextInt(4) + 1;
      }
    }
  }

// setState(() {
// for (var tile in _puzzle) {
// if (tile.removed) {
// while (tile.y > 0) {
// var swap = _puzzle.singleWhere((e) {
// return e.x == tile.x && e.y == tile.y - 1;
// });
//
// var tempY = swap.y;
// var tempX = swap.x;
//
// swap.y = tile.y;
// swap.x = tile.x;
//
// tile.y = tempY;
// tile.x = tempX;
// }
// }
// }
// });
//
// await Future.delayed(const Duration(milliseconds: 510));
//
// setState(() {
// for (var tile in _puzzle) {
// if (tile.removed) {
// tile.removed = false;
// }
// }
// });
}
