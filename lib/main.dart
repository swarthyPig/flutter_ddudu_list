import 'package:ddudu/provider/store.dart';
import 'package:ddudu/util/show_dialog.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'layout/content.dart';
import 'layout/footer.dart';
import 'layout/login_view.dart';
import 'model/style.dart' as style;

final auth = FirebaseAuth.instance;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
        DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => const MyApp(), // Wrap your app
        ),

    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Store()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko','KR'),
        ],
        theme: auth.currentUser?.uid == null ? ThemeData.light() : style.theme,
        darkTheme: ThemeData.dark(),
        home: auth.currentUser?.uid == null ? const LoginView() : const Home(),
      ),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const FaIcon(FontAwesomeIcons.plus),
        onPressed: (){
          showCreateDialog(context, context.read<Store>().pvSelectedDay);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar( centerTitle: true, title: const Text('Task'),),
      body: const Content(),
      bottomNavigationBar: const Footer(),
    );
  }
}

