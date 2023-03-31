import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class GreetingScreen extends StatelessWidget {
  const GreetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(15, 3, 49, 1),
                Color.fromRGBO(38, 28, 81, 1),
              ],
              transform: GradientRotation(1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "VP Financials",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        color: Colors.blueAccent.shade700,
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ]),
              ),
              Lottie.network(
                fit: BoxFit.scaleDown,
                'https://assets9.lottiefiles.com/packages/lf20_y8orqkyi.json',
              ),
              const Text(
                "Learn trading with us",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  Get.toNamed("/login");
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Get.toNamed("/register");
              //   },
              //   child: Container(
              //     margin: const EdgeInsets.all(10),
              //     padding: const EdgeInsets.all(10),
              //     width: MediaQuery.of(context).size.width * 0.8,
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //       color: Colors.blueAccent,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: const Text(
              //       "Register",
              //       style: TextStyle(
              //         fontSize: 24,
              //         fontWeight: FontWeight.w400,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
