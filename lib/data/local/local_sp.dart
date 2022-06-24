import 'package:araya_core_prefs/araya_core_prefs.dart';
import 'package:araya_player/data/models/playist_sp_model.dart';
import 'package:araya_player/notifiers/repeat_button_notifier.dart';
import 'package:araya_player/utilize/constants.dart';
import 'package:audio_service/audio_service.dart';

class LocalSP {
  factory LocalSP() => LocalSP._internal();
  LocalSP._internal();

  List<Map<String, String>> fetchListMapSpPlaylist() {
    final spData = SharedPrefs().getString(Constants.spPlaylist);
    final listPlaylistSp = spData ?? '[[]]';
    final listPlaylist = playlistSpModelFromJson(listPlaylistSp);

    return listPlaylist[0].map((e) => e.toMap()).toList();
  }

  Future storeSpPlaylist(List<MediaItem> mediaItems) async {
    final spPlaylist = fetchListMapSpPlaylist();
    spPlaylist.addAll(mediaItems.map((e) => {
          "id": e.id,
          "title": e.title,
          "album": e.album!,
          "url": e.extras!["url"]
        }));
    final storeToSp = [
      spPlaylist.map((e) => PlaylistSpModel.fromMap(e)).toList()
    ];

    await SharedPrefs()
        .setString(Constants.spPlaylist, playlistSpModelToJson(storeToSp));
  }

  Future removeItemSpPlaylist(int index) async {
    var listPlaylistSp = playlistSpModelFromJson(
        SharedPrefs().getString(Constants.spPlaylist) ?? '[[]]');
    listPlaylistSp[0].removeAt(index);
    listPlaylistSp[0].map((e) => PlaylistSpModel.fromJson(e.toMap())).toList();

    await SharedPrefs()
        .setString(Constants.spPlaylist, playlistSpModelToJson(listPlaylistSp));
  }

  RepeatState? getRepeat() {
    final value =
        SharedPrefs().getString(Constants.spRepeatMode) ?? RepeatState.off.name;
    var repeatState = RepeatState.values.firstWhere((v) => v.name == value);
    final next = (repeatState.index + 1) % RepeatState.values.length;
    repeatState = RepeatState.values[next];
    return repeatState;
  }

  Future setRepeat(RepeatState repeatMode) async {
    await SharedPrefs().setString(Constants.spRepeatMode, repeatMode.name);
  }

  String getPathFile(int index) {
    final spPlaylist = fetchListMapSpPlaylist();
    final data = spPlaylist.map((e) => PlaylistSpModel.fromMap(e)).toList();
    final pathFile = data.elementAt(index).url;
    return pathFile;
  }
}
