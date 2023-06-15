import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:topick/dialogs/LastTopicDialog.dart';
import '../constants/ColorConstants.dart';

class ShufflePage extends StatefulWidget {
  const ShufflePage({Key? key, required this.topicList}) : super(key: key);
  final List<List<String>> topicList ;

  @override
  State<ShufflePage> createState() => _ShufflePageState();
}

class _ShufflePageState extends State<ShufflePage> {
  bool _isStop = false;
  int _topicIndex = 0;
  String _selectedTopic = '';
  late Timer _timer;
  late List<List<String>> remainTopics;

  @override
  void initState() {

    super.initState();
    remainTopics = List.from(widget.topicList);
    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) => _shuffle());
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  void _setTopic(int index) {
    setState(() {
      _topicIndex = index;
      _selectedTopic = remainTopics[_topicIndex][0];
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
          title: Text('シャッフル', style: const TextStyle(color: ColorConstants.subColor, fontWeight: FontWeight.bold),),
          backgroundColor: ColorConstants.baseColor,
          iconTheme: const IconThemeData(color: ColorConstants.subColor),
        ),
        body: _body(context),
        backgroundColor: ColorConstants.baseColor
    );
  }

  Widget _body(BuildContext context) {
    final buttonImageUrl = _isStop ? 'assets/images/shuffle/button_shuffle.png' : 'assets/images/shuffle/button_stop.png';
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Container(
              height: 150,
              margin: const EdgeInsets.only(right: 10, left: 10),
              decoration: BoxDecoration(
                  border:Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                        offset: Offset(10, 10)
                    )
                  ],
                  color: ColorConstants.baseColor
              ),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border:Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                ),
                child: Text(_selectedTopic),
              ),
            ),
            GestureDetector(
              onTap: () => _mngShuffle(),
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    color: ColorConstants.baseColor,
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

  void _mngShuffle() {
    if (_isStop) {
      if (remainTopics.length == 1) {
        // ダイアログを表示する。
        showDialog<int>(
            context: context,
            builder: (_) {
              return const LastTopicDialog();
            }).then((result) => {
              if (result == 1) {
                Navigator.of(context).pop()
              }
        });
        // shuffleStateは変えない
        return;
      } else if (remainTopics.length == 2) {
        remainTopics.removeAt(_topicIndex);
        _shuffle();
      } else if ( remainTopics.length > 2) {
        // シャッフルする
        remainTopics.removeAt(_topicIndex);
        _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) => _shuffle());
      }
    } else if (_timer.isActive) {
    //  ストップする
      _timer.cancel();
    }
    _setShuffleState(!_isStop);
  }

  void _shuffle() {
    if (remainTopics.isNotEmpty) {
      // 次のトピックを表示
      var topicIndex = math.Random().nextInt(remainTopics.length);
      _setTopic(topicIndex);
    }
  }
}