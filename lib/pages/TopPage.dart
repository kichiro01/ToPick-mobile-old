import 'package:flutter/material.dart';
import 'package:topick/codes/SelectionTypeCode.dart';
import 'package:topick/constants/ColorConstants.dart';
import 'package:topick/topics/recommendations.dart';

import '../constants/Strings.dart';
import '../constants/StyleConstants.dart';

class TopPage extends StatelessWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Column(
            children: [
              _selectArea(context),
              _recommendationArea(context)
            ]),)
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
        child: Row(children: [
          Expanded(child: Text(Strings.PAGE_TITLE_SELECT_TOPIC, style: StyleConstants.PAGE_TITLE_TEXTSTYLE))
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
        child: ListTile(title: Text(selectionType.getLabel(), style: const TextStyle(fontSize: 18, color: ColorConstants.subColor),),
          onTap: () => {
            // context.read<AppState>().setSelectionType(selectionType),
            Navigator.of(context).pushNamed('/select', arguments: selectionType)
          },)
    );
  }

  // 「オススメ」話題集のエリア
  Widget _recommendationArea(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Expanded(child: Text(Strings.PAGE_TITLE_SELECT_TOPIC, style: StyleConstants.PAGE_TITLE_TEXTSTYLE))
        ],),
      ),
      _recommendCards(context)
    ],
    );
  }

  // 「オススメ話題集」のカードウィジェット
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
