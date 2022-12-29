part of 'apiservices.dart';

class EmailVerifyService {
  static Future<http.Response> postEmail(String email) {
    return http.post(
        Uri.https(Const.base_url, "/cirestapi/api/mahasiswa/sendmail"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "AFL2-CloudComp-KEY": "AFL2-CloudComp"
          // rijalu.aria@gmail.com
        },
        body: json.encode(<String, dynamic>{"email": email}));
  }
}



// static Future<http.Response> postEmail(String email) async {
//     var response = await http
//         .get(Uri.parse("https://" + Const.base_url + "/api/mahasiswa"));

//     print(response);

//     try {
//       if (response.statusCode == 200) {
//         return await http.post(
//             Uri.https(Const.base_url, "/cirestapi/api/mahasiswa"),
//             headers: <String, String>{
//               "Content-Type": "application/json; charset=UTF-8",
//             },
//             body: json.encode(<String, dynamic>{"email": email}));
//       } else {
//         throw Exception("Failed to load the data");
//       }
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }