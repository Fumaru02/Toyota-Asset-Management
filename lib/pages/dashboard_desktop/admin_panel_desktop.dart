import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/admin_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/update_sheet_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/size_config.dart';
import '../widgets/custom/custom_flat_button.dart';
import '../widgets/custom/custom_ripple_button.dart';
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
            Obx(
              () => adminController.isLoading.isTrue
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : adminController.isOpenDashboardTabel.isTrue
                      ? const SuperAdminTabelDashboard()
                      : Center(
                          child: CustomRippleButton(
                            onTap: () {
                              adminController.getDashboardTabelData();
                            },
                            child: Container(
                              width: SizeConfig.horizontal(50),
                              height: SizeConfig.horizontal(5),
                              color: AppColors.maroon,
                              child: Center(
                                  child: RobotoTextView(
                                value: 'Dashboard Tabel',
                                fontWeight: FontWeight.w600,
                                size: SizeConfig.safeBlockHorizontal * 1.5,
                                color: AppColors.white,
                              )),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuperAdminTabelDashboard extends StatefulWidget {
  const SuperAdminTabelDashboard({super.key});

  @override
  _SuperAdminTabelDashboardState createState() =>
      _SuperAdminTabelDashboardState();
}

class _SuperAdminTabelDashboardState extends State<SuperAdminTabelDashboard> {
  late DashboardController dashboardController;
  late UpdateSheetController updateSheetController;
  late AdminController adminController;
  late List<PlutoColumn> columns;

  @override
  void initState() {
    super.initState();
    dashboardController = Get.put(DashboardController());
    updateSheetController = Get.put(UpdateSheetController());
    adminController = Get.put(AdminController());
    _initializeColumns();
  }

  void _initializeColumns() {
    columns = <PlutoColumn>[
      _buildColumn('No Asset', 'no_asset', PlutoColumnType.text(), true, 12),
      _buildColumn(
          'Asset Name', 'asset_name', PlutoColumnType.text(), true, 18),
      _buildColumn('Category', 'category_field',
          PlutoColumnType.select(dashboardController.category), true, 16),
      _buildColumn('Coordinator', 'coordinator_field',
          PlutoColumnType.select(dashboardController.coordinator), true, 16),
      _buildColumn('PIC', 'pic_field',
          PlutoColumnType.select(dashboardController.allPic), false, 16),
      _buildColumn('Area', 'area_field',
          PlutoColumnType.select(dashboardController.area), true, 15),
      _buildImageColumn(),
      _buildColumn('Location', 'location_field',
          PlutoColumnType.select(dashboardController.location), false, 28),
      _buildColumn(
          'Input Time', 'input_time_field', PlutoColumnType.text(), false, 15),
      _buildDeleteAsset('is_check_field', 8, false),
      _buildColumn('Year', 'year_field', PlutoColumnType.text(), false, 15),
    ];
  }

  PlutoColumn _buildColumn(String title, String field, PlutoColumnType type,
      bool edit, double width) {
    return PlutoColumn(
      width: SizeConfig.horizontal(width),
      title: title,
      field: field,
      type: type,
      enableEditingMode: edit,
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
      backgroundColor: AppColors.maroon,
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: title,
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }

  PlutoColumn _buildDeleteAsset(String field, double width, bool edit) {
    return PlutoColumn(
      width: SizeConfig.horizontal(width),
      enableEditingMode: edit,
      title: 'No Asset',
      field: field,
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
      backgroundColor: AppColors.maroon,
      renderer: (PlutoColumnRendererContext rendererContext) {
        return Row(
          children: <Widget>[
            CustomFlatButton(
              backgroundColor: AppColors.maroon,
              textColor: AppColors.white,
              width: SizeConfig.horizontal(0.5),
              height: SizeConfig.horizontal(0.5),
              text: 'Delete',
              onTap: () {
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
                            value: 'Apakah anda sudah yakin?',
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
                                  text: 'Delete',
                                  onTap: () async {
                                    final String deletedAseetNumber =
                                        rendererContext.row.cells['no_asset']
                                            ?.value as String;
                                    await adminController
                                        .removeAssetFromDashboard(
                                            deletedAseetNumber);
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
            ),
          ],
        );
      },
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Settings',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }

  PlutoColumn _buildImageColumn() {
    return PlutoColumn(
      title: 'Image',
      field: 'image_field',
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
      backgroundColor: AppColors.maroon,
      renderer: (PlutoColumnRendererContext rendererContext) {
        return Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                _launchUrl(
                    rendererContext.row.cells['image_field']?.value as String);
              },
              child: RobotoTextView(
                value: 'Click Picture',
                textDecoration: TextDecoration.underline,
                color: AppColors.maroon,
                size: SizeConfig.safeBlockHorizontal * 1.2,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                updateSheetController.noAssetUpdate.value =
                    rendererContext.row.cells['no_asset']?.value as String;
                updateSheetController.pickImageSuperAdmin(
                  ImageSource.gallery,
                  true,
                  dashboardController.username.value,
                );
              },
              child: RobotoTextView(
                value: 'Edit',
                textDecoration: TextDecoration.underline,
                color: AppColors.black,
                size: SizeConfig.safeBlockHorizontal * 1.2,
              ),
            ),
          ],
        );
      },
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Image',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      print('Error launching URL: $e');
      // You can show a SnackBar here if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const SpaceSizer(
            vertical: 1,
          ),
          Center(
            child: CustomRippleButton(
              onTap: () {},
              child: Container(
                width: SizeConfig.horizontal(30),
                height: SizeConfig.horizontal(3),
                color: AppColors.maroon,
                child: Center(
                    child: RobotoTextView(
                  value: 'Dashboard Tabel',
                  fontWeight: FontWeight.w600,
                  size: SizeConfig.safeBlockHorizontal * 1,
                  color: AppColors.white,
                )),
              ),
            ),
          ),
          const SpaceSizer(
            vertical: 1,
          ),
          Obx(() {
            if (adminController.isLoading.isTrue) {
              return const CircularProgressIndicator();
            } else {
              return SizedBox(
                width: SizeConfig.horizontal(85),
                height: SizeConfig.horizontal(30),
                child: PlutoGrid(
                  configuration: PlutoGridConfiguration(
                    style: PlutoGridStyleConfig(
                      borderColor: AppColors.black,
                      columnHeight: SizeConfig.horizontal(1.6),
                      rowHeight: SizeConfig.horizontal(1.4),
                    ),
                  ),
                  columnMenuDelegate: const PlutoColumnMenuDelegateDefault(),
                  rowColorCallback: (PlutoRowColorContext rowColorContext) {
                    return rowColorContext.rowIdx.isEven
                        ? AppColors.cyan
                        : Colors.white;
                  },
                  columns: columns,
                  rows: adminController.rowsDashboardDataTabel,
                  createFooter: (PlutoGridStateManager stateManager) {
                    stateManager.setPageSize(13, notify: false);
                    return PlutoPagination(stateManager);
                  },
                  onChanged: _handleGridChange,
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    event.stateManager.setShowColumnFilter(true);
                    print(event);
                  },
                ),
              );
            }
          }),
          const SpaceSizer(
            vertical: 3,
          ),
          CustomFlatButton(
              width: 20,
              height: 5,
              backgroundColor: AppColors.redAlert,
              textColor: AppColors.white,
              text: 'Back',
              radius: 0.8,
              onTap: () async {
                adminController.isOpenDashboardTabel.value = false;
              }),
        ],
      ),
    );
  }

  void _handleGridChange(PlutoGridOnChangedEvent event) {
    print(event);
    final String field = event.column.field;
    final dynamic newValue = event.value;
    final String documentAsset = event.row.cells['no_asset']?.value as String;

    switch (field) {
      case 'asset_name':
      case 'no_asset':
      case 'category_field':
      case 'coordinator_field':
      case 'pic_field':
      case 'area_field':
      case 'location_field':
        adminController.updateTableDashboardSheet(
          field == 'category_field'
              ? 'category'
              : field == 'coordinator_field'
                  ? 'coordinator'
                  : field == 'pic_field'
                      ? 'pic'
                      : field == 'area_field'
                          ? 'area'
                          : field,
          newValue as String,
          documentAsset,
        );
        break;
      default:
        print('Field $field tidak memiliki handler khusus');
    }
  }
}
