import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/constant.dart';
import '../../utils/size_config.dart';
import '../dashboard_desktop/widgets/tabel_check_sheet_content.dart';
import '../widgets/custom/custom_flat_button.dart';
import '../widgets/layout/space_sizer.dart';
import '../widgets/text/roboto_text_view.dart';
import 'admin_panel.mobile.dart';
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
                  tooltipContent: 'Expansion Item 1',
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
              CheckSheetContent(
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


class CheckSheetContent extends StatelessWidget {
  const CheckSheetContent({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    final List<_ChartData> chartData = <_ChartData>[
      _ChartData(
        'Ideal',
        50,
        55,
      ),
      _ChartData('Other', 10, 0),
    ];
    return SingleChildScrollView(
      child: Container(
        color: AppColors.greySecond,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.horizontal(1)),
              child: Row(
                children: <Widget>[
                  RobotoTextView(
                    value: 'Pages /',
                    size: SizeConfig.safeBlockHorizontal * 1,
                    color: AppColors.grey,
                  ),
                  const SpaceSizer(
                    horizontal: 0.5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.maroon,
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.horizontal(0.4)))),
                    padding: EdgeInsets.all(SizeConfig.horizontal(0.4)),
                    child: RobotoTextView(
                      value: 'Check Sheet',
                      size: SizeConfig.safeBlockHorizontal * 1,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: SizeConfig.horizontal(3)),
                  child: SizedBox(
                    width: SizeConfig.horizontal(12),
                    height: SizeConfig.horizontal(18),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        margin: EdgeInsets.symmetric(
                            vertical: SizeConfig.horizontal(2)),
                        width: SizeConfig.horizontal(10),
                        child: ExpansionTile(
                            iconColor: AppColors.maroon,
                            collapsedBackgroundColor: AppColors.white,
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig.horizontal(0.3)))),
                            collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    SizeConfig.horizontal(0.3)))),
                            title: RobotoTextView(
                              value: ConstantString().columnMenu[index],
                              size: SizeConfig.safeBlockHorizontal * 1,
                            )),
                      ),
                    ),
                  ),
                ),
                const SpaceSizer(
                  horizontal: 2,
                ),
                Container(
                  width: SizeConfig.horizontal(45),
                  height: SizeConfig.horizontal(15),
                  color: AppColors.white,
                  child: SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    title: const ChartTitle(text: 'Status Check'),
                    legend: const Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap,
                    ),
                    primaryXAxis: const CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                    ),
                    primaryYAxis: const NumericAxis(
                        rangePadding: ChartRangePadding.none,
                        axisLine: AxisLine(width: 0),
                        majorTickLines: MajorTickLines(size: 0)),
                    series: <CartesianSeries<_ChartData, String>>[
                      StackedColumn100Series<_ChartData, String>(
                          dataSource: chartData,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                          xValueMapper: (_ChartData sales, _) => sales.x,
                          yValueMapper: (_ChartData sales, _) => sales.y1,
                          name: 'Product A'),
                      StackedColumn100Series<_ChartData, String>(
                          dataSource: chartData,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                          xValueMapper: (_ChartData sales, _) => sales.x,
                          yValueMapper: (_ChartData sales, _) => sales.y2,
                          name: 'Product B'),
                    ],
                    tooltipBehavior: dashboardController.tooltipBehavior,
                  ),
                ),
                const SpaceSizer(
                  horizontal: 2,
                ),
                Container(
                  width: SizeConfig.horizontal(12),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.maroon)),
                  child: Column(
                    children: <Widget>[
                      RobotoTextView(
                        value: '% Check',
                        size: SizeConfig.safeBlockHorizontal * 2,
                      ),
                      Divider(
                        thickness: 1.0,
                        color: AppColors.maroon,
                      ),
                      RobotoTextView(
                        value: '61%',
                        color: AppColors.maroon,
                        size: SizeConfig.safeBlockHorizontal * 2.5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const TabelCheckSheetContent()
          ],
        ),
      ),
    );
  }
}

/// Private class for storing the stacked column series data points.
class _ChartData {
  _ChartData(
    this.x,
    this.y1,
    this.y2,
  );
  final String x;
  final num y1;
  final num y2;
}
