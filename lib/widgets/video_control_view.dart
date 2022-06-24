import 'package:araya_player/notifiers/video_control_provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

enum ControlType { next, previous }

class VideoControlView extends StatelessWidget {
  const VideoControlView({
    Key? key,
    required this.isFullscreen,
    required this.onToggleFullScreen,
    this.isVideoControllerInitialized = false,
    this.videoController,
    required this.onTapPrevNext,
  }) : super(key: key);
  final bool isFullscreen;
  final Function() onToggleFullScreen;
  final bool isVideoControllerInitialized;
  final VideoPlayerController? videoController;
  final Function(ControlType type) onTapPrevNext;

  @override
  Widget build(BuildContext context) {
    var disabled = context.watch<VideoControlProvider>().opacity == 0 ||
        !isVideoControllerInitialized;
    return Positioned.fill(
      child: GestureDetector(
        onLongPressUp: () {},
        onTapUp: (d) {
          debugPrint('araya onTap');
          context.read<VideoControlProvider>().onTapVideoArea();
        },
        child: AnimatedOpacity(
          opacity: context.watch<VideoControlProvider>().opacity,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Material(
            color: Colors.black38,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 74),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildRewindButton(context, disabled),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              iconSize: isFullscreen ? 42 : 32,
                              onPressed: disabled
                                  ? null
                                  : () {
                                      debugPrint('araya play/pause');
                                      onTapPrevNext(ControlType.previous);
                                    },
                              icon: const Icon(Icons.skip_previous_rounded),
                            ),
                            _buildPlayPauseButton(context, disabled),
                            IconButton(
                              iconSize: isFullscreen ? 42 : 32,
                              onPressed: disabled
                                  ? null
                                  : () {
                                      debugPrint('araya play/pause');
                                      onTapPrevNext(ControlType.next);
                                    },
                              icon: const Icon(Icons.skip_next_rounded),
                            ),
                          ],
                        ),
                        IconButton(
                          iconSize: isFullscreen ? 42 : 32,
                          splashRadius: 64,
                          onPressed: disabled
                              ? null
                              : () {
                                  debugPrint('araya forward');
                                },
                          icon: const Icon(Icons.fast_forward_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildTogglerFullscreenButton(context),
                _buildProgressSlider(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewindButton(BuildContext context, bool disabled) =>
      GestureDetector(
        onTap: () {
          debugPrint('araya onTap');
        },
        onDoubleTap: () {
          debugPrint('araya onDoubleTapDown');
        },
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.fast_rewind_rounded,
            size: isFullscreen ? 42 : 32,
          ),
        ),
      );

  Widget _buildPlayPauseButton(BuildContext context, bool disabled) {
    disabled = disabled || !isVideoControllerInitialized;
    bool hideControlView = true;
    IconData icon = Icons.play_arrow_rounded;

    if (isVideoControllerInitialized && videoController!.value.isPlaying) {
      icon = Icons.pause_rounded;
      hideControlView = false;
    }

    return IconButton(
      iconSize: isFullscreen ? 58 : 42,
      onPressed: disabled
          ? null
          : () {
              if (videoController!.value.isPlaying) {
                videoController?.pause();
              } else {
                videoController?.play();
              }
              context
                  .read<VideoControlProvider>()
                  .setHideVideoControl(hideControlView);
            },
      icon: Icon(icon),
    );
  }

  _buildTogglerFullscreenButton(BuildContext context) => SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              iconSize: isFullscreen ? 42 : 32,
              splashRadius: 32,
              onPressed: () => onToggleFullScreen(),
              icon: Icon(isFullscreen
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded),
            )
          ],
        ),
      );

  Widget _buildProgressSlider(BuildContext context) {
    bool hasData = isVideoControllerInitialized;
    return Container(
      padding:
          EdgeInsets.only(left: 8, right: 8, bottom: isFullscreen ? 16 : 0),
      child: ProgressBar(
        timeLabelLocation: TimeLabelLocation.sides,
        progressBarColor: Colors.red,
        baseBarColor: Colors.white.withOpacity(0.24),
        bufferedBarColor: Colors.white.withOpacity(0.24),
        thumbColor: Colors.white,
        thumbRadius: 8,
        progress: hasData ? videoController!.value.position : Duration.zero,
        total: hasData ? videoController!.value.duration : Duration.zero,
        // onSeek: _pageManager.seek,
      ),
    );
  }

  // void _onGestureTapUp(BuildContext context, Offset position) {
  //   final positionY = (MediaQuery.of(context).size.width * 0.6) - 16;
  //   final validYArea = position.dy < positionY;

  //   var leftArea = MediaQuery.of(context).size.width * 0.3;
  //   var rightArea = MediaQuery.of(context).size.width * 0.7;
  //   if (position.dx <= leftArea && validYArea) {
  //     debugPrint('araya onTapUp leftArea $leftArea ${position.dx}');
  //   } else if (position.dx >= rightArea && validYArea) {
  //     debugPrint('araya onTapUp rightArea $rightArea ${position.dx}');
  //   }
  // }
}
