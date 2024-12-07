import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/check_sheet_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/update_sheet_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/size_config.dart';
import '../dashboard_desktop/check_sheet_desktop.dart';
import '../dashboard_desktop/dashboard_content.dart';
import '../widgets/layout/space_sizer.dart';
import '../widgets/text/roboto_text_view.dart';
import 'widgets/custom_dropdown_form_mobile.dart';
import 'widgets/tabel_check_sheet_content.dart';
import 'widgets/tabel_check_sheet_mobile_content_by_area.dart';
import 'widgets/tabel_check_sheet_mobile_content_by_area_pic.dart';

class CheckSheetMobile extends StatelessWidget {
  const CheckSheetMobile({
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
                    size: SizeConfig.safeBlockHorizontal * 3,
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
                      size: SizeConfig.safeBlockHorizontal * 3,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SpaceSizer(
              vertical: 1,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SpaceSizer(
                  horizontal: 2,
                ),
                Column(
                  children: <Widget>[
                    CustomDropDownFormMobile(
                      selectedDropdown: () async {
                        await dashboardController.getPics(
                            updateSheetController.onChangedDropDownForm.value);
                        await updateSheetController.getLocationArea(
                            updateSheetController.onChangedDropDownForm.value);
                        checkSheetController.onChangedDropDownForm.value =
                            updateSheetController.onChangedDropDownForm.value;
                             checkSheetController.isByArea.value = true;
                        updateSheetController.onChangedDropDownPIC.value =
                            updateSheetController.dropdownInitialPIC.value;
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
                    CustomDropDownFormMobile(
                      selectedDropdown: () {
                        updateSheetController.picValue.value =
                            updateSheetController.onChangedDropDownPIC.value;
                        dashboardController.countPicHandled(
                            updateSheetController.onChangedDropDownPIC.value);
                             checkSheetController.isByArea.value = false;
                        checkSheetController.isByAreaPic.value = true;
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
                    // CustomDropDownFormMobile(
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
                const SpaceSizer(
                  horizontal: 1,
                ),
                Container(
                  width: SizeConfig.horizontal(20),
                  height: SizeConfig.horizontal(15),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.maroon)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: SizeConfig.horizontal(40),
                        height: SizeConfig.horizontal(5),
                        color: AppColors.maroon,
                        child: Center(
                          child: RobotoTextView(
                            color: AppColors.white,
                            value: 'Check Total',
                            size: SizeConfig.safeBlockHorizontal * 3,
                          ),
                        ),
                      ),
                      const SpaceSizer(
                        vertical: 1,
                      ),
                      Obx(
                        () => RobotoTextView(
                          value:
                              '${dashboardController.totalPersentase.value.toInt()}%',
                          color: AppColors.maroon,
                          size: SizeConfig.safeBlockHorizontal * 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(
              () => updateSheetController.onChangedDropDownPIC.value == '' ||
                      updateSheetController.onChangedDropDownPIC.value == 'PIC'
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: GraphicsCheckSheet(
                          checkSheetController: checkSheetController,
                          dashboardController: dashboardController,
                          fontSize: SizeConfig.safeBlockHorizontal * 3,
                          height: 100,
                          width: 200),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: GrapichSelectedPICCheckSheet(
                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                        height: 100,
                        width: 100,
                        checkSheetController: checkSheetController,
                        dashboardController: dashboardController,
                        updateSheetController: updateSheetController,
                      ),
                    ),
            ),
            Obx(
              () => updateSheetController.onChangedDropDownForm.value == 'Area'
                  ? const TabelCheckSheetMobileContent()
                  : Column(
                      children: <Widget>[
                        if (checkSheetController.isByArea.isTrue)
                          const TabelCheckSheetMobileContentByArea()
                        else if (checkSheetController.isByAreaPic.isTrue)
                          const TabelCheckSheetMobileContentByAreaPic()
                        else
                          const TabelCheckSheetMobileContent(),
                      ],
                    ),
            )
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
