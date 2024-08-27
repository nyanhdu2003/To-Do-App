import 'package:flutter/material.dart';
import 'package:todo_list_app/screens/login_screen.dart';
import 'package:todo_list_app/screens/signup_screen.dart';
import 'package:todo_list_app/theme/theme.dart';
import 'package:todo_list_app/widgets/custom_scaffold.dart';
import 'package:todo_list_app/widgets/welcome_buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Column(
      children: [
        Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 0,
              ),
              child: Center(
                  child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(children: [
                  TextSpan(
                      text: 'Welcome to ToDo List\n',
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.w600,
                      )),
                  TextSpan(
                      text:
                          '\nEnter your personal details to enter the application',
                      style: TextStyle(fontSize: 20))
                ]),
              )),
            )),
        Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                      child: WelcomeButtons(
                          buttonText: 'Log In',
                          color: Colors.black45,
                          textColor: Colors.white,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
                          }

                          )),
                  Expanded(
                      child: WelcomeButtons(
                          buttonText: 'Sign Up',
                          color: Colors.white,
                          textColor: lightColorScheme.primary,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          })),
                ],
              ),
            ))
      ],
    ));
  }
}
