import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../controllers/login_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/assets_list.dart';
import '../../../utils/size_config.dart';
import '../../widgets/custom/custom_flat_button.dart';
import '../../widgets/custom/custom_text_field.dart';
import '../../widgets/layout/space_sizer.dart';
import '../../widgets/text/roboto_text_view.dart';

class LoginPagesDesktop extends StatelessWidget {
  const LoginPagesDesktop({
    super.key,
    required this.loginController,
  });

  final LoginController loginController;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: SizeConfig.horizontal(49.4),
          child: Center(
            child: Image.asset(
              AssetList.coverLogo,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        const SpaceSizer(
          horizontal: 6,
        ),
        if (loginController.isTappedSignUp.isTrue)
          RegisterForm(loginController: loginController)
        else
          LoginForm(loginController: loginController),
      ],
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({
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
      width: SizeConfig.horizontal(38),
      height: SizeConfig.horizontal(43),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RobotoTextView(
              value: 'Create Account',
              size: SizeConfig.safeBlockHorizontal * 2,
              fontWeight: FontWeight.bold,
            ),
            const SpaceSizer(
              vertical: 1,
            ),
            RobotoTextView(
              value: 'Continue with Google or enter your details.',
              size: SizeConfig.safeBlockHorizontal * 1,
            ),
            const SpaceSizer(
              vertical: 2,
            ),
            CustomFlatButton(
                image: AssetList.googleIcon,
                text: 'Login with Google',
                radius: 0.5,
                borderColor: AppColors.maroon,
                onTap: () => loginController.signInWithGoogle()),
            const SpaceSizer(
              vertical: 5,
            ),
            CustomTextField(
              title: 'Fullname',
              focus: loginController.fullnameFocusNode,
              controller: loginController.fullNameController,
              borderColor: loginController.isValidatedFullname.value == false
                  ? AppColors.redAlert
                  : AppColors.greenSuccess,
              onChanged: (String value) {
                loginController.validateFullName(value);
              },
            ),
            const SpaceSizer(vertical: 0.5),
            CustomTextField(
              title: 'Email',
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
                      size: SizeConfig.safeBlockHorizontal * 1,
                      color: AppColors.yellowWarning,
                    ),
                  ],
                ),
              )
            else
              const SizedBox.shrink(),
            const SpaceSizer(vertical: 0.5),
            CustomTextField(
              title: 'Password',
              isPasswordField: true,
              controller: loginController.passwordController,
              focus: loginController.passwordFocusNode,
            ),
            const SpaceSizer(vertical: 0.5),
            CustomTextField(
              title: 'Confirm Password',
              isPasswordField: true,
              controller: loginController.confirmPasswordController,
              focus: loginController.confirmPasswordFocusNode,
            ),
            const SpaceSizer(
              vertical: 3,
            ),
            CustomFlatButton(
              text: 'Create Account',
              radius: 0.5,
              textColor: AppColors.white,
              backgroundColor: AppColors.maroon,
              onTap: () => loginController.signUpWithEmailAndPassword(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RobotoTextView(
                  value: 'Already have an account?',
                  size: SizeConfig.safeBlockHorizontal * 1,
                  fontWeight: FontWeight.bold,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () => loginController.changeForm(),
                      child: RobotoTextView(
                        value: 'back to Login',
                        size: SizeConfig.safeBlockHorizontal * 1,
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

class LoginForm extends StatelessWidget {
  const LoginForm({
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
      width: SizeConfig.horizontal(38),
      height: SizeConfig.horizontal(38),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RobotoTextView(
              value: 'Welcome Back!',
              size: SizeConfig.safeBlockHorizontal * 2,
              fontWeight: FontWeight.bold,
            ),
            const SpaceSizer(
              vertical: 1,
            ),
            RobotoTextView(
              value: 'Continue with Google or enter your details.',
              size: SizeConfig.safeBlockHorizontal * 1,
            ),
            const SpaceSizer(
              vertical: 2,
            ),
            CustomFlatButton(
                image: AssetList.googleIcon,
                text: 'Login with Google',
                radius: 0.5,
                borderColor: AppColors.maroon,
                // onTap: () => loginController.signInWithGoogle(),
                onTap: () => context.goNamed('dashboard')),
            const SpaceSizer(
              vertical: 5,
            ),
            CustomTextField(
              title: 'Email',
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
                      size: SizeConfig.safeBlockHorizontal * 1,
                      color: AppColors.yellowWarning,
                    ),
                  ],
                ),
              )
            else
              const SizedBox.shrink(),
            const SpaceSizer(
              vertical: 3,
            ),
            CustomTextField(
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
                    onPressed: () {},
                    child: RobotoTextView(
                      value: 'Forgot Password',
                      size: SizeConfig.safeBlockHorizontal * 1,
                      color: AppColors.maroon,
                    )),
              ),
            ),
            const SpaceSizer(
              vertical: 3,
            ),
            CustomFlatButton(
              text: 'Login',
              radius: 0.5,
              textColor: AppColors.white,
              backgroundColor: AppColors.maroon,
              onTap: () {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RobotoTextView(
                  value: "Doesn't have an account?",
                  size: SizeConfig.safeBlockHorizontal * 1,
                  fontWeight: FontWeight.bold,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () => loginController.changeForm(),
                      child: RobotoTextView(
                        value: 'Sign Up',
                        size: SizeConfig.safeBlockHorizontal * 1,
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
