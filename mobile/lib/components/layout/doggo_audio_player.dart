import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:mobile/theme/colors.dart';

class DoggoAudioPlayer extends StatefulWidget {
  final DoggoFile file;
  const DoggoAudioPlayer({super.key, required this.file});

  @override
  State<DoggoAudioPlayer> createState() => _DoggoAudioPlayerState();
}

class _DoggoAudioPlayerState extends State<DoggoAudioPlayer> {
  late AudioPlayer player = AudioPlayer()
    ..setAudioSource(AudioSource.uri(Uri.parse(widget.file.url), tag: MediaItem(id: widget.file.id, title: widget.file.name)));
  double _progress = 0.0;
  bool _isPaused = true;

  @override
  void initState() {
    super.initState();
    player.positionStream.listen((event) {
      setState(() {
        _progress = event.inMilliseconds /
            (player.duration ?? const Duration(days: 1)).inMilliseconds;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            LinearProgressIndicator(
                minHeight: 7,
                value: _progress,
                valueColor:
                    const AlwaysStoppedAnimation(Color.fromRGBO(21, 25, 109, 1)),
                backgroundColor: DoggoColors.secondary),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    int seek = player.position.inMilliseconds - 10000;
                    if (seek < 0) {
                      seek = 0;
                    }
                    player.seek(Duration(milliseconds: seek));
                  },
                  icon:
                      const Icon(Icons.replay_10, color: DoggoColors.secondary),
                ),
                IconButton(
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause,
                      color: DoggoColors.secondary),
                  onPressed: () {
                    if (_isPaused) {
                      player.play();
                    } else {
                      player.pause();
                    }
                    setState(() {
                      _isPaused = !_isPaused;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10,
                      textDirection: TextDirection.rtl,
                      color: DoggoColors.secondary),
                  onPressed: () {
                    int seek = player.position.inMilliseconds + 10000;
                    if (seek > player.duration!.inMilliseconds) {
                      seek = player.duration!.inMilliseconds;
                    }
                    player.seek(Duration(milliseconds: seek));
                  },
                )
              ],
            ),
          ],
        ));
  }
}
