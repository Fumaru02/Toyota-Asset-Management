import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/check_sheet_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/update_sheet_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/size_config.dart';
import '../widgets/layout/space_sizer.dart';
import '../widgets/text/roboto_text_view.dart';
import 'dashboard_content.dart';
import 'widgets/tabel_check_sheet_content.dart';

class CheckSheetDesktop extends StatelessWidget {
  const CheckSheetDesktop({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    final UpdateSheetController updateSheetController =
        Get.put(UpdateSheetController());
    final CheckSheetController checkSheetController =
        Get.put(CheckSheetController());
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
                const SpaceSizer(
                  horizontal: 2,
                ),
                Column(
                  children: <Widget>[
                    CustomDropDownForm(
                      width: 15,
                      selectedDropdown: () async {
                        await dashboardController.getPics(
                            updateSheetController.onChangedDropDownForm.value);
                        await updateSheetController.getLocationArea(
                            updateSheetController.onChangedDropDownForm.value);
                        checkSheetController.onChangedDropDownForm.value =
                            updateSheetController.onChangedDropDownForm.value;
                      },
                      list: dashboardController.area,
                      titleDropDown: 'Area',
                      onChangedDropDownValue:
                          updateSheetController.onChangedDropDownForm,
                      initialDropdown:
                          updateSheetController.dropdownInitialArea,
                    ),
                    const SpaceSizer(
                      vertical: 1,
                    ),
                    CustomDropDownForm(
                      width: 15,
                      selectedDropdown: () {
                        updateSheetController.picValue.value =
                            updateSheetController.onChangedDropDownPIC.value;
                        dashboardController.countPicHandled(
                            updateSheetController.onChangedDropDownPIC.value);
                      },
                      list: dashboardController.areaPics,
                      titleDropDown: 'PIC',
                      onChangedDropDownValue:
                          updateSheetController.onChangedDropDownPIC,
                      initialDropdown: updateSheetController.dropdownInitialPIC,
                    ),
                    //todo:
                    // const SpaceSizer(
                    //   vertical: 1,
                    // ),
                    // CustomDropDownForm(
                    //   width: 15,
                    //   selectedDropdown: () {
                    //     updateSheetController.locationValue.value =
                    //         updateSheetController
                    //             .onChangedDropDownLocation.value;
                    //   },
                    //   list: checkSheetController.picLocations,
                    //   titleDropDown: 'Location',
                    //   onChangedDropDownValue:
                    //       updateSheetController.onChangedDropDownLocation,
                    //   initialDropdown:
                    //       updateSheetController.initialDropDownForm,
                    // ),
                    const SpaceSizer(
                      vertical: 2,
                    ),
                  ],
                ),
                const SpaceSizer(
                  horizontal: 2,
                ),
                Obx(
                  () => updateSheetController.onChangedDropDownPIC.value ==
                              '' ||
                          updateSheetController.onChangedDropDownPIC.value ==
                              'PIC'
                      ? GraphicsCheckSheet(
                          checkSheetController: checkSheetController,
                          dashboardController: dashboardController)
                      : GrapichSelectedPICCheckSheet(
                          checkSheetController: checkSheetController,
                          dashboardController: dashboardController,
                          updateSheetController: updateSheetController,
                        ),
                ),
                const SpaceSizer(
                  horizontal: 1,
                ),
                Container(
                  width: SizeConfig.horizontal(9),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.maroon)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: SizeConfig.horizontal(10),
                        color: AppColors.maroon,
                        child: Center(
                          child: RobotoTextView(
                            color: AppColors.white,
                            value: 'Check Total',
                            size: SizeConfig.safeBlockHorizontal * 1,
                          ),
                        ),
                      ),
                      const SpaceSizer(
                        vertical: 0.5,
                      ),
                      Obx(
                        () => RobotoTextView(
                          value:
                              '${dashboardController.totalPersentase.value.toInt()}%',
                          color: AppColors.maroon,
                          size: SizeConfig.safeBlockHorizontal * 1.5,
                        ),
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

class GrapichSelectedAreaCheckSheet extends StatelessWidget {
  const GrapichSelectedAreaCheckSheet({
    super.key,
    this.height,
    this.width,
    this.fontSize,
    required this.dashboardController,
    required this.checkSheetController,
  });

  final double? height;
  final double? width;
  final double? fontSize;
  final DashboardController dashboardController;
  final CheckSheetController checkSheetController;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: AppColors.white,
        width: SizeConfig.horizontal(width ?? 40),
        height: SizeConfig.horizontal(height ?? 20),
        child: Center(
          // Tambahkan Center di sini
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  String label;
                  switch (details.value.toInt()) {
                    case 0:
                      label = dashboardController.onChangedDropDownArea.value;
                      break;
                    default:
                      label = '';
                  }
                  return ChartAxisLabel(label, details.textStyle);
                },
              ),
              title: ChartTitle(
                  text:
                      'Status check ${checkSheetController.onChangedDropDownForm.value}',
                  textStyle: TextStyle(
                      fontSize:
                          fontSize ?? SizeConfig.safeBlockHorizontal * 1)),
              legend: const Legend(isVisible: true),
              tooltipBehavior: checkSheetController.tooltipBehavior,
              series: <ColumnSeries<SalesData, int>>[
                ColumnSeries<SalesData, int>(
                  name: 'Total Asset',
                  spacing: 0.1,
                  dataSource: <SalesData>[
                    SalesData(
                      '',
                      1,
                      dashboardController.selectedAreaTotalAsset.value
                          .toDouble(),
                    ),
                  ],
                  xValueMapper: (SalesData sales, _) => sales.month,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(
                        fontSize:
                            fontSize ?? SizeConfig.safeBlockHorizontal * 0.8),
                  ),
                  width: 1,
                ),
                ColumnSeries<SalesData, int>(
                  name: 'Asset Checked',
                  color: AppColors.orangeActive,
                  dataSource: <SalesData>[
                    SalesData(
                      '',
                      1,
                      dashboardController.selectedAreaTotalAssetChecked
                          .value //lanjut sort/live per area
                          .toDouble(),
                    ),
                  ],
                  xValueMapper: (SalesData sales, _) => sales.month,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  dataLabelSettings: DataLabelSettings(
                    textStyle: TextStyle(
                        fontSize:
                            fontSize ?? SizeConfig.safeBlockHorizontal * 0.8),
                    isVisible: true,
                  ),
                  width: 1,
                )
              ]),
        ),
      ),
    );
  }
}

class GrapichSelectedPICCheckSheet extends StatelessWidget {
  const GrapichSelectedPICCheckSheet({
    super.key,
    required this.dashboardController,
    required this.updateSheetController,
    required this.checkSheetController,
    this.height,
    this.width,
    this.fontSize,
  });

  final DashboardController dashboardController;
  final UpdateSheetController updateSheetController;
  final CheckSheetController checkSheetController;
  final double? height;
  final double? width;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: checkSheetController.getAssetCheckingStream(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data available'));
          }
          // Proses data
          final Map<String, dynamic> data =
              snapshot.data!.data()! as Map<String, dynamic>;
          checkSheetController.liveDataCheckSheetPIC(
              updateSheetController.onChangedDropDownForm.value,
              updateSheetController.onChangedDropDownPIC.value,
              data);
          return Container(
            color: AppColors.white,
            height: SizeConfig.horizontal(height ?? 20),
            width: SizeConfig.horizontal(width ?? 50),
            child: Center(
              child: Obx(
                () => SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      axisLabelFormatter: (AxisLabelRenderDetails details) {
                        const String label = 'Total Checked All Area';

                        return ChartAxisLabel(label, details.textStyle);
                      },
                    ),
                    title: ChartTitle(
                        text:
                            'Status check by PIC ${updateSheetController.onChangedDropDownPIC.value}',
                        textStyle: TextStyle(
                            fontSize: fontSize ??
                                SizeConfig.safeBlockHorizontal * 1)),
                    legend: const Legend(isVisible: true),
                    tooltipBehavior: dashboardController.tooltipBehavior,
                    series: <ColumnSeries<SalesData, int>>[
                      ColumnSeries<SalesData, int>(
                        name: 'Total Handled Asset',
                        spacing: 0.1,
                        dataSource: dashboardController.totalAssetHandledByPIC,
                        xValueMapper: (SalesData sales, _) => sales.month,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(
                              fontSize: fontSize ??
                                  SizeConfig.safeBlockHorizontal * 0.8),
                        ),
                        width: 1,
                      ),
                      ColumnSeries<SalesData, int>(
                        name: 'Asset Checked',
                        color: AppColors.orangeActive,
                        dataSource: <SalesData>[
                          SalesData(
                            '',
                            0,
                            checkSheetController.picTotalCheck.value.toDouble(),
                          ),
                        ],
                        xValueMapper: (SalesData sales, _) => sales.month,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        dataLabelSettings: DataLabelSettings(
                          textStyle: TextStyle(
                              fontSize: fontSize ??
                                  SizeConfig.safeBlockHorizontal * 0.8),
                          isVisible: true,
                        ),
                        width: 1,
                      )
                    ]),
              ),
            ),
          );
        });
  }
}

