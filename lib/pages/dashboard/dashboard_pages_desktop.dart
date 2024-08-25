import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/dashboard_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/constant.dart';
import '../../utils/size_config.dart';
import '../widgets/custom/custom_flat_button.dart';
import '../widgets/custom/custom_text_field.dart';
import '../widgets/layout/space_sizer.dart';
import '../widgets/text/roboto_text_view.dart';
import 'widgets/dashboard_content.dart';
import 'widgets/tabel_check_sheet_content.dart';
import 'widgets/tabel_update_content.dart';
import 'widgets/tabel_users_data.dart';

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
              openSideMenuWidth: SizeConfig.horizontal(20),
              hoverColor: AppColors.blueTransparent,
              selectedHoverColor: AppColors.greyDisabled,
              selectedColor: AppColors.maroon,
              selectedTitleTextStyle: RobotoStyle().labelStyle(),
              selectedIconColor: AppColors.white,
              unselectedTitleTextStyle: RobotoStyle().unSelectedStyle()
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              // ),
              // backgroundColor: Colors.grey[200]
              ),
          title: Column(
            children: <Widget>[
              const SpaceSizer(
                vertical: 2,
              ),
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
            physics: const NeverScrollableScrollPhysics(),
            controller: dashboardController.pageController,
            children: <Widget>[
              DashboardContent(
                dashboardController: dashboardController,
              ),
              UsersDataTable(
                dashboardController: dashboardController,
              ),
              CheckSheetContent(
                dashboardController: dashboardController,
              ),
              UpdateSheet(
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

class UsersDataTable extends StatelessWidget {
  const UsersDataTable({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.horizontal(1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              RobotoTextView(
                value: 'Pages /',
                size: SizeConfig.safeBlockHorizontal * 1,
                color: AppColors.grey,
              ),
              RobotoTextView(
                value: ' Super Admin',
                size: SizeConfig.safeBlockHorizontal * 1,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(SizeConfig.horizontal(1)),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.redAlert,
                  borderRadius: BorderRadius.all(
                      Radius.circular(SizeConfig.horizontal(0.4)))),
              padding: EdgeInsets.all(SizeConfig.horizontal(0.8)),
              child: RobotoTextView(
                value: 'Super Admin',
                size: SizeConfig.safeBlockHorizontal * 1.3,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          const SpaceSizer(
            vertical: 4,
          ),
          CustomTextField(
            width: 15,
            title: 'Search by name',
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            textSize: SizeConfig.safeBlockHorizontal * 1.2,
          ),
          const SpaceSizer(
            vertical: 2,
          ),
          TabelUsersData(
            dashboardController: dashboardController,
          )
        ],
      ),
    );
  }
}

class UpdateSheet extends StatelessWidget {
  const UpdateSheet({
    super.key,
    required this.dashboardController,
  });
  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.horizontal(1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
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
                    value: 'Update Sheet',
                    size: SizeConfig.safeBlockHorizontal * 1,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            const SpaceSizer(
              vertical: 4,
            ),
            Row(
              children: <Widget>[
                CustomTextField(
                  width: 15,
                  height: SizeConfig.vertical(5),
                  title: 'No Asset',
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  textSize: SizeConfig.safeBlockHorizontal * 1,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.horizontal(2)),
                  child: CustomFlatButton(
                    width: 10,
                    radius: 0.5,
                    colorIconImage: AppColors.white,
                    iconSize: SizeConfig.safeBlockHorizontal * 1.2,
                    height: 5,
                    backgroundColor: AppColors.maroon,
                    textColor: AppColors.white,
                    text: 'Add New Asset',
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(SizeConfig.horizontal(2)))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CustomTextField(
                                width: 15,
                                height: SizeConfig.vertical(5),
                                title: 'No Asset',
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                textSize: SizeConfig.safeBlockHorizontal * 1.2,
                              ),
                              const SpaceSizer(
                                vertical: 2,
                              ),
                              CustomTextField(
                                width: 15,
                                height: SizeConfig.vertical(5),
                                title: 'Area',
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                textSize: SizeConfig.safeBlockHorizontal * 1.2,
                              ),
                              const SpaceSizer(
                                vertical: 2,
                              ),
                              CustomTextField(
                                width: 15,
                                height: SizeConfig.vertical(5),
                                title: 'PIC',
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                textSize: SizeConfig.safeBlockHorizontal * 1.2,
                              ),
                              const SpaceSizer(
                                vertical: 2,
                              ),
                              CustomTextField(
                                width: 15,
                                height: SizeConfig.vertical(5),
                                title: 'Category',
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                textSize: SizeConfig.safeBlockHorizontal * 1.2,
                              ),
                              const SpaceSizer(
                                vertical: 2,
                              ),
                              CustomTextField(
                                width: 15,
                                height: SizeConfig.vertical(5),
                                title: 'Ruangan',
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                textSize: SizeConfig.safeBlockHorizontal * 1.2,
                              ),
                              const SpaceSizer(
                                vertical: 2,
                              ),
                              CustomTextField(
                                width: 15,
                                height: SizeConfig.vertical(5),
                                title: 'Tahun Asset',
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                textSize: SizeConfig.safeBlockHorizontal * 1.2,
                              ),
                              const SpaceSizer(
                                vertical: 2,
                              ),
                              CustomTextField(
                                width: 15,
                                height: SizeConfig.vertical(5),
                                title: 'Image Upload',
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                textSize: SizeConfig.safeBlockHorizontal * 1.2,
                              ),
                              const SpaceSizer(
                                vertical: 2,
                              ),
                              CustomFlatButton(
                                width: 16,
                                height: 5,
                                backgroundColor: AppColors.maroon,
                                textColor: AppColors.white,
                                text: 'Send',
                                radius: 0.8,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    icon: Icons.add,
                  ),
                )
              ],
            ),
            const SpaceSizer(
              vertical: 2,
            ),
            const TabelUpdateContent(),
            const SpaceSizer(
              vertical: 2,
            ),
            Center(
              child: CustomFlatButton(
                width: 20,
                backgroundColor: AppColors.maroon,
                textColor: AppColors.white,
                text: 'Send',
                onTap: () {},
              ),
            )
          ],
        ),
      ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RobotoTextView(
                        value: 'Pages /',
                        size: SizeConfig.safeBlockHorizontal * 1,
                        color: AppColors.grey,
                      ),
                      RobotoTextView(
                        value: ' CheckSheet',
                        size: SizeConfig.safeBlockHorizontal * 1,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.horizontal(1)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.maroon,
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.horizontal(0.4)))),
                      padding: EdgeInsets.all(SizeConfig.horizontal(0.8)),
                      child: RobotoTextView(
                        value: 'CheckSheet',
                        size: SizeConfig.safeBlockHorizontal * 1.3,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
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
