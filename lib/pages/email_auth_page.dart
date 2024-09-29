import 'package:bah/pages/nickname_page.dart';
import 'package:bah/static_var.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../widgets/my_button.dart';

class EmailAuthPage extends StatefulWidget {
  const EmailAuthPage({super.key});

  @override
  State<EmailAuthPage> createState() => _EmailAuthPageState();
}

class _EmailAuthPageState extends State<EmailAuthPage> {
  // Text editing controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _emailExists = false; // For checking if email exists
  bool _checkedEmail = false; // To control when to show password fields
  bool _isEmailEditable = true; // Flag to control email editing

  bool _isPasswordVisible = false; // To toggle password visibility
  bool _isConfirmPasswordVisible = false; // To toggle confirm password visibility

  // Function to check if email exists
  Future<void> _checkEmail() async {
    bool emailExists = await Auth().isEmailRegistered(email: _emailController.text);

    setState(() {
      _emailExists = emailExists;
      _checkedEmail = true; // Show password fields after checking
      _isEmailEditable = false; // Disable email editing after check
    });
  }

  // Function to handle the confirm button press
  Future<void> _handleConfirm() async {
    if (_emailExists) {
      // Sign in with email and password
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      // Register new user
      if (_passwordController.text == _confirmPasswordController.text) {
        await Auth().createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        // Show error for password mismatch
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!')),
        );
      }
    }
  }

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
                    if (_isEmailEditable) {
                      Navigator.pop(context); // Handle back navigation
                    } else {
                      setState(() {
                        _emailExists = false;
                        _checkedEmail = false;
                        _isEmailEditable = true;
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                      });
                    }
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
              Text(
                (_checkedEmail && !_emailExists)
                    ? 'Crea una password'
                    : _checkedEmail
                    ? 'Inserisci la password'
                    : 'Iniziamo con l\'email',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),

              // Email TextField
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    TextField(
                      controller: _emailController,
                      obscureText: false,
                      enabled: _isEmailEditable, // Enable/disable editing
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
                  ],
                ),
              ),

              const SizedBox(height: 5),

              // Conditionally show the password text fields with transition
              AnimatedOpacity(
                opacity: _checkedEmail ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: (_checkedEmail && !_emailExists)
                      ? 190
                      : _checkedEmail
                      ? 100
                      : 0, // Adjust height as needed
                  curve: Curves.easeInOut, // Animation curve
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
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
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          if (!_emailExists) ...[
                            const SizedBox(height: 15),
                            const Text(
                              'Conferma Password',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
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
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              MyButton(
                icon: null,
                imagePath: null,
                text: "Conferma",
                color: Colors.white,
                iconColor: null,
                onPressed: (){
                  if(_checkedEmail && !_emailExists){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NicknamePage()),
                    );
                  } else if (_checkedEmail){
                    _handleConfirm();
                  } else {
                    _checkEmail();
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
