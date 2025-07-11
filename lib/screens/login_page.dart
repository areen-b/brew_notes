import 'package:brew_notes/screens/forgot_password_page.dart';
import 'package:brew_notes/screens/home_page.dart';
import 'package:brew_notes/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  Future<void> _loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } catch (e) {
      setState(() => _error = "incorrect email or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.latteFoam(context),
      body: Stack(
        children: [
          const TopCurveHeader(),
          Positioned(
            top: 40,
            right: 16,
            child: ThemeToggleButton(iconColor: AppColors.brown(context)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 200, left: 15, right: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Log in',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown(context),
                        ),
                      ),
                      SizedBox(width: 24),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpPage()),
                        ),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontFamily: 'Playfair Display',
                            color: AppColors.brown(context).withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  CustomTextField(label: "email", controller: _emailController),
                  SizedBox(height: 30),
                  PasswordField(controller: _passwordController),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPassword()),
                      ),
                      child: Text(
                        "forgot password?",
                        style: TextStyle(
                          color: AppColors.sage(context),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Log in',
                      color: AppColors.dark,
                      textColor: AppColors.light,
                      onPressed: _loginUser,
                    ),
                  ),
                  SizedBox(height: 30),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
