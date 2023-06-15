import 'package:flutter/material.dart';

import '../constants/ColorConstants.dart';
import '../constants/Strings.dart';
import '../constants/StyleConstants.dart';
import '../constants/UriConstants.dart';
import '../helpers/NetworkHelper.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({Key? key}) : super(key: key);
  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {

  Future<List<dynamic>>? _retrievedMyLists;

  @override
  void initState() {
    super.initState();
    _retrievedMyLists = _retrieveMyLists();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<dynamic>> _retrieveMyLists() async {
    List<dynamic> lists = [];
    NetworkHelper networkHelper = NetworkHelper(url: UriConstants.BROWSE_RETRIEVE_ALL);
    List<dynamic> data = await networkHelper.getData();
    for (var i = 0; i < data.length; i++) {
      lists.add(data[i]);
    }
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Column(
            children: [
              _titleArea(context),
              _recommendationArea(context)
            ]),)
    );
  }
  // タイトル表示
  Widget _titleArea(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(children: [
          Expanded(child: Text(Strings.PAGE_TITLE_BROWSE, style: StyleConstants.PAGE_TITLE_TEXTSTYLE))
        ],),
      ),
      const Text(Strings.SUB_TITLE_BROWSE, style: TextStyle(fontSize: 16)),
      const SizedBox(height: 8),
    ],
    );
  }
  // 「オススメ」話題週のエリア
  Widget _recommendationArea(BuildContext context) {
    return Column(children: [
      // APIで取得した公開マイリストの一覧
      FutureBuilder<List<dynamic>>(
        future: _retrievedMyLists,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: ColorConstants.baseColor,),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            return _recommendCards(context, snapshot);
          } else {
            return const Text("データが存在しません");
          }
        },
      ),
    ],
    );
  }

  // 「オススメ話題集」のカードウィジェット
  Widget _recommendCards(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.count(
      // padding: const EdgeInsets.all(4.0),
      crossAxisCount: 2,
      crossAxisSpacing: 10.0, // 縦
      mainAxisSpacing: 10.0, // 横
      childAspectRatio: 0.9, // 高さ
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      children: List.generate(snapshot.data == null? 0 : snapshot.data.length, (index) {
        var themeType = snapshot.data![index]["theme_type"];
        var imgUrl = 'assets/images/mylist-theme/$themeType.png';
        return GestureDetector(
            //onTap: () => Navigator.of(context).pushNamed('/topics/?noDescription', arguments: recommendations[index]),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset(imgUrl, fit: BoxFit.fitWidth,),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Container(
                      padding: new EdgeInsets.only(right: 10.0),
                      child: Text(
                        snapshot.data![index]["title"],
                        style: const TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ),
                  ),
                ]
            )
        );
      }),
    );
  }
}