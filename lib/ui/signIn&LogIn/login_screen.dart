import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/viewmodels/login_screen_view_model.dart';
import '../../utils/constants/strings.dart';
import '../../utils/constants/validations.dart';
import '../../utils/utilities.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginScreenViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            maintainBottomViewPadding: true,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  buildLoginTitle(),
                  buildLoginSubTitle(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  Form(
                    key: provider.loginFormKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                              height: 60.0,
                              child: buildTextFormField(
                                  provider,
                                  StringsAsset.enterEmail,
                                  StringsAsset.emailLabelText)),
                          SizedBox(
                              height:
                              MediaQuery.of(context).size.height * 0.03),
                          SizedBox(
                            height: 60,
                            child: buildTextFormField(
                                provider,
                                StringsAsset.enterPassword,
                                StringsAsset.passwordLabelText),
                          ),
                          SizedBox(
                              height:
                              MediaQuery.of(context).size.height * 0.01),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {},
                              child: const Text(
                                "Forgot your password ?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: buildElevatedLoginButton(provider, context),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 1,
                        child: Container(
                          color: Colors.black54,
                        ),
                      ),
                      const Text(
                        "  Continue with  ",
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(
                        width: 100,
                        height: 1,
                        child: Container(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
                        child: buildRowFooterText(),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row buildRowFooterText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "Not a member ?",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            navigationService.pushNamed("/sign_up");
          },
          child: const Text(
            "Register Now",
            style: TextStyle(
                color: Colors.deepOrange, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  ElevatedButton buildElevatedLoginButton(
      LoginScreenViewModel provider, BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.deepOrange),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: Colors.deepOrange)),
          )),
      onPressed: () async {
        loginPressed = true;
        if (provider.loginFormKey.currentState?.validate() ?? false) {
          provider.loginFormKey.currentState?.save();
          bool result =
          await authService.login(provider.email!, provider.password!);
          print(result);
          if (result) {
            navigationService.pushReplacementNamed("/home_page");
          } else {
            final snackBar = SnackBar(
              content: const Text('Invalid Credentials'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some action to undo
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      LoginScreenViewModel provider, String cautionText, String labelText) {
    return TextFormField(
        validator: (value) {
          if (value != null &&
              labelText == "Email" &&
              EMAIL_VALIDATION_REGEX.hasMatch(value)) {
            provider.email = value;
            return null;
          }
          if (value != null &&
              labelText == "Password" &&
              PASSWORD_VALIDATION_REGEX.hasMatch(value)) {
            provider.password = value;
            return null;
          }
          return cautionText;
        },
        keyboardType: (labelText == "Email") ? TextInputType.emailAddress : TextInputType.text,
        obscureText: (labelText == "Password")
            ? provider.eyeButton
            ? false
            : true
            : false,
        autovalidateMode: loginPressed
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            labelText: labelText,
            fillColor: Colors.blue,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              height: 0.5,
              fontWeight: FontWeight.normal,
            ),
            alignLabelWithHint: true,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            suffixIcon: (labelText == "Password")
                ? provider.eyeButton
                ? IconButton(
              onPressed: () {
                provider.eyeButton = !provider.eyeButton;
                print(provider.eyeButton);
              },
              icon: const Icon(Icons.visibility),
            )
                : IconButton(
              onPressed: () {
                provider.eyeButton = !provider.eyeButton;
                print(provider.eyeButton);
              },
              icon: const Icon(Icons.visibility_off),
            )
                : const SizedBox.shrink(),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 2,
                ),
                gapPadding: BorderSide.strokeAlignOutside)));
  }

  Text buildLoginSubTitle() {
    return const Text(
      "  Sign in to continue ;-)",
      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
    );
  }

  Row buildLoginTitle() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          " Welcome ",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
        Text(
          "User",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.deepOrange),
        ),
      ],
    );
  }
}
