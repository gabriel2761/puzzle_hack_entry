import 'dart:collection';
import 'package:collection/collection.dart';
import 'dart:math';

import 'package:flutter/material.dart';

import 'models/tile.dart';
import 'models/tiles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _puzzle = Puzzle();

  final _colors = <Color>[
    Colors.blueGrey,
    Colors.deepPurple,
    Colors.redAccent,
    Colors.greenAccent,
  ];

  void _move(Tile tile) async {
    setState(() => _puzzle.move(tile));
    await Future.delayed(Duration(milliseconds: 300));
    while (_puzzle.popMatches()) {
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        _puzzle.dropTiles();
      });
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        _puzzle.resetRemoveTiles();
      });
    }
  }

  void _removeMatches() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          for (var tile in _puzzle.tiles)
            tile.isWhiteSpace
                ? const SizedBox()
                : AnimatedAlign(
                    onEnd: () {},
                    alignment: Alignment(
                      (tile.x - 4) / 4,
                      (tile.y - (_puzzle.dimensions - 1.1) * 2) /
                          (_puzzle.dimensions / 2),
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: AnimatedContainer(
                      height: tile.removed ? 0 : 100,
                      width: tile.removed ? 0 : 100,
                      color: _colors[tile.value - 1],
                      duration: Duration(milliseconds: 300),
                      onEnd: () {},
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: _colors[tile.value - 1],
                        ),
                        onPressed: () {
                          if (tile.y > _puzzle.dimensions) {
                            _move(tile);
                          }
                        },
                        child: Text(''),
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}
