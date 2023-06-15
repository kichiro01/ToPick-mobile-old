import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper({required this.url});

  final String url;

  Future<dynamic> getData() async {
    http.Response response;

    response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // 文字化けしないようにエンコードを明示的に指定
      String data = utf8.decode(response.bodyBytes);
      dynamic jsonObjects = jsonDecode(data);

      // TODO ローディングの確認のため意図的に入れいている待ち時間を削除する
      await new Future.delayed(Duration(seconds: 3));
      return jsonObjects;
    } else {
      print(response.statusCode);
    }
  }


}

