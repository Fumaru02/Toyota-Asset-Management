import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../widgets/layout/space_sizer.dart';
import '../../widgets/text/roboto_text_view.dart';

class TabelUsersDataMobile extends StatelessWidget {
  const TabelUsersDataMobile({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const SpaceSizer(
            vertical: 4,
          ),
          Container(
            alignment: Alignment.center,
            width: SizeConfig.horizontal(80),
            color: AppColors.maroon,
            child: RobotoTextView(
              value: 'List Users',
              size: SizeConfig.safeBlockHorizontal * 3.5,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: AppColors.white,
            ),
          ),
          SizedBox(
            height: SizeConfig.horizontal(120),
            child: PlutoGrid(
                configuration: PlutoGridConfiguration(
                  style: PlutoGridStyleConfig(
                      borderColor: AppColors.black,
                      columnHeight: SizeConfig.horizontal(5),
                      rowHeight: SizeConfig.horizontal(5)),
                ),
                columnMenuDelegate: const PlutoColumnMenuDelegateDefault(),
                rowColorCallback: (PlutoRowColorContext rowColorContext) {
                  if (rowColorContext.rowIdx.isEven) {
                    return AppColors.cyan; // Warna biru muda untuk baris ganjil
                  }
                  return Colors.white; // Warna putih untuk baris genap
                },
                createFooter: (PlutoGridStateManager stateManager) {
                  stateManager.setPageSize(20, notify: false);
                  return PlutoPagination(stateManager);
                },
                columns: columns,
                rows: dashboardController.rows,
                onChanged: (PlutoGridOnChangedEvent event) {
                  if (event.column.field == 'role_field') {
                    final String? useruid =
                        event.row.cells['user_uid']?.value as String?;
                    final String newRole = event.value as String;
                    if (useruid != null) {
                      dashboardController.updateUserRole(useruid, newRole);
                    }
                  }
                },
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  print(event);
                }),
          ),
        ],
      ),
    );
  }
}

List<PlutoColumn> columns = <PlutoColumn>[
  /// Text Column definition
  PlutoColumn(
    width: SizeConfig.horizontal(60),
    title: 'Nama',
    field: 'name_field',
    enableEditingMode: false,
    type: PlutoColumnType.text(),
    textAlign: PlutoColumnTextAlign.center,
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'Nama',
        size: SizeConfig.safeBlockHorizontal * 3,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),

  PlutoColumn(
    width: SizeConfig.horizontal(35),
    title: 'Role Member',
    field: 'role_field',
    type: PlutoColumnType.select(<String>['Guest', 'Admin', 'Super Admin']),
    textAlign: PlutoColumnTextAlign.center,
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'Role Member',
        size: SizeConfig.safeBlockHorizontal * 3,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),

  PlutoColumn(
      width: SizeConfig.horizontal(70),
      title: 'Email',
      field: 'email_value',
      type: PlutoColumnType.text(),
      titleTextAlign: PlutoColumnTextAlign.center,
      enableEditingMode: false,
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Email',
          size: SizeConfig.safeBlockHorizontal * 3,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),

  PlutoColumn(
      width: SizeConfig.horizontal(60),
      title: 'User UID',
      titleTextAlign: PlutoColumnTextAlign.center,
      field: 'user_uid',
      textAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'User UID',
          size: SizeConfig.safeBlockHorizontal * 3,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),
];
