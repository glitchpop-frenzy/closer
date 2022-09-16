import 'package:flutter/material.dart';

class OfferAndAnswerButtons extends StatelessWidget {
  final Function() onOffer;
  final Function() onAnswer;
  const OfferAndAnswerButtons({
    Key? key,
    required this.onAnswer,
    required this.onOffer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ButtonLayout(
          title: 'Offer',
          onPressed: onOffer,
        ),
        ButtonLayout(
          title: 'Answer',
          onPressed: () {},
        ),
      ],
    );
  }
}

class ButtonLayout extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const ButtonLayout({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(5),
        ),
        backgroundColor: MaterialStateProperty.all(
          Colors.teal[100],
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
