import 'package:flutter/material.dart';
import 'package:streaming_service/services/auth_service.dart';
import 'package:streaming_service/services/extensions.dart';
import 'package:streaming_service/ui/pages/auth/create_account_page.dart';
import 'package:streaming_service/ui/pages/auth/login_page.dart';
import 'package:streaming_service/ui/widgets/sign_in_button/sign_in_button.dart';

class LandingLoginPage extends StatelessWidget {
  static const String routeName = '/landing_login';
  const LandingLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Spotidemo.\nFree demo songs.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              SignInButton(
                Buttons.Google,
                onPressed: () => socialSignIn(AuthType.google),
              ),
              const SizedBox(height: 10),
              SignInButton(
                Buttons.Facebook,
                onPressed: () => socialSignIn(AuthType.facebook),
              ),
              const SizedBox(height: 10),
              SignInButton(
                Buttons.Email,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAccountPage(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> socialSignIn(AuthType authType) async {
    String? errorMessage = await AuthService.signIn(authType);
    if (errorMessage != null) {
      errorMessage.showAsSnackBarMessage();
    }
  }
}
