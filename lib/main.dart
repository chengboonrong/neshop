import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neshop/collection.dart';
import 'package:neshop/deals.dart';
import 'package:neshop/home.dart';
import 'package:neshop/new.dart';
import 'package:neshop/search.dart';
import 'package:neshop/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    CupertinoApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => HomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/new': (context) => NewPage(),
        '/deals': (context) => DealsPage(),
        '/search': (context) => SearchPage(),
        '/collection': (context) => CollectionPage(),
        '/settings': (context) => SettingsPage(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
