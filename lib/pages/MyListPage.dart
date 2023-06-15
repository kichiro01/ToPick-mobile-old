import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topick/constants/UriConstants.dart';

import '../constants/ColorConstants.dart';
import '../constants/Strings.dart';
import '../constants/StyleConstants.dart';
import '../helpers/NetworkHelper.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({Key? key}) : super(key: key);
  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  late int _userId;
  final key = "user_id";

  var _mylists;
  final mylistKey = "mylists";
  bool _isOn = true;

  //ローディング表示の状態
  bool visibleLoading = false;

  Future<List<dynamic>>? _retrievedMyLists;

  Future<List<dynamic>> _retrieveMyLists() async {
    List<dynamic> lists = [];
    NetworkHelper networkHelper = NetworkHelper(url: '${UriConstants.MYLIST_RETRIEVE_ALL}1');
    List<dynamic> data = await networkHelper.getData();
    for (var i = 0; i < data.length; i++) {
      lists.add(data[i]);
    }
    return lists;
  }

  void _getUserId() async {
    // SharedPreferencesオブジェクトの取得
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // 端末に保存されているuser_idを取得する。なければ-1とする。
      _userId = prefs.getInt(key) ?? -1;
    });
  }

  void _loadMyLists() async {
    // SharedPreferencesオブジェクトの取得
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // 端末に保存されているマイリストを取得する。なければ空の配列をローカル変数に代入。
      _mylists = prefs.getInt(mylistKey) ?? [];
    });
  }
    void _saveCount() async {
      // SharedPreferencesオブジェクトの取得
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        // 端末に保存する
        _userId = _userId + 1;
        prefs.setInt(key, _userId);
      });
    }

    void _deleteCounter() async {
      // SharedPreferencesオブジェクトの取得
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        // countの初期化と保存されているデータを削除
        _userId = 0;
        prefs.remove(key);
      });
    }

  // Future _retrieveMyLists() async{
  //   final uri = Uri.parse(UriConstants.MYLIST_RETRIEVE_ALL + _userId.toString());
  //   var response = await http.get(uri);
  //   if (response.statusCode == 200) {
  //     String data = response.body;
  //     dynamic jsonObjects = json.decode(data);
  //     return jsonObjects;
  //   } else {
  //     print(response.statusCode);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _loadMyLists();
    _retrievedMyLists = _retrieveMyLists();

    // _getUserId();
    // if (_userId != -1) {
    // //  マイリストを表示する。
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Column(
            children: [
              _myListArea(context),
              //OverlayLoadingMolecules(visible: visibleLoading)
            ]),)
    );
  }
  // マイリスト表示エリア
  Widget _myListArea(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(children: [
          Expanded(child: Text(Strings.PAGE_TITLE_MYLIST, style: StyleConstants.PAGE_TITLE_TEXTSTYLE))
        ],),
      ),
      // マイリストを追加するセル
      ListView(
        shrinkWrap : true,
        physics: const NeverScrollableScrollPhysics(),
        children:  [
          _addListTile(context)
        ],),
      // APIで取得したマイリストの一覧
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
            return ListView.builder(
              itemCount:  snapshot.data == null? 0 : snapshot.data.length,
              //itemCount: _mylists == null? 0 : _mylists.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                var themeType = snapshot.data![index]["theme_type"];
                return GestureDetector(
                    onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text('Tap $index'),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0, right: 0, bottom: 4.0, left: 0),
                  child: Row(
                    children: [

                      Container(
                        height: 80,
                        width: 80,
                        color: ColorConstants.baseColor,
                        child: Image.asset('assets/images/mylist-theme/$themeType.png', fit: BoxFit.fitWidth,),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(snapshot.data![index]["title"], style: const TextStyle(fontSize: 18, color: Colors.black),),
                      ),
                      if (snapshot.data![index]["is_private"]) const Icon(Icons.lock, color: Colors.grey,),
                    ],
                  ),
                )
                );
              }
            );
          } else {
            return const Text("データが存在しません");
          }
        },
      ),
    ],
    );
  }

  // マイリスト追加のセル
  Widget _addListTile(BuildContext context) {
    return InkWell(
      onTap: _showCreateMyListModal,
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0, right: 0, bottom: 4.0, left: 0),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              color: ColorConstants.baseColor,
              child: const Icon(Icons.add, size: 60, color: ColorConstants.subColor,),
            ),
            const SizedBox(width: 16.0),
            const Text("マイリストを追加", style: TextStyle(fontSize: 18, color: Colors.black),),
          ],
        ),
      )
    );
  }

  void _showCreateMyListModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return _createMyListModal(context, setModalState);
            })
    );
  }



  // 新規マイリスト作成のモーダルウィジェット
  // TODO ファイル分割検討  公開非公開のスイッチボタンの状態（_isOn）を親WidgetのStateに持たせているため外だしできていない。
  Widget _createMyListModal(BuildContext context, StateSetter setModalState) {
    var screenSize = MediaQuery.of(context).size;

    // 各種コンポーネントの高さの定数
    // 擬似ナビゲーションバーの高さ
    const double modalNavBarHeight = 56;
    // モーダルコンテンツ（擬似ナビバー以下の部分）の上下左右のマージン
    const double modalContentMargin = 16;
    // 作成するボタンの上側のマージン
    const double createButtonMarginTop = 32;
    // 作成するボタンの高さ
    const double createButtonHeight = 50;

    return SizedBox(
      // モーダルの高さは固定値で設定（380はテーマ画像、マイリスト名入力欄、公開ボタンの高さとマージンの合計）
        height: modalNavBarHeight + modalContentMargin + 380 + createButtonHeight + createButtonMarginTop,
        child: Column(
          children: [
            Container(
              // 擬似ナビゲーションバー
              height: modalNavBarHeight,
              decoration: const BoxDecoration(
                color: ColorConstants.baseColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Stack(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('キャンセル', style: TextStyle(fontWeight: FontWeight.normal, color: ColorConstants.subColor, fontSize: 14)),
                          ),
                          const SizedBox(
                            width: 6,
                          )
                        ]),
                  ),
                  const Center(
                    child: Text('マイリストを追加',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.subColor,
                            fontSize: 20)),
                  )
                ],
              ),
            ),
            // モーダルのコンテンツ
            Expanded(
              child: Container(
                  color: Colors.white,
                  child: Container(
                    // width: double.infinity,
                      margin: const EdgeInsets.all(modalContentMargin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Image.asset('assets/images/mylist-theme/001.png', fit: BoxFit.fitWidth,),
                                      Icon(Icons.image_rounded, color: Colors.grey, size: 50,)
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: screenSize.width*2/3,
                                      child: const TextField(
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.black, fontSize: 19),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'マイリスト名',
                                          hintStyle: TextStyle(color: Colors.grey, fontSize: 19),
                                        ),
                                      ),
                                    )
                                  ]
                              )
                            ],
                          ),
                          Row(
                            // 公開/非公開スイッチボタン
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                // スイッチボタン
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Switch.adaptive(
                                      value: _isOn,
                                      onChanged: (bool value) {
                                        setModalState(() {
                                          _isOn = value;
                                        });
                                      },
                                    )
                                  ]
                              ),
                              // マイリストを公開
                              const Text('マイリストを公開', style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16)),
                              // ヘルプボタン
                              Container(
                                margin: const EdgeInsets.only(left: 6),
                                child: const Tooltip(
                                    message: '公開をオンにしたマイリストは、「見つける」機能で他のユーザーが閲覧可能になります。',
                                    padding: EdgeInsets.all(10), //吹き出しのpadding
                                    margin: EdgeInsets.all(10), //吹き出しのmargin
                                    verticalOffset: 20, //childのwidgetから垂直方向にどれだけ離すか
                                    preferBelow: true, //メッセージを子widgetの上に出すか下に出すか
                                    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white), //メッセージの文字スタイル
                                    triggerMode: TooltipTriggerMode.tap,
                                    child: Icon(Icons.help, color: Colors.grey)
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 32),
                          // 作成するボタン
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: _createMyList,
                                style: TextButton.styleFrom(
                                    fixedSize: Size(screenSize.width - 32, createButtonHeight),
                                    backgroundColor: ColorConstants.baseColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    )),
                                child: const Text(
                                  '作成する',
                                  style: TextStyle(
                                      color: ColorConstants.subColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                  )
              ),
            )
          ],
        )
    );
  }

  // マイリスト作成API呼び出し
  void _createMyList() {
    // 成功したらモーダルを閉じる
    return;
  }
}