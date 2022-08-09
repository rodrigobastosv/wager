import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:wager/pages/company/company_form_page.dart';
import 'package:wager/pages/company/company_list_page.dart';
import 'package:wager/pages/pages.dart';
import 'package:wager/pages/role/role_form_page.dart';
import 'package:wager/pages/role/role_list_page.dart';
import 'package:wager/pages/splash/splash_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'pt_BR';

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            switch (routeSettings.name) {
              case SignInPage.routeName:
                return const SignInPage();
              case HomePage.routeName:
                return const HomePage();
              case CompanyListPage.routeName:
                return const CompanyListPage();
              case CompanyFormPage.routeName:
                return const CompanyFormPage();
              case RoleListPage.routeName:
                return const RoleListPage();
              case RoleFormPage.routeName:
                return const RoleFormPage();
              default:
                return const HomePage();
            }
          },
        );
      },
    );
  }
}
