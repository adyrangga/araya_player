import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../page_manager.dart';
import '../services/service_locator.dart';

class Playlist extends StatelessWidget {
  const Playlist({
    Key? key,
    this.isVideo = false,
    this.onSelectVideo,
  }) : super(key: key);

  final bool isVideo;
  final Function(String title, int index)? onSelectVideo;

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return Expanded(
      child: ValueListenableBuilder<List<String>>(
        valueListenable: pageManager.playlistNotifier,
        builder: (context, playlistTitles, _) {
          return ListView.builder(
            itemCount: playlistTitles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(playlistTitles[index]),
                onTap: () {
                  if (isVideo && onSelectVideo != null) {
                    onSelectVideo!(playlistTitles[index], index);
                  } else {
                    pageManager.skipToQueueItem(index);
                  }
                },
                trailing: IconButton(
                  iconSize: 20,
                  onPressed: () {
                    showConfirmDelete(
                        context, playlistTitles, index, pageManager);
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

  showConfirmDelete(BuildContext context, List<String> playlistTitles,
      int index, PageManager pageManager) {
    pageManager.pause();
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
              pageManager.remove(index).then((_) {
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
