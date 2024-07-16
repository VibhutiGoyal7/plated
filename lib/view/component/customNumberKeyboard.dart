import 'package:flutter/material.dart';

class CustomNumberKeyboard extends StatelessWidget {
  final Function(String) onKeyTap;

  CustomNumberKeyboard({required this.onKeyTap});

  void _onKeyPressed(String value) {
    onKeyTap(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey[200],
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildKey('1'),
              _buildKey('2'),
              _buildKey('3'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildKey('4'),
              _buildKey('5'),
              _buildKey('6'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildKey('7'),
              _buildKey('8'),
              _buildKey('9'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    _onKeyPressed("clear");
                  },
                  icon: Icon(
                    Icons.backspace_outlined,
                    size: 32,
                  )),
              _buildKey('0'),
              IconButton(
                  onPressed: () {
                    _onKeyPressed("submit");
                  },
                  icon: Icon(
                    Icons.check_circle_outline_outlined,
                    size: 38,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String value) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onKeyPressed(value),
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
