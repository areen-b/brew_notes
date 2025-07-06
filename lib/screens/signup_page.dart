import 'package:brew_notes/screens/landing_page.dart';
import 'package:brew_notes/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'package:brew_notes/screens/login_page.dart';
import 'package:brew_notes/screens/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';
  String _formError = '';

  Future<void> _signUpUser() async {
    setState(() {
      _emailError = '';
      _passwordError = '';
      _confirmPasswordError = '';
      _formError = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final username = _usernameController.text.trim();

    if (password != confirmPassword) {
      setState(() => _confirmPasswordError = 'Passwords do not match');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _emailError = 'Please enter a valid email');
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.currentUser!.updateDisplayName(username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() => _emailError = 'this email is already registered');
      } else if (e.code == 'invalid-email') {
        setState(() => _emailError = 'please enter a valid email');
      } else if (e.code == 'weak-password') {
        setState(() => _passwordError = 'password should be at least 6 characters');
      } else {
        setState(() => _formError = 'an unexpected error occurred. please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.latteFoam,
      body: Stack(
        children: [
          ClipPath(clipper: TopInverseCurveClipper(), child: Container(height: 230, color: AppColors.brown)),
          ClipPath(clipper: TopInverseCurveClipper(), child: Container(height: 180, color: AppColors.primary.withOpacity(0.9))),
          ClipPath(clipper: TopInverseCurveClipper(), child: Container(height: 140, color: AppColors.latteFoam.withOpacity(0.3))),
          const Positioned(top: 40, right: 16, child: ThemeToggleButton(iconColor: AppColors.brown)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 200, left: 15, right: 15),
              child: Column(
                children: [
                  // tab header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                        child: Text('Log in',
                            style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontFamily: 'Playfair Display',
                              color: AppColors.brown.withOpacity(0.5),
                            )),
                      ),
                      const SizedBox(width: 24),
                      Text('Sign up',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontFamily: 'Playfair Display',
                            fontWeight: FontWeight.bold,
                            color: AppColors.brown,
                          )),
                    ],
                  ),

                  const SizedBox(height: 60),
                  CustomTextField(label: "username", controller: _usernameController),
                  const SizedBox(height: 30),
                  CustomTextField(label: "email", controller: _emailController),
                  if (_emailError.isNotEmpty)
                    Text(_emailError, style: const TextStyle(color: AppColors.error)),
                  const SizedBox(height: 30),
                  PasswordField(controller: _passwordController),
                  if (_passwordError.isNotEmpty)
                    Text(_passwordError, style: const TextStyle(color: AppColors.error)),
                  const SizedBox(height: 30),
                  ConfirmPasswordField(controller: _confirmPasswordController),
                  if (_confirmPasswordError.isNotEmpty)
                    Text(_confirmPasswordError, style: const TextStyle(color: AppColors.error)),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(label: 'Sign up', color: AppColors.brown, onPressed: _signUpUser),
                  ),
                  if (_formError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(_formError, style: const TextStyle(color: AppColors.error)),
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
