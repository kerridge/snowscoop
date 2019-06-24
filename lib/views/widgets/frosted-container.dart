import 'package:flutter/material.dart';

class FrostedContainer extends StatelessWidget{

  FrostedContainer({
    this.child,
    this.height,
    this.width,
  }): assert(height != null && height >= 0.0),
      assert(width != null && width >= 0.0);

  final Widget child;

  final double height;
  final double width;

  @override
  Widget build(BuildContext context){
    return new Container(
      height: height,
      width: width,
      // margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
        //you can change opacity with color here
        color: Colors.white.withOpacity(0.5),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: new Offset(5.0, 5.0),
          ),
        ],
      ),
      child: child
    );
  }
}