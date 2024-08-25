import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../widgets/text/roboto_text_view.dart';

class TabelUsersData extends StatelessWidget {
  const TabelUsersData({
    super.key,
    required this.dashboardController,
  });

  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: SizeConfig.horizontal(79),
            height: SizeConfig.horizontal(4.5),
            child: PlutoGrid(
                configuration: PlutoGridConfiguration(
                  style: PlutoGridStyleConfig(
                      borderColor: AppColors.black,
                      columnHeight: SizeConfig.horizontal(2),
                      rowHeight: SizeConfig.horizontal(2)),
                ),
                columnMenuDelegate: const PlutoColumnMenuDelegateDefault(),
                rowColorCallback: (PlutoRowColorContext rowColorContext) {
                  if (rowColorContext.rowIdx.isEven) {
                    return AppColors.cyan; // Warna biru muda untuk baris ganjil
                  }
                  return Colors.white; // Warna putih untuk baris genap
                },
                columns: columns,
                rows: dashboardController.rows,
                onChanged: (PlutoGridOnChangedEvent event) {
                  if (event.column.field == 'role_field') {
                    final String? username =
                        event.row.cells['name_field']?.value as String?;
                    final String newRole = event.value as String;
                    if (username != null) {
                      dashboardController.updateUserRole(username, newRole);
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
        size: SizeConfig.safeBlockHorizontal * 1.2,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),

  PlutoColumn(
    title: 'Role Member',
    field: 'role_field',
    type: PlutoColumnType.select(<String>['Guest', 'Admin', 'Super Admin']),
    textAlign: PlutoColumnTextAlign.center,
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'Role Member',
        size: SizeConfig.safeBlockHorizontal * 1.2,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),

  PlutoColumn(
      title: 'Email',
      field: 'email_value',
      type: PlutoColumnType.text(),
      titleTextAlign: PlutoColumnTextAlign.center,
      enableEditingMode: false,
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Email',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),

  PlutoColumn(
      title: 'User UID',
      titleTextAlign: PlutoColumnTextAlign.center,
      field: 'user_uid',
      textAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'User UID',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),
];
