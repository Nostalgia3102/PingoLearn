import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/viewmodels/sign_up_screen_view_model.dart';
import '../../services/database_service.dart';
import '../../utils/constants/colors.dart';
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
          backgroundColor: AppColors.color4,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            maintainBottomViewPadding: true,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  buildSignUpTitle(),
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                              height: 60.0,
                              child: buildTextFormField(
                                  provider,
                                  StringsAsset.enterEmail,
                                  StringsAsset.emailLabelText)),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                            height: 60,
                            child: buildTextFormField(
                                provider,
                                StringsAsset.enterPassword,
                                StringsAsset.passwordLabelText),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
                    child: buildRowFooterText(provider, context),
                  ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Column buildRowFooterText(SignUpScreenViewModel provider,BuildContext context) {
    return Column(
      children: [
        buildElevatedSignUpButton(provider, context),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Already have an Account ?",
              style: TextStyle(fontWeight:FontWeight.normal, color: Colors.black),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Login",
                style: TextStyle(
                    color: AppColors.color1, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    );
  }

  ElevatedButton buildElevatedSignUpButton(
      SignUpScreenViewModel provider, BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.color1),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: AppColors.color1)),
          )),
      onPressed: () async {
        provider.setRegisterPressed(provider, true);
        if (provider.signUpFormKey.currentState?.validate() ?? false) {
          provider.signUpFormKey.currentState?.save();
          bool result =
              await authService.register(provider.email!, provider.password!);
          print(result);
          bool resultTwo = await DatabaseService().addUser(
            fullName: provider.name ?? "NAME",
            email: provider.email ?? "EMAIL",
          );
          if (resultTwo) {
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

  TextFormField buildTextFormField(
      SignUpScreenViewModel provider, String cautionText, String labelText) {
    return TextFormField(
        keyboardType: (labelText == "Phone Number")
            ? TextInputType.phone
            : (labelText == "Email")
                ? TextInputType.emailAddress
                : TextInputType.text,
        validator: (value) {
          print("INSIDE THE CHECKER");
          if (value != null &&
              labelText == "Full name" &&
              NAME_VALIDATION_REGEX.hasMatch(value)) {
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
        autovalidateMode: provider.registerPressed
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

  Padding buildSignUpTitle() {
    return const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Text(" e-Shop ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Poppins',
                color: AppColors.color1)));
  }
}
