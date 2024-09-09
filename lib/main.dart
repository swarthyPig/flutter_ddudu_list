import 'package:ddudu/provider/store.dart';
import 'package:ddudu/util/show_dialog.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'layout/content.dart';
import 'layout/footer.dart';
import 'layout/login_view.dart';
import 'model/style.dart' as style;

final auth = FirebaseAuth.instance;

DateTime? currentBackPressTime;

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
        initialRoute: '/',
        routes: {
          "/home": (context) => const Home(),
        },
        theme: style.theme, // Light mode 일때
        darkTheme: style.theme, // Dark mode 일때 적용 할 테마
        home: MediaQuery(
          data:MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: auth.currentUser?.uid == null ? const LoginView() : const Home(),
        )
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
      body : const WillPopScope(
        onWillPop: onWillPop,
        child: Content(),
      ),
      // ios에서 이슈가있음
      /*body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          await onPopScope();
        },
        child: const Content(),
      ),*/
      bottomNavigationBar: const Footer(),
    );
  }
}

Future<bool> onWillPop(){

  DateTime now = DateTime.now();

  if(currentBackPressTime == null || now.difference(currentBackPressTime!)
      > const Duration(seconds: 2))
  {

    currentBackPressTime = now;
    const msg = "'뒤로'버튼을 한 번 더 누르면 종료됩니다.";

    Fluttertoast.showToast(msg: msg);
    return Future.value(false);

  }

  return Future.value(true);

}

// ios에서 이슈가있음
/*Future<bool> onPopScope(){

  DateTime now = DateTime.now();

  if(currentBackPressTime == null || now.difference(currentBackPressTime!)
      > const Duration(seconds: 2))
  {

    currentBackPressTime = now;
    const msg = "'뒤로'버튼을 한 번 더 누르면 종료됩니다.";

    Fluttertoast.showToast(msg: msg);
    return Future.value(false);

  }

  return Future.value(true);

}*/
