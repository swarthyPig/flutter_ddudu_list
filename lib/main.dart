import 'package:ddudu/provider/store.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'layout/content.dart';
import 'layout/footer.dart';
import 'model/style.dart' as style;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Store()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: style.theme,
        home: const Home(),
      ),
    )
  );
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
      floatingActionButton: FloatingActionButton(child: const FaIcon(FontAwesomeIcons.plus), onPressed: (){
      },),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar( centerTitle: true, title: const Text('Task'),),
      body: const Content(),
      bottomNavigationBar: const Footer(),
    );
  }
}

