import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../widgets/layout/space_sizer.dart';
import '../../widgets/text/roboto_text_view.dart';

class DashboardPagesDesktop extends StatelessWidget {
  const DashboardPagesDesktop({
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
            hoverColor: AppColors.maroonTransparent,
            selectedHoverColor: AppColors.greyDisabled,
            selectedColor: AppColors.maroon,
            selectedTitleTextStyle: const TextStyle(color: Colors.white),
            selectedIconColor: Colors.white,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.all(Radius.circular(10)),
            // ),
            // backgroundColor: Colors.grey[200]
          ),
          title: Column(
            children: <Widget>[
              ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: Container(
                      padding: EdgeInsets.all(SizeConfig.horizontal(2)),
                      decoration: BoxDecoration(
                          color: AppColors.white, shape: BoxShape.circle),
                      child: Icon(
                        Icons.person_2_rounded,
                        size: SizeConfig.safeBlockHorizontal * 4,
                      ))),
              const SpaceSizer(
                vertical: 0.5,
              ),
              RobotoTextView(
                value: 'Agus S',
                size: SizeConfig.safeBlockHorizontal * 1.5,
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
              badgeContent: const Text(
                '3',
                style: TextStyle(color: Colors.white),
              ),
              tooltipContent: 'This is a tooltip for Dashboard item',
            ),
            SideMenuItem(
              title: 'Users',
              onTap: (int index, _) {
                dashboardController.sideMenu.changePage(index);
              },
              icon: const Icon(Icons.supervisor_account),
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
                  badgeContent: const Text(
                    '3',
                    style: TextStyle(color: Colors.white),
                  ),
                  tooltipContent: 'Expansion Item 1',
                ),
                SideMenuItem(
                  title: 'Update Sheet',
                  onTap: (int index, _) {
                    dashboardController.sideMenu.changePage(index);
                  },
                  icon: const Icon(Icons.update_sharp),
                )
              ],
            ),
            SideMenuItem(
              title: 'Peminjaman',
              onTap: (int index, _) {
                dashboardController.sideMenu.changePage(index);
              },
              icon: const Icon(Icons.file_copy_rounded),
              trailing: Container(
                  decoration: BoxDecoration(
                      color: AppColors.greenDark,
                      borderRadius: const BorderRadius.all(Radius.circular(6))),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
                    child: Text(
                      'New',
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  )),
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
            const SideMenuItem(
              title: 'Log out',
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        const VerticalDivider(
          width: 0,
        ),
        Expanded(
          child: PageView(
            controller: dashboardController.pageController,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Users',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Expansion Item 1',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Expansion Item 2',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Files',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
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

              // this is for SideMenuItem with builder (divider)
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
