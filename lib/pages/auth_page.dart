import 'package:bah/pages/email_auth_page.dart';
import 'package:bah/static_var.dart';
import 'package:flutter/material.dart';
import '../widgets/my_button.dart';
import 'package:bah/auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaticVar.CYAN,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // TODO add function
                    },
                  ),
                ),

                const SizedBox(height: 50),

                Center(
                    child: Image.asset(
                      StaticVar.BAH_WHITE_ICON,
                      height: 80,
                    ),
                ),

                const Text(
                  'Registrati o accedi',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                const SizedBox(height: 40),

                // Continue with Apple button
                MyButton(
                  icon: Icons.apple,
                  imagePath: null,
                  text: 'Continua con Apple',
                  color: Colors.white,
                  iconColor: Colors.black,
                  onPressed: Auth().signInWithApple,
                ),

                const SizedBox(height: 5),

                // Continue with Google button
                MyButton(
                  icon: null,
                  imagePath: StaticVar.GOOGLE_ICON_PATH,
                  text: 'Continua con Google',
                  color: Colors.white,
                  iconColor: Colors.black,
                  onPressed: Auth().signInWithGoogle,
                ),

                const SizedBox(height: 5),

                // Continue with Facebook button
                MyButton(
                  icon: Icons.facebook,
                  imagePath: null,
                  text: 'Continua con Facebook',
                  color: Colors.white,
                  iconColor: Colors.blue.shade800,
                  onPressed: () {
                    // Handle Apple Sign-in
                  },
                ),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        '   Oppure   ',
                        style: TextStyle(
                            color: Colors.white,
                        ),
                      ),

                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Continue with Google button
                MyButton(
                  icon: null,
                  imagePath: StaticVar.EMAIL_ICON_PATH,
                  text: 'Continua con l\'email',
                  color: Colors.white,
                  iconColor: Colors.black38,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EmailAuthPage()),
                    );
                  },
                ),

                const SizedBox(height: 100),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
                  child: Text(
                    'Continuando a utilizzare BAH, accetti i nostri Termini di Servizio e informativa sulla privacy, I dati personali aggiunti a BAH sono pubblici per impostazione predefinita. Per apportare modifiche, consulta le FAQ sulla privacy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              ],
            ),
          )
      ),
    );
  }
}