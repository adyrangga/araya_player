import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  factory Utils() => Utils._internal();
  Utils._internal();

  Color? primaryIconColor(BuildContext context, [bool enabled = true]) {
    final color = Theme.of(context).primaryIconTheme.color!;
    if (enabled) return color;
    return color.withOpacity(0.6);
  }

  String formatDuration(Duration? duration) {
    duration = duration ?? Duration.zero;
    return duration.toString().split('.').first.padLeft(8, '0');
  }

  String getFileName(String path) {
    return path.split('/').last.split('.')[0];
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  Future<bool> checkPermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    var req = await Permission.storage.request();
    return req.isGranted;
  }
}
