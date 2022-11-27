import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:senior_fit_1/screens/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:senior_fit_1/screens/home_list.dart';
import 'package:senior_fit_1/screens/note.dart';
import 'package:senior_fit_1/screens/mypage.dart';

import 'database/drift_database.dart';
// App에 넣음
// ch-appui test
late SharedPreferences prefs;
late final database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = LocalDatabase();
  prefs = await SharedPreferences.getInstance();
  // await prefs.clear(); // for test
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool visited = prefs.getBool('visited') ?? false;
    return MaterialApp(
      home: visited ? const MyHomePage() : const OnBoardingPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPos = 1;

  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of([
    TabItem(
      Icons.sticky_note_2_rounded,
      "운동노트",
      Colors.blue,
      labelStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.home,
      "홈",
      Colors.purple,
      labelStyle: const TextStyle(
        color: Colors.purple,
        fontWeight: FontWeight.bold,
      ),
    ),
    TabItem(
      Icons.account_box,
      "마이페이지",
      Colors.red,
      labelStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  ]);

  late CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            child: bodyContainer(),
            padding: EdgeInsets.only(bottom: bottomNavBarHeight),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    Color? selectedColor = tabItems[selectedPos].circleColor;
    String slogan;
    switch (selectedPos) {
      case 0:
        return const Note();
      case 1:
        return const Homelist();
      case 2:
        return const MyPage();
      default:
        return const Center(child: Text('Error'));
    }

  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      backgroundBoxShadow: <BoxShadow>[
        const BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: const Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;
          print(_navigationController.value);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}