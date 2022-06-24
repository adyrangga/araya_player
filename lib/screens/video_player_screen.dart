import 'dart:io';

import 'package:araya_player/data/local/local_sp.dart';
import 'package:araya_player/page_manager.dart';
import 'package:araya_player/services/service_locator.dart';
import 'package:araya_player/utilize/constants.dart';
import 'package:araya_player/utilize/utils.dart';
import 'package:araya_player/widgets/playlist.dart';
import 'package:araya_player/widgets/video_control_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
// import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController? _videoController;

  @override
  void initState() {
    _videoController = null;
    _resetFullScreen();
    super.initState();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _resetFullScreen();
    super.dispose();
  }

  Future _onToggleFullScreen(BuildContext context, bool isPotrait) async {
    if (isPotrait) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      await _resetFullScreen();
    }
  }

  Future _resetFullScreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([]);
    await SystemChrome.restoreSystemUIOverlays();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isPotrait = orientation == Orientation.portrait;
        return Scaffold(
          appBar: isPotrait
              ? AppBar(
                  backgroundColor: Colors.black,
                  title: const Text(Constants.appName),
                )
              : null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey.withOpacity(0.5),
                height: isPotrait
                    ? (MediaQuery.of(context).size.height * 0.3)
                    : MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    _buildVideoPreview(context),
                    VideoControlView(
                      isFullscreen: !isPotrait,
                      onToggleFullScreen: () =>
                          _onToggleFullScreen(context, isPotrait),
                      isVideoControllerInitialized: _videoController != null,
                      videoController: _videoController,
                      onTapPrevNext: (type) => _onTapPrevNext(context, type),
                    ),
                  ],
                ),
              ),
              _buildPlaylist(context, isPotrait),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoPreview(BuildContext context) {
    return _videoController != null
        ? Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          )
        : const SizedBox();
  }

  Widget _buildPlaylist(BuildContext context, bool isPotrait) {
    return isPotrait
        ? Playlist(
            isVideo: true,
            onSelectVideo: (title, index) => _onSelectVideo(title, index),
          )
        : const SizedBox();
  }

  _onSelectVideo(String title, int index) {
    _videoController?.pause();
    _videoController?.dispose();
    final pathFile = LocalSP().getPathFile(index);
    debugPrint('araya onSelectVideo $pathFile, $index');
    _videoController = VideoPlayerController.file(File(pathFile))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        Future.delayed(const Duration(milliseconds: 500)).then((_) {
          setState(() {
            _videoController?.play();
          });
        });
      });
  }

  _onTapPrevNext(BuildContext context, ControlType type) {
    final pageManager = getIt<PageManager>();
    final files = pageManager.playlistNotifier.value;
    debugPrint('araya _onTapPrevNext $type ${files[0]}');
    final maxIndex = files.length - 1;
    final currentSource =
        _videoController!.dataSource.replaceAll('file://', '');
    final currentIndex =
        files.indexWhere((v) => v == Utils().getFileName(currentSource));

    debugPrint('araya currentIndex $currentIndex');
    if (currentIndex == -1) return;

    debugPrint('araya $type $currentSource');
    if (type == ControlType.previous) {
      final nextIndex = currentIndex - 1;
      if (nextIndex < 0) return;
      _onSelectVideo(
          Utils().getFileName(files.elementAt(nextIndex)), nextIndex);
    } else if (type == ControlType.next) {
      final nextIndex = currentIndex + 1;
      if (nextIndex > maxIndex) return;
      _onSelectVideo(
          Utils().getFileName(files.elementAt(nextIndex)), nextIndex);
    }
  }
}
