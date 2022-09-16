import 'dart:convert';

import 'package:closer/widgets/offer_and_ans_button.dart';
import 'package:closer/widgets/sdp_candidates_buttons.dart';
import 'package:closer/widgets/sdp_candidates_text_field.dart';
import 'package:closer/widgets/video_renderers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Closer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Closer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _offer = false;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final RTCVideoRenderer _renderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  final TextEditingController _sdpController = TextEditingController();

  @override
  void initState() {
    _initRenderer();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });

    super.initState();
  }

  @override
  void dispose() {
    _renderer.dispose();
    _remoteRenderer.dispose();
    _sdpController.dispose();
    super.dispose();
  }

  _getMedia() async {
    final Map<String, dynamic> constraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream stream = await navigator.mediaDevices.getUserMedia(constraints);

    _renderer.srcObject = stream;

    return stream;
  }

  _initRenderer() async {
    await _renderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    Map<String, dynamic> config = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"}
      ],
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "offerToReceiveAudio": true,
        "offerToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getMedia();

    RTCPeerConnection pc = await createPeerConnection(
      config,
      offerSdpConstraints,
    );

    pc.addStream(_localStream!);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print('printing ICE candidates');
        print(json.encode({
          "candidate": e.candidate,
          "sdpMid": e.sdpMid,
          "sdpMLineInd": e.sdpMLineIndex,
        }));
      }
    };

    pc.onIceConnectionState = (e) {
      print('printing ICE connection state');
      print(e);
    };
    pc.onAddStream = (str) {
      print('add stream:  ${str.id}');
      _remoteRenderer.srcObject = str;
    };

    return pc;
  }

  void _createOffer() async {
    RTCSessionDescription desc =
        await _peerConnection!.createOffer({'offerToReceiveVideo': 1});

    final session = parse(desc.sdp!);
    print('sessions on creating offers');
    print(json.encode(session));
    _offer = true;

    await _peerConnection!.setLocalDescription(desc);
  }

  void _createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});
    var session = parse(description.sdp!);
    await _peerConnection!.setLocalDescription(description);
  }

  void _setRemoteDescription() async {
    String json = _sdpController.text;
    final session = await jsonDecode(json);

    String? sdp = write(session, null);

    RTCSessionDescription desc = RTCSessionDescription(
      sdp,
      _offer ? 'answer' : 'offer',
    );
    print('setting remote description');
    print(desc.toMap());

    await _peerConnection!.setRemoteDescription(desc);
  }

  void _setCandidate() async {
    String json = _sdpController.text;
    final session = await jsonDecode(json);
    print(session['candidate']);
    final candidate = RTCIceCandidate(
      session['candidate'],
      session['sdpMid'],
      session['sdpMLineIndex'],
    );

    await _peerConnection!.addCandidate(candidate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          VideoRenderers(
            localRenderer: _renderer,
            remoteRenderer: _remoteRenderer,
          ),
          OfferAndAnswerButtons(onAnswer: _createAnswer, onOffer: _createOffer),
          SdpCandidateTf(
            controller: _sdpController,
          ),
          SdpCandidatesButton(
            setCandidate: _setCandidate,
            setRemoteDescription: _setRemoteDescription,
          ),
        ],
      ),
    );
  }
}
