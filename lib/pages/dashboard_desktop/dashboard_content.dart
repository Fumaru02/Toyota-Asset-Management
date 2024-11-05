import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/dashboard_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/size_config.dart';
import '../widgets/custom/custom_flat_button.dart';
import '../widgets/layout/space_sizer.dart';
import '../widgets/text/roboto_text_view.dart';
import 'widgets/tabel_dashboard_content.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomDropDown(
                      countTotalChecked: () {
                        dashboardController.onChangedDropDownPic.value = '';
                        dashboardController.totalCheckingAssetByArea(
                            dashboardController.onChangedDropDownArea.value,
                            '${dashboardController.month.value}/${dashboardController.year.value}');
                      },
                      selectedDropdown: () {
                        dashboardController.countSelectedLocations(
                            dashboardController.onChangedDropDownArea.value);
                      },
                      initialDropdown: dashboardController.dropdownInitialArea,
                      list: dashboardController.area,
                      titleDropDown: 'Area',
                      onChangedDropDownValue:
                          dashboardController.onChangedDropDownArea,
                    ),
                    const SpaceSizer(
                      vertical: 1,
                    ),
                    if (dashboardController.onChangedDropDownArea.value ==
                            'Semua Area' ||
                        dashboardController.onChangedDropDownArea.value == '')
                      const SizedBox.shrink()
                    else
                      CustomDropDown(
                        countTotalChecked: () =>
                            dashboardController.totalCheckingAsset(
                                dashboardController.onChangedDropDownPic.value,
                                '${dashboardController.month.value}/${dashboardController.year.value}'),
                        selectedDropdown: () =>
                            dashboardController.countPicHandled(
                                dashboardController.onChangedDropDownPic.value),
                        initialDropdown: dashboardController.dropdownInitialPic,
                        onChangedDropDownValue:
                            dashboardController.onChangedDropDownPic,
                        list: dashboardController.areaPics,
                        titleDropDown: 'PIC',
                      ),
                    const SpaceSizer(
                      vertical: 1.5,
                    ),
                    Row(
                      children: <Widget>[
                        const SpaceSizer(
                          horizontal: 1,
                        ),
                        Container(
                          width: SizeConfig.horizontal(8),
                          height: SizeConfig.horizontal(2),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.black)),
                          child: Center(
                            child: Obx(
                              () => RobotoTextView(
                                value: dashboardController.month.value == 0
                                    ? 'MM/YYYY'
                                    : '${dashboardController.month.value}/${dashboardController.year.value}',
                                size: SizeConfig.safeBlockHorizontal * 1,
                              ),
                            ),
                          ),
                        ),
                        const SpaceSizer(
                          horizontal: 1,
                        ),
                        CustomFlatButton(
                            width: 2.5,
                            height: 5,
                            radius: 0.5,
                            backgroundColor: AppColors.maroon,
                            textColor: AppColors.white,
                            text: '',
                            icon: Icons.calendar_month_sharp,
                            colorIconImage: AppColors.white,
                            onTap: () async {
                              await dashboardController.chooseDate(false);
                              await dashboardController.totalCheckingAssetAllArea(
                                  '${dashboardController.month.value}/${dashboardController.year.value}');
                            })
                      ],
                    ),
                  ],
                ),
                const SpaceSizer(
                  vertical: 1,
                ),
                Obx(
                  () => Row(
                    children: <Widget>[
                      const SpaceSizer(
                        horizontal: 0.5,
                      ),
                      if (dashboardController.onChangedDropDownArea.value ==
                              '' ||
                          dashboardController.onChangedDropDownArea.value ==
                              'Semua Area')
                        GrapichAllArea(dashboardController: dashboardController)
                      else
                        GrapichSelectedArea(
                            dashboardController: dashboardController),
                      const SpaceSizer(
                        horizontal: 1,
                      ),
                    ],
                  ),
                ),
                if (dashboardController.onChangedDropDownArea.value ==
                        'Semua Area' ||
                    dashboardController.onChangedDropDownArea.value == '')
                  const SizedBox.shrink()
                else
                  Obx(
                    () => dashboardController.isLoading.isTrue
                        ? const CircularProgressIndicator()
                        : Column(
                            children: <Widget>[
                              if (dashboardController
                                          .onChangedDropDownPic.value ==
                                      '' ||
                                  dashboardController
                                          .onChangedDropDownPic.value ==
                                      'Semua PIC')
                                GraphPIC(
                                    dashboardController: dashboardController)
                              else
                                GrapichSelectedPIC(
                                    dashboardController: dashboardController),
                            ],
                          ),
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

class GrapichSelectedPIC extends StatelessWidget {
  const GrapichSelectedPIC({
    super.key,
    required this.dashboardController,
    this.height,
    this.width,
    this.fontSize,
  });

  final DashboardController dashboardController;
  final double? height;
  final double? width;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      height: SizeConfig.horizontal(height ?? 20),
      width: SizeConfig.horizontal(width ?? 50),
      child: Center(
        // Tambahkan Center di sini
        child: Obx(
          () => SfCartesianChart(
              primaryXAxis: CategoryAxis(
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  const String label = 'Total Checked All Area';

                  return ChartAxisLabel(label, details.textStyle);
                },
              ),
              //lanjutdisini
              title: ChartTitle(
                  text:
                      'Status check by PIC [${dashboardController.onChangedDropDownPic.value}] ${dashboardController.monthByName} ${dashboardController.year.value == 0 ? '' : dashboardController.year}',
                  textStyle: TextStyle(
                      fontSize:
                          fontSize ?? SizeConfig.safeBlockHorizontal * 1)),
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
                        fontSize:
                            fontSize ?? SizeConfig.safeBlockHorizontal * 0.8),
                  ),
                  width: 1,
                ),
                ColumnSeries<SalesData, int>(
                  name: 'Asset Checked',
                  color: AppColors.orangeActive,
                  dataSource: dashboardController.assetHandled,
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

class GrapichSelectedArea extends StatelessWidget {
  const GrapichSelectedArea({
    super.key,
    required this.dashboardController,
    this.height,
    this.width,
    this.fontSize,
  });

  final DashboardController dashboardController;
  final double? height;
  final double? width;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      width: SizeConfig.horizontal(width ?? 45),
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
                    'Status check ${dashboardController.onChangedDropDownArea.value}',
                textStyle: TextStyle(
                    fontSize: fontSize ?? SizeConfig.safeBlockHorizontal * 1)),
            legend: const Legend(isVisible: true),
            tooltipBehavior: dashboardController.tooltipBehavior,
            series: <ColumnSeries<SalesData, int>>[
              ColumnSeries<SalesData, int>(
                name: 'Total Asset',
                spacing: 0.1,
                dataSource: <SalesData>[
                  SalesData(
                    '',
                    1,
                    dashboardController.selectedAreaTotalAsset.value.toDouble(),
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
                    dashboardController.selectedAreaTotalAssetChecked.value
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
    );
  }
}

class GrapichAllArea extends StatelessWidget {
  const GrapichAllArea({
    super.key,
    required this.dashboardController,
    this.height,
    this.width,
    this.fontSize,
  });

  final DashboardController dashboardController;
  final double? height;
  final double? width;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: dashboardController.getAssetCheckingStream(),
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
          final String date =
              '${dashboardController.initialMonth}/${dashboardController.initialYear}';
          if (data.containsKey(date)) {
            final Map<String, dynamic> monthData =
                data[date] as Map<String, dynamic>;
            if (monthData.containsKey('area')) {
              final List<dynamic> areaList = monthData['area'] as List<dynamic>;
              for (final dynamic area in areaList) {
                dashboardController
                    .processAreaData(area as Map<String, dynamic>);
              }
              final double totalNilai =
                  dashboardController.tlc1krw.value.toDouble() +
                      dashboardController.tlc2str.value.toDouble() +
                      dashboardController.tlc3krw.value.toDouble() +
                      dashboardController.sunter1.value.toDouble() +
                      dashboardController.akti.value.toDouble();

              final double totalChecked =
                  dashboardController.tlc1krwChecked.value.toDouble() +
                      dashboardController.tlc2strChecked.value.toDouble() +
                      dashboardController.tlc3krwChecked.value.toDouble() +
                      dashboardController.sunter1Checked.value.toDouble() +
                      dashboardController.aktiChecked.value.toDouble();

              print('Total Nilai: $totalNilai');
              print('Total Checked: $totalChecked');
              dashboardController.totalPersentase.value =
                  (totalChecked / totalNilai) * 100;

              print(
                  'Total Persentase: ${dashboardController.totalPersentase.value}');
            }
          }
          return Obx(
            () => Container(
                color: AppColors.white,
                width: SizeConfig.horizontal(width ?? 75),
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
                          SalesData(
                            'HO',
                            6,
                            dashboardController.ho.value.toDouble(),
                          )
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
                            dashboardController.tlc1krwChecked.value.toDouble(),
                          ),
                          SalesData(
                            'TLC3 krw',
                            2,
                            dashboardController.tlc3krwChecked.value.toDouble(),
                          ),
                          SalesData(
                            'TLC2 STR',
                            3,
                            dashboardController.tlc2strChecked.value.toDouble(),
                          ),
                          SalesData(
                            'Sunter 1',
                            4,
                            dashboardController.sunter1Checked.value.toDouble(),
                          ),
                          SalesData(
                            'akti',
                            5,
                            dashboardController.aktiChecked.value.toDouble(),
                          ),
                          SalesData(
                            'HO',
                            6,
                            dashboardController.hoChecked.value.toDouble(),
                          )
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

class GraphPIC extends StatelessWidget {
  const GraphPIC({
    super.key,
    required this.dashboardController,
    this.height,
    this.width,
    this.fontSize,
  });

  final DashboardController dashboardController;
  final double? height;
  final double? width;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.white,
        width: SizeConfig.horizontal(width ?? 80),
        height: SizeConfig.horizontal(height ?? 20),
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              axisLabelFormatter: (AxisLabelRenderDetails details) {
                final int index = details.value.toInt();
                final String label = index < dashboardController.allPic.length
                    ? dashboardController.allPic[index]
                    : '';
                return ChartAxisLabel(label, details.textStyle);
              },
            ),

            // Chart title
            title: ChartTitle(
                text: 'Status check by PIC',
                textStyle: TextStyle(
                    fontSize: fontSize ?? SizeConfig.safeBlockHorizontal * 1)),
            // Enable legend
            legend: const Legend(isVisible: true),

            // Enable tooltip
            tooltipBehavior: dashboardController.tooltipBehavior,
            series: <ColumnSeries<SalesData, int>>[
              ColumnSeries<SalesData, int>(
                name: 'Total Asset',
                spacing: 0.1,
                dataSource: dashboardController.getDataHandledAssetPic(),
                xValueMapper: (SalesData sales, _) => sales.month,
                yValueMapper: (SalesData sales, _) => sales.sales,
                // Enable data label
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                      fontSize:
                          fontSize ?? SizeConfig.safeBlockHorizontal * 0.7),
                ),
                // Set column width and spacing
                width: 0.4,
              ),
              ColumnSeries<SalesData, int>(
                name: 'Asset Checked',
                color: AppColors.orangeActive,
                dataSource: dashboardController.getTLC1DataSource(),
                xValueMapper: (SalesData sales, _) => sales.month,
                yValueMapper: (SalesData sales, _) => sales.sales,
                // Enable data label
                dataLabelSettings: DataLabelSettings(
                  textStyle: TextStyle(
                      fontSize:
                          fontSize ?? SizeConfig.safeBlockHorizontal * 0.7),
                  isVisible: true,
                ),
                // Set column width and spacing
                width: 0.8,
              )
            ]));
  }
}

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.list,
    required this.titleDropDown,
    required this.onChangedDropDownValue,
    required this.initialDropdown,
    required this.selectedDropdown,
    this.countTotalChecked,
    this.height,
    this.leftPadding,
    this.width,
    this.sizeFont,
  });

  final RxList<String> list;
  final String titleDropDown;
  final RxString onChangedDropDownValue;
  final RxString initialDropdown;
  final Function() selectedDropdown;
  final Function()? countTotalChecked;
  final double? width;
  final double? height;
  final double? leftPadding;
  final double? sizeFont;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: SizeConfig.horizontal(leftPadding ?? 1)),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RobotoTextView(
                value: titleDropDown,
                size: sizeFont ?? SizeConfig.safeBlockHorizontal * 1,
                fontWeight: FontWeight.w500,
              ),
              Container(
                width: SizeConfig.horizontal(width ?? 20),
                height: SizeConfig.horizontal(height ?? 2),
                decoration:
                    BoxDecoration(border: Border.all(color: AppColors.black)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: onChangedDropDownValue.value.isEmpty
                        ? null
                        : (list.contains(onChangedDropDownValue.value)
                            ? onChangedDropDownValue.value
                            : null),
                    icon: const Icon(Icons.arrow_drop_down),
                    style: RobotoStyle().dropdownStyle(),
                    onChanged: (String? value) async {
                      value ??= initialDropdown.value;
                      onChangedDropDownValue.value = value;
                      await countTotalChecked!();
                      selectedDropdown();
                    },
                    items: <String>['', ...list.toSet()]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value.isEmpty ? null : value,
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.horizontal(0.2)),
                          child: RobotoTextView(
                            value:
                                value.isEmpty ? initialDropdown.value : value,
                            size:
                                sizeFont ?? SizeConfig.safeBlockHorizontal * 1,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class CustomDropDownForm extends StatelessWidget {
  const CustomDropDownForm({
    super.key,
    required this.list,
    required this.titleDropDown,
    required this.onChangedDropDownValue,
    required this.initialDropdown,
    required this.selectedDropdown,
    this.width,
    this.height,
  });

  final RxList<String> list;
  final String titleDropDown;
  final RxString onChangedDropDownValue;
  final RxString initialDropdown;
  final Function() selectedDropdown;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RobotoTextView(
            value: titleDropDown,
            size: SizeConfig.safeBlockHorizontal * 1,
            fontWeight: FontWeight.w500,
          ),
          Container(
            width: SizeConfig.horizontal(width ?? 20),
            height: SizeConfig.horizontal(height ?? 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(SizeConfig.horizontal(0.2))),
                border: Border.all(color: AppColors.greySmooth)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: onChangedDropDownValue.value.isEmpty
                    ? null
                    : (list.contains(onChangedDropDownValue.value)
                        ? onChangedDropDownValue.value
                        : null),
                icon: const Icon(Icons.arrow_drop_down),
                style: RobotoStyle().dropdownStyle(),
                onChanged: (String? value) {
                  value ??= initialDropdown.value;
                  onChangedDropDownValue.value = value;
                  selectedDropdown();
                },
                items: <String>['', ...list.toSet()]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value.isEmpty ? null : value,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.horizontal(0.2)),
                      child: RobotoTextView(
                        overFlow: TextOverflow.ellipsis,
                        value: value.isEmpty ? initialDropdown.value : value,
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
