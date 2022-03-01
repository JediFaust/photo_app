import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:photo_app/src/models/photo_location.dart';
import 'package:photo_app/src/providers/photo_provider.dart';
import 'package:photo_app/src/screens/photo_location.dart';
import 'package:photo_app/src/screens/photos_list.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ChangeNotifierProvider.value(
      value: PhotoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'app',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (BuildContext context) {
              switch (routeSettings.name) {
                case MapScreen.routeName:
                  return MapScreen(
                    selectedLocation: routeSettings.arguments as PhotoLocation,
                  );
                case PhotosList.routeName:
                default:
                  return const PhotosList();
              }
            },
          );
        },
      ),
    );
  }
}
