import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TopFlushbar extends Flushbar {
  final IconData iconData;
  final String title;
  final String message;
  final Color backgroundColor;

  TopFlushbar(this.iconData, this.title, this.message, this.backgroundColor)
      : super(
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.GROUNDED,
          titleText: Row(
            children: <Widget>[
              Container(
                width: 50,
                child: Icon(
                  iconData,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      message,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          messageText: Container(),
          shouldIconPulse: false,
          backgroundColor: backgroundColor,
          animationDuration: Duration(milliseconds: 300),
          forwardAnimationCurve: Curves.bounceIn,
          reverseAnimationCurve: Curves.linear,
        );
}

Widget createTopFlushbar(
  IconData iconData,
  String title,
  String message,
  Color backgroundColor,
) {
  return Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    titleText: Row(
      children: <Widget>[
        Container(
          width: 50,
          child: Icon(
            iconData,
            size: 35,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    ),
    messageText: Container(),
    backgroundColor: backgroundColor,
    animationDuration: Duration(milliseconds: 300),
    forwardAnimationCurve: Curves.bounceIn,
    reverseAnimationCurve: Curves.linear,
  );
}
