import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:remember_game/model/board_item_model.dart';
import 'package:remember_game/bloc/histories_bloc.dart';
import 'package:remember_game/widgets/board_item.dart';
import 'package:remember_game/widgets/success_dialog.dart';
import 'package:remember_game/widgets/warning_dialog.dart';

class LandingPage extends StatefulWidget {
  String? label;
  int? value;
  int? time;

  LandingPage({Key? key, this.label, this.value, this.time}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int? numberItem;
  int? main = 0;
  Timer? _timer;
  String labelLevel = "";

  int _start = 60;

  // 8 numberItem akan membuat 16 items (karena pair)

  int currentScore = 0;

  late String status;

  //berisi semua board item yang ada di puzzle
  List<BoardItemModel> boardPuzzle = [];

  //berisi board item yang dipilih, tetapi belum complete
  List<BoardItemModel> chosenItem = [];
  Timer timeDelayed = Timer(const Duration(seconds: 1), () => {});

  @override
  void get initState {
    numberItem = widget.value!;
    labelLevel = widget.label!;
    _start = widget.time!;
    setUpBoard();
    setState(() {
      status = "Ketuk Play untuk bermain";
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  static int? get value => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[100],
          // title: Text("Game Ketuk ketuk "),
          title: Row(
            children: [
              const Text("Remember game|"),
              const Text("Kelompok 2"),
              const SizedBox(width: 10),
              Image.asset('assets/question.webp',
                  fit: BoxFit.contain, height: 37),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //       image: DecorationImage(
            //           image: AssetImage("assets/banner.webp"),
            //           fit: BoxFit.fill)),
            // ),
            SingleChildScrollView(
              child: Container(
                // decoration: const BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/banner.webp"),
                //     fit: BoxFit.fitHeight,
                //   ),
                // ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          backgroundColor: Color.fromARGB(255, 166, 255, 212),
                          value: currentScore / ((widget.value! - 1) * 10),
                          minHeight: 24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 0, 225, 116)),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.only(left: 7),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  color: Color.fromARGB(255, 225, 190, 231)),
                              child: Text(
                                "Score : ",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Text(
                                "${double.parse((currentScore / (widget.value! - 1) * 10).toStringAsFixed(2))} %")
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 4),
                                padding: const EdgeInsets.only(left: 7),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                    color: Color.fromARGB(255, 225, 190, 231)),
                                child: Text("Time : ",
                                    style: TextStyle(color: Colors.white))),
                            Text(formatTime(_start))
                          ],
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        //       decoration: const BoxDecoration(
                        //         borderRadius: BorderRadius.all(Radius.circular(10)),
                        //         color: Colors.greenAccent
                        //       ),
                        //       child: Text(" Score: ${double.parse((currentScore / (widget.value! - 1) * 10).toStringAsFixed(2))} / 100% \t"),
                        //     ),
                        //     Container(
                        //       margin: EdgeInsets.only(left: 5),
                        //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        //       decoration: const BoxDecoration(
                        //         borderRadius: BorderRadius.all(Radius.circular(10)),
                        //         color: Colors.greenAccent
                        //       ),
                        //       child: Text(formatTime(_start))
                        //     )
                        //   ],
                        // ),
                        const SizedBox(height: 7),
                        GridView(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  mainAxisSpacing: 0.0,
                                  maxCrossAxisExtent: 100.0),
                          children: List.generate(boardPuzzle.length, (index) {
                            return BoardItem(
                              itemModel: boardPuzzle[index],
                              onTap: () {
                                if (main == 1) {
                                  onItemTap(index);
                                }
                              },
                            );
                          }),
                        ),
                        FlatButton(
                          child: const Text('Play',
                              style: TextStyle(color: Colors.white)),
                          color: Colors.purple[100],
                          onPressed: () => onPlay(),
                        ),
                        Text(
                          status,
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                ),
              ),
            )
          ],
        ));
  }

  String formatTime(int seconds) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes =
        twoDigits(Duration(seconds: seconds).inMinutes.remainder(60));
    String twoDigitSeconds =
        twoDigits(Duration(seconds: seconds).inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            main = 0;
            status = "";
            timer.cancel();
            _start = widget.time!;
          });
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => const WarningDialog(
                    description: "Anda gagal telah melewati batas",
                  ));
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void onItemTap(int index) {
    var selectedItem = boardPuzzle[index];
    if (!selectedItem.isCompleted && !selectedItem.isRevealed) {
      setState(() {
        selectedItem.setRevealed(true);
        //kalau lebih dari 2 kita tutup dulu yang lama
        closePreviousChosenItem();
        chosenItem.add(selectedItem);
        if (chosenItem.length == 2) {
          //jika 2 item telah dipilih
          if (chosenItem[0].imagePath == chosenItem[1].imagePath) {
            //saat complete
            onItemCompleted();
          } else {
            timeDelayed.cancel();
            timeDelayed = Timer(const Duration(seconds: 2), () {
              //tutup yang terbuka setelah 2 detik
              closePreviousChosenItem();
            });
            // and later, before the timer goes off...

          }
        }
      });
    }
  }

  void onItemCompleted() {
    if (chosenItem.length == 2) {
      setState(() {
        chosenItem[0].setCompleted(true);
        chosenItem[1].setCompleted(true);
        chosenItem.clear();

        //score
        currentScore += 10;
        if (currentScore == (numberItem! - 1) * 10) {
          onCompleted();
        }
      });
    }
  }

  void onCompleted() {
    HistoryBloc.addHistory(labelLevel, currentScore).then((value) async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const SuccessDialog(
                description: "Yey kamu menang, kamu hebat sekali mama bangga",
              ));
    }, onError: (error) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Ini error post history",
              ));
    });
    setState(() {
      status = "Selamat Permainan Selesai, Ketuk play untuk bermain lagi...";
      _timer!.cancel();
    });
  }

  void closePreviousChosenItem() {
    if (chosenItem.length == 2) {
      setState(() {
        chosenItem[0].setRevealed(false);
        chosenItem[1].setRevealed(false);
        chosenItem.clear();
      });
    }
  }

  void setUpBoard() {
    List<BoardItemModel> allItem = [];
    for (int x = 1; x < numberItem!; x++) {
      allItem.add(BoardItemModel(imagePath: "assets/$x.png"));
    }
    //clear choosenItem
    boardPuzzle = [];

    //Acak allItem, dan ambil numberItem teratas (misal 8 teratas)
    var randomItem = (allItem..shuffle()).take(numberItem!);

    //tambahkan 2x karena item nya berpasangan.
    boardPuzzle.addAll(randomItem);
    boardPuzzle.addAll(randomItem.map((item) => item.copy()).toList());
    setState(() {
      boardPuzzle.shuffle();
      currentScore = 0;
      status = "Temukan jodoh si gambar !";
    });
  }

  void onPlay() {
    setUpBoard();
    //reveal for first 3 sec
    // Timer(const Duration(seconds: 3), () {
    //   startTimer();
    // });
    for (var element in boardPuzzle) {
      setState(() {
        main = 1;
        element.isRevealed = true;
        status = "Ingat gambarnya dalam 3 detik...";
      });
    }

    timeDelayed.cancel();
    timeDelayed = Timer(const Duration(seconds: 3), () {
      for (var element in boardPuzzle) {
        setState(() {
          element.isRevealed = false;
          status = "Temukan pasangan gambar !";
        });
      }
      _start = widget.time!;
      startTimer();
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Timer>('timeDelayed', timeDelayed));
    properties.add(DiagnosticsProperty<Timer>('timeDelayed', timeDelayed));
  }
}
