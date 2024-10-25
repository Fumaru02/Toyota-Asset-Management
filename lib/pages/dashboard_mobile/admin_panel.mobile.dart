import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/admin_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/size_config.dart';
import '../widgets/custom/custom_flat_button.dart';
import '../widgets/layout/space_sizer.dart';
import '../widgets/text/roboto_text_view.dart';
import 'widgets/tabel_staging_user_mobile.dart';
import 'widgets/tabel_users_data_mobile.dart';

class AdminPanelMobile extends StatelessWidget {
  const AdminPanelMobile({
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
            size: SizeConfig.safeBlockHorizontal * 5,
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
                        height: SizeConfig.horizontal(4),
                        width: SizeConfig.horizontal(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.redAlert),
                        child: Center(
                          child: RobotoTextView(
                            value:
                                adminController.dataUsername.length.toString(),
                            color: AppColors.white,
                            size: SizeConfig.safeBlockHorizontal * 2,
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
                      padding: EdgeInsets.only(top: SizeConfig.horizontal(1.5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.horizontal(1.5)),
                            child: RobotoTextView(
                              value:
                                  'Request approval from ${adminController.usernameStaging.value}',
                              size: SizeConfig.safeBlockHorizontal * 3,
                              color: AppColors.black,
                            ),
                          ),
                          const SpaceSizer(
                            vertical: 3,
                          ),
                          const TabelStagingUserMobile(),
                        ],
                      ),
                    )
                  : adminController.dataUsername.isEmpty
                      ? Center(
                          child: RobotoTextView(
                            value: 'Tidak ada permintaan data',
                            size: SizeConfig.safeBlockHorizontal * 3,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        )
                      : ListView.builder(
                          itemCount: adminController.dataUsername.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Column(
                            children: <Widget>[
                              const SpaceSizer(
                                vertical: 1,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.horizontal(2)),
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
                                              5,
                                        )),
                                    const SpaceSizer(
                                      horizontal: 3,
                                    ),
                                    RobotoTextView(
                                      value:
                                          adminController.dataUsername[index],
                                      size: SizeConfig.safeBlockHorizontal * 3,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                    const Spacer(),
                                    CustomFlatButton(
                                        width: 25,
                                        height: 12,
                                        radius: 0.5,
                                        textSize:
                                            SizeConfig.safeBlockHorizontal * 3,
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
                              const SpaceSizer(
                                vertical: 0.5,
                              ),
                              SizedBox(
                                width: SizeConfig.horizontal(120),
                                child: Divider(
                                  indent: 5,
                                  endIndent: 5,
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
                child: TabelUsersDataMobile(
                    dashboardController: dashboardController)),
            const Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ),
    );
  }
}
