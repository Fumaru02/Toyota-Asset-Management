import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../widgets/text/roboto_text_view.dart';

class TabelDashboardContent extends StatelessWidget {
  const TabelDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());
    return Obx(
      () => Center(
        child: dashboardController.isLoading.isTrue
            ? const CircularProgressIndicator()
            : Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(SizeConfig.horizontal(0.6)),
                    alignment: Alignment.center,
                    width: SizeConfig.horizontal(79),
                    color: AppColors.maroon,
                    child: RobotoTextView(
                      value: 'List Asset',
                      size: SizeConfig.safeBlockHorizontal * 1.5,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.horizontal(79),
                    height: SizeConfig.horizontal(20),
                    child: PlutoGrid(
                      configuration: PlutoGridConfiguration(
                        columnFilter: PlutoGridColumnFilterConfig(
                          resolveDefaultColumnFilter: (PlutoColumn column,
                              dynamic Function<T>() resolver) {
                            if (column.field == 'number_asset') {
                              return resolver<PlutoFilterTypeGreaterThan>()
                                  as PlutoFilterType;
                            }
                            return resolver<PlutoFilterTypeContains>()
                                as PlutoFilterType;
                          },
                          filters: <PlutoFilterType>[
                            ...FilterHelper.defaultFilters,
                          ],
                        ),
                        style: PlutoGridStyleConfig(
                            borderColor: AppColors.black,
                            columnHeight: SizeConfig.horizontal(1.6),
                            rowHeight: SizeConfig.horizontal(1.4)),
                      ),
                      createFooter: (PlutoGridStateManager stateManager) {
                        stateManager.setPageSize(10,
                            notify: false); // default 40
                        return PlutoPagination(stateManager);
                      },
                      columnMenuDelegate:
                          const PlutoColumnMenuDelegateDefault(),
                      rowColorCallback: (PlutoRowColorContext rowColorContext) {
                        if (rowColorContext.rowIdx.isEven) {
                          return AppColors
                              .cyan; // Warna biru muda untuk baris ganjil
                        }
                        return Colors.white; // Warna putih untuk baris genap
                      },
                      columns: columns,
                      rows: dashboardController.rowListAsset,
                      onChanged: (PlutoGridOnChangedEvent event) {
                        print(event);
                      },
                      onLoaded: (PlutoGridOnLoadedEvent event) {
                        event.stateManager.setShowColumnFilter(true);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

List<PlutoColumn> columns = <PlutoColumn>[
  /// Text Column definition
  PlutoColumn(
    width: SizeConfig.horizontal(10),
    title: 'No Asset',
    field: 'number_asset',
    type: PlutoColumnType.number(
      format: '####',
    ),
    textAlign: PlutoColumnTextAlign.center,
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'No Asset',
        size: SizeConfig.safeBlockHorizontal * 1,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),

  PlutoColumn(
      title: 'Nama Asset',
      field: 'text_asset_name',
      titleTextAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Nama Asset',
          size: SizeConfig.safeBlockHorizontal * 1,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),

  PlutoColumn(
    width: SizeConfig.horizontal(10),
    title: 'PIC',
    field: 'pic_name',
    type: PlutoColumnType.text(),
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'PIC',
        size: SizeConfig.safeBlockHorizontal * 1,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),

  PlutoColumn(
      width: SizeConfig.horizontal(10),
      title: 'Category',
      field: 'category_value',
      type: PlutoColumnType.text(),
      titleTextAlign: PlutoColumnTextAlign.center,
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Category',
          size: SizeConfig.safeBlockHorizontal * 1,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),

  PlutoColumn(
      width: SizeConfig.horizontal(14),
      title: 'Lokasi',
      titleTextAlign: PlutoColumnTextAlign.center,
      field: 'location_value',
      textAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Lokasi',
          size: SizeConfig.safeBlockHorizontal * 1,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),
  PlutoColumn(
    width: SizeConfig.horizontal(10),
    title: 'Area',
    field: 'area_value',
    type: PlutoColumnType.text(),
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'Area',
        size: SizeConfig.safeBlockHorizontal * 1,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),
  PlutoColumn(
    width: SizeConfig.horizontal(10),
    title: 'Koordinator',
    field: 'koordinator_value',
    type: PlutoColumnType.text(),
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'Koordinator',
        size: SizeConfig.safeBlockHorizontal * 1,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),
];
