import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/dashboard_controller.dart';
import '../../controllers/update_sheet_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/enums.dart';
import '../../utils/size_config.dart';
import '../widgets/custom/custom_flat_button.dart';
import '../widgets/custom/custom_ripple_button.dart';
import '../widgets/custom/custom_text_field.dart';
import '../widgets/layout/space_sizer.dart';
import '../widgets/text/roboto_text_view.dart';
import 'dashboard_content.dart';
import 'widgets/tabel_update_content.dart';

class UpdateSheet extends StatelessWidget {
  const UpdateSheet({
    super.key,
    required this.dashboardController,
  });
  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateSheetController>(
      init: UpdateSheetController(),
      builder: (UpdateSheetController updateSheetController) => Container(
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
                        builder: (BuildContext context) => Obx(
                          () => Dialog(
                            child: Container(
                              width: SizeConfig.horizontal(45),
                              height: SizeConfig.horizontal(41),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          SizeConfig.horizontal(2)))),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: SizeConfig.horizontal(7),
                                          top: SizeConfig.horizontal(1),
                                          bottom: SizeConfig.horizontal(1),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              SizeConfig.horizontal(1)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    SizeConfig.horizontal(
                                                        0.3))),
                                            color: AppColors.yellowWarning,
                                          ),
                                          width: SizeConfig.horizontal(30),
                                          child: RobotoTextView(
                                            alignText: AlignTextType.justify,
                                            fontWeight: FontWeight.w600,
                                            value:
                                                'Mohon lengkapi form data yang valid sesuai aktual dengan benar.',
                                            size:
                                                SizeConfig.safeBlockHorizontal *
                                                    1,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: const Icon(Icons.close),
                                        iconSize:
                                            SizeConfig.safeBlockHorizontal * 2,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          CustomTextField(
                                            controller: updateSheetController
                                                .noAssetTextEditingController,
                                            focus: updateSheetController
                                                .noAssetFocusNode,
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    1),
                                            width: 20,
                                            height: SizeConfig.vertical(4.4),
                                            borderRadius: 0.07,
                                            title: 'No Asset',
                                            contentPadding: EdgeInsets.all(
                                                SizeConfig.horizontal(0.8)),
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            textSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    1,
                                            borderSideColor:
                                                AppColors.greySmooth,
                                          ),
                                          const SpaceSizer(
                                            vertical: 1,
                                          ),
                                          CustomTextField(
                                            controller: updateSheetController
                                                .assetNameTextEditingController,
                                            focus: updateSheetController
                                                .assetNameFocusNode,
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    1),
                                            width: 20,
                                            height: SizeConfig.vertical(4.4),
                                            borderRadius: 0.07,
                                            title: 'Asset Name',
                                            contentPadding: EdgeInsets.all(
                                                SizeConfig.horizontal(0.8)),
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType: TextInputType.text,
                                            textSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    1,
                                            borderSideColor:
                                                AppColors.greySmooth,
                                          ),
                                          const SpaceSizer(
                                            vertical: 1,
                                          ),
                                          CustomDropDownForm(
                                            selectedDropdown: () {
                                              updateSheetController
                                                      .locationValue.value =
                                                  updateSheetController
                                                      .onChangedDropDownLocation
                                                      .value;
                                            },
                                            list: updateSheetController
                                                .areaLocation,
                                            titleDropDown: 'Location',
                                            onChangedDropDownValue:
                                                updateSheetController
                                                    .onChangedDropDownLocation,
                                            initialDropdown:
                                                updateSheetController
                                                    .initialDropDownForm,
                                          ),
                                          const SpaceSizer(
                                            vertical: 1,
                                          ),
                                          CustomDropDownForm(
                                            selectedDropdown: () {
                                              updateSheetController
                                                      .picValue.value =
                                                  updateSheetController
                                                      .onChangedDropDownPIC
                                                      .value;
                                            },
                                            list: dashboardController.areaPics,
                                            titleDropDown: 'PIC',
                                            onChangedDropDownValue:
                                                updateSheetController
                                                    .onChangedDropDownPIC,
                                            initialDropdown:
                                                updateSheetController
                                                    .dropdownInitialPIC,
                                          ),
                                        ],
                                      ),
                                      const SpaceSizer(
                                        horizontal: 1,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          CustomDropDownForm(
                                            selectedDropdown: () async {
                                              await dashboardController.getPics(
                                                  updateSheetController
                                                      .onChangedDropDownForm
                                                      .value);
                                              await updateSheetController
                                                  .getLocationArea(
                                                      updateSheetController
                                                          .onChangedDropDownForm
                                                          .value);
                                              await updateSheetController
                                                  .getCoordinatorArea(
                                                      updateSheetController
                                                          .onChangedDropDownForm
                                                          .value);
                                              updateSheetController
                                                      .areaValue.value =
                                                  updateSheetController
                                                      .onChangedDropDownForm
                                                      .value;
                                              updateSheetController
                                                      .initialDropDownFormCoordinator
                                                      .value =
                                                  updateSheetController
                                                      .coordinatorLocation[0];
                                              updateSheetController
                                                      .coordinatorValue.value =
                                                  updateSheetController
                                                      .coordinatorLocation[0];
                                            },
                                            list: dashboardController.area,
                                            titleDropDown: 'Area',
                                            onChangedDropDownValue:
                                                updateSheetController
                                                    .onChangedDropDownForm,
                                            initialDropdown:
                                                updateSheetController
                                                    .dropdownInitialArea,
                                          ),
                                          const SpaceSizer(
                                            vertical: 1,
                                          ),
                                          CustomDropDownForm(
                                            selectedDropdown: () {
                                              updateSheetController
                                                      .categoryValue.value =
                                                  updateSheetController
                                                      .onChangedDropDownCategory
                                                      .value;
                                            },
                                            list: dashboardController.category,
                                            titleDropDown: 'Category',
                                            onChangedDropDownValue:
                                                updateSheetController
                                                    .onChangedDropDownCategory,
                                            initialDropdown:
                                                updateSheetController
                                                    .initialDropDownForm,
                                          ),
                                          const SpaceSizer(
                                            vertical: 1,
                                          ),
                                          CustomDropDownForm(
                                            selectedDropdown: () {
                                              updateSheetController
                                                      .coordinatorValue.value =
                                                  updateSheetController
                                                      .onChangedDropDownCoordinator
                                                      .value;
                                            },
                                            list: updateSheetController
                                                .coordinatorLocation,
                                            titleDropDown: 'Coordinator',
                                            onChangedDropDownValue:
                                                updateSheetController
                                                    .onChangedDropDownCoordinator,
                                            initialDropdown: updateSheetController
                                                .initialDropDownFormCoordinator,
                                          ),
                                          const SpaceSizer(
                                            vertical: 1,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              RobotoTextView(
                                                value: 'Asset Year',
                                                size: SizeConfig
                                                        .safeBlockHorizontal *
                                                    1,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        SizeConfig.horizontal(
                                                            16.5),
                                                    height:
                                                        SizeConfig.horizontal(
                                                            2),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColors
                                                                .greySmooth)),
                                                    child: Center(
                                                      child: Obx(
                                                        () => RobotoTextView(
                                                          value: updateSheetController
                                                                      .year
                                                                      .value ==
                                                                  0
                                                              ? 'YYYY'
                                                              : '${updateSheetController.year.value}',
                                                          size: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              1,
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
                                                      backgroundColor:
                                                          AppColors.maroon,
                                                      textColor:
                                                          AppColors.white,
                                                      text: '',
                                                      icon: Icons
                                                          .calendar_month_sharp,
                                                      colorIconImage:
                                                          AppColors.white,
                                                      onTap: () async {
                                                        await dashboardController
                                                            .chooseDate(true);
                                                      }),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SpaceSizer(
                                    vertical: 1,
                                  ),
                                  if (updateSheetController.isLoading.isTrue)
                                    SizedBox(
                                        width: SizeConfig.horizontal(41),
                                        height: SizeConfig.horizontal(15),
                                        child: const Center(
                                            child: CircularProgressIndicator()))
                                  else
                                    CustomRippleButton(
                                      borderRadius: BorderRadius.zero,
                                      onTap: () async {
                                        await updateSheetController.pickImage(
                                            ImageSource.gallery, false, '');
                                      },
                                      child: Container(
                                        width: SizeConfig.horizontal(41),
                                        height: SizeConfig.horizontal(15),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.greySmooth)),
                                        child: Obx(
                                          () => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              if (updateSheetController
                                                      .previewImageBytes
                                                      .value !=
                                                  null)
                                                Image.memory(
                                                  updateSheetController
                                                      .previewImageBytes.value!,
                                                  width:
                                                      SizeConfig.horizontal(40),
                                                  height:
                                                      SizeConfig.horizontal(13),
                                                  fit: BoxFit.fill,
                                                )
                                              else
                                                Icon(
                                                  Icons.upload_file,
                                                  size: SizeConfig
                                                          .safeBlockHorizontal *
                                                      1.5,
                                                  color: AppColors.greySmooth,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SpaceSizer(
                                    vertical: 2,
                                  ),
                                  if (updateSheetController
                                          .areaValue.value.isEmpty ||
                                      updateSheetController
                                          .categoryValue.value.isEmpty ||
                                      updateSheetController
                                          .picValue.value.isEmpty ||
                                      updateSheetController
                                              .previewImageBytes.value ==
                                          null)
                                    Container()
                                  else
                                    CustomFlatButton(
                                        width: 20,
                                        height: 5,
                                        backgroundColor: AppColors.maroon,
                                        textColor: AppColors.white,
                                        text: 'Confirm',
                                        radius: 0.8,
                                        onTap: () async {
                                          await updateSheetController
                                              .onConfirmAddAsset(
                                                  updateSheetController
                                                      .noAssetTextEditingController
                                                      .text
                                                      .trim(),
                                                  4,
                                                  false,
                                                  updateSheetController
                                                      .assetNameTextEditingController
                                                      .text
                                                      .trim(),
                                                  dashboardController
                                                      .username.value,
                                                  dashboardController.year.value
                                                      .toString());
                                          await dashboardController
                                              .getUserAssetStage(
                                                  dashboardController
                                                      .username.value);
                                          Get.back();
                                          updateSheetController
                                              .assetNameTextEditingController
                                              .clear();
                                          updateSheetController
                                              .noAssetTextEditingController
                                              .clear();
                                          updateSheetController
                                                  .onChangedDropDownForm.value =
                                              updateSheetController
                                                  .dropdownInitialArea.value;
                                          updateSheetController
                                                  .onChangedDropDownPIC.value =
                                              updateSheetController
                                                  .dropdownInitialPIC.value;
                                          updateSheetController
                                                  .onChangedDropDownCategory
                                                  .value =
                                              updateSheetController
                                                  .initialDropDownForm.value;
                                          updateSheetController
                                                  .onChangedDropDownLocation
                                                  .value =
                                              updateSheetController
                                                  .initialDropDownForm.value;

                                          updateSheetController.year.value = 0;
                                          updateSheetController
                                              .previewImageBytes.value = null;
                                        }),
                                ],
                              ),
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
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: SizedBox(
                        width: SizeConfig.horizontal(20),
                        height: SizeConfig.horizontal(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RobotoTextView(
                              value:
                                  'Mohon periksa kembali data\nApakah anda sudah yakin?',
                              size: SizeConfig.safeBlockHorizontal * 1,
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
                                    width: 8,
                                    height: 4,
                                    backgroundColor: AppColors.maroon,
                                    textColor: AppColors.white,
                                    text: 'Kirim',
                                    onTap: () async {
                                      if (dashboardController
                                          .stagingData.isNotEmpty) {
                                        await updateSheetController
                                            .sendDataToAdmin(
                                                dashboardController.stagingData,
                                                dashboardController
                                                    .username.value);
                                        await dashboardController
                                            .deleteDataAfterUploading(
                                                dashboardController
                                                    .username.value);
                                        Get.back();
                                      } else {
                                        return;
                                      }
                                    }),
                                CustomFlatButton(
                                  width: 8,
                                  height: 4,
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
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
