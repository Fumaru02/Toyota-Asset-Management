import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/admin_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/update_sheet_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/constant.dart';
import '../../utils/enums.dart';
import '../../utils/size_config.dart';
import '../widgets/custom/custom_flat_button.dart';
import '../widgets/custom/custom_ripple_button.dart';
import '../widgets/custom/custom_text_field.dart';
import '../widgets/layout/space_sizer.dart';
import '../widgets/text/roboto_text_view.dart';
import 'widgets/dashboard_content.dart';
import 'widgets/tabel_check_sheet_content.dart';
import 'widgets/tabel_staging_user.dart';
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
              unselectedTitleTextStyle: RobotoStyle().unSelectedStyle()),
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
                value: dashboardController.username.value,
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
                    child: SizedBox(
                      width: SizeConfig.horizontal(20),
                      height: SizeConfig.horizontal(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RobotoTextView(
                            value: 'apakah anda yakin?',
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
                                  text: 'Log out',
                                  onTap: () async {
                                    authController.signOut();
                                    Get.back();
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
              DashboardContent(
                dashboardController: dashboardController,
              ),
              if (dashboardController.userRole.value == 'Super Admin' ||
                  dashboardController.userRole.value == 'Admin')
                AdminPanel(
                  dashboardController: dashboardController,
                )
              else
                Container(),
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

class AdminPanel extends StatelessWidget {
  const AdminPanel({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.put(AdminController());
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: RobotoTextView(
            value: 'Super Admin',
            size: SizeConfig.safeBlockHorizontal * 1.3,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Obx(
                  () => Stack(children: <Widget>[
                    const Icon(Icons.cloud_download_rounded),
                    if (adminController.dataUsername.isEmpty)
                      const SizedBox.shrink()
                    else
                      Container(
                        height: SizeConfig.horizontal(1),
                        width: SizeConfig.horizontal(1),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.redAlert),
                        child: Center(
                          child: RobotoTextView(
                            value:
                                adminController.dataUsername.length.toString(),
                            color: AppColors.white,
                            size: SizeConfig.safeBlockHorizontal * 0.8,
                          ),
                        ),
                      )
                  ]),
                ),
              ),
              const Tab(
                icon: Icon(Icons.supervised_user_circle),
              ),
              const Tab(
                icon: Icon(Icons.brightness_5_sharp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Obx(
              () => adminController.isShowTableStaging.isTrue
                  ? Padding(
                      padding: EdgeInsets.only(top: SizeConfig.horizontal(0.5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.horizontal(0.5)),
                            child: RobotoTextView(
                              value:
                                  'Request approval from ${adminController.usernameStaging.value}',
                              size: SizeConfig.safeBlockHorizontal * 1,
                              color: AppColors.black,
                            ),
                          ),
                          const SpaceSizer(
                            vertical: 3,
                          ),
                          const TabelStagingUser(),
                        ],
                      ),
                    )
                  : adminController.dataUsername.isEmpty
                      ? Center(
                          child: RobotoTextView(
                            value: 'Tidak ada permintaan data',
                            size: SizeConfig.safeBlockHorizontal * 1.3,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        )
                      : ListView.builder(
                          itemCount: adminController.dataUsername.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.horizontal(1)),
                                width: SizeConfig.horizontal(80),
                                height: SizeConfig.horizontal(5),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(
                                            SizeConfig.horizontal(0.5)),
                                        decoration: BoxDecoration(
                                            color: AppColors.greyDisabled,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.person_2_rounded,
                                          size: SizeConfig.safeBlockHorizontal *
                                              2,
                                        )),
                                    const SpaceSizer(
                                      horizontal: 3,
                                    ),
                                    RobotoTextView(
                                      value:
                                          adminController.dataUsername[index],
                                      size:
                                          SizeConfig.safeBlockHorizontal * 1.3,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                    const Spacer(),
                                    CustomFlatButton(
                                        width: 10,
                                        height: 5,
                                        radius: 0.5,
                                        backgroundColor: AppColors.maroon,
                                        textColor: AppColors.white,
                                        text: 'Get Data',
                                        colorIconImage: AppColors.white,
                                        onTap: () {
                                          adminController.getUserAssetStage(
                                              adminController
                                                  .dataUsername[index]);
                                        }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.horizontal(100),
                                child: Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  color: AppColors.greyDisabled,
                                  thickness: 0.5,
                                  height: SizeConfig.horizontal(1),
                                ),
                              )
                            ],
                          ),
                        ),
            ),
            Center(
                child:
                    TabelUsersData(dashboardController: dashboardController)),
            const Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
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
                                  Padding(
                                    padding: EdgeInsets.all(
                                        SizeConfig.horizontal(1)),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          SizeConfig.horizontal(1)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                SizeConfig.horizontal(0.3))),
                                        color: AppColors.yellowWarning,
                                      ),
                                      width: SizeConfig.horizontal(30),
                                      child: RobotoTextView(
                                        alignText: AlignTextType.justify,
                                        fontWeight: FontWeight.w600,
                                        value:
                                            'Mohon lengkapi form data yang valid sesuai aktual dengan benar.',
                                        size:
                                            SizeConfig.safeBlockHorizontal * 1,
                                      ),
                                    ),
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
                                      dashboardController.year.value
                                              .toString() ==
                                          '0' ||
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
                                      await updateSheetController
                                          .sendDataToAdmin(
                                              dashboardController.stagingData,
                                              dashboardController
                                                  .username.value);
                                      await dashboardController
                                          .deleteDataAfterUploading(
                                              dashboardController
                                                  .username.value);
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
