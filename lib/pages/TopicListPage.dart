
import 'package:flutter/material.dart';
import 'package:topick/constants/ColorConstants.dart';
import 'package:topick/topics/categories.dart';

import '../topics/recommendations.dart';
import '../topics/scenes.dart';

class TopicListPage extends StatelessWidget {
  const TopicListPage({Key? key, required this.selection, this.fromTopPage = false}) : super(key: key);
  const TopicListPage.noDescription({Key? key, required this.selection, this.fromTopPage = true}) : super(key: key);

  final Map<String, Object> selection;
  final bool fromTopPage;

  @override
  Widget build(BuildContext context) {
    final title = selection['category_name'] as List<String>;
    final snippet = selection['img_url_snippet'] as String;
    final imgUrl = 'assets/images/$snippet/${snippet}_background@2x.png';
    final appBar = AppBar(
      title: Text(title[0]),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            child: const Icon(Icons.shuffle),
            onTap: () => Navigator.of(context).pushNamed('/shuffle', arguments: _getTopicList()),
          ),
        )
      ],
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imgUrl),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter
              ),
            ),
          ),
          SafeArea(
              child: Column(
                children: [
                  _descriptionArea(),
                  Expanded(child: _listArea(),)
                ],
              )
          )
        ],
      ),
    );
  }

  Widget _descriptionArea() {
    final description1 = fromTopPage ? ['', ''] : selection['description1'] as List<String>;
    final description2 = fromTopPage ? ['', ''] : selection['description2'] as List<String>;
    return Visibility(
      visible: !fromTopPage,
      child: Center(
        child: Column(
            children: [
              Container(margin: const EdgeInsets.only(top: 20, bottom: 2), child: Text(description1[0], style: const TextStyle(color: Colors.white)),),
              Container(margin: const EdgeInsets.only(bottom: 6), child: Text(description2[0], style: const TextStyle(color: Colors.white)),)
            ]
        ),
      )
    );
  }

  Widget _listArea() {
    final topicList = _getTopicList();
    return ListView.builder(
        itemCount: topicList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index){
          return Container(
            margin: const EdgeInsets.only(top: 5, right: 3, bottom: 5, left: 3),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.7),
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              title: Text(topicList[index][0], textAlign: TextAlign.center,),
              trailing: IconButton(
                icon: const Icon(Icons.control_point, color: ColorConstants.subColor,),
                onPressed: () { print('someting'); },

              ),
              leading: const Text(''),
            ),
          );
    }
    );
  }

  String _firstCharacter(String snippet) {
    return snippet.substring(0, 1);
  }

  List<List<String>> _getTopicList() {
    Map<String, List<List<String>>> topics = {'': [['', ''], ['', '']]};
    switch (_firstCharacter(selection['img_url_snippet'] as String)) {
      case 'c':
        topics = Categories.topics;
        break;
      case 's':
        topics = Scenes.topics;
        break;
      case 'r':
        topics = Recommendations.topics;
        break;
    }
    return topics[(selection['category_id'] as int).toString()]!;
  }
}
