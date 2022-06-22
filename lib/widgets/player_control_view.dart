import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import '../notifiers/play_button_notifier.dart';
import '../notifiers/progress_notifier.dart';
import '../notifiers/repeat_button_notifier.dart';
import '../page_manager.dart';
import '../services/service_locator.dart';

class PlayerControlView extends StatefulWidget {
  const PlayerControlView({Key? key}) : super(key: key);

  @override
  State<PlayerControlView> createState() => _PlayerControlViewState();
}

class _PlayerControlViewState extends State<PlayerControlView> {
  late PageManager _pageManager;

  @override
  void initState() {
    _pageManager = getIt<PageManager>();
    super.initState();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentMediaTitle(context),
          _buildSliderProgressBar(context),
          _buildControlButtons(context),
        ],
      ),
    );
  }

  _buildCurrentMediaTitle(BuildContext context) => Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ValueListenableBuilder<String>(
            valueListenable: _pageManager.currentSongTitleNotifier,
            builder: (_, title, __) {
              return Text(
                title,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              );
            },
          ),
        ),
      );

  _buildSliderProgressBar(BuildContext context) =>
      ValueListenableBuilder<ProgressBarState>(
        valueListenable: _pageManager.progressNotifier,
        builder: (_, value, __) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ProgressBar(
              progressBarColor: Colors.red,
              baseBarColor: Colors.white.withOpacity(0.24),
              bufferedBarColor: Colors.white.withOpacity(0.24),
              thumbColor: Colors.white,
              thumbRadius: 8,
              timeLabelPadding: 4,
              progress: value.current,
              buffered: value.buffered,
              total: value.total,
              onSeek: _pageManager.seek,
            ),
          );
        },
      );

  _buildControlButtons(BuildContext context) => SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder<RepeatState>(
              valueListenable: _pageManager.repeatButtonNotifier,
              builder: (context, value, child) {
                Icon icon;
                switch (value) {
                  case RepeatState.off:
                    icon = const Icon(Icons.repeat, color: Colors.grey);
                    break;
                  case RepeatState.repeatSong:
                    icon = const Icon(Icons.repeat_one);
                    break;
                  case RepeatState.repeatPlaylist:
                    icon = const Icon(Icons.repeat);
                    break;
                }
                return IconButton(
                  icon: icon,
                  onPressed: _pageManager.repeat,
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _pageManager.isFirstSongNotifier,
              builder: (_, isFirst, __) {
                return IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: (isFirst) ? null : _pageManager.previous,
                );
              },
            ),
            ValueListenableBuilder<ButtonState>(
              valueListenable: _pageManager.playButtonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 32.0,
                      height: 32.0,
                      child: const CircularProgressIndicator(),
                    );
                  case ButtonState.paused:
                    return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: 32.0,
                      onPressed: _pageManager.play,
                    );
                  case ButtonState.playing:
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      iconSize: 32.0,
                      onPressed: _pageManager.pause,
                    );
                }
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _pageManager.isLastSongNotifier,
              builder: (_, isLast, __) {
                return IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: (isLast) ? null : _pageManager.next,
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _pageManager.isShuffleModeEnabledNotifier,
              builder: (context, isEnabled, child) {
                return IconButton(
                  icon: (isEnabled)
                      ? const Icon(Icons.shuffle)
                      : const Icon(Icons.shuffle, color: Colors.grey),
                  onPressed: _pageManager.shuffle,
                );
              },
            ),
          ],
        ),
      );
}
