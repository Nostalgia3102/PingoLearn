import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/viewmodels/sign_up_screen_view_model.dart';
import '../../utils/constants/strings.dart';
import '../../utils/constants/validations.dart';
import '../../utils/utilities.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpScreenViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            maintainBottomViewPadding: true,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  buildSignUpTitle(),
                  buildSignUpSubTitle(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Form(
                    key: provider.signUpFormKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        children: [
                          SizedBox(
                              height: 60.0,
                              child: buildTextFormField(
                                  provider,
                                  StringsAsset.enterName,
                                  StringsAsset.nameLabelText)),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                              height: 60.0,
                              child: buildTextFormField(
                                  provider,
                                  StringsAsset.enterEmail,
                                  StringsAsset.emailLabelText)),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                            height: 60,
                            child: buildTextFormField(
                                provider,
                                StringsAsset.enterPassword,
                                StringsAsset.passwordLabelText),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: buildElevatedSignUpButton(provider, context),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.045),
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
                        child: buildRowFooterText(context),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row buildRowFooterText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "Have an Account ?",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Sign In",
            style: TextStyle(
                color: Colors.deepOrange, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  ElevatedButton buildElevatedSignUpButton(SignUpScreenViewModel provider,
      BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.deepOrange),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: Colors.deepOrange)),
          )),
      onPressed: () async {
        provider.setRegisterPressed(provider, true);
        if (provider.signUpFormKey.currentState?.validate() ?? false) {
          provider.signUpFormKey.currentState?.save();
          bool result =
          await authService.register(provider.email!, provider.password!);
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
          "Register",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(SignUpScreenViewModel provider,
      String cautionText, String labelText) {
    return TextFormField(
        keyboardType: (labelText == "Phone Number")
            ? TextInputType.phone
            : (labelText == "Email") ? TextInputType.emailAddress : TextInputType.text,

        validator: (value) {
          print("INSIDE THE CHECKER");
          if (value != null &&
              labelText == "Full name" && NAME_VALIDATION_REGEX.hasMatch(value)) {
            print("INSIDE THE FULL NAME FIELD");
            provider.name = value;
            return null;
          }

          if (value != null &&
              labelText == "Email" &&
              EMAIL_VALIDATION_REGEX.hasMatch(value)) {
            print("INSIDE THE EMAIL FIELD");
            provider.email = value;
            return null;
          }

          if (value != null &&
              labelText == "Password" &&
              PASSWORD_VALIDATION_REGEX.hasMatch(value)) {
            print("INSIDE THE PASSWORD FIELD");
            provider.password = value;
            return null;
          }

          return cautionText;
        },
        obscureText: (labelText == "Password")
            ? provider.eyeButton
            ? false
            : true
            : false,
        autovalidateMode: provider.registerPressed ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,

        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            labelText: labelText,
            fillColor: Colors.blue,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              height: 0.3,
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
                ? IconButton(
              onPressed: () {
                provider.toggleEyeButton(provider, !provider.eyeButton);
              },
              icon: provider.eyeButton
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
            )
                : const SizedBox.shrink(),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 2,
                ),
                gapPadding: 0)));
  }

  Text buildSignUpSubTitle() {
    return const Text(
      "  Fill in your registration information",
      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
    );
  }

  Row buildSignUpTitle() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          " Sign ",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
        Text(
          "Up",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.deepOrange),
        ),
      ],
    );
  }
}
