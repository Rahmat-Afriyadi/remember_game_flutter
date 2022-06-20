import 'package:flutter/material.dart';
import 'package:remember_game/model/histories.dart';
import 'package:remember_game/bloc/login_bloc.dart';
import 'package:remember_game/bloc/logout_bloc.dart';
import 'package:remember_game/bloc/histories_bloc.dart';
import 'package:remember_game/ui/level_page.dart';
import 'package:remember_game/ui/login_page.dart';
import 'package:remember_game/ui/rank_page.dart';
import 'package:remember_game/widgets/warning_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String nama = "";
  int score = 0;
  MyData? histories;
  String roleImage = "assets/banner.webp";

  List<DataRow> _createRows() {
    List<DataRow> data = <DataRow>[];
    int i = 1;
    histories!.results!.forEach((v) {
      data.add(DataRow(cells: [
        DataCell(Container(
            width: 105, //SET width
            child: Text('${v.tanggal}'))),
        DataCell(Text(
          '${v.level}',
          style: TextStyle(fontSize: 15),
        )),
        DataCell(Text(
          '${v.score}',
          style: TextStyle(fontSize: 15),
        )),
      ]));
      i += 1;
    });

    return data;
  }

  @override
  void get initState {
    startPage();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void startPage() {
    LoginBloc.me().then((value) async {
      setState(() {
        nama = value.nama != null ? value.nama.toString() : "";
        score = value.score != null ? value.score!.toInt() : 0;
        if (score <= 100) {
          roleImage = "assets/role/baby.png";
        } else if (score <= 200) {
          roleImage = "assets/role/teen.png";
        } else {
          roleImage = "assets/role/old.png";
        }
      });
    }, onError: (error) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Login gagal, silahkan coba lagi",
              ));
    });

    HistoryBloc.getHistories().then((value) async {
      setState(() {
        histories = value != null ? value : null;
      });
    }, onError: (error) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Login gagal, silahkan coba lagi",
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.purple[100], actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RankPage()));
            },
            child: Text("Rank"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ]
            // title: Text("Game Ketuk ketuk "),
            ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: const Text("Logout"),
                trailing: const Icon(Icons.logout, color: Colors.red),
                onTap: () async {
                  await LogoutBloc.logout().then((value) => {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()))
                      });
                },
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Row(              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                  height: 270,
                  width: 170,
                  child: Image(
                      fit: BoxFit.contain,
                      image: AssetImage(roleImage)
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.purple,
                      width: 3,
                    ),
                  )
                      // image: DecorationImage(
                      //     image: AssetImage(roleImage), fit: BoxFit.contain),
                      // borderRadius:
                      //     const BorderRadius.all(Radius.circular(10))),

                ),
                // SizedBox(width: 20),
                // Image.asset(roleImage,
                //   fit: BoxFit.contain, height: 270),
                const SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        "Nama",
                        style:
                            TextStyle(color: Colors.purple[300], fontSize: 17),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 1),
                    ),
                    Text(
                      "${nama}",
                      style: TextStyle(fontSize: 25, color: Colors.purple[300]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      // color: Colors.purple[100],
                      decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        "Score",
                        style:
                            TextStyle(color: Colors.purple[300], fontSize: 17),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 1),
                    ),
                    Text("${score}",
                        style:
                            TextStyle(fontSize: 25, color: Colors.purple[300])),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text('Play'),
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LevelPage()))
                            .then((value) => startPage());
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.greenAccent,
                          padding:
                              EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 300,
              height: 7,
              child: const DecoratedBox(
                decoration: const BoxDecoration(
                    color: Colors.purple,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
              ),
            ),
            SingleChildScrollView(
              child: 
            DataTable(
                columns: const [
                  DataColumn(
                      label: Text(
                    "Tanggal",
                    style: TextStyle(fontSize: 17, color: Colors.redAccent),
                  )),
                  DataColumn(
                      label: Text(
                    "Level",
                    style: TextStyle(fontSize: 17, color: Colors.redAccent),
                  )),
                  DataColumn(
                      label: Text(
                    "Score",
                    style: TextStyle(fontSize: 17, color: Colors.redAccent),
                  )),
                ],
                rows: histories != null
                    ? _createRows()
                    :
                    // _createRows()
                    [
                        DataRow(cells: [
                          DataCell(Text("tanggal")),
                          DataCell(Text("level")),
                          DataCell(Text("score")),
                        ])
                      ])
                      ,
            )
          ],
        )));
  }
}
