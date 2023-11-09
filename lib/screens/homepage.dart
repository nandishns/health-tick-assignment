import 'package:assignment/helpers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CountdownController timer = CountdownController();
  bool isInitial = true;
  bool isStarted = false;
  bool isPaused = false;
  int count = 0;
  bool volumeOn = true;
  var duration;
  List headers = [
    "Nom nom :)",
    "Break Time",
    "Finish your meal",
    "Finish your meal"
  ];
  List desc = [
    "You have 10 minutes to eat before the pause.\nFocus on eating slowly",
    "Take a give-minute break to check in on your level of fullness",
    "You can eat until you feel full",
    "You can eat until you feel full"
  ];
  final player = AudioPlayer();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(23, 20, 32, 255),
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          "Mindful Meal timer",
          style: GoogleFonts.lexend(
            color: lightWhite,
            // fontWeight: FontWeight.w600,
            fontSize: responsiveSize(24, context),
          ),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.black45,
      ),
      body: Column(
        children: [
          verticalGap(context, 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: !isInitial
                    ? count == 0
                        ? white
                        : Colors.white70
                    : Colors.white70,
                radius: !isInitial
                    ? count == 0
                        ? 10
                        : 8.0
                    : 8,
              ),
              horizontalGap(context, 0.02),
              CircleAvatar(
                backgroundColor: count == 1 ? white : Colors.white70,
                radius: count == 1 ? 10 : 8.0,
              ),
              horizontalGap(context, 0.02),
              CircleAvatar(
                backgroundColor: count == 2 ? white : Colors.white70,
                radius: count == 2 ? 10 : 8.0,
              ),
              horizontalGap(context, 0.02),
            ],
          ),
          verticalGap(context, 0.02),
          Text(
            headers[count],
            style: GoogleFonts.lexend(
              color: white,
              letterSpacing: 0.5,
              // fontWeight
              // : FontWeight.w600,
              fontSize: responsiveSize(32, context),
            ),
          ),
          verticalGap(context, 0.01),
          Text(
            desc[count],
            textAlign: TextAlign.center,
            style: GoogleFonts.lexend(
              color: lightWhite,
              letterSpacing: 0.5,
              // fontWeight: FontWeight.w600,
              fontSize: responsiveSize(22, context),
            ),
          ),
          verticalGap(context, 0.03),
          Stack(alignment: Alignment.center, children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.56),
              radius: 160.0,
            ),
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 130.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Countdown(
                      controller: timer,
                      seconds: 30,
                      build: (BuildContext context, double time) {
                        if (time < 06) {
                          player.play(AssetSource('tick.mp3'));
                        }
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 220,
                              height: 220,
                              child: CircularProgressIndicator(
                                value: time / 30,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.green),
                                strokeWidth: 10,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "00:${time.floor().toString().padLeft(2, '0')}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: responsiveSize(40, context),
                                  ),
                                ),
                                Text("minutes remaining",
                                    style: GoogleFonts.lexend(
                                      color: Colors.grey,
                                      fontSize: responsiveSize(22, context),
                                    ))
                              ],
                            )
                          ],
                        );
                      },
                      onFinished: () {
                        setState(() {
                          isStarted = false;
                          timer.restart();
                          isInitial = true;
                          timer.pause();
                          count++;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ]),
          verticalGap(context, 0.03),
          CupertinoSwitch(
              value: volumeOn,
              onChanged: (bool val) {
                if (volumeOn) {
                  player.setVolume(0);
                  setState(() {
                    volumeOn = false;
                  });
                } else {
                  player.setVolume(1);
                  setState(() {
                    volumeOn = true;
                  });
                }
              }),
          verticalGap(context, 0.01),
          Text(
            "Sound On",
            style: GoogleFonts.lexend(
              color: lightWhite,
              // fontWeight: FontWeight.w600,
              fontSize: responsiveSize(22, context),
            ),
          ),
          SizedBox(
            width: responsiveSize(445, context),
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  isInitial = false;
                });
                if (isStarted) {
                  setState(() {
                    timer.pause();
                    isStarted = false;
                  });
                } else {
                  setState(() {
                    timer.start();
                    isStarted = true;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 208, 236, 218),
                onPrimary: Colors.black,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded border
                ),
                padding:
                    EdgeInsets.symmetric(vertical: responsiveSize(22, context)),
              ),
              child: Text(
                isInitial
                    ? "START"
                    : isStarted
                        ? "PAUSE"
                        : "RESUME",
                style: GoogleFonts.lexend(
                  color: Colors.black,
                  // fontWeight: FontWeight.w600,
                  fontSize: responsiveSize(26, context),
                ), // Bigger text
              ),
            ),
          ),
          verticalGap(context, 0.03),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: darkBlue,
                onPrimary: Colors.white,
                side:
                    BorderSide(color: Colors.white.withOpacity(0.4), width: 2),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded border
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: responsiveSize(120, context),
                    vertical: responsiveSize(28, context)),
              ),
              child: Text(
                "LET'S STOP I'M FULL",
                style: GoogleFonts.lexend(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ), // Bigger text
              )),
          verticalGap(context, 0.07),
          Text(
            "Developed by Nandish N S",
            style: GoogleFonts.lexend(
                fontSize: responsiveSize(22, context),
                color: Colors.white.withOpacity(0.4)),
          )
        ],
      ),
    );
  }
}
