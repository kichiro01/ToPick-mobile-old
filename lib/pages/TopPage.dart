import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:topick/codes/SelectionTypeCode.dart';
import 'package:topick/constants.dart';
import 'package:topick/pages/SelectPage.dart';
import 'package:topick/pages/TopPage.dart';
import 'package:topick/topics/recommendations.dart';

import '../main.dart';

class TopPage extends StatelessWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/header-parts/header.png', height: 50),
          backgroundColor: AppConstants.baseColor,
        ),
        body: Container(
            margin: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(child: Column(
                children: [
                  _selectArea(context),
                  _recommendationArea(context)
                ]),)
        )
    );
  }

  //　「話題を選ぶ」のエリア
  Widget _selectArea(BuildContext context) {
    return Column(children: [
      Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFC8C7CC)))
        ),
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(children: const [
          Expanded(child: Text("話題を選ぶ", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)))
        ],),
      ),
      ListView(
        shrinkWrap : true,
        physics: const NeverScrollableScrollPhysics(),
        children:  [
          _listTile(context, SelectionType.category),
          _listTile(context, SelectionType.scene)
        ],)
    ],
    );
  }
  // 「話題を選ぶ」のリストウィジェット
  Widget _listTile(BuildContext context, SelectionType selectionType) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFC8C7CC)))
        ),
        // padding: const EdgeInsets.only(bottom: 10.0),
        child: ListTile(title: Text(selectionType.getLabel(), style: const TextStyle(fontSize: 18, color: AppConstants.subColor),),
          onTap: () => {
            // context.read<AppState>().setSelectionType(selectionType),
            Navigator.of(context).pushNamed('/select', arguments: selectionType)
          },)
    );
  }

  // 「オススメ」話題週のエリア
  Widget _recommendationArea(BuildContext context) {

    return Column(children: [
      Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Row(children: const [
          Expanded(child: Text("オススメ話題集", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)))
        ],),
      ),
      _recommendCards(context)
    ],
    );
  }

  // 「オススメ話題週」のカードウィジェット
  Widget _recommendCards(BuildContext context) {
    const recommendations = Recommendations.recommendations;
    return GridView.count(
      // padding: const EdgeInsets.all(4.0),
      crossAxisCount: 2,
      crossAxisSpacing: 10.0, // 縦
      mainAxisSpacing: 10.0, // 横
      childAspectRatio: 0.9, // 高さ
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      children: List.generate(recommendations.length, (index) {
        var titleList = recommendations[index]["category_name"] as List<String>;
        var imgUrlSnippet = recommendations[index]['img_url_snippet'] as String;
        var imgUrl = 'assets/images/$imgUrlSnippet/$imgUrlSnippet.png';
        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/topics/?noDescription', arguments: recommendations[index]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Image.asset(imgUrl, fit: BoxFit.fitWidth,),
              ),
              Text(titleList[0], style: const TextStyle(fontSize: 12))
            ]
          )
        );
      }),
    );
  }
}
