import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_color/dynamic_color.dart';
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
      // Color statusBarColor =
      //     lightColorScheme?.background ?? _defaultLightColorScheme.background;
      // if (Theme.of(context).brightness == Brightness.dark) {
      //   statusBarColor = darkColorScheme?.onBackground ??
      //       _defaultDarkColorScheme.onBackground;
      // }
      if (Theme.of(context).brightness == Brightness.dark) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      } else {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      }
      // FlutterStatusbarcolor.setStatusBarColor((lightColorScheme!.background ??
      //         _defaultLightColorScheme.background) ??
      //     (darkColorScheme!.onBackground ??
      //         _defaultDarkColorScheme.onBackground));
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
