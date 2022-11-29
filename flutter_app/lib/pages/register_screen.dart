import 'package:cash_manager/components/widgets/confirmpassword_field.dart';
import 'package:cash_manager/components/widgets/email_field.dart';
import 'package:cash_manager/components/widgets/classic_button.dart';
import 'package:cash_manager/components/widgets/fields/ip_field.dart';
import 'package:cash_manager/components/widgets/messages_screen.dart';
import 'package:cash_manager/components/widgets/password_field.dart';
import 'package:cash_manager/components/widgets/username_field.dart';
import 'package:cash_manager/services/manager.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmpasswordController;
  late TextEditingController usernameController;

  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmpasswordController = TextEditingController();
    usernameController = TextEditingController();
    super.initState();
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: loadingBallAppear
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
                child: MessagesScreen())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween(begin: 1, end: _elementsOpacity),
                        builder: (_, value, __) => Opacity(
                          opacity: value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.flutter_dash,
                                  size: 60, color: Color(0xff21579C)),
                              const SizedBox(height: 25),
                              const Text(
                                "Register,",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 35),
                              ),
                              Text(
                                "Remplir le formulaire",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 27),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CustomField(
                                fade: _elementsOpacity == 0,
                                controller: usernameController),
                            const SizedBox(height: 60),
                            EmailField(
                                fadeEmail: _elementsOpacity == 0,
                                emailController: emailController),
                            const SizedBox(height: 40),
                            PasswordField(
                                fadePassword: _elementsOpacity == 0,
                                passwordController: passwordController),
                            const SizedBox(height: 60),
                            ConfirmpasswordField(
                                fadePassword: _elementsOpacity == 0,
                                confirmpasswordController:
                                    confirmpasswordController),
                            const SizedBox(height: 60),
                            ClassicButton(
                              text: "Sign up",
                              elementsOpacity: _elementsOpacity,
                              onTap: () {
                                setState(() {
                                  _elementsOpacity = 0;
                                });
                                // Manager.of(context).api.register()
                              },
                              onAnimationEnd: () async {
                                await Future.delayed(
                                    const Duration(milliseconds: 500));
                                setState(() {
                                  loadingBallAppear = true;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
