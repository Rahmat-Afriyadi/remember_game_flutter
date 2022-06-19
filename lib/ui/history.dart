import 'package:flutter/material.dart';


class HistoryPlay extends StatefulWidget {
  const HistoryPlay({ Key? key }) : super(key: key);

  @override
  State<HistoryPlay> createState() => _HistoryPlayState();
}

class _HistoryPlayState extends State<HistoryPlay> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          DataTable(
            columns: [
              DataColumn(label: Text("Tanggal", style: TextStyle(fontSize: 20, color: Colors.redAccent),)),
              DataColumn(label: Text("Level", style: TextStyle(fontSize: 20, color: Colors.redAccent),)),
              DataColumn(label: Text("Score", style: TextStyle(fontSize: 20, color: Colors.redAccent),)),
            ], 
            rows: [
              DataRow(cells: [
                DataCell(Text("tanggal")),
                DataCell(Text("level")),
                DataCell(Text("score")),
              ]),
              DataRow(cells: [
                DataCell(Text("tanggal1")),
                DataCell(Text("level1")),
                DataCell(Text("score1")),
              ]),
            ]
          )
        ],
      );
  }
}