import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/assets_list.dart';
import '../../../utils/size_config.dart';
import '../../widgets/custom/custom_flat_button.dart';
import '../../widgets/custom/custom_text_field.dart';
import '../../widgets/layout/space_sizer.dart';
import '../../widgets/text/roboto_text_view.dart';

class LoginPagesMobile extends StatelessWidget {
  const LoginPagesMobile({
    super.key,
    required this.focusNodeEmail,
    required this.focusNodePassword,
  });

  final FocusNode focusNodeEmail;
  final FocusNode focusNodePassword;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.horizontal(0.5)))),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RobotoTextView(
                value: 'Welcome Back!',
                size: SizeConfig.safeBlockHorizontal * 4,
                fontWeight: FontWeight.bold,
              ),
              const SpaceSizer(
                vertical: 1,
              ),
              RobotoTextView(
                value: 'Continue with Google or enter your details.',
                size: SizeConfig.safeBlockHorizontal * 3.5,
              ),
              const SpaceSizer(
                vertical: 2,
              ),
              CustomFlatButton(
                width: 75,
                image: AssetList.googleIcon,
                text: 'Login with Google',
                textSize: SizeConfig.safeBlockHorizontal * 3.5,
                radius: 0.5,
                borderColor: AppColors.maroon,
                onTap: () {},
              ),
              const SpaceSizer(
                vertical: 5,
              ),
              CustomTextField(
                title: 'Email',
                focus: focusNodeEmail,
                width: 75,
                textSize: SizeConfig.safeBlockHorizontal * 3.5,
              ),
              const SpaceSizer(
                vertical: 3,
              ),
              CustomTextField(
                title: 'Password',
                focus: focusNodePassword,
                textSize: SizeConfig.safeBlockHorizontal * 3.5,
                width: 75,
                isPasswordField: true,
              ),
              Padding(
                padding: EdgeInsets.only(right: SizeConfig.horizontal(12)),
                child: Row(
                  children: <Widget>[
                    const Spacer(),
                    TextButton(
                        onPressed: () {},
                        child: RobotoTextView(
                          value: 'Forgot Password',
                          size: SizeConfig.safeBlockHorizontal * 3.5,
                          color: AppColors.maroon,
                        )),
                  ],
                ),
              ),
              const SpaceSizer(
                vertical: 3,
              ),
              CustomFlatButton(
                text: 'Login',
                radius: 0.5,
                textColor: AppColors.white,
                textSize: SizeConfig.safeBlockHorizontal * 3.5,
                width: 75,
                backgroundColor: AppColors.maroon,
                onTap: () {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RobotoTextView(
                    value: "Doesn't have an account?",
                    size: SizeConfig.safeBlockHorizontal * 3.5,
                    fontWeight: FontWeight.bold,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {},
                        child: RobotoTextView(
                          value: 'Sign Up',
                          size: SizeConfig.safeBlockHorizontal * 3.5,
                          color: AppColors.maroon,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
