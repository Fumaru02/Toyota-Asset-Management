import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/admin_controller.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/update_sheet_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../widgets/custom/custom_flat_button.dart';
import '../../widgets/layout/space_sizer.dart';
import '../../widgets/text/roboto_text_view.dart';

class TabelStagingUser extends StatefulWidget {
  const TabelStagingUser({super.key});

  @override
  _TabelStagingUserState createState() => _TabelStagingUserState();
}

class _TabelStagingUserState extends State<TabelStagingUser> {
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
                final String deletedAseetNumber =
                    rendererContext.row.cells['no_asset']?.value as String;
                adminController.removeAssetFromStaging(
                    adminController.usernameStaging.value, deletedAseetNumber);
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
                updateSheetController.pickImage(
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
          Obx(() {
            if (adminController.isLoading.isTrue) {
              return const CircularProgressIndicator();
            } else {
              return SizedBox(
                width: SizeConfig.horizontal(79),
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
                  rows: adminController.rowsStagingData,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomFlatButton(
                  width: 20,
                  height: 5,
                  backgroundColor: AppColors.redAlert,
                  textColor: AppColors.white,
                  text: 'Back',
                  radius: 0.8,
                  onTap: () async {
                    adminController.isShowTableStaging.value = false;
                  }),
              const SpaceSizer(
                horizontal: 2,
              ),
              CustomFlatButton(
                  width: 20,
                  height: 5,
                  backgroundColor: AppColors.maroon,
                  textColor: AppColors.white,
                  text: 'Confirm',
                  radius: 0.8,
                  onTap: () async {
                    await adminController
                        .sendDataToDashboard(adminController.stagingData);
                    await adminController.deleteUserDocument(
                        adminController.usernameStaging.value);
                  }),
            ],
          ),
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
        updateSheetController.updateTableUpdateSheet(
          field == 'category_field'
              ? 'category'
              : field == 'coordinator_field'
                  ? 'coordinator'
                  : field == 'pic_field'
                      ? 'pic'
                      : field == 'area_field'
                          ? 'area'
                          : field,
          dashboardController.username.value,
          newValue as String,
          documentAsset,
        );
        break;
      default:
        print('Field $field tidak memiliki handler khusus');
    }
  }
}
