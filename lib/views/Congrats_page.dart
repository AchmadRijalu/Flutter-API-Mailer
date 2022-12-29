import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CongratsPage extends StatelessWidget {
  String? urisource;
  CongratsPage({super.key, this.urisource});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Congratss!!")),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            child: Column(children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Congrats!! Kamu Sudah Kelar!!",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w700),
                          )
                        ]),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/EmailVerifyPng.png"))),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                ],
              ))
            ]),
          ),
        )));
  }
}
