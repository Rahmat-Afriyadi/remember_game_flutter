import 'package:flutter/material.dart';
import 'package:remember_game/bloc/histories_bloc.dart';
import 'package:remember_game/model/rank.dart';
import 'package:remember_game/widgets/warning_dialog.dart';

class RankPage extends StatefulWidget {
  const RankPage({Key? key}) : super(key: key);

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  RankData? rank;

  @override
  void get initState {
    startPage();
  }

  List<DataRow> _createRows() {
    List<DataRow> data = <DataRow>[];
    int i = 1;
    rank!.results!.forEach((v) {
      data.add(DataRow(cells: [
        DataCell(Container(child: Text('${i}'))),
        DataCell(Text(
          '${v.nama}',
          style: TextStyle(fontSize: 17),
        )),
        DataCell(Text(
          '${v.score}',
          style: TextStyle(fontSize: 17),
        )),
      ]));
      i += 1;
    });
    return data;
  }

  void startPage() {
    HistoryBloc.getRank().then((value) async {
      setState(() {
        rank = value != null ? value : null;
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
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        // title: Text("Game Ketuk ketuk "),
      ),
      body: SingleChildScrollView(
          child: Center(
              child: DataTable(
                  columns: const [
            DataColumn(
                label: Text(
              "id",
              style: TextStyle(fontSize: 20, color: Colors.redAccent),
            )),
            DataColumn(
                label: Text(
              "Nama",
              style: TextStyle(fontSize: 20, color: Colors.redAccent),
            )),
            DataColumn(
                label: Text(
              "Score",
              style: TextStyle(fontSize: 20, color: Colors.redAccent),
            )),
          ],
                  rows: rank != null
                      ? _createRows()
                      : [
                          DataRow(cells: [
                            DataCell(Text("1")),
                            DataCell(Container(
                                width: 150, //SET width
                                child: Text('text'))),
                            DataCell(Text("1000000000")),
                          ])
                        ]))),
    );
  }
}
