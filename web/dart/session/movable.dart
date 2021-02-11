import 'dart:html';
import 'dart:math';

import 'board.dart';

class Movable {
  final HtmlElement e;
  final Board board;

  bool _accessible = true;
  bool get accessible => _accessible;
  set accessible(bool accessible) {
    _accessible = accessible;
  }

  Point _position;
  Point get position => _position;
  set position(Point position) {
    _position = position;
    e.style.left = '${position.x}px';
    e.style.top = '${position.y}px';
  }

  Movable({this.board, String img})
      : e = DivElement()
          ..className = 'movable'
          ..append(ImageElement(src: img)) {
    position = Point(0, 0);

    var drag = false;
    Point start;
    Point offset;

    e.onMouseDown.listen((event) async {
      start = position;
      offset = Point(0, 0);
      drag = true;
      await window.onMouseUp.first;
      drag = false;
    });

    window.onMouseMove.listen((event) {
      if (drag) {
        offset += event.movement * (1 / board.scaledZoom);

        var zoom = board.scaledZoom;
        var cell = board.grid.cellSize;

        var pos = start + offset;
        position = Point(
          ((pos.x / cell + 0.5)).floor() * cell,
          ((pos.y / cell + 0.5)).floor() * cell,
        );
      }
    });
  }
}
