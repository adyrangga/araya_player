import 'package:araya_player/config/routes.dart';
import 'package:araya_player/utilize/constants.dart';
import 'package:araya_player/widgets/player_control_view.dart';
import 'package:araya_player/widgets/playlist.dart';
import 'package:flutter/material.dart';

import '../page_manager.dart';
import '../services/service_locator.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(Constants.appName),
        actions: [_buildPopupMenu(context)],
      ),
      body: SafeArea(
        child: Column(
          children: const [
            Playlist(),
            PlayerControlView(),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    final items = ['Add Item', 'Add Playlist', 'Video Player'];
    final pageManager = getIt<PageManager>();

    return PopupMenuButton(
      padding: const EdgeInsets.all(0),
      splashRadius: 24,
      itemBuilder: (context) => items
          .map((v) => PopupMenuItem(
                enabled: v != 'Add Playlist',
                value: v,
                height: 40,
                child: Text(v),
              ))
          .toList(),
      onSelected: (v) {
        if (v == 'Add Item') {
          pageManager.add(context).then((_) {
            /// after add item process, hide loadingBar
            Navigator.pop(context);
          });
        } else if (v == 'Video Player') {
          pageManager.pause().then((value) {
            Navigator.pushNamed(context, Routes.videoPlayer);
          });
        }
      },
    );
  }
}
