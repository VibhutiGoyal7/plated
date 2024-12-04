import 'package:flutter/material.dart';

class CustomLoader extends StatefulWidget {
  @override
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.blue,

      end: Colors.red,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) {
                  return Icon(
                    Icons.fingerprint,
                    color: _colorAnimation.value,
                    size: 40,
                  );
                },
              ),
               SizedBox(height: 6),
               Text(
                "Loading please wait...",
                style: TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
