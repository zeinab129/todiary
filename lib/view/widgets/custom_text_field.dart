import 'package:flutter/material.dart';
import 'package:todiary/core/utils/app_strings.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;

  bool isForDesc;

  CustomTextField(
      {super.key, required this.controller, this.isForDesc = false, required this.onFieldSubmitted, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: TextFormField(
          controller: controller,
          maxLines: isForDesc ? 1 : 4,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              border: isForDesc ? InputBorder.none : null,
              counter: Container(),
              hintText: isForDesc ? AppStrings.addNote : null,
              prefixIcon: isForDesc
                  ? const Icon(
                      Icons.bookmark_border,
                      color: Colors.grey,
                    )
                  : null,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300))),
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
