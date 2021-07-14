import 'package:flutter/material.dart';

class TaskColumn extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String? subtitle;
  TaskColumn({
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: iconBackgroundColor,
          child: Icon(
            icon,
            size: 15.0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45),
                ),
            ],
          ),
        )
      ],
    );
  }
}
