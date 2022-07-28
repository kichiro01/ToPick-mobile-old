import 'package:flutter/material.dart';
import 'package:topick/constants.dart';
import 'package:topick/topics/recommendations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToPick',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'ToPick Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/header-parts/header.png', height: 50),
        backgroundColor: AppConstants.baseColor,
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Column(
            children: [
              _selectArea(),
              _recommendationArea()
            ]),)
      )
    );
  }

  //　「話題を選ぶ」のエリア
  Widget _selectArea() {
    return Container(
      child: Column(children: [
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
            _listTile("カテゴリー"),
            _listTile("シーン")
        ],)
      ],
      ),
    );
  }
  // 「話題を選ぶ」のリストウィジェット
  Widget _listTile(title) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: Color(0xFFC8C7CC)))
        ),
        // padding: const EdgeInsets.only(bottom: 10.0),
        child: ListTile(title: Text(title))
    );
  }

  // 「オススメ」話題週のエリア
  Widget _recommendationArea() {

    return Container(
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Row(children: const [
            Expanded(child: Text("オススメ話題集", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)))
          ],),
        ),
        _recommendCards()
      ],
      ),
    );
  }

  // 「オススメ話題週」のカードウィジェット
  Widget _recommendCards() {
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Image.asset(imgUrl, fit: BoxFit.fitWidth,),
            ),
            Text(titleList[0], style: const TextStyle(fontSize: 12))
          ]
        );
      }),
    );
  }
}
