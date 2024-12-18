import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/provider/focus.dart';


class NeumorphicPlayBtn extends StatefulWidget {
  const NeumorphicPlayBtn({super.key});

  @override
  _NeumorphicPlayBtnState createState() => _NeumorphicPlayBtnState();
}

class _NeumorphicPlayBtnState extends State<NeumorphicPlayBtn> {
  bool _isPressed = false;
  bool isRunning = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        isRunning
            ? Provider.of<TimerService>(context, listen: false).stop()
            : Provider.of<TimerService>(context, listen: false).start();
        setState(() {
          isRunning = !isRunning;
        });
        _onPointerDown(e);
      },
      onPointerUp: _onPointerUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,

          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isPressed
                ? [
                    Colors.white,
                    const Color.fromRGBO(214, 223, 230, 1),
                  ]
                : [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                  ],
          ),

          
        ),
        child: Icon(
          isRunning ? Icons.pause : Icons.play_arrow,
          size: 60,
          color: isRunning ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}

