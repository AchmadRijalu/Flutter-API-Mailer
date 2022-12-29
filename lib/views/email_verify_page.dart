import 'dart:async';
import 'dart:convert';

import 'package:cloud_flutter/views/Congrats_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_flutter/services/apiservices.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uni_links/uni_links.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({super.key});

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  @override
  void initState() {
    super.initState();
    _initURIHandler();
  }

  Uri? _initialURI;
  Uri? _latestUri;
  Object? _err;
  String message = "";
  StreamSubscription? _sub;
  bool _initialURILinkHandled = false;
  final _keyState = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;

      try {
        final initialize = await getInitialUri();

        if (initialize != null) {
          message = "opened with link";
          debugPrint("Initial URI received $initialize");

          setState(() {
            _initialURI = initialize;
          });
        } else {
          message = "Opened without link";
          debugPrint("Null Initial URI received");
        }
      } on PlatformException {
        debugPrint("Failed to initialize");
      } on FormatException catch (error) {
        debugPrint('Error');
        setState(() => _err = error);
      }
    }
  }

  // void _incomingLinkHandler() {
  //   _sub = uriLinkStream.listen((Uri? uri) {
  //     if (!mounted) {
  //       return;
  //     }
  //     debugPrint('Received URI: $uri');
  //     setState(() {
  //       _latestUri = uri;
  //       _err = null;
  //     });
  //   }, onError: (Object err) {
  //     if (!mounted) {
  //       return;
  //     }
  //     debugPrint('Error occurred: $err');
  //     setState(() {
  //       _latestUri = null;
  //       if (err is FormatException) {
  //         _err = err;
  //       } else {
  //         _err = null;
  //       }
  //     });
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (message == "") {
      //   return
      return Scaffold(
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Verifikasi Email",
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
                          image:
                              AssetImage("assets/images/EmailVerifyPng.png"))),
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
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 5.0),
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                      print(results);
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
                        ),
                      ]),
                ),
              ],
            )),
          ]),
        ),
      )));
    } else {
      return CongratsPage();
    }
    //     body: StreamBuilder<String?>(
    //   stream: linkStream,
    //   builder: (context, snapshot) {
    //     final link = snapshot.data ?? "";

    //     return FutureBuilder<String?>(
    //       future: getInitialLink(),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         }
    //         final link = snapshot.data ?? "";
    //         final message = link.isEmpty
    //             ? "Opened without Link"
    //             : "Opened with Link \n${link}";

    //         if (message == "Opened without Link") {
    //           return SafeArea(
    //               child: Padding(
    //             padding: const EdgeInsets.all(12),
    //             child: Container(
    //               child: Column(children: [
    //                 Expanded(
    //                     child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.stretch,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Container(
    //                       child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Text(
    //                               "Verifikasi Email",
    //                               style: TextStyle(
    //                                   fontSize: 26,
    //                                   fontWeight: FontWeight.w700),
    //                             )
    //                           ]),
    //                     ),
    //                     Container(
    //                       width: 200,
    //                       height: 200,
    //                       decoration: BoxDecoration(
    //                           image: DecorationImage(
    //                               image: AssetImage(
    //                                   "assets/images/EmailVerifyPng.png"))),
    //                     ),
    //                     SizedBox(
    //                       height: 32,
    //                     ),
    //                     Form(
    //                         key: _keyState,
    //                         child: Container(
    //                             width: 20,
    //                             child: Column(
    //                               children: [
    //                                 TextFormField(
    //                                   onChanged: (value) {
    //                                     emailController.text = value;
    //                                   },
    //                                   autovalidateMode:
    //                                       AutovalidateMode.onUserInteraction,
    //                                   validator: (value) {
    //                                     return EmailValidator.validate(
    //                                             value.toString())
    //                                         ? null
    //                                         : "Format harus dalam bentuk email";
    //                                   },
    //                                   decoration: InputDecoration(
    //                                     border: OutlineInputBorder(
    //                                       borderRadius:
    //                                           BorderRadius.circular(12),
    //                                       borderSide: BorderSide(
    //                                           color: Colors.blue, width: 5.0),
    //                                     ),
    //                                     enabledBorder: OutlineInputBorder(
    //                                         borderSide: BorderSide(
    //                                             color: Colors.blue,
    //                                             width: 3.0)),
    //                                     hintText: 'Email',
    //                                   ),
    //                                 ),
    //                               ],
    //                             ))),
    //                     SizedBox(
    //                       height: 32,
    //                     ),
    //                     Container(
    //                       width: 28,
    //                       // color: Colors.amber,
    //                       height: 46,
    //                       child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Container(
    //                               width: 160,
    //                               child: ElevatedButton(
    //                                   onPressed: (() async {
    //                                     if (_keyState.currentState!
    //                                         .validate()) {
    //                                       if (emailController.text == "") {
    //                                         Fluttertoast.showToast(
    //                                             msg:
    //                                                 "Mohon untuk mengisi email terlebih dahulu",
    //                                             toastLength: Toast.LENGTH_SHORT,
    //                                             gravity: ToastGravity.BOTTOM,
    //                                             timeInSecForIosWeb: 1,
    //                                             backgroundColor: Colors.red,
    //                                             textColor: Colors.white,
    //                                             fontSize: 16.0);
    //                                       } else {
    //                                         await EmailVerifyService.postEmail(
    //                                                 emailController.text)
    //                                             .then((value) {
    //                                           var results = json.decode(
    //                                               value.body.toString());
    //                                           print(results);
    //                                         });
    //                                         Fluttertoast.showToast(
    //                                             msg:
    //                                                 "${emailController.text} berhasil dikirim",
    //                                             toastLength: Toast.LENGTH_SHORT,
    //                                             gravity: ToastGravity.BOTTOM,
    //                                             timeInSecForIosWeb: 1,
    //                                             backgroundColor: Colors.green,
    //                                             textColor: Colors.white,
    //                                             fontSize: 16.0);
    //                                       }
    //                                     } else {
    //                                       Fluttertoast.showToast(
    //                                           msg:
    //                                               "Form tidak sesuai dengan format!",
    //                                           toastLength: Toast.LENGTH_SHORT,
    //                                           gravity: ToastGravity.BOTTOM,
    //                                           timeInSecForIosWeb: 1,
    //                                           backgroundColor: Colors.red,
    //                                           textColor: Colors.white,
    //                                           fontSize: 16.0);
    //                                     }
    //                                   }),
    //                                   child: Text("Kirim Email")),
    //                             )
    //                           ]),
    //                     ),
    //                   ],
    //                 ))
    //               ]),
    //             ),
    //           ));
    //         } else {
    //           return CongratsPage();
    //         }
    //       },
    //     );
    //   },
    // )
  }
}
