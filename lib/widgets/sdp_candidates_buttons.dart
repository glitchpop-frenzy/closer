import 'package:closer/widgets/offer_and_ans_button.dart';
import 'package:flutter/material.dart';

class SdpCandidatesButton extends StatelessWidget {
  final Function() setRemoteDescription;
  final Function() setCandidate;
  const SdpCandidatesButton({
    Key? key,
    required this.setCandidate,
    required this.setRemoteDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonLayout(
          title: 'Set Remote Candidate',
          onPressed: setRemoteDescription,
        ),
        ButtonLayout(
          title: 'Set Candidate',
          onPressed: setCandidate,
        ),
      ],
    );
  }
}
