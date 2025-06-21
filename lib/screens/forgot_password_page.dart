import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'package:brew_notes/screens/enter_code_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: AppColors.latteFoam,
      body: Stack(
        children: [
          const TopCurveHeader(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height: 260,
                color: AppColors.primary,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 200.0, left: 15.0, right: 15.0),
                child: Column(
                  children: [
                    // Tab Row
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brown,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Enter your email to reset your password.',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    CustomTextField(label: "email"),

                    const SizedBox(height: 30),
                    SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: 'send code',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EnterCode()),
                            );
                          },
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const BackButtonText(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }}