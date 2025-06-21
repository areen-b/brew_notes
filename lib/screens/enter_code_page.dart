import 'package:brew_notes/screens/forgot_password_page.dart';
import 'package:brew_notes/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';
import 'package:brew_notes/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class EnterCode extends StatefulWidget {
  const EnterCode({super.key});

  @override
  State<EnterCode> createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
            child: Padding(
              padding: const EdgeInsets.only(top: 200.0, left: 15.0, right: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Enter Code',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: AppColors.brown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter the code that was sent to your email.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 60),
                    const CodeInputField(),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(label: 'log in', onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      }),
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
  }
}