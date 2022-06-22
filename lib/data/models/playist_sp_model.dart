// To parse this JSON data, do
//
//     final playlistSpModel = playlistSpModelFromJson(jsonString);

import 'dart:convert';

List<List<PlaylistSpModel>> playlistSpModelFromJson(String str) =>
    List<List<PlaylistSpModel>>.from(json.decode(str).map((x) =>
        List<PlaylistSpModel>.from(x.map((x) => PlaylistSpModel.fromJson(x)))));

String playlistSpModelToJson(List<List<PlaylistSpModel>> data) =>
    json.encode(List<dynamic>.from(
        data.map((x) => List<dynamic>.from(x.map((x) => x.toMap())))));

class PlaylistSpModel {
  PlaylistSpModel({
    this.id = '',
    this.title = '',
    this.album = '',
    this.url = '',
  });

  String id;
  String title;
  String album;
  String url;

  factory PlaylistSpModel.fromJson(Map<String, dynamic> json) =>
      PlaylistSpModel(
        id: json["id"],
        title: json["title"],
        album: json["album"],
        url: json["url"],
      );

  factory PlaylistSpModel.fromMap(Map<String, String> json) => PlaylistSpModel(
        id: json["id"]!,
        title: json["title"]!,
        album: json["album"]!,
        url: json["url"]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "album": album,
        "url": url,
      };

  Map<String, String> toMap() => {
        "id": id,
        "title": title,
        "album": album,
        "url": url,
      };
}
