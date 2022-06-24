import 'package:araya_player/utilize/constants.dart';
import 'package:araya_player/widgets/player_control_view.dart';
import 'package:araya_player/widgets/playlist.dart';
import 'package:flutter/material.dart';

import '../page_manager.dart';
import '../services/service_locator.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
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
    final items = ['Add Item'];

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
          _pageManager.add(context).then((_) {
            /// after add item process, hide loadingBar
            Navigator.pop(context);
          });
        }
      },
    );
  }
}
