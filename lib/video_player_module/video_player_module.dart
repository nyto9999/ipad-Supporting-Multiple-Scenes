import 'package:flutter/material.dart';
import 'package:multiple_scenes/video_player_module/video_control_panel.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerModule extends StatefulWidget {
  const VideoPlayerModule({super.key, required this.uri});
  final Uri uri;

  @override
  State<VideoPlayerModule> createState() => _VideoPlayerModuleState();
}

class _VideoPlayerModuleState extends State<VideoPlayerModule> {
  late VideoPlayerController _controller;
  late final ValueNotifier<bool> _isInitialized;
  late final ValueNotifier<String?> _errorMessage;
   
  final double _size = 500.0;
  final double _aspectRatio = (16 / 9);
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(widget.uri)
      ..initialize().then((_) {
        setState(() {});
      });

    _isInitialized = ValueNotifier(_controller.value.isInitialized);
    _errorMessage = ValueNotifier(null);

    _controller.addListener(_update);
  }

  void _update() {
    _isInitialized.value = _controller.value.isInitialized;
    _controller.value.hasError
        ? _errorMessage.value = "影片載入失敗"
        : _errorMessage.value = null;
  }

  @override
  void dispose() {
    _controller.removeListener(_update);
    _controller.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _isFullScreen ? MediaQuery.of(context).size.width : _size,
      height: _isFullScreen
          ? MediaQuery.of(context).size.height
          : _size / _aspectRatio,
      child: Column(
        children: [
          Expanded(child: _buildVideoPlayer()),
          VideoControlPanel(
            controller: _controller,
            fullScreenCallback: _toggleFullScreen,
            fullScreenIcon:
                _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
          ),
          _buildErrorMessage(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isInitialized,
      builder: (context, value, child) {
        return value
            ? VideoPlayer(_controller)
            : Container(color: Colors.black);
      },
    );
  }

  Widget _buildErrorMessage() {
    return ValueListenableBuilder<String?>(
      valueListenable: _errorMessage,
      builder: (context, value, child) {
        if (value != null) {
          return Center(
            child: Text(
              value,
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        }
        return Container();
      },
    );
  }
}
