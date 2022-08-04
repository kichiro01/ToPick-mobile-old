

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topick/codes/SelectionTypeCode.dart';

import '../constants.dart';
import '../main.dart';
import '../topics/categories.dart';
import '../topics/scenes.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({Key? key, required this.selectionType}) : super(key: key);
  final SelectionType selectionType;

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  // int _counter = 0;
  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.selectionType.getLabel(), style: const TextStyle(color: AppConstants.subColor, fontWeight: FontWeight.bold),),
          backgroundColor: AppConstants.baseColor,
          iconTheme: const IconThemeData(color: AppConstants.subColor),
        ),
        body: _body(context)
    );
  }

  Widget _body(BuildContext context) {
    final selectionInfo = widget.selectionType == SelectionType.category ? Categories.categories: Scenes.scenes;
    final name = widget.selectionType == SelectionType.category ? Categories.categories: Scenes.scenes;

    return Container(
        margin: const EdgeInsets.only(top: 46),
        child: Center(
          child: Column(
            children:  [
              Container(margin: const EdgeInsets.only(bottom: 11), child: const Text("一般", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),),
              Container(margin: const EdgeInsets.only(bottom: 2), child: const Text("一般的な話題を提供します。", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppConstants.darkGrey))),
              Container(margin: const EdgeInsets.only(bottom: 50), child: const Text("困った時はこれ！", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppConstants.darkGrey))),
              _selectionArea(context, selectionInfo)
            ],
          ),
        )
    );
  }

  Widget _selectionArea(BuildContext context, List<Map<String, Object>> selectionInfo) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 55 / 111,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: selectionInfo.length,
          itemBuilder: (context, index) {
            final snippet = selectionInfo[index]['img_url_snippet'] as String;
            final double marginLeft = index == 0 ? (screenSize.height / 12.8) : 0;
            final double marginRight = index == selectionInfo.length - 1 ? (screenSize.height / 12.8) : 0;
            return _selectionCards(snippet, marginLeft, marginRight);
          }),
      );
  }
  
  Widget _selectionCards(String snippet, double marginLeft, double marginRight) {
    var imgUrl = 'assets/images/$snippet/$snippet@2x.png';
    return Container(
      margin: EdgeInsets.only(left: marginLeft, right: marginRight),
      child: Image.asset(imgUrl, fit: BoxFit.fitHeight,),
    );
  }
}