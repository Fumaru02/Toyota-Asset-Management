import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../widgets/custom/custom_flat_button.dart';
import '../../widgets/custom/custom_text_field.dart';
import '../../widgets/layout/space_sizer.dart';
import '../../widgets/text/roboto_text_view.dart';
import 'tabel_dashboard_content.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    const List<String> list = <String>['Karawang', 'Two', 'Three', 'Four'];
    return SingleChildScrollView(
      child: Container(
          color: AppColors.white,
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
                          value: 'Dashboard',
                          size: SizeConfig.safeBlockHorizontal * 1,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    const Column(
                      children: <Widget>[
                        CustomDropDown(
                          list: list,
                          titleDropDown: 'Area',
                        ),
                      ],
                    ),
                    const SpaceSizer(
                      horizontal: 2,
                    ),
                    Column(
                      children: <Widget>[
                        CustomTextField(
                          style: RobotoStyle().textfieldStyle(),
                          title: 'PIC',
                          textSize: SizeConfig.blockSizeHorizontal * 1,
                          height: SizeConfig.vertical(4),
                          width: 20,
                          borderRadius: 0,
                        ),
                      ],
                    ),
                    const SpaceSizer(
                      horizontal: 3,
                    ),
                    CustomFlatButton(
                      width: 4,
                      radius: 0.5,
                      backgroundColor: AppColors.maroon,
                      textColor: AppColors.white,
                      text: '',
                      icon: Icons.calendar_month_sharp,
                      colorIconImage: AppColors.white,
                      onTap: () {},
                    )
                  ],
                ),
                const SpaceSizer(
                  vertical: 1,
                ),
                Row(
                  children: <Widget>[
                    const SpaceSizer(
                      horizontal: 0.5,
                    ),
                    Container(
                        color: AppColors.white,
                        width: SizeConfig.horizontal(75),
                        height: SizeConfig.horizontal(20),
                        child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                              maximum: 6,
                              axisLabelFormatter:
                                  (AxisLabelRenderDetails details) {
                                String label;
                                switch (details.value.toInt()) {
                                  case 0:
                                    label = 'TLC1 KRW';
                                    break;
                                  case 1:
                                    label = 'TLC3 KRW';
                                    break;
                                  case 2:
                                    label = 'TLC2 STR';
                                    break;
                                  case 3:
                                    label = 'Sunter 1';
                                    break;
                                  case 4:
                                    label = 'AKTI';
                                    break;
                                  case 5:
                                    label = 'HO';
                                    break;
                                  default:
                                    label = '';
                                }
                                return ChartAxisLabel(label, details.textStyle);
                              },
                            ),

                            // Chart title
                            title:
                                const ChartTitle(text: 'Status check by Area'),
                            // Enable legend
                            legend: const Legend(isVisible: true),

                            // Enable tooltip
                            tooltipBehavior:
                                dashboardController.tooltipBehavior,
                            series: <ColumnSeries<SalesData, int>>[
                              ColumnSeries<SalesData, int>(
                                name: 'Total Asset',
                                spacing: 0.1,
                                dataSource: <SalesData>[
                                  SalesData(
                                    'TLC#1',
                                    1,
                                    32,
                                  ),
                                  SalesData(
                                    'TLC#1',
                                    2,
                                    22,
                                  ),
                                  SalesData(
                                    'TLC#1',
                                    3,
                                    32,
                                  ),
                                  SalesData(
                                    'TLC#1',
                                    4,
                                    33,
                                  ),
                                  SalesData(
                                    'TLC#1',
                                    5,
                                    31,
                                  ),
                                  SalesData(
                                    'TLC#1',
                                    6,
                                    31,
                                  )
                                ],
                                xValueMapper: (SalesData sales, _) =>
                                    sales.month,
                                yValueMapper: (SalesData sales, _) =>
                                    sales.sales,
                                // Enable data label
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      fontSize:
                                          SizeConfig.safeBlockHorizontal * 0.8),
                                ),
                                // Set column width and spacing
                                width: 0.4,
                              ),
                              ColumnSeries<SalesData, int>(
                                name: 'Asset Checked',
                                color: AppColors.orangeActive,
                                dataSource: <SalesData>[
                                  SalesData(
                                    'TLC#1',
                                    1,
                                    1,
                                  ),
                                  SalesData(
                                    'TLC#1',
                                    2,
                                    28,
                                  ),
                                  SalesData(
                                    'TLC#1',
                                    3,
                                    34,
                                  ),
                                  SalesData(
                                    'TLC#1',
                                    4,
                                    32,
                                  ),
                                  SalesData(
                                    'TLC#1',
                                    5,
                                    40,
                                  ),
                                  SalesData(
                                    'TLC#1',
                                    6,
                                    40,
                                  )
                                ],
                                xValueMapper: (SalesData sales, _) =>
                                    sales.month,
                                yValueMapper: (SalesData sales, _) =>
                                    sales.sales,
                                // Enable data label
                                dataLabelSettings: DataLabelSettings(
                                  textStyle: TextStyle(
                                      fontSize:
                                          SizeConfig.safeBlockHorizontal * 0.8),
                                  isVisible: true,
                                ),
                                // Set column width and spacing
                                width: 0.4,
                              )
                            ])),
                    const SpaceSizer(
                      horizontal: 1,
                    ),
                    // GraphPIC(dashboardController: dashboardController),
                  ],
                ),
                const SpaceSizer(
                  vertical: 5,
                ),
                const TabelDashboardContent()
              ])),
    );
  }
// ... (kode lainnya tetap sama)
}

class GraphPIC extends StatelessWidget {
  const GraphPIC({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.white,
        width: SizeConfig.horizontal(40),
        height: SizeConfig.horizontal(20),
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              maximum: 6,
              axisLabelFormatter: (AxisLabelRenderDetails details) {
                String label;
                switch (details.value.toInt()) {
                  case 0:
                    label = 'TLC#1';
                    break;
                  case 1:
                    label = 'TLC#2';
                    break;
                  case 2:
                    label = 'TLC#3';
                    break;
                  case 3:
                    label = 'Sunter 1';
                    break;
                  case 4:
                    label = 'AKTI';
                    break;
                  case 5:
                    label = 'Other';
                    break;
                  default:
                    label = '';
                }
                return ChartAxisLabel(label, details.textStyle);
              },
            ),

            // Chart title
            title: const ChartTitle(text: 'Status check by PIC'),
            // Enable legend
            legend: const Legend(isVisible: true),

            // Enable tooltip
            tooltipBehavior: dashboardController.tooltipBehavior,
            series: <ColumnSeries<SalesData, int>>[
              ColumnSeries<SalesData, int>(
                name: 'Total Asset',
                spacing: 0.1,
                dataSource: <SalesData>[
                  SalesData(
                    'TLC#1',
                    1,
                    32,
                  ),
                  SalesData(
                    'TLC#1',
                    2,
                    22,
                  ),
                  SalesData(
                    'TLC#1',
                    3,
                    32,
                  ),
                  SalesData(
                    'TLC#1',
                    4,
                    33,
                  ),
                  SalesData(
                    'TLC#1',
                    5,
                    31,
                  ),
                  SalesData(
                    'TLC#1',
                    6,
                    31,
                  )
                ],
                xValueMapper: (SalesData sales, _) => sales.month,
                yValueMapper: (SalesData sales, _) => sales.sales,
                // Enable data label
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle:
                      TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 0.8),
                ),
                // Set column width and spacing
                width: 0.4,
              ),
              ColumnSeries<SalesData, int>(
                name: 'Asset Checked',
                color: AppColors.orangeActive,
                dataSource: <SalesData>[
                  SalesData(
                    'TLC#1',
                    1,
                    35,
                  ),
                  SalesData(
                    'TLC#1',
                    2,
                    28,
                  ),
                  SalesData(
                    'TLC#1',
                    3,
                    34,
                  ),
                  SalesData(
                    'TLC#1',
                    4,
                    32,
                  ),
                  SalesData(
                    'TLC#1',
                    5,
                    40,
                  ),
                  SalesData(
                    'TLC#1',
                    6,
                    40,
                  )
                ],
                xValueMapper: (SalesData sales, _) => sales.month,
                yValueMapper: (SalesData sales, _) => sales.sales,
                // Enable data label
                dataLabelSettings: DataLabelSettings(
                  textStyle:
                      TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 0.8),
                  isVisible: true,
                ),
                // Set column width and spacing
                width: 0.4,
              )
            ]));
  }
}

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.list,
    required this.titleDropDown,
  });

  final List<String> list;
  final String titleDropDown;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.horizontal(1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RobotoTextView(
            value: titleDropDown,
            size: SizeConfig.safeBlockHorizontal * 1,
            fontWeight: FontWeight.w500,
          ),
          Container(
            width: SizeConfig.horizontal(20),
            height: SizeConfig.horizontal(2),
            decoration:
                BoxDecoration(border: Border.all(color: AppColors.black)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: list.first,
                icon: const Icon(Icons.arrow_drop_down),
                style: RobotoStyle().dropdownStyle(),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.horizontal(0.2)),
                      child: RobotoTextView(
                        value: value,
                        size: SizeConfig.safeBlockHorizontal * 1,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(
    this.title,
    this.month,
    this.sales,
  );

  final String title;
  final int month;
  final double sales;
}
