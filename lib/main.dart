import "package:flutter/material.dart";
import 'dart:math';
import 'package:number_puzzle/shake_view.dart';


void main() {
  runApp(MaterialApp(
    home: NumberPuzzle(),
    debugShowCheckedModeBanner: false,
  ));
}
class NumberPuzzle extends StatefulWidget {
  @override
  NumberPuzzleState createState() => NumberPuzzleState();
}
class NumberPuzzleState extends State<NumberPuzzle> with SingleTickerProviderStateMixin {

  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0];
  List<int> rand = [];
  int max = 16;
  int counter = 0;
  ShakeController _shakeController;
  bool _isDragging = false;


  @override
  void initState() {
    _shakeController = ShakeController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    randomList();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: 510,
              height: 550,

              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: <Widget>[
                  for (var i = 0; i < rand.length; i++)
                    tiles(rand[i])

                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.0, 0.7),
            child: Container(
              width: 250,
              height: 100,
              child: RaisedButton(
                color: Colors.indigo,
                onPressed: () {
                  rand.clear();
                  _shakeController.shake();
                  setState(() {
                    randomList();
                    counter = 0;
                  });
                },
                child: Text(
                  "Click to Shuffle!",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.0, 0.8),
            child: Container(
              child: Text('$counter Moves ${reamainingTiles()} Tiles Matched',
                style: TextStyle(fontSize: 30),),
            ),
          ),

        ],
      ),
    );
  }

  Widget tiles(int i) {
    bool isZero = i == 0;
    return GestureDetector(
      onVerticalDragUpdate: (detail) {
        if (detail.delta.distance == 0 || _isDragging) {
          return;
        }
        _isDragging = true;
        if (detail.delta.direction > 0) {
          moveDown(i);
        } else {
          moveUp(i);
        }
      },
      onVerticalDragEnd: (detail) {
        _isDragging = false;
      },
      onVerticalDragCancel: () {
        _isDragging = false;
      },
      onHorizontalDragUpdate: (detail) {
        if (detail.delta.distance == 0 || _isDragging) {
          return;
        }
        _isDragging = true;
        if (detail.delta.direction > 0) {
          moveLeft(i);
        } else {
          moveRight(i);
        }
      },
      onHorizontalDragDown: (detail) {
        _isDragging = false;
      },
      onHorizontalDragCancel: () {
        _isDragging = false;
      },

      child: ShakeView(
        controller: _shakeController,
        child: Container(

          width: 125,
          height: 100,
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(

            color: isZero ? Colors.white : Color(0xff000080),
            border: Border.all(width: 2.0),
          ),
          child: Center(
            child: Text(
              '$i',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),

      ),
    );
  }

  void randomList() {
    //To Create a Random List
    Random rnd = new Random();
    int num = rnd.nextInt(max);
    if (rand.length == numbers.length) {
      return;
    }
    if (rand.contains(num)) {
      randomList();
    } else {
      rand.add(num);
    }
    if (rand.length < numbers.length) {
      randomList();
    }
  }

  bool check() {
    int temp = 0;
    for (var i = 0; i < numbers.length; i++) {
      if (rand[i] == numbers[i])
        temp++;
    }
    bool checkWon = temp == numbers.length ? true : false;
    return checkWon;
  }

  Widget won() {
    return AlertDialog(
      title: Text("You Won"),
      content: Text('Play Again?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            rand.clear();
            setState(() {
              randomList();
            });
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],

    );
  }



  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  int reamainingTiles() {
    var num = 0;
    for (var i = 0; i < rand.length; i++) {
      if (rand[i] == numbers[i]) {
        num++;
      }
    }
    return num;
  }


  void moveDown(int i) {
    int clickPosition=rand.indexOf(i);
    int zeroPosition=rand.indexOf(0);
    if((clickPosition+4)==zeroPosition)
      {
        setState(() {
          rand[clickPosition]=0;
          rand[zeroPosition]=i;
          counter++;
        });
      }
    if(check())
    {
      //Text("You Won",style: TextStyle(fontSize: 40,color: Colors.black),);
      won();
      showDialog(context: context,
          builder: (context)=>won(),barrierDismissible: false
      );
    }

  }
  void moveUp(int i) {
    int clickPosition=rand.indexOf(i);
    int zeroPosition=rand.indexOf(0);
    if((clickPosition-4)==zeroPosition)
      {
        setState(() {
          rand[clickPosition]=0;
          rand[zeroPosition]=i;
          counter++;
        });
      }
    if(check())
    {
      //Text("You Won",style: TextStyle(fontSize: 40,color: Colors.black),);
      won();
      showDialog(context: context,
          builder: (context)=>won(),barrierDismissible: false
      );
    }
  }

  void moveLeft(int i) {
    int clickPosition=rand.indexOf(i);
    int zeroPosition=rand.indexOf(0);
    if((clickPosition-1)==zeroPosition)
      {
        setState(() {
          rand[clickPosition]=0;
          rand[zeroPosition]=i;
          counter++;
        });
      }
    if(check())
    {
      //Text("You Won",style: TextStyle(fontSize: 40,color: Colors.black),);
      won();
      showDialog(context: context,
          builder: (context)=>won(),barrierDismissible: false
      );
    }
  }
  void moveRight(int i){
    int clickPosition=rand.indexOf(i);
    int zeroPosition=rand.indexOf(0);
    if((clickPosition+1)==zeroPosition)
      {
        setState(() {
          rand[clickPosition]=0;
          rand[zeroPosition]=i;
          counter++;
        });
      }
    if(check())
    {
      //Text("You Won",style: TextStyle(fontSize: 40,color: Colors.black),);
      won();
      showDialog(context: context,
          builder: (context)=>won(),barrierDismissible: false
      );
    }
  }
}

