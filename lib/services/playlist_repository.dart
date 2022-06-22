import 'package:araya_player/data/local/local_sp.dart';
import 'package:flutter/material.dart';

abstract class PlaylistRepository {
  Future<List<Map<String, String>>> fetchInitialPlaylist();
  Future<Map<String, String>> fetchAnotherSong(BuildContext context);
}

class DemoPlaylist extends PlaylistRepository {
  @override
  Future<List<Map<String, String>>> fetchInitialPlaylist(
      {int length = 0}) async {
    return LocalSP().fetchListMapSpPlaylist();
  }

  @override
  Future<Map<String, String>> fetchAnotherSong(BuildContext context) async {
    return {
      'id': '',
      'title': '',
      'album': 'EL Araya',
      'url': '',
    };
  }
}
