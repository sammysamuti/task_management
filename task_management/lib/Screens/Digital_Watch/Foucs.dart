
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/Screens/Digital_Watch/CenterProgressPie.dart';
import 'package:task_management/Screens/Digital_Watch/NeoDigitalScreen.dart';
import 'package:task_management/Screens/Digital_Watch/NeumorphicResetBtn.dart';
import 'package:task_management/Screens/Home.dart';
import 'package:task_management/provider/Theme_changer.dart';
import 'package:task_management/provider/focus.dart';

class Digi_Watch extends StatelessWidget {
  const Digi_Watch({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerService>(
      create: (_) => TimerService(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) => const Home(),));
          }, icon: const Icon(Icons.close)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Consumer<ThemeProvider>(
                builder: (context, value, child) {
                return Row(
                children: [
                  Text(
                    "Focus Mode",
                    style: TextStyle(
                        fontSize: 25,
                        color:value.isDarkMode? Colors.white: const Color.fromRGBO(49, 68, 105, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              );
              },),
              const Spacer(),
              const NeoDigitalScreen(),
              const Spacer(),
              const CenterProgressPie(),
              const Spacer(),
              const Spacer(),
              NeumorphicResetBtn(
                color: Theme.of(context).primaryColor,
                child: const Center(
                  child: Text(
                    "RESET",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
