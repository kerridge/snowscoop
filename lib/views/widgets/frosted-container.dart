import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class FrostedContainer extends StatelessWidget {
  FrostedContainer({
    this.child,
    this.width,
  })  : assert(width != null && width >= 0.0);

  final Widget child;

  final double width;

  @override
  Widget build(BuildContext context) {
    return new ClipRect(
      child: new BackdropFilter(
        filter: new ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: new Container(
            width: width,
            // margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
            padding: const EdgeInsets.all(15.0),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(10.0),
              shape: BoxShape.rectangle,
              //you can change opacity with color here
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  offset: new Offset(5.0, 5.0),
                ),
              ],
            ),
            child: child),
      ),
    );
  }
}
