import 'package:flutter/material.dart';
import 'package:remember_game/pages/landing_page.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({ Key? key }) : super(key: key);

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text("Level "),
      ),
      body: ListView(
        children: [
            Level(label: "EASY", value: 8, time: 90),
            Level(label: "MEDIUM", value: 11, time:100),
            Level(label: "HARD", value: 15, time:180),
        ],
      )  
    );
  }
}


class Level extends StatelessWidget {
  final String label ;
  final int value ;
  final int time ;
  const Level({Key? key, required this.label, required this.value, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LandingPage(
                      label: label,
                      value: value,
                      time: time
                    )));
      },
      child: Card(
        child: ListTile(
          title: Text(label, style: TextStyle(color: Colors.purple[100]),),
        ),
      ),
    );
  }
}