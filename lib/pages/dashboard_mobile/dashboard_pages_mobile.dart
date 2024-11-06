import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/size_config.dart';
import '../widgets/custom/custom_flat_button.dart';
import '../widgets/layout/space_sizer.dart';
import '../widgets/text/roboto_text_view.dart';
import 'admin_panel_mobile.dart';
import 'check_sheet_mobile.dart';
import 'update_sheet_mobile.dart';
import 'widgets/dashboard_content_mobile.dart';

class DashboardPagesMobile extends StatelessWidget {
  const DashboardPagesMobile({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SideMenu(
          controller: dashboardController.sideMenu,
          style: SideMenuStyle(
              showHamburger: true,
              displayMode: SideMenuDisplayMode.compact,
              openSideMenuWidth: SizeConfig.horizontal(500),
              hoverColor: AppColors.blueTransparent,
              selectedHoverColor: AppColors.greyDisabled,
              selectedColor: AppColors.maroon,
              selectedTitleTextStyle: RobotoStyle().labelStyle(),
              selectedIconColor: AppColors.white,
              unselectedTitleTextStyle: RobotoStyle().unSelectedStyle()),
          title: Column(
            children: <Widget>[
              const SpaceSizer(
                vertical: 2,
              ),
              ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 90,
                    maxWidth: 90,
                  ),
                  child: Container(
                      padding: EdgeInsets.all(SizeConfig.horizontal(2)),
                      decoration: BoxDecoration(
                          color: AppColors.white, shape: BoxShape.circle),
                      child: Icon(
                        Icons.person_2_rounded,
                        size: SizeConfig.safeBlockHorizontal * 6,
                      ))),
              const SpaceSizer(
                vertical: 0.5,
              ),
              RobotoTextView(
                value: dashboardController.username.value,
                size: SizeConfig.safeBlockHorizontal * 3,
                fontWeight: FontWeight.w600,
              ),
              const Divider(
                indent: 8.0,
                endIndent: 8.0,
              ),
            ],
          ),
          items: <dynamic>[
            SideMenuItem(
              title: 'Dashboard',
              onTap: (int index, _) {
                dashboardController.sideMenu.changePage(index);
              },
              icon: const Icon(Icons.home),
            ),
            if (dashboardController.userRole.value == 'Super Admin' ||
                dashboardController.userRole.value == 'Admin')
              SideMenuItem(
                title: 'Admin Panel',
                onTap: (int index, _) {
                  dashboardController.sideMenu.changePage(index);
                },
                icon: const Icon(Icons.supervisor_account),
              )
            else
              SideMenuItem(
                title: 'Peminjaman',
                onTap: (int index, _) {
                  dashboardController.sideMenu.changePage(index);
                },
                icon: const Icon(Icons.file_copy_rounded),
                trailing: Container(
                    decoration: BoxDecoration(
                        color: AppColors.greenDark,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6))),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
                      child: Text(
                        'New',
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    )),
              ),
            SideMenuExpansionItem(
              title: 'Sheet',
              icon: const Icon(Icons.kitchen),
              children: <SideMenuItem>[
                SideMenuItem(
                  title: 'Check Sheet',
                  onTap: (int index, _) {
                    dashboardController.sideMenu.changePage(index);
                  },
                  icon: const Icon(Icons.check_box_sharp),
                  tooltipContent: 'Check Sheet',
                ),
                SideMenuItem(
                  title: 'Update Sheet',
                  onTap: (int index, _) {
                    dashboardController.sideMenu.changePage(index);
                  },
                  icon: const Icon(Icons.update_sharp),
                ),
              ],
            ),
            SideMenuItem(
              title: 'Pengembalian',
              onTap: (int index, _) {
                dashboardController.sideMenu.changePage(index);
              },
              icon: const Icon(Icons.download),
            ),
            SideMenuItem(
              builder: (BuildContext context, SideMenuDisplayMode displayMode) {
                return const Divider(
                  endIndent: 8,
                  indent: 8,
                );
              },
            ),
            SideMenuItem(
              title: 'Settings',
              onTap: (int index, _) {
                dashboardController.sideMenu.changePage(index);
              },
              icon: const Icon(Icons.settings),
            ),
            SideMenuItem(
              onTap: (int index, SideMenuController sideMenuController) {
                final AuthController authController = Get.put(AuthController());
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Container(
                      padding: EdgeInsets.all(SizeConfig.horizontal(2)),
                      width: SizeConfig.horizontal(20),
                      height: SizeConfig.horizontal(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RobotoTextView(
                            value: 'Apakah anda yakin?',
                            size: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          const SpaceSizer(
                            vertical: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              CustomFlatButton(
                                  width: 20,
                                  height: 5,
                                  textSize: SizeConfig.safeBlockHorizontal * 3,
                                  backgroundColor: AppColors.maroon,
                                  textColor: AppColors.white,
                                  text: 'Log out',
                                  onTap: () async {
                                    authController.signOut();
                                    Get.back();
                                  }),
                              CustomFlatButton(
                                textSize: SizeConfig.safeBlockHorizontal * 3,
                                width: 20,
                                height: 5,
                                backgroundColor: AppColors.redAlert,
                                textColor: AppColors.white,
                                text: 'Batal',
                                onTap: () => Get.back(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              title: 'Log out',
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
        const VerticalDivider(
          width: 0,
        ),
        Expanded(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: dashboardController.pageController,
            children: <Widget>[
              DashboardContentMobile(
                dashboardController: dashboardController,
              ),
              if (dashboardController.userRole.value == 'Super Admin' ||
                  dashboardController.userRole.value == 'Admin')
                AdminPanelMobile(
                  dashboardController: dashboardController,
                )
              else
                Container(),
              CheckSheetMobile(
                dashboardController: dashboardController,
              ),
              UpdateSheetMobile(
                dashboardController: dashboardController,
              ),
              Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Download',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              const SizedBox.shrink(),
              Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
