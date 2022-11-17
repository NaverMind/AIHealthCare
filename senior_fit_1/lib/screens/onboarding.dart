import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:senior_fit_1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late FocusNode myFocusNode;
  late SharedPreferences prefs;
  String strName = 'ex) 홍길동';
  String strSex = 'ex) 여';
  String strBirth = 'ex) 65';
  String strHeigth = 'ex) 160';
  String strWeigth = 'ex) 60';

  late bool cmpName;
  late bool cmpSex;
  late bool cmpBirth;
  late bool cmpHeight;
  late bool cmpWeight;

  Future<void> initPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initPref();
    cmpName = false;
    cmpSex = false;
    cmpBirth = false;
    cmpHeight = false;
    cmpWeight = false;

    myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final cntrName = TextEditingController();
    final cntrSex = TextEditingController();
    final cntrBirth = TextEditingController();
    final cntrHeight = TextEditingController();
    final cntrWeight = TextEditingController();

    return IntroductionScreen(
      pages: [
        PageViewModel(
          // 이름
          titleWidget: Text(
            '이름을 입력해주세요.',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          bodyWidget: cmpName
              ? Text(
                  '입력완료',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.deepPurpleAccent,
                  ),
                )
              : TextField(
                  textInputAction: TextInputAction.next,
                  controller: cntrName,
                  onSubmitted: (text) {
                    setState(() {
                      prefs.setString('name', text);
                      cmpName = true;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: strName,
                  ),
                ),

          image: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Image.asset('images/senior_fit_intro_logo1.png'),
              ],
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          //성별
          titleWidget: Text(
            '성별을 선택해주세요.',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          bodyWidget: cmpSex
              ? Text(
            '입력완료',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: Colors.deepPurpleAccent,
            ),
          )
              : TextField(
            textInputAction: TextInputAction.next,
            controller: cntrSex,
            onSubmitted: (text) {
              setState(() {
                prefs.setString('sex', text);
                cmpSex = true;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: strSex,
            ),
          ),
          image: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Image.asset('images/senior_fit_intro_logo2.png'),
              ],
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          // 나이
          titleWidget: Text(
            '나이를 입력해주세요.',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          bodyWidget: cmpBirth
              ? Text(
            '입력완료',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: Colors.deepPurpleAccent,
            ),
          )
              : TextField(
            textInputAction: TextInputAction.next,
            controller: cntrBirth,
            onSubmitted: (text) {
              setState(() {
                prefs.setString('birth', text);
                cmpBirth = true;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: strBirth,
            ),
          ),
          image: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Image.asset('images/senior_fit_intro_logo3.png'),
              ],
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          // 키
          titleWidget: Text(
            '키를 입력해주세요.(cm)',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          bodyWidget: cmpHeight
              ? Text(
            '입력완료',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: Colors.deepPurpleAccent,
            ),
          )
              : TextField(
            textInputAction: TextInputAction.next,
            controller: cntrHeight,
            onSubmitted: (text) {
              setState(() {
                prefs.setString('height', text);
                cmpHeight = true;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: strHeigth,
            ),
          ),
          image: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Image.asset('images/senior_fit_intro_logo4.png'),
              ],
            ),
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          // 몸무게
          titleWidget: Text(
            '몸무게를 입력해주세요.(kg)',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          bodyWidget: cmpWeight
              ? Text(
            '입력완료',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: Colors.deepPurpleAccent,
            ),
          )
              : TextField(
            textInputAction: TextInputAction.next,
            controller: cntrWeight,
            onSubmitted: (text) {
              setState(() {
                prefs.setString('weight', text);
                cmpWeight = true;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: strWeigth,
            ),
          ),
          image: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Image.asset('images/senior_fit_intro_logo5.png'),
              ],
            ),
          ),
          decoration: getPageDecoration(),
        ),
      ],
      done: const Text('done'),
      onDone: () {
        prefs.setBool('visited', true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyHomePage()));
      },
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.deepPurple,
      ),
      showSkipButton: true,
      skip: const Text(
        'skip',
        style: TextStyle(color: Colors.deepPurple),
      ),
      dotsDecorator: DotsDecorator(
        color: Colors.grey,
        size: const Size(10, 10),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        activeColor: Colors.deepPurple,
      ),
      curve: Curves.bounceOut,
    );
  }


  PageDecoration getPageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.deepPurple,
      ),
      imagePadding: EdgeInsets.only(top: 40),
      pageColor: Colors.white,
      titlePadding: EdgeInsets.only(top: 0.0, bottom: 24.0),
    );
  }
}
