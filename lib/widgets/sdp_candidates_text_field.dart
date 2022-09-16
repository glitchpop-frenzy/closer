import 'package:flutter/material.dart';

class SdpCandidateTf extends StatelessWidget {
  final TextEditingController controller;
  const SdpCandidateTf({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLength: TextField.noMaxLength,
      ),
    );
  }
}
