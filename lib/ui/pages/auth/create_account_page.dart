import 'package:flutter/material.dart';
import 'package:streaming_service/services/auth_service.dart';
import 'package:streaming_service/services/extensions.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/app_text_field.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final buttonText = ValueNotifier<String>("Create account");
  final buttonEnabled = ValueNotifier<bool>(false);
  final errorText = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    _emailController.addListener(textChanged);
    _passwordController.addListener(textChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void textChanged() {
    buttonEnabled.value = _emailController.text.isEmail() &&
        _passwordController.text.isPassword();
  }

  Future<void> _createAccount() async {
    errorText.value = "";
    buttonEnabled.value = false;
    buttonText.value = "Creating account...";
    String? errorMessage = await AuthService.signIn(
      AuthType.createAccount,
      email: _emailController.text,
      password: _passwordController.text,
    );
    buttonText.value = "Create account";
    if (errorMessage != null) {
      errorText.value = errorMessage;
      buttonEnabled.value = true;
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.blackMatte,
        elevation: 0,
        centerTitle: true,
        title: const Text("Create Account"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Email',
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
              AppTextField(
                controller: _emailController,
                fieldType: FieldType.email,
              ),
              const SizedBox(height: 16),
              const Text(
                'Password',
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
              AppTextField(
                controller: _passwordController,
                fieldType: FieldType.password,
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<String>(
                valueListenable: errorText,
                builder: (_, value, __) {
                  return Text(
                    value,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  );
                },
              ),
              const SizedBox(height: 8),
              Center(
                child: ValueListenableBuilder<String>(
                  valueListenable: buttonText,
                  builder: (_, text, __) => ValueListenableBuilder<bool>(
                    valueListenable: buttonEnabled,
                    builder: (_, isEnabled, __) {
                      return MaterialButton(
                        height: 50.0,
                        color: AppTheme.primaryColor,
                        disabledColor: Colors.white30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Text(text),
                        onPressed: isEnabled ? _createAccount : null,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
