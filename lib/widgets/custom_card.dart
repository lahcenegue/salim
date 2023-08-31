import 'package:flutter/material.dart';

Widget customCard({
  required String name,
  required double width,
  required Function() onTap,
}) {
  return Container(
    height: width * 0.12,
    margin: EdgeInsets.only(
      right: width * 0.05,
      left: width * 0.05,
      top: width * 0.035,
    ),
    padding: EdgeInsets.only(right: width * 0.08, left: width * 0.02),
    decoration: BoxDecoration(
      color: const Color(0xffF1F0FD),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.7),
          offset: Offset(width * 0.007, width * 0.008),
          blurRadius: 5,
        ),
      ],
    ),
    child: Center(
      child: ListTile(
        title: Text(
          name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: width * 0.032,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_back_ios_new,
          size: width * 0.05,
        ),
        onTap: onTap,
      ),
    ),
  );
}
