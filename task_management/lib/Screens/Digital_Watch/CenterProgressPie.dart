import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/Screens/Digital_Watch/NeuProgressPainter.dart';
import 'package:task_management/Screens/Digital_Watch/NeumorphicPlayBtn.dart';
import 'package:task_management/provider/focus.dart';
class CenterProgressPie extends StatelessWidget {
  const CenterProgressPie({super.key});

  @override
  Widget build(BuildContext context) {
    // getting the value from TimerService Provider and Converting into percentage for pie
    final percentage =
        Provider.of<TimerService>(context).currentDuration.inSeconds %
            60 *
            100 /
            60;

    return Container(
      height: 300,
      width: 400,
      decoration: BoxDecoration(
        border: Border.all(
            width: 10, color: Theme.of(context).scaffoldBackgroundColor),
        shape: BoxShape.circle,
        color: Colors.white70,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
          ],
        ),

      ),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 240,
              child: CustomPaint(
                painter: NeuProgressPainter(
                  circleWidth: 55,
                  completedPercentage: percentage,
                  defaultCircleColor: Colors.transparent,
                ),
                child: const Center(),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 190,
              width: 190,
              foregroundDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                 
                  backgroundBlendMode: BlendMode.overlay,
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                    Colors.black,
                    Colors.white.withOpacity(0.9),
                  ])),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 10, color: Colors.white70)),
            ),
          ),
          const Center(child: NeumorphicPlayBtn()),
        ],
      ),
    );
  }
}
