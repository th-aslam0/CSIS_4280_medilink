import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

const String appId = "94ec467231d749f080f1360cf5a7ec72";
const String channelName = "test_channel";
const String token = "007eJxTYAjbObG7WuCU0Ert83K/PfUfye7qjJ2yUThZ4GJG3ySGHXsVGCxNUpNNzMyNjA1TzE0s0wwsDNIMjc0MktNME81Tk82NrNezZjQEMjIIMIqxMjJAIIjPw1CSWlwSn5yRmJeXmsPAAADMgR/X";


class VideoCall extends StatefulWidget {
  final String doctorName;
  final String patientId;
  final String doctorId;

  const VideoCall({
    Key? key,
    required this.doctorName,
    required this.patientId,
    required this.doctorId,
  }) : super(key: key);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late RtcEngine _engine;
  int? _localUid;
  int? _remoteUid;
  bool _isJoined = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _localUid = connection.localUid;
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      //wait for be
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
  }

  @override
  void dispose() {
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.doctorName}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                _remoteUid != null
                    ? AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: _engine,
                    canvas: VideoCanvas(uid: _remoteUid!),
                    connection: RtcConnection(channelId: channelName),
                  ),
                )
                    : const Center(child: Text("Waiting for doctor to join...")),

                //patient video
                Positioned(
                  bottom: 16,
                  right: 16,
                  width: 100,
                  height: 150,
                  child: _localUid != null
                      ? AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(
                        //uid: _localUid!,
                        uid: 0,
                        renderMode: RenderModeType.renderModeHidden,
                      ),
                    ),
                  )
                      : const Center(child: Text("Initializing patient feed...")),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _isJoined ? leaveChannel : initAgora,
              child: Text(_isJoined ? "Leave call" : "Join call"),
            ),
          ),
        ],
      ),
    );
  }
}