import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControlPanel extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback fullScreenCallback;
  final IconData fullScreenIcon;

  const VideoControlPanel({
    super.key,
    required this.fullScreenCallback,
    required this.fullScreenIcon,
    required this.controller,
  });

  @override
  State<VideoControlPanel> createState() => _VideoControlPanelState();
}

class _VideoControlPanelState extends State<VideoControlPanel> {
  late final ValueNotifier<bool> _isPlaying;
  late final ValueNotifier<Duration> _position;
  late final ValueNotifier<Duration> _buffered;
  late final ValueNotifier<double> _playbackSpeed;

  @override
  void initState() {
    super.initState();
    _isPlaying = ValueNotifier(widget.controller.value.isPlaying);
    _position = ValueNotifier(widget.controller.value.position);
    _buffered = ValueNotifier(widget.controller.value.buffered.isNotEmpty
        ? widget.controller.value.buffered.last.end
        : Duration.zero);
    _playbackSpeed = ValueNotifier(widget.controller.value.playbackSpeed);

    widget.controller.addListener(_update);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    _isPlaying.dispose();
    _position.dispose();
    _buffered.dispose();
    _playbackSpeed.dispose();
    super.dispose();
  }

  void _update() {
    _position.value = widget.controller.value.position;
    _isPlaying.value = widget.controller.value.isPlaying;
    _buffered.value = widget.controller.value.buffered.isNotEmpty
        ? widget.controller.value.buffered.last.end
        : Duration.zero;
    _playbackSpeed.value = widget.controller.value.playbackSpeed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      child: Column(
        children: [
          _buildProgressBar(context),
          Row(
            children: [
              _buildPlayAndPauseButton(),
              const Spacer(),
              _buildSpeedButtons(),
              _buildFullScreenIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return SliderTheme(
      data: _customSliderTheme(context),
      child: Stack(
        children: [
          ValueListenableBuilder<Duration>(
            valueListenable: _buffered,
            builder: (context, value, child) {
              final duration = widget.controller.value.duration;
              final relativeBuffer = duration.inMilliseconds > 0
                  ? value.inMilliseconds / duration.inMilliseconds
                  : 0.0;
              return Slider(
                value: relativeBuffer,
                onChanged: null,
                activeColor: Colors.grey,
                inactiveColor: Colors.grey[700],
              );
            },
          ),
          ValueListenableBuilder<Duration>(
            valueListenable: _position,
            builder: (context, value, child) {
              final duration = widget.controller.value.duration;
              final relativePosition = duration.inMilliseconds > 0
                  ? value.inMilliseconds / duration.inMilliseconds
                  : 0.0;
              return Slider(
                value: relativePosition,
                onChanged: (changed) {
                  widget.controller.seekTo(duration * changed);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  SliderThemeData _customSliderTheme(BuildContext context) {
    return SliderTheme.of(context).copyWith(
      activeTrackColor: Colors.blue,
      inactiveTrackColor: Colors.grey,
      trackHeight: 2.0,
      thumbColor: Colors.blue,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
      overlayColor: Colors.blue.withAlpha(32),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
    );
  }

  Widget _buildPlayAndPauseButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPlaying,
      builder: (context, value, child) {
        return IconButton(
          icon: Icon(
            value ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: () =>
              value ? widget.controller.pause() : widget.controller.play(),
        );
      },
    );
  }

  Widget _buildFullScreenIcon() {
    return IconButton(
      icon: Icon(
        widget.fullScreenIcon,
        color: Colors.white,
      ),
      onPressed: widget.fullScreenCallback,
    );
  }

  Widget _buildSpeedButtons() {
    return PopupMenuButton<double>(
      icon: const Icon(Icons.speed, color: Colors.white),
      onSelected: (speed) {
        widget.controller.setPlaybackSpeed(speed);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0.5,
          child: Text('0.5x'),
        ),
        const PopupMenuItem(
          value: 1.0,
          child: Text('1.0x'),
        ),
        const PopupMenuItem(
          value: 1.5,
          child: Text('1.5x'),
        ),
        const PopupMenuItem(
          value: 2.0,
          child: Text('2.0x'),
        ),
      ],
    );
  }
}
