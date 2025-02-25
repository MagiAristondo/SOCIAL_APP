import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'providers/login_provider.dart';
import 'providers/shared_preferences_provider.dart';
import 'providers/theme_provider.dart';
import 'routes/app_router.dart';
import 'providers/api_provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkMode: false)),
        Provider(create: (_) => ApiProvider()),
        Provider(create: (_) => SharedPreferencesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Anonymous Social App',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        initialRoute: '/splash',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
