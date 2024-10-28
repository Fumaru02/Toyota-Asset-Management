import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/update_sheet_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../widgets/custom/custom_flat_button.dart';
import '../../widgets/text/roboto_text_view.dart';

class TabelUpdateContentMobile extends StatefulWidget {
  const TabelUpdateContentMobile({super.key});

  @override
  _TabelUpdateContentMobileState createState() =>
      _TabelUpdateContentMobileState();
}

class _TabelUpdateContentMobileState extends State<TabelUpdateContentMobile> {
  late DashboardController dashboardController;
  late UpdateSheetController updateSheetController;
  late List<PlutoColumn> columns;

  @override
  void initState() {
    super.initState();
    dashboardController = Get.put(DashboardController());
    updateSheetController = Get.put(UpdateSheetController());
    _initializeColumns();
  }

  void _initializeColumns() {
    columns = <PlutoColumn>[
      _buildColumn(40, 'No Asset', 'no_asset', PlutoColumnType.text(), false),
      _buildColumn(
          40, 'Asset Name', 'asset_name', PlutoColumnType.text(), true),
      _buildColumn(40, 'Category', 'category_field',
          PlutoColumnType.select(dashboardController.category), true),
      _buildColumn(30, 'Coordinator', 'coordinator_field',
          PlutoColumnType.select(dashboardController.coordinator), true),
      _buildColumn(40, 'PIC', 'pic_field',
          PlutoColumnType.select(dashboardController.allPic), false),
      _buildColumn(40, 'Area', 'area_field',
          PlutoColumnType.select(dashboardController.area), true),
      _buildImageColumn(),
      _buildColumn(60, 'Location', 'location_field',
          PlutoColumnType.select(dashboardController.location), true),
      _buildColumn(
          60, 'Input Time', 'input_time_field', PlutoColumnType.text(), false),
      _buildColumn(20, 'Year', 'year_field', PlutoColumnType.text(), false),
      _buildDeleteAsset('is_check_field', 30, false)
    ];
  }

  PlutoColumn _buildColumn(double width, String title, String field,
      PlutoColumnType type, bool edit) {
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
          size: SizeConfig.safeBlockHorizontal * 3,
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
      title: 'Settings',
      field: field,
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
      backgroundColor: AppColors.maroon,
      renderer: (PlutoColumnRendererContext rendererContext) {
        return CustomFlatButton(
          backgroundColor: AppColors.maroon,
          textColor: AppColors.white,
          width: SizeConfig.horizontal(8),
          textSize: SizeConfig.safeBlockHorizontal * 3,
          height: SizeConfig.horizontal(2),
          text: 'Delete',
          onTap: () {
            final String deletedAseetNumber =
                rendererContext.row.cells['no_asset']?.value as String;
            updateSheetController.removeAssetFromStaging(
                dashboardController.username.value, deletedAseetNumber);
          },
        );
      },
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Settings',
          size: SizeConfig.safeBlockHorizontal * 3,
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
                size: SizeConfig.safeBlockHorizontal * 3,
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
                size: SizeConfig.safeBlockHorizontal * 3,
              ),
            ),
          ],
        );
      },
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Image',
          size: SizeConfig.safeBlockHorizontal * 3,
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
        child: GetBuilder<DashboardController>(
            init: DashboardController(),
            builder: (DashboardController dashboardController) => Column(
                  children: <Widget>[
                    if (dashboardController.isLoading.value)
                      SizedBox(
                          width: SizeConfig.horizontal(10),
                          height: SizeConfig.horizontal(10),
                          child:
                              const Center(child: CircularProgressIndicator()))
                    else
                      SizedBox(
                        width: SizeConfig.horizontal(120),
                        height: SizeConfig.horizontal(120),
                        child: StreamBuilder(
                          stream: dashboardController.streamRowUpdateSheet(
                              dashboardController.username.value),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              dashboardController.isLoading.value = true;
                              return SizedBox(
                                  width: SizeConfig.horizontal(10),
                                  height: SizeConfig.horizontal(10),
                                  child: const Center(
                                      child: CircularProgressIndicator()));
                            } else {
                              dashboardController.isLoading.value = false;
                              final List<dynamic> stagingData =
                                  snapshot.data as List<dynamic>;
                              dashboardController.rowsStagingData.value =
                                  dashboardController
                                      .convertToStagingTabel(stagingData);

                              return PlutoGrid(
                                configuration: PlutoGridConfiguration(
                                  style: PlutoGridStyleConfig(
                                    borderColor: AppColors.black,
                                    columnHeight: SizeConfig.horizontal(5),
                                    rowHeight: SizeConfig.horizontal(5),
                                  ),
                                ),
                                columnMenuDelegate:
                                    const PlutoColumnMenuDelegateDefault(),
                                rowColorCallback:
                                    (PlutoRowColorContext rowColorContext) {
                                  return rowColorContext.rowIdx.isEven
                                      ? AppColors.cyan
                                      : Colors.white;
                                },
                                columns: columns,
                                rows: dashboardController.rowsStagingData,
                                createFooter:
                                    (PlutoGridStateManager stateManager) {
                                  stateManager.setPageSize(13, notify: false);
                                  return PlutoPagination(stateManager);
                                },
                                onChanged: _handleGridChange,
                                onLoaded: (PlutoGridOnLoadedEvent event) {
                                  event.stateManager.setShowColumnFilter(true);
                                  print(event);
                                },
                              );
                            }
                          },
                        ),
                      ),
                  ],
                )));
  }

  void _handleGridChange(PlutoGridOnChangedEvent event) {
    print(event);
    final String field = event.column.field;
    final dynamic newValue = event.value;
    final String documentAsset = event.row.cells['no_asset']?.value as String;
    updateSheetController.noAssetUpdate.value = documentAsset;
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
                          : field == 'no_asset'
                              ? 'no_asset'
                              : field == 'asset_name'
                                  ? 'asset_name'
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
