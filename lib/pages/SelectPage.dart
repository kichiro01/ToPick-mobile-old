

import 'package:carousel_slider/carousel_slider.dart';
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
  List<Map<String, Object>>? _selectionInfo;
  int _spotNum = 0;
  Size? _screenSize;
  double? _cardHeight;
  double _largeFlickVelocityThreshold = 1600.0;
  double _minimumFlickVelocityThreshold = 1000.0;

  void _setSpotNum(int num) {
    setState(() {
      _spotNum = num;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _cardHeight = _screenSize!.height * 55 / 111;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.selectionType.getLabel(), style: const TextStyle(color: AppConstants.subColor, fontWeight: FontWeight.bold),),
          backgroundColor: AppConstants.baseColor,
          iconTheme: const IconThemeData(color: AppConstants.subColor),
        ),
        body: _body()
    );
  }

  Widget _body() {
    _selectionInfo = widget.selectionType == SelectionType.category ? Categories.categories: Scenes.scenes;

    return Container(
        margin: const EdgeInsets.only(top: 46),
        child: Center(
          child: Column(
            children:  [
              Container(margin: const EdgeInsets.only(bottom: 11), child: Text((_selectionInfo![_spotNum]['category_name'] as List<String>)[0], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),),
              Container(margin: const EdgeInsets.only(bottom: 2), child: Text((_selectionInfo![_spotNum]['description1'] as List<String>)[0], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppConstants.darkGrey))),
              Container(margin: const EdgeInsets.only(bottom: 50), child: Text((_selectionInfo![_spotNum]['description2'] as List<String>)[0], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppConstants.darkGrey))),
              _selectionArea()
            ],
          ),
        )
    );
  }

  Widget _selectionArea() {
    return CarouselSlider(
        items:  _selectionInfo!.map((value) {
          return Builder(
            builder: (BuildContext context) {
              return _selectionCards(value);
            },
          );
        }).toList(),
        options: CarouselOptions(
          height: _cardHeight!,
          initialPage: 0,
          autoPlay: false,
          onPageChanged:(index, reason) => _setSpotNum(index),
          viewportFraction: 0.6,
          enableInfiniteScroll: false,
          reverse: false,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
    );
  }

  Widget _selectionCards(Map<String, Object> selection) {
    final snippet = selection['img_url_snippet'] as String;
    var imgUrl = 'assets/images/$snippet/$snippet@2x.png';
    return GestureDetector(
      onTap: () => print(selection['category_id']),
      child: Image.asset(imgUrl, fit: BoxFit.fitHeight,),
    );
  }
}