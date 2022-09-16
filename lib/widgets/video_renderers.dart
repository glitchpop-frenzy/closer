import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoRenderers extends StatelessWidget {
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  const VideoRenderers({
    Key? key,
    required this.localRenderer,
    required this.remoteRenderer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      // width: MediaQuery.of(context).size.width * 0.40,
      child: Row(children: [
        Flexible(
          child: VideoBox(
            videoRenderer: localRenderer,
            key: const Key('local'),
          ),
        ),
        Flexible(
          child: VideoBox(
            videoRenderer: remoteRenderer,
            key: const Key('remote'),
          ),
        ),
      ]),
    );
  }
}

class VideoBox extends StatelessWidget {
  final RTCVideoRenderer videoRenderer;
  const VideoBox({
    required Key key,
    required this.videoRenderer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      margin: const EdgeInsets.all(7),
      decoration: const BoxDecoration(color: Colors.black),
      child: RTCVideoView(videoRenderer),
    );
  }
}
