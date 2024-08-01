import 'package:flutter/material.dart';
import 'package:todiary/core/utils/app_strings.dart';

class DateTimePickerField extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String time;
  final bool isTime;

  const DateTimePickerField(
      {super.key,
      required this.title,
      required this.time,
      required this.onTap,
      this.isTime = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      height: 55,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: isTime? 80: 130,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: Center(
              child: Text(
                time,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          )
        ],
      ),
    );
  }
}
