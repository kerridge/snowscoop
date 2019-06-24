import 'package:flutter/material.dart';
import 'package:snowscoop/models/enums/current-weather.dart';

class GraphButton extends StatelessWidget {
  GraphButton({
    this.label,
    this.selected,
    this.onPressed
  });

  final String label;
  final SelectedButton selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;

    if (selected.toString() == "SelectedButton." + label) {
      isSelected = true;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: new Container(
            // width: _phoneSize.width * 0.17,
            child: new Material(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                // shadowColor: Colors.grey,
                // elevation: 4.0,
                color: isSelected ? Theme.of(context).disabledColor : Theme.of(context).buttonColor,
                child: new MaterialButton(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: new Text(label,
                        style: Theme.of(context).textTheme.button,
                        textAlign: TextAlign.center),
                  ),
                  onPressed: () {
                    isSelected ? print("disabled") : onPressed();
                  },
                ))),
      ),
    );
  }
}