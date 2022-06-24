import 'package:araya_player/config/routes.dart';
import 'package:araya_player/screens/audio_player_screen.dart';
import 'package:araya_player/screens/video_player_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
        return MaterialPageRoute(builder: (_) => const AudioPlayerScreen());
      case Routes.videoPlayer:
        return MaterialPageRoute(builder: (_) => const VideoPlayerScreen());
      // if want to send arguments, final args = settings.arguments;
      // return MaterialPageRoute(builder: (_) => AboutPage(args));
      default:
        return _notFoundRoute();
    }
  }

  static Route<dynamic> _notFoundRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(child: Text('Page Not Found')),
      );
    });
  }
}
