import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:topick/codes/SelectionTypeCode.dart';
import 'package:topick/constants.dart';
import 'package:topick/pages/SelectPage.dart';
import 'package:topick/pages/ShufflePage.dart';
import 'package:topick/pages/TopPage.dart';
import 'package:topick/pages/TopicListPage.dart';
import 'package:topick/topics/recommendations.dart';

void main() {
  runApp(const MyApp());
}

class AppState extends ChangeNotifier {
  SelectionType? _selectionType;

  SelectionType? get selectionType => _selectionType;

  void setSelectionType(SelectionType selectionType) {
    _selectionType = selectionType;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (context) => AppState(),)
      ],
      child: MaterialApp(
        title: 'ToPick',
        theme: ThemeData(textTheme: GoogleFonts.notoSansJavaneseTextTheme(Theme.of(context).textTheme)),
        home: const TopPage(),
        routes: <String, WidgetBuilder> {
          '/select': (BuildContext context) => SelectPage(selectionType: ModalRoute.of(context)!.settings.arguments as SelectionType),
          '/topics': (BuildContext context) => TopicListPage(selection: ModalRoute.of(context)!.settings.arguments as Map<String, Object>),
          '/topics/?noDescription': (BuildContext context) => TopicListPage.noDescription(selection: ModalRoute.of(context)!.settings.arguments as Map<String, Object>),
          '/shuffle': (BuildContext context) => ShufflePage(topicList: ModalRoute.of(context)!.settings.arguments as List<List<String>>,),
        }
      )
    );
  }
}