import 'dart:async';

import 'package:cloud_flutter/views/email_verify_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //getInitialLinks = This returns the link app was started with, if any. And itu returns a String.

    //getInitialUri = Same as get initialLink, but returned as a Uri

    //LinkStream = This is important if your app is already running in the background and then opened via a link. In that case getInitailLink would be null and getLinksStream would get a new event holding the link.

    //uriLinkStream: Same as linkStream with Uri objects as its events.

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EmailVerify(),
    );
  }
}