class GraphicsCheckSheet extends StatelessWidget {
  const GraphicsCheckSheet({
    super.key,
    required this.dashboardController,
    required this.checkSheetController,
    this.fontSize,
    this.height,
    this.width,
  });

  final DashboardController dashboardController;
  final CheckSheetController checkSheetController;
  final double? fontSize;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: checkSheetController.getAssetCheckingStream(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data available'));
          }

          // Proses data
          final Map<String, dynamic> data =
              snapshot.data!.data()! as Map<String, dynamic>;
          checkSheetController.liveDataCheckSheet(data);
          return Obx(
            () => Container(
                color: AppColors.white,
                width: SizeConfig.horizontal(width ?? 50),
                height: SizeConfig.horizontal(height ?? 20),
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      axisLabelFormatter: (AxisLabelRenderDetails details) {
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
                            label = 'SUNTER 1';
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
                    title: ChartTitle(
                        text: 'Status check all Area',
                        textStyle: TextStyle(
                            fontSize: fontSize ??
                                SizeConfig.safeBlockHorizontal * 1)),
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
                            'TLC1 KRW',
                            1,
                            dashboardController.tlc1krw.value.toDouble(),
                          ),
                          SalesData(
                            'TLC3 KRW',
                            2,
                            dashboardController.tlc3krw.value.toDouble(),
                          ),
                          SalesData(
                            'TLC2 STR',
                            3,
                            dashboardController.tlc2str.value.toDouble(),
                          ),
                          SalesData(
                            'Sunter 1',
                            4,
                            dashboardController.sunter1.value.toDouble(),
                          ),
                          SalesData(
                            'AKTI',
                            5,
                            dashboardController.akti.value.toDouble(),
                          ),
                        ],
                        xValueMapper: (SalesData sales, _) => sales.month,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(
                              fontSize: fontSize ??
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
                            'TLC1 KRW',
                            1,
                            checkSheetController.tlc1krwChecked.value
                                .toDouble(),
                          ),
                          SalesData(
                            'TLC3 krw',
                            2,
                            checkSheetController.tlc3krwChecked.value
                                .toDouble(),
                          ),
                          SalesData(
                            'TLC2 STR',
                            3,
                            checkSheetController.tlc2strChecked.value
                                .toDouble(),
                          ),
                          SalesData(
                            'Sunter 1',
                            4,
                            checkSheetController.sunter1Checked.value
                                .toDouble(),
                          ),
                          SalesData(
                            'akti',
                            5,
                            checkSheetController.aktiChecked.value.toDouble(),
                          ),
                        ],
                        xValueMapper: (SalesData sales, _) => sales.month,
                        yValueMapper: (SalesData sales, _) => sales.sales,
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(
                          textStyle: TextStyle(
                              fontSize: fontSize ??
                                  SizeConfig.safeBlockHorizontal * 0.8),
                          isVisible: true,
                        ),
                        // Set column width and spacing
                        width: 0.4,
                      )
                    ])),
          );
        });
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
