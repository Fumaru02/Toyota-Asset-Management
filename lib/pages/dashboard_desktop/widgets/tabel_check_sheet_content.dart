import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/check_sheet_controller.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/update_sheet_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../widgets/custom/custom_flat_button.dart';
import '../../widgets/text/roboto_text_view.dart';

class TabelCheckSheetContent extends StatefulWidget {
  const TabelCheckSheetContent({super.key});

  @override
  _TabelCheckSheetContentState createState() => _TabelCheckSheetContentState();
}

class _TabelCheckSheetContentState extends State<TabelCheckSheetContent> {
  late DashboardController dashboardController;
  late UpdateSheetController updateSheetController;
  late CheckSheetController checkSheetController;
  late List<PlutoColumn> columns;

  @override
  void initState() {
    super.initState();
    dashboardController = Get.put(DashboardController());
    updateSheetController = Get.put(UpdateSheetController());
    checkSheetController = Get.put(CheckSheetController());
    _initializeColumns();
  }

  void _initializeColumns() {
    columns = <PlutoColumn>[
      _buildColumn('No Asset', 'no_asset', PlutoColumnType.text(), false),
      _buildColumn('Asset Name', 'asset_name', PlutoColumnType.text(), true),
      _buildColumn('Category', 'category_field',
          PlutoColumnType.select(dashboardController.category), true),
      _buildColumn('Coordinator', 'coordinator_field',
          PlutoColumnType.select(dashboardController.coordinator), true),
      _buildColumn('PIC', 'pic_field',
          PlutoColumnType.select(dashboardController.allPic), false),
      _buildColumn('Area', 'area_field',
          PlutoColumnType.select(dashboardController.area), true),
      _buildImageColumn(),
      _buildColumn('Location', 'location_field',
          PlutoColumnType.select(dashboardController.location), true),
      _buildColumn(
          'Last Checked', 'input_time_field', PlutoColumnType.text(), false),
      _buildColumn('Year', 'year_field', PlutoColumnType.text(), false),
      _buildDeleteAsset('is_check_field', 8, false)
    ];
  }

  PlutoColumn _buildColumn(
      String title, String field, PlutoColumnType type, bool edit) {
    return PlutoColumn(
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
      title: 'Check',
      field: field,
      type: PlutoColumnType.text(),
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
      backgroundColor: AppColors.maroon,
      renderer: (PlutoColumnRendererContext rendererContext) {
        // Ambil tanggal terakhir check dari database
        final String lastCheckDate =
            rendererContext.row.cells['input_time_field']?.value as String;

        // Convert string date ke DateTime object
        final DateTime lastCheck =
            DateTime.tryParse(lastCheckDate) ?? DateTime.now();
        final DateTime today = DateTime.now();

        // Compare tanggal dengan hari ini
        final bool isToday = lastCheck.year == today.year &&
            lastCheck.month == today.month &&
            lastCheck.day == today.day;

        return Center(
          child: CustomFlatButton(
            backgroundColor: Colors.transparent,
            radius: 0,
            height: SizeConfig.horizontal(0.3),
            width: SizeConfig.horizontal(0.2),
            text: '',
            icon: isToday ? Icons.check_box : Icons.crop_square_sharp,
            // Ubah warna icon berdasarkan tanggal
            colorIconImage: isToday ? AppColors.greenSuccess : Colors.black,
            onTap: () async {
              checkSheetController.noAssetCheck.value =
                  rendererContext.row.cells['no_asset']?.value as String;
              checkSheetController.picAssetCheck.value =
                  rendererContext.row.cells['pic_field']?.value as String;
              checkSheetController.locationAssetCheck.value =
                  rendererContext.row.cells['location_field']?.value as String;
              checkSheetController.areaAssetCheck.value =
                  rendererContext.row.cells['area_field']?.value as String;

              // Update tanggal terakhir check
              await checkSheetController
                  .updateLastChecked(checkSheetController.noAssetCheck.value);
              await checkSheetController.addOrUpdateCheckAsset(
                area: checkSheetController.areaAssetCheck.value.toLowerCase(),
                location: checkSheetController.locationAssetCheck.value,
                pic: checkSheetController.picAssetCheck.value,
                noAsset: checkSheetController.noAssetCheck.value,
              );
            },
          ),
        );
      },
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Check',
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
                        width: SizeConfig.horizontal(85),
                        height: SizeConfig.horizontal(30),
                        child: StreamBuilder(
                          stream: dashboardController.streamRowCheckSheet(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                  width: SizeConfig.horizontal(10),
                                  height: SizeConfig.horizontal(10),
                                  child: const Center(
                                      child: CircularProgressIndicator()));
                            } else {
                              final List<dynamic> stagingData =
                                  snapshot.data as List<dynamic>;
                              dashboardController.rowsStagingData.value =
                                  dashboardController
                                      .convertToStagingTabel(stagingData);

                              return PlutoGrid(
                                configuration: PlutoGridConfiguration(
                                  style: PlutoGridStyleConfig(
                                    borderColor: AppColors.black,
                                    columnHeight: SizeConfig.horizontal(1.6),
                                    rowHeight: SizeConfig.horizontal(2),
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
    log(field);
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
