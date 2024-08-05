import 'package:ddudu/provider/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: const Text('home'),);
  }
}
