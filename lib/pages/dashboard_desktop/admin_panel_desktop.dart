
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controllers/admin_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/size_config.dart';
import '../widgets/custom/custom_flat_button.dart';
import '../widgets/layout/space_sizer.dart';
import '../widgets/text/roboto_text_view.dart';
import 'widgets/tabel_staging_user.dart';
import 'widgets/tabel_users_data.dart';

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
