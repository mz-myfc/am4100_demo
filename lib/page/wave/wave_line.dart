import 'package:flutter/material.dart';

/*
 * @description Draw Line
 * @author zl
 * @date 2025/2/14 10:45
 */
class DrawLine {
  static final DrawLine instance = DrawLine._();

  DrawLine._();

  Size _waveSize = Size.zero; //Wave Size
  int _waveIndex = 0;
  int _maxIndex = 499;
  Offset _startX = Offset.zero; //X start position
  Offset _endX = Offset.zero; //X end position
  List<Offset> _waveArray = List<Offset>.generate(500, (i) => Offset(i.toDouble(), 100)); //Data Set

  Offset get getStartX => _startX;

  Offset get getEndX => _endX;

  //initialize
  void init() {
    _waveSize = Size.zero;
    _waveIndex = 0;
    _maxIndex = 499;
    _startX = Offset.zero;
    _endX = Offset.zero;
    _waveArray = List<Offset>.generate(500, (i) => Offset(i.toDouble(), 100));
    resetSize();
  }

  //Draw Wave
  void drawWave(num wave) {
    double xIndent = 1; //x axis start indentation
    double widthX = 5; //Occlusion X width
    Offset point = Offset(
      _waveSize.width * _waveIndex.toDouble() / _maxIndex.toDouble(),
      _waveSize.height * (1 - wave.toDouble() / 100),
    );
    if (_waveIndex < _maxIndex) {
      _waveArray[_waveIndex] = point;
      _waveIndex += 1;
    } else if (_waveIndex == _maxIndex) {
      _waveArray[_waveIndex] = point;
      _waveIndex = 0;
    } else {
      _waveArray[0] = point;
      _waveIndex = 0;
    }
    _startX = Offset(point.dx - xIndent, _waveSize.height);
    _endX = Offset(point.dx + widthX, 0);
  }

  //Update the waveform chart
  List<Offset> updateSize(Size size) {
    _waveSize = size;
    _maxIndex = size.width.toInt();
    if (_waveArray.length != _maxIndex + 1) {
      var xRatio = size.width / _maxIndex.toDouble();
      _waveArray = List<Offset>.generate(
        _maxIndex + 1,
        (i) => Offset(i.toDouble() * xRatio, size.height),
      );
      _startX = _endX = Offset(0, size.height);
      _waveIndex = 0;
    }
    return _waveArray;
  }

  //Reset the chart
  void resetSize() => updateSize(Size.zero);
}
