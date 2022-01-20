import 'package:flutter/material.dart';

class ToolBar extends StatefulWidget {
  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: Row(
            children: [
            ],
          ),
        ),
      ),
    );
  }
}
