import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../controllers/dashboard_controller.dart';
import '../utils/app_colors.dart';
import 'dashboard_desktop/dashboard_pages_desktop.dart';
import 'dashboard_mobile/dashboard_pages_mobile.dart';
import 'widgets/frame/frame_scaffold.dart';

class DashboardPages extends StatelessWidget {
  const DashboardPages({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FrameScaffold(
          heightBar: 0,
          elevation: 0,
          color: AppColors.black,
          statusBarColor: AppColors.black,
          colorScaffold: AppColors.greySecond,
          statusBarBrightness: Brightness.light,
          view: GetBuilder<DashboardController>(
            init: DashboardController(),
            builder: (DashboardController dashboardController) =>
                ScreenTypeLayout.builder(
                    desktop: (BuildContext p0) => DashboardPagesDesktop(
                          dashboardController: dashboardController,
                        ),
                    mobile: (BuildContext p0) => DashboardPagesMobile(
                          dashboardController: dashboardController,
                        )),
          )),
    );
  }
}
