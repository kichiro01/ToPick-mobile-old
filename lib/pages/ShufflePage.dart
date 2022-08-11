

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:topick/codes/SelectionTypeCode.dart';

import '../constants.dart';
import '../topics/categories.dart';
import '../topics/scenes.dart';

class ShufflePage extends StatefulWidget {
  const ShufflePage({Key? key, required this.topicList}) : super(key: key);
  final List<List<String>> topicList ;

  @override
  State<ShufflePage> createState() => _ShufflePageState();
}

class _ShufflePageState extends State<ShufflePage> {
  bool _isStop = false;
  String _selectedTopic = '';

  void _setTopic(int index) {
    setState(() {
      _selectedTopic = widget.topicList[index][0];
    });
  }
  void _setShuffleState(bool state) {
    setState(() {
      _isStop = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _screenSize = MediaQuery.of(context).size;
    // _cardHeight = _screenSize!.height * 55 / 111;

    return Scaffold(
        appBar: AppBar(
          title: Text('シャッフル', style: const TextStyle(color: AppConstants.subColor, fontWeight: FontWeight.bold),),
          backgroundColor: AppConstants.baseColor,
          iconTheme: const IconThemeData(color: AppConstants.subColor),
        ),
        body: _body(context)
    );
  }

  Widget _body(BuildContext context) {
    final buttonImageUrl = _isStop ? 'assets/images/shuffle/button_stop.png' : 'assets/images/shuffle/button_shuffle.png';
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Stack(
              children: [
                Text(_selectedTopic)
              ],
            ),
            GestureDetector(
              onTap: () => _setShuffleState(!_isStop),
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    color: AppConstants.baseColor,
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Image.asset(buttonImageUrl),
              ),
            )
          ],
        ),
      ),
    );
  }
}