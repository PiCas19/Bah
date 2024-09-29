import 'package:bah/widgets/bottom_nav_bar.dart';
import 'package:bah/widgets/my_button.dart';
import 'package:flutter/material.dart';

import '../static_var.dart';

class NicknamePage extends StatefulWidget {
  const NicknamePage({super.key});

  @override
  State<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {

  // text editing controllers
  final TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaticVar.CYAN,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 150),

              Center(
                child: Image.asset(
                  StaticVar.BAH_WHITE_ICON,
                  height: 80,
                ),
              ),

              const Text(
                'Scegli il tuo Nickname',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 40),
                child: TextField(
                  controller: _nicknameController,
                  obscureText: false,

                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    fillColor: StaticVar.CYAN,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              MyButton(
                  icon: null,
                  imagePath: null,
                  text: 'Continua',
                  color: Colors.white,
                  iconColor: null,
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BottomNavBar()),
                    );
                  },
              ),

              const SizedBox(height: 40),

              const Text(
                'skip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
