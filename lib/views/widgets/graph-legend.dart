import 'package:flutter/material.dart';
import 'package:snowscoop/views/widgets/frosted-container.dart';

class GraphLegendItem extends StatelessWidget {

  GraphLegendItem({
    this.label,
    this.onTap,
    this.trailing,
    this.width,
    this.color,
  });

  final String label;
  final double width;
  final VoidCallback onTap;
  // trailing widget
  final Widget trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {

    Size _phoneSize = MediaQuery.of(context).size;
    _phoneSize =
        Size(_phoneSize.width, _phoneSize.height - 50);

    return new GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        width: width,
        child: new Padding(
          padding: const EdgeInsets.only(left: 6),
        child: new Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              height: _phoneSize.width * 0.07,
              width: _phoneSize.width * 0.07,
            ),
            new SizedBox(width: _phoneSize.width*0.05),
            new Expanded(
              flex: 4,
              child: Text(
                label,
                style: Theme.of(context).textTheme.body2
              )
            ),
            new Expanded(
              flex: 1,
              child: trailing,
            )
          ],
        )
        )
      )
    );
  }
}