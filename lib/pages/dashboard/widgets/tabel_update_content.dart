import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/update_sheet_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../widgets/text/roboto_text_view.dart';

class TabelUpdateContent extends StatelessWidget {
  const TabelUpdateContent({
    super.key,
    required this.dashboardController,
  });
  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          if (dashboardController.isLoading.isTrue)
            const CircularProgressIndicator()
          else
            SizedBox(
              width: SizeConfig.horizontal(79),
              height: SizeConfig.horizontal(30),
              child: PlutoGrid(
                  configuration: PlutoGridConfiguration(
                    style: PlutoGridStyleConfig(
                        borderColor: AppColors.black,
                        columnHeight: SizeConfig.horizontal(1.6),
                        rowHeight: SizeConfig.horizontal(1.4)),
                  ),
                  columnMenuDelegate: const PlutoColumnMenuDelegateDefault(),
                  rowColorCallback: (PlutoRowColorContext rowColorContext) {
                    if (rowColorContext.rowIdx.isEven) {
                      return AppColors
                          .cyan; // Warna biru muda untuk baris ganjil
                    }
                    return Colors.white; // Warna putih untuk baris genap
                  },
                  columns: columnrs,
                  rows: dashboardController.rowsStagingData,
                  createFooter: (PlutoGridStateManager stateManager) {
                    stateManager.setPageSize(13, notify: false); // default 40
                    return PlutoPagination(stateManager);
                  },
                  onChanged: (PlutoGridOnChangedEvent event) {
                    print(event);
                  },
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    event.stateManager.setShowColumnFilter(true);

                    print(event);
                  }),
            ),
        ],
      ),
    );
  }
}

List<PlutoColumn> columnrs = <PlutoColumn>[
  /// Text Column definition
  PlutoColumn(
    title: 'No Asset',
    field: 'no_asset',
    enableEditingMode: false,
    type: PlutoColumnType.text(),
    textAlign: PlutoColumnTextAlign.center,
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'No Asset',
        size: SizeConfig.safeBlockHorizontal * 1.2,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),

  PlutoColumn(
    title: 'Asset Name',
    field: 'asset_name',
    type: PlutoColumnType.text(),
    textAlign: PlutoColumnTextAlign.center,
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'Asset Name',
        size: SizeConfig.safeBlockHorizontal * 1.2,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),

  PlutoColumn(
      title: 'Category',
      titleTextAlign: PlutoColumnTextAlign.center,
      field: 'category_field',
      textAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Category',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),
  PlutoColumn(
      title: 'Coordinator',
      titleTextAlign: PlutoColumnTextAlign.center,
      field: 'coordinator_field',
      textAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Coordinator',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),
  PlutoColumn(
      title: 'PIC',
      titleTextAlign: PlutoColumnTextAlign.center,
      field: 'pic_field',
      textAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'PIC',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),
  PlutoColumn(
      title: 'Area',
      field: 'area_field',
      type: PlutoColumnType.text(),
      titleTextAlign: PlutoColumnTextAlign.center,
      enableEditingMode: false,
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Area',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),
  PlutoColumn(
      title: 'Image',
      titleTextAlign: PlutoColumnTextAlign.center,
      field: 'image_field',
      textAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      renderer: (PlutoColumnRendererContext rendererContext) {
        final UpdateSheetController updateSheetController =
            Get.put(UpdateSheetController());
        final DashboardController dashboardController =
            Get.put(DashboardController());
        return Row(
          children: <Widget>[
            InkWell(
              onTap: () async {
                final String urlString = rendererContext.cell.value as String;
                try {
                  final Uri url = Uri.parse(urlString);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $urlString';
                  }
                } catch (e) {
                  // Handle error (e.g., show a snackbar or print to console)
                  print('Error launching URL: $e');
                  // If you have access to BuildContext, you can show a SnackBar:
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('Error launching URL: $e')),
                  // );
                }
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
      backgroundColor: AppColors.maroon),

  PlutoColumn(
      title: 'Check',
      titleTextAlign: PlutoColumnTextAlign.center,
      field: 'is_check_field',
      textAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Check',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),
  PlutoColumn(
      title: 'Location',
      titleTextAlign: PlutoColumnTextAlign.center,
      field: 'location_field',
      textAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Location',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),

  PlutoColumn(
      title: 'Input Time',
      titleTextAlign: PlutoColumnTextAlign.center,
      field: 'input_time_field',
      textAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Input Time',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),
];
