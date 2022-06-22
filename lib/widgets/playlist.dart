import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../page_manager.dart';
import '../services/service_locator.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
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
    return Expanded(
      child: ValueListenableBuilder<List<String>>(
        valueListenable: _pageManager.playlistNotifier,
        builder: (context, playlistTitles, _) {
          return ListView.builder(
            itemCount: playlistTitles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(playlistTitles[index]),
                onTap: () => _pageManager.skipToQueueItem(index),
                trailing: IconButton(
                  iconSize: 20,
                  onPressed: () {
                    showConfirmDelete(context, playlistTitles, index);
                  },
                  icon: const Icon(Icons.delete_rounded),
                ),
                contentPadding: const EdgeInsets.only(left: 16, right: 0),
                shape: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  showConfirmDelete(
      BuildContext context, List<String> playlistTitles, int index) {
    _pageManager.pause();
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Are you sure want delete this item?'),
        content: Text(playlistTitles[index]),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Yes'),
            onPressed: () {
              _pageManager.remove(index).then((_) {
                /// close the dialog.
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }
}
