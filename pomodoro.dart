import 'package:flutter/material.dart';
import "dart:async";

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color.fromARGB(255, 225, 59, 29),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        cardColor: const Color(0xFFF4EDDB),
      ),
      home: const HomeScreen(),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int secondsPerCycle = 25 * 60;
  static const fiveMinutes = 5 * 60;

  int buttonPressed = 25;
  int totalCycle = 0;
  int totalSeconds = secondsPerCycle;
  bool isRunning = false;
  bool isResting = false;
  Timer? timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      // work
      if (!isResting) {
        setState(() {
          isRunning = false;
          totalCycle++;
          // 1 round over -> rest
          if (totalCycle % 4 != 0) {
            isResting = false;
            totalSeconds = secondsPerCycle;
          } else {
            isResting = true;
            totalSeconds = fiveMinutes;
          }
        });
      } else {
        // rest
        setState(() {
          isRunning = false;
          isResting = false;
          totalSeconds = secondsPerCycle;
        });
      }

      timer.cancel();
    } else {
      setState(() {
        totalSeconds--;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );

    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer!.cancel();

    setState(() {
      isRunning = false;
    });
  }

  void onMinuteButtonPressed(int minute) {
    setState(() {
      if (timer != null) {
        timer!.cancel();
      }
      isRunning = false;
      secondsPerCycle = minute * 60;
      totalSeconds = secondsPerCycle;
    });
  }

  void onResetButtonPressed() {
    setState(() {
      if (timer != null) {
        timer!.cancel();
      }

      buttonPressed = 25;
      totalCycle = 0;
      secondsPerCycle = 25 * 60;
      totalSeconds = secondsPerCycle;
      isRunning = false;
      isResting = false;
    });
  }

  List<String> format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2).split(":");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            "POMOTIMER",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Time
          Flexible(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isResting ? "[ Rest ]" : "[ Work ]",
                    style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 180,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                format(totalSeconds)[0],
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  fontSize: 85,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Text(
                          ":",
                          style: TextStyle(
                            color: Theme.of(context).cardColor.withOpacity(0.6),
                            fontSize: 85,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        height: 180,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                format(totalSeconds)[1],
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  fontSize: 85,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Choose time & reset
          Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FractionallySizedBox(
                      alignment: Alignment.center,
                      heightFactor: 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          onMinuteButtonPressed(15);
                          setState(() {
                            buttonPressed = 15;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonPressed == 15
                              ? Theme.of(context).cardColor
                              : Theme.of(context).colorScheme.background,
                          side: BorderSide(
                            width: 2.0,
                            color: Theme.of(context).cardColor.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          "15",
                          style: TextStyle(
                            color: buttonPressed == 15
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).cardColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.center,
                      heightFactor: 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          onMinuteButtonPressed(20);
                          setState(() {
                            buttonPressed = 20;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonPressed == 20
                              ? Theme.of(context).cardColor
                              : Theme.of(context).colorScheme.background,
                          side: BorderSide(
                            width: 2.0,
                            color: Theme.of(context).cardColor.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          "20",
                          style: TextStyle(
                            color: buttonPressed == 20
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).cardColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.center,
                      heightFactor: 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          onMinuteButtonPressed(25);
                          setState(() {
                            buttonPressed = 25;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonPressed == 25
                              ? Theme.of(context).cardColor
                              : Theme.of(context).colorScheme.background,
                          side: BorderSide(
                            width: 2.0,
                            color: Theme.of(context).cardColor.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          "25",
                          style: TextStyle(
                            color: buttonPressed == 25
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).cardColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.center,
                      heightFactor: 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          onMinuteButtonPressed(30);
                          setState(() {
                            buttonPressed = 30;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonPressed == 30
                              ? Theme.of(context).cardColor
                              : Theme.of(context).colorScheme.background,
                          side: BorderSide(
                            width: 2.0,
                            color: Theme.of(context).cardColor.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          "30",
                          style: TextStyle(
                            color: buttonPressed == 30
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).cardColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.center,
                      heightFactor: 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          onMinuteButtonPressed(35);
                          setState(() {
                            buttonPressed = 35;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonPressed == 35
                              ? Theme.of(context).cardColor
                              : Theme.of(context).colorScheme.background,
                          side: BorderSide(
                            width: 2.0,
                            color: Theme.of(context).cardColor.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          "35",
                          style: TextStyle(
                            color: buttonPressed == 35
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).cardColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          // Icon
          Flexible(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed: isRunning ? onPausePressed : onStartPressed,
                    icon: Icon(isRunning
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline),
                  ),
                ),
                Center(
                  child: IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed: onResetButtonPressed,
                    icon: const Icon(Icons.restart_alt),
                  ),
                ),
              ],
            ),
          ),
          // Round and goal
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${totalCycle % 4} / 4',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color:
                                  Theme.of(context).cardColor.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "ROUND",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$totalCycle / 12',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color:
                                  Theme.of(context).cardColor.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "GOAL",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
