import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/login_controller.dart';
import '../../../helpers/snackbar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/assets_list.dart';
import '../../../utils/enums.dart';
import '../../../utils/size_config.dart';
import '../../widgets/custom/custom_flat_button.dart';
import '../../widgets/custom/custom_text_field.dart';
import '../../widgets/layout/space_sizer.dart';
import '../../widgets/text/roboto_text_view.dart';
import 'login_pages_desktop.dart';

class LoginPagesMobile extends StatelessWidget {
  const LoginPagesMobile({
    super.key,
    required this.loginController,
  });

  final LoginController loginController;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (loginController.isTappedSignUp.isTrue)
          RegisterForm(
            width: 100,
            height: 300,
            loginController: loginController,
          )
        else
          LoginFormMobile(
            loginController: loginController,
          ),
      ],
    );
  }
}

class LoginFormMobile extends StatelessWidget {
  const LoginFormMobile({
    super.key,
    required this.loginController,
  });

  final LoginController loginController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.horizontal(0.5)))),
      width: SizeConfig.horizontal(100),
      height: SizeConfig.horizontal(300),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RobotoTextView(
              value: 'Welcome Back!',
              size: SizeConfig.safeBlockHorizontal * 8,
              fontWeight: FontWeight.bold,
            ),
            const SpaceSizer(
              vertical: 1,
            ),
            RobotoTextView(
              value: 'Continue with Google or enter your details.',
              size: SizeConfig.safeBlockHorizontal * 5,
            ),
            const SpaceSizer(
              vertical: 2,
            ),
            CustomFlatButton(
                width: 80,
                height: 8,
                image: AssetList.googleIcon,
                textSize: SizeConfig.safeBlockHorizontal * 4,
                iconSize: SizeConfig.safeBlockHorizontal * 1.5,
                text: 'Login with Google',
                radius: 0.5,
                borderColor: AppColors.maroon,
                onTap: () {
                  // loginController.signInWithGoogle();
                  Snack.show(SnackbarType.error, 'Information',
                      'Login feature coming soon');
                }),
            const SpaceSizer(
              vertical: 3,
            ),
            CustomTextField(
              width: 80,
              height: SizeConfig.horizontal(18),
              title: 'Email',
              textSize: SizeConfig.safeBlockHorizontal * 6,
              focus: loginController.emailFocusNode,
              controller: loginController.emailController,
              borderColor: loginController.isValidated.value == false
                  ? AppColors.redAlert
                  : AppColors.greenSuccess,
              onChanged: (String value) {
                loginController.validateEmail(value);
              },
            ),
            if (loginController.isValidated.value == false &&
                loginController.emailController.text != '')
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.horizontal(6.5)),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.warning,
                      color: AppColors.yellowWarning,
                    ),
                    RobotoTextView(
                      value: 'Please enter a valid email address.',
                      size: SizeConfig.safeBlockHorizontal * 5,
                      color: AppColors.yellowWarning,
                    ),
                  ],
                ),
              )
            else
              const SizedBox.shrink(),
            const SpaceSizer(
              vertical: 2,
            ),
            CustomTextField(
              width: 80,
              height: SizeConfig.horizontal(18),
              textSize: SizeConfig.safeBlockHorizontal * 6,
              title: 'Password',
              isPasswordField: true,
              controller: loginController.passwordController,
              focus: loginController.passwordFocusNode,
            ),
            Padding(
              padding: EdgeInsets.only(right: SizeConfig.horizontal(6)),
              child: Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                            child: Container(
                                width: SizeConfig.horizontal(30),
                                height: SizeConfig.horizontal(15),
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            SizeConfig.horizontal(2)))),
                                child: Column(
                                  children: <Widget>[
                                    const SpaceSizer(
                                      vertical: 2,
                                    ),
                                    RobotoTextView(
                                      value:
                                          'Please enter a valid email address.',
                                      size: SizeConfig.safeBlockHorizontal * 3,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const SpaceSizer(
                                      vertical: 2,
                                    ),
                                    Obx(
                                      () => CustomTextField(
                                        title: 'Email',
                                        focus: loginController.emailFocusNode,
                                        controller:
                                            loginController.emailController,
                                        borderColor:
                                            loginController.isValidated.value ==
                                                    false
                                                ? AppColors.redAlert
                                                : AppColors.greenSuccess,
                                        onChanged: (String value) {
                                          loginController.validateEmail(value);
                                        },
                                      ),
                                    ),
                                    const SpaceSizer(
                                      vertical: 2,
                                    ),
                                    CustomFlatButton(
                                        text: 'Send Link to Email',
                                        radius: 0.5,
                                        backgroundColor: AppColors.maroon,
                                        textColor: AppColors.white,
                                        onTap: () {
                                          loginController.resetPassword();
                                        }),
                                  ],
                                )))),
                    child: Center(
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: SizeConfig.horizontal(50)),
                        child: RobotoTextView(
                          value: 'Forgot Password',
                          size: SizeConfig.safeBlockHorizontal * 4,
                          color: AppColors.maroon,
                        ),
                      ),
                    )),
              ),
            ),
            const SpaceSizer(
              vertical: 2,
            ),
            Obx(
              () => CustomFlatButton(
                  loading: loginController.isLoading.value,
                  widthCircleLoading: 2,
                  heightCircleLoading: 2,
                  width: 80,
                  height: 8,
                  text: 'Login',
                  radius: 0.5,
                  textColor: AppColors.white,
                  textSize: SizeConfig.safeBlockHorizontal * 6,
                  backgroundColor: AppColors.maroon,
                  onTap: () async {
                    await loginController.signInWithEmailAndPassword();
                    loginController.emailController.clear();
                    loginController.passwordController.clear();
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RobotoTextView(
                  value: "Doesn't have an account?",
                  size: SizeConfig.safeBlockHorizontal * 5,
                  fontWeight: FontWeight.bold,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () => loginController.changeForm(),
                      child: RobotoTextView(
                        value: 'Sign Up',
                        size: SizeConfig.safeBlockHorizontal * 5,
                        color: AppColors.maroon,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
