import 'package:flutter/material.dart';
import 'package:social_app/screens/login/splash_screen.dart';
import 'package:social_app/screens/new_post.dart';
import '../models/missatge.dart';
import '../screens/home_page.dart';
import '../screens/login/login_screen.dart';
//import '../screens/register_page.dart';
import '../screens/settings_page.dart';
import '../screens/message_detail_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      // case '/register':
      //   return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case '/messageDetail':
        final missatge = settings.arguments as Missatge;
        return MaterialPageRoute(
          builder: (_) => MessageDetailPage(missatge: missatge),
        );
      case '/newPost':
        return MaterialPageRoute(builder: (_) => NewPostPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Ruta no trobada: ${settings.name}')),
          ),
        );
    }
  }
}
