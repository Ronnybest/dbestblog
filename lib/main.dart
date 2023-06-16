import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'common/routes/pages.dart';
import 'global.dart';

void main() async {
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.deepPurple, brightness: Brightness.dark);
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      Color statusBarColor = lightColorScheme?.onBackground ??
          _defaultLightColorScheme.onSecondary;
      if (Theme.of(context).brightness == Brightness.dark) {
        statusBarColor = darkColorScheme?.onBackground ??
            _defaultDarkColorScheme.onSecondary;
      }
      FlutterStatusbarcolor.setStatusBarColor(statusBarColor);
      return MultiBlocProvider(
        providers: [...AppPagesComplect.allBlocsProvider(context)],
        child: MaterialApp(
          onGenerateRoute: AppPagesComplect.generateRoutes,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
            useMaterial3: true,
          ),
          //home: AuthorizationPage(),
        ),
      );
    });
  }
}
