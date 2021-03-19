import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<int> snake = [];
  static var random = Random();
  static int foodPosition = random.nextInt(522);

  static int score = 0;
  static String direction = "up";
  int numberOfSquare = 540;

  void newFood() {
    foodPosition = random.nextInt(522);
    if (foodPosition < 18 ||
        foodPosition % 18 == 0 ||
        (foodPosition + 1) % 18 == 0) {
      newFood();
    }
  }

  void snakePosition() {
    var ran = Random();
    int snakePositionElement = ran.nextInt(360);
    if (snakePositionElement < 18 ||
        snakePositionElement % 18 == 0 ||
        (snakePositionElement + 1) % 18 == 0) {
      snakePosition();
    }
    snake = [
      snakePositionElement,
      snakePositionElement + 18,
      snakePositionElement + 18 + 18,
      snakePositionElement + 18 + 18 + 18,
      snakePositionElement + 18 + 18 + 18 + 18,
    ];
  }

  void startGame() {
    score = 0;
    snakePosition();
    Duration duration = const Duration(milliseconds: 200);
    Timer.periodic(
      duration,
      (timer) {
        updateSnake();
        if (gameOver()) {
          timer.cancel();
          _showGameOverScreen();
        }
      },
    );
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case "down":
          if (snake.last > 540) {
            snake.add(snake.last + 18 - numberOfSquare);
          } else {
            snake.add(snake.last + 18);
          }
          break;
        case "up":
          if (snake.last < 18) {
            snake.add(snake.last - 18 + numberOfSquare);
          } else {
            snake.add(snake.last - 18);
          }

          break;

        case "left":
          if (snake.last % 18 == 0) {
            snake.add(snake.last - 1 + 18);
          } else {
            snake.add(snake.last - 1);
          }

          break;
        case "right":
          if ((snake.last + 1) % 18 == 0) {
            snake.add(snake.last + 1 + 18);
          } else {
            snake.add(snake.last + 1);
          }

          break;
      }
    });

    if (snake.last == foodPosition) {
      score += 1;
      newFood();
    } else {
      snake.removeAt(0);
    }
  }

  bool gameOver() {
    bool over = false;
    if (snake.last % 18 == 0 ||
        (snake.last + 1) % 18 == 0 ||
        snake.last < 18 ||
        snake.last > 522 ||
        snake.first % 18 == 0 ||
        (snake.first + 1) % 18 == 0 ||
        snake.first < 18 ||
        snake.first > 522) {
      over = true;
    }
    return over;
  }

  @override
  void initState() {
    // print("Game started");
    startGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.grey.shade900,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Name: Ankit Sagar ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Level: 01 ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Score: $score",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: GestureDetector(
                onHorizontalDragUpdate: (value) {
                  if (direction != "left" && value.delta.dx > 0) {
                    direction = "right";
                  } else if (direction != "right" && value.delta.dx < 0) {
                    direction = "left";
                    //Left
                  }
                },
                onVerticalDragUpdate: (onVerticalDragAction) {
                  if (direction != "up" && onVerticalDragAction.delta.dy > 0) {
                    direction = "down";
                    //Down
                  } else if (direction != "down" &&
                      onVerticalDragAction.delta.dy < 0) {
                    direction = "up";
                    // Up
                  }
                },
                child: Container(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquare,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width ~/ 20),
                    itemBuilder: (context, index) {
                      if (snake.contains(index)) {
                        return Container(
                          color: Colors.black,
                          padding: EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else if (foodPosition == index) {
                        return Container(
                          color: Colors.black,
                          padding: EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: Colors.green,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          color: Colors.black,
                          padding: EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: Colors.grey.shade900,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  startGame();
                },
                child: Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    // color: Colors.green,
                    child: Center(
                      child: Text(
                        "StartGame",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showGameOverScreen() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: TextButton(
            child: Text("Restart"),
            onPressed: () {
              startGame();
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
