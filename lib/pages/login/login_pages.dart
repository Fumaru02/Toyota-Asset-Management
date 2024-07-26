import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../controllers/login_controller.dart';
import '../../utils/app_colors.dart';
import '../widgets/frame/frame_scaffold.dart';
import 'widgets/login_pages_desktop.dart';
import 'widgets/login_pages_mobile.dart';

class LoginPages extends StatelessWidget {
  const LoginPages({super.key});

  @override
  Widget build(BuildContext context) {
    return FrameScaffold(
        heightBar: 0,
        elevation: 0,
        color: AppColors.black,
        statusBarColor: AppColors.black,
        colorScaffold: AppColors.greyDisabled,
        statusBarBrightness: Brightness.light,
        view: GetBuilder<LoginController>(
          init: LoginController(),
          builder: (LoginController loginController) =>
              ScreenTypeLayout.builder(
            desktop: (BuildContext p0) => LoginPagesDesktop(
              loginController: loginController,
            ),
            mobile: (BuildContext p0) => LoginPagesMobile(
              focusNodeEmail: loginController.emailFocusNode,
              focusNodePassword: loginController.passwordFocusNode,
            ),
          ),
        ));
  }
}
