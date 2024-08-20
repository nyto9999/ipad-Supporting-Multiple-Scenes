import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const VideoApp());

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  VideoAppState createState() => VideoAppState();
}

class VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    final uri = Uri.parse('https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8');
    _controller = VideoPlayerController.networkUrl(uri)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              width: _isFullScreen ? MediaQuery.of(context).size.width : 300,
              height: _isFullScreen
                  ? MediaQuery.of(context).size.height
                  : 300 / (16 / 9),
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(color: Colors.black),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _controller.setPlaybackSpeed(0.5);
                      });
                    },
                    child: const Text('0.5x'),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _controller.setPlaybackSpeed(1.0);
                      });
                    },
                    child: const Text('1x'),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _controller.setPlaybackSpeed(1.5);
                      });
                    },
                    child: const Text('1.5x'),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _controller.setPlaybackSpeed(2.0);
                      });
                    },
                    child: const Text('2x'),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _toggleFullScreen();
                      });
                    },
                    child: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFullScreen() {
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }
    _isFullScreen = !_isFullScreen;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}