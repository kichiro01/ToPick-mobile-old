import 'package:flutter/material.dart';

class LastTopicDialog extends StatelessWidget {
  const LastTopicDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('最後のトピックです。'),
      content: Text('話題一覧に戻りますか？'),
      actions: <Widget>[
        GestureDetector(
          child: Text('いいえ'),
          onTap: () {
            Navigator.pop(context, 0);
          },
        ),
        GestureDetector(
          child: Text('はい'),
          onTap: () {
            Navigator.pop(context, 1);
          },
        )
      ],
    );
  }
}