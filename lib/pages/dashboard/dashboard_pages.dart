import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../controllers/dashboard_controller.dart';
import '../../utils/app_colors.dart';
import '../widgets/frame/frame_scaffold.dart';
import 'widgets/dashboard_pages_desktop.dart';

class DashboardPages extends StatelessWidget {
  const DashboardPages({super.key});

  @override
  Widget build(BuildContext context) {
    return FrameScaffold(
        heightBar: 0,
        elevation: 0,
        color: AppColors.black,
        statusBarColor: AppColors.black,
        colorScaffold: AppColors.greyDisabled,
        statusBarBrightness: Brightness.light,
        view: GetBuilder<DashboardController>(
          init: DashboardController(),
          builder: (DashboardController dashboardController) =>
              ScreenTypeLayout.builder(
                  desktop: (BuildContext p0) => DashboardPagesDesktop(
                        dashboardController: dashboardController,
                      ),
                  mobile: (BuildContext p0) => Container()),
        ));
  }
}
