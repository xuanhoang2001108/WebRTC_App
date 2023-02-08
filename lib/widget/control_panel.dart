import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ControlPanel extends StatelessWidget {
  final bool? videoEnabled;
  final bool? audioEnabled;
  final bool? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? onMeetingEnd;

  const ControlPanel({
    super.key,
    this.audioEnabled,
    this.videoEnabled,
    this.onAudioToggle,
    this.onVideoToggle,
    this.isConnectionFailed,
    this.onMeetingEnd,
    this.onReconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildControl(),
      ),
    );
  }

  List<Widget> buildControl() {
    if (!isConnectionFailed!) {
      return <Widget>[
        IconButton(
          onPressed: onVideoToggle,
          icon: Icon(videoEnabled! ? Icons.videocam : Icons.videocam_off),
          iconSize: 32,
          color: Colors.white,
        ),
        IconButton(
          onPressed: onAudioToggle,
          icon: Icon(audioEnabled! ? Icons.mic : Icons.mic_off),
          iconSize: 32,
          color: Colors.white,
        ),
        const SizedBox(
          width: 25,
        ),
        Container(
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.redAccent,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.call_end,
              color: Colors.white,
            ),
            onPressed: onMeetingEnd!,
          ),
        )
      ];
    } else {
      return <Widget>[
        FormHelper.submitButton("Reconnect", onReconnect!,
            btnColor: Colors.red, borderRadius: 10, width: 200, height: 40)
      ];
    }
  }
}
