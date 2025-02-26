import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shared_preferences_provider.dart';
import 'providers/theme_provider.dart';
import 'routes/app_router.dart';
import 'providers/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;

  const MyApp({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkMode: isDarkMode)),
        Provider(create: (_) => ApiProvider()),
        Provider(create: (_) => SharedPreferencesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Anonymous Social App',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/splash',
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
