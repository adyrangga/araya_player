import 'package:araya_player/screens/audio_player_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AudioPlayerScreen());
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
