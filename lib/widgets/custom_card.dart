import 'package:flutter/material.dart';

Widget customCard({
  required String name,
  required Function() onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(
      right: 25,
      left: 25,
      top: 16,
    ),
    padding: const EdgeInsets.only(right: 27),
    decoration: BoxDecoration(
      color: const Color(0xffF1F0FD),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.7),
          offset: const Offset(3, 4),
          blurRadius: 5,
        ),
      ],
    ),
    child: ListTile(
        title: Text(
          name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_back_ios_new),
        onTap: onTap),
  );
}
