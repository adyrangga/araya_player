import 'package:araya_core_prefs/araya_core_prefs.dart';
import 'package:araya_player/config/route_generator.dart';
import 'package:araya_player/config/routes.dart';
import 'package:araya_player/notifiers/video_control_provider.dart';
import 'package:araya_player/screens/audio_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'page_manager.dart';
import 'services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize SharedPreference first, before runApp.
  await SharedPrefs().init();

  await setupServiceLocator();

  runApp(MultiProvider(
    providers: [
      // araya core changeThemeProvider
      ChangeNotifierProvider(create: (_) => ArayaThemeProvider()),
      ChangeNotifierProvider(create: (_) => VideoControlProvider()),
    ],
    child: const App(),
  ));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    getIt<PageManager>().init();
  }

  @override
  void dispose() {
    getIt<PageManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      initialRoute: Routes.initial,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: const AudioPlayerScreen(),
    );
  }
}
