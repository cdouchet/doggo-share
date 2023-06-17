import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class DoggoVideoPlayer extends StatefulWidget {
  final String url;
  const DoggoVideoPlayer({super.key, required this.url});

  @override
  State<DoggoVideoPlayer> createState() => _DoggoVideoPlayerState();
}

class _DoggoVideoPlayerState extends State<DoggoVideoPlayer> {
  late BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BetterPlayerController(
        const BetterPlayerConfiguration(
            controlsConfiguration: BetterPlayerControlsConfiguration(
                enableAudioTracks: false,
                enableFullscreen: false,
                enableMute: true,
                enableOverflowMenu: false,
                enablePip: false,
                enablePlayPause: true,
                enablePlaybackSpeed: false,
                enableProgressBar: true,
                enableProgressBarDrag: true,
                enableProgressText: false,
                enableQualities: true,
                enableRetry: true,
                enableSkips: false,
                enableSubtitles: false)),
        betterPlayerDataSource: BetterPlayerDataSource.network(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(controller: _controller);
  }
}
