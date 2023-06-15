import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:topick/codes/SelectionTypeCode.dart';
import 'package:topick/pages/BasePage.dart';
import 'package:topick/pages/SelectPage.dart';
import 'package:topick/pages/ShufflePage.dart';
import 'package:topick/pages/TopicListPage.dart';

// TODO test用のproviderを削除する
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class AppState extends ChangeNotifier {
  SelectionType? _selectionType;

  SelectionType? get selectionType => _selectionType;

  void setSelectionType(SelectionType selectionType) {
    _selectionType = selectionType;
    notifyListeners();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);
    return MaterialApp(
        title: 'ToPick',
        theme: ThemeData(textTheme: GoogleFonts.notoSansJavaneseTextTheme(Theme.of(context).textTheme)),
        home: const BasePage(),
        routes: <String, WidgetBuilder> {
          '/select': (BuildContext context) => SelectPage(selectionType: ModalRoute.of(context)!.settings.arguments as SelectionType),
          '/topics': (BuildContext context) => TopicListPage(selection: ModalRoute.of(context)!.settings.arguments as Map<String, Object>),
          '/topics/?noDescription': (BuildContext context) => TopicListPage.noDescription(selection: ModalRoute.of(context)!.settings.arguments as Map<String, Object>),
          '/shuffle': (BuildContext context) => ShufflePage(topicList: ModalRoute.of(context)!.settings.arguments as List<List<String>>,),
        }
    );
  }
}