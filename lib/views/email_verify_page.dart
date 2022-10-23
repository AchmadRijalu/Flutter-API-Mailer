import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_flutter/services/apiservices.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({super.key});

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  @override
  void initState() {
    super.initState();
  }

  final _keyState = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Verifikasi Email",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  )
                ]),
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/EmailVerifyPng.png"))),
              ),
              SizedBox(
                height: 32,
              ),
              Form(
                  key: _keyState,
                  child: Container(
                      width: 20,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (value) {
                              emailController.text = value;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return EmailValidator.validate(value.toString())
                                  ? null
                                  : "Format harus dalam bentuk email";
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 3.0)),
                              hintText: 'Email',
                            ),
                          ),
                        ],
                      ))),
              SizedBox(
                height: 32,
              ),
              Container(
                width: 28,
                // color: Colors.amber,
                height: 46,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 160,
                    child: ElevatedButton(
                        onPressed: (() async {
                          if (_keyState.currentState!.validate()) {
                            if (emailController.text == "") {
                              Fluttertoast.showToast(
                                  msg:
                                      "Mohon untuk mengisi email terlebih dahulu",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              await EmailVerifyService.postEmail(
                                      emailController.text)
                                  .then((value) {
                                var results =
                                    json.decode(value.body.toString());
                              });
                              Fluttertoast.showToast(
                                  msg:
                                      "${emailController.text} berhasil dikirim",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Form tidak sesuai dengan format!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }),
                        child: Text("Kirim Email")),
                  )
                ]),
              )
            ]),
      ),
    )));
  }
}
