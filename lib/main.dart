import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:remember_game/ui/profile_page.dart';
import 'package:remember_game/ui/login_page.dart';
import 'package:remember_game/helpers/user_info.dart';
import 'pages/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Lato',
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        home: MyHomePage(title: "Profile"));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int dropdownvalue = 1;
  Widget page = const CircularProgressIndicator();

  @override
  void get initState {
    isLogin();
  }

  void isLogin() async {
    var token = await UserInfo().getToken();
    if (token != null) {
      setState(() {
        page = const ProfilePage();
        widget.title = "Profile";
      });
    } else {
      setState(() {
        page = const LoginPage();
        widget.title = "Login";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.purple[100],
        //   title: Text(widget.title),
        // ),
        body: page
        );
  }
}

class Level extends StatelessWidget {
  final String label;
  final int value;
  final int time;
  const Level(
      {Key? key, required this.label, required this.value, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LandingPage(label: label, value: value, time: time)));
      },
      child: Card(
        child: ListTile(
          title: Text(
            label,
            style: TextStyle(color: Colors.purple[100]),
          ),
        ),
      ),
    );
  }
}
