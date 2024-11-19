import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../dashboard_desktop/dashboard_content.dart';
import '../../widgets/custom/custom_flat_button.dart';
import '../../widgets/layout/space_sizer.dart';
import '../../widgets/text/roboto_text_view.dart';
import 'tabel_dashboard_content_mobile.dart';

class DashboardContentMobile extends StatelessWidget {
  const DashboardContentMobile({
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
                                Radius.circular(SizeConfig.horizontal(1)))),
                        padding: EdgeInsets.all(SizeConfig.horizontal(1)),
                        child: RobotoTextView(
                          value: 'Dashboard',
                          size: SizeConfig.safeBlockHorizontal * 3,
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
                      sizeFont: SizeConfig.safeBlockHorizontal * 3,
                      height: 8,
                      width: 50,
                      leftPadding: 2,
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
                        sizeFont: SizeConfig.safeBlockHorizontal * 3,
                        height: 8,
                        width: 50,
                        leftPadding: 2,
                        // countTotalChecked: () =>
                        //     dashboardController.totalCheckingAsset(
                        //         dashboardController.onChangedDropDownPic.value,
                        //         '${dashboardController.month.value}/${dashboardController.year.value}'),
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
                          width: SizeConfig.horizontal(20),
                          height: SizeConfig.horizontal(5),
                          margin:
                              EdgeInsets.only(left: SizeConfig.horizontal(1)),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.black)),
                          child: Center(
                            child: Obx(
                              () => RobotoTextView(
                                value: dashboardController.month.value == 0
                                    ? 'MM/YYYY'
                                    : '${dashboardController.month.value}/${dashboardController.year.value}',
                                size: SizeConfig.safeBlockHorizontal * 3,
                              ),
                            ),
                          ),
                        ),
                        const SpaceSizer(
                          horizontal: 2,
                        ),
                        CustomFlatButton(
                            width: 10,
                            height: 5,
                            radius: 2,
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
                  vertical: 2,
                ),
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        const SpaceSizer(
                          horizontal: 0.5,
                        ),
                        if (dashboardController.onChangedDropDownArea.value ==
                                '' ||
                            dashboardController.onChangedDropDownArea.value ==
                                'Semua Area')
                          GrapichAllArea(
                            fontSize: SizeConfig.safeBlockHorizontal * 3,
                            dashboardController: dashboardController,
                            height: 50,
                            width: 200,
                          )
                        else
                          GrapichSelectedArea(
                              fontSize: SizeConfig.safeBlockHorizontal * 3,
                              height: 50,
                              width: 100,
                              dashboardController: dashboardController),
                        const SpaceSizer(
                          horizontal: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                if (dashboardController.onChangedDropDownArea.value ==
                        'Semua Area' ||
                    dashboardController.onChangedDropDownArea.value == '')
                  const SizedBox.shrink()
                else
                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: dashboardController.isLoading.isTrue
                          ? const CircularProgressIndicator()
                          : Column(
                              children: <Widget>[
                                if (dashboardController
                                            .onChangedDropDownPic.value ==
                                        '' ||
                                    dashboardController
                                            .onChangedDropDownPic.value ==
                                        'Semua PIC')
                                  Column(
                                    children: <Widget>[
                                      GraphPICAssetTotal(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  3,
                                          height: 50,
                                          width: 100,
                                          dashboardController:
                                              dashboardController),
                                      GraphPICCheckedTotal(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  3,
                                          height: 50,
                                          width: 100,
                                          dashboardController:
                                              dashboardController),
                                    ],
                                  )
                                else
                                  GrapichSelectedPIC(
                                      fontSize:
                                          SizeConfig.safeBlockHorizontal * 3,
                                      height: 50,
                                      width: 100,
                                      dashboardController: dashboardController),
                              ],
                            ),
                    ),
                  ),
                const SpaceSizer(
                  vertical: 5,
                ),
                const TabelDashboardMobileContent()
              ])),
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
