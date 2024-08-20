import 'package:flutter/material.dart';
import 'package:multiple_scenes/video_player_module/video_player_module.dart';

final Uri uri = Uri.parse('https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8');

void main() => runApp(const VideosScreen());

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: VideoPlayerModule(uri: uri),
      ),
    );
  }
}
