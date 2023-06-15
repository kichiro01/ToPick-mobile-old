import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:topick/constants/ColorConstants.dart';
import 'package:http/http.dart' as http;

class CreateMyListModal extends StatefulWidget {
  const CreateMyListModal({Key? key}) : super(key: key);
  @override
  State<CreateMyListModal> createState() => _CreateMyListModalState();
}

class _CreateMyListModalState extends State<CreateMyListModal> {
  bool _isOn = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _createMyListModal(context);
  }

  Widget _createMyListModal(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SizedBox(
        height: screenSize.height * 0.95,
        child: Column(
          children: [
            Container(
              // 擬似ナビゲーションバー
              height: 56,
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
                            fontSize: 16)),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                  color: Colors.white,
                  child: Container(
                    // width: double.infinity,
                      margin: const EdgeInsets.all(16.0),
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
                                    children: [
                                      Image.asset('assets/images/mylist-theme/001.png', fit: BoxFit.fitWidth,),
                                      const Text('マイリストを追加',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: ColorConstants.subColor,
                                              fontSize: 16)),
                                    ],
                                  ),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Switch.adaptive(
                                      value: _isOn,
                                      onChanged: (bool value) {
                                        setState(() {
                                          print(_isOn);
                                          _isOn = value;
                                        });
                                      },
                                    )
                                  ]
                              )
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
}