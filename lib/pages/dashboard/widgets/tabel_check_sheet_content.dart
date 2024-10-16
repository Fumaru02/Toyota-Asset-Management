import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../widgets/text/roboto_text_view.dart';

class TabelCheckSheetContent extends StatelessWidget {
  const TabelCheckSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(SizeConfig.horizontal(0.6)),
            alignment: Alignment.center,
            width: SizeConfig.horizontal(79),
            color: AppColors.maroon,
            child: RobotoTextView(
              value: 'List Check Asset',
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
                rows: rows,
                onChanged: (PlutoGridOnChangedEvent event) {
                  print(event);
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
        size: SizeConfig.safeBlockHorizontal * 1.2,
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
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),

  PlutoColumn(
    title: 'Images',
    field: 'images_val',
    type: PlutoColumnType.text(),
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'Images',
        size: SizeConfig.safeBlockHorizontal * 1.2,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),

  PlutoColumn(
      title: 'Category',
      field: 'category_value',
      type: PlutoColumnType.text(),
      titleTextAlign: PlutoColumnTextAlign.center,
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
      title: 'Lokasi',
      titleTextAlign: PlutoColumnTextAlign.center,
      field: 'location_value',
      textAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.text(),
      titleSpan: WidgetSpan(
        child: RobotoTextView(
          value: 'Lokasi',
          size: SizeConfig.safeBlockHorizontal * 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      backgroundColor: AppColors.maroon),
  PlutoColumn(
    title: 'Area',
    field: 'area_value',
    type: PlutoColumnType.text(),
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'Area',
        size: SizeConfig.safeBlockHorizontal * 1.2,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),
  PlutoColumn(
    title: 'Check',
    field: 'check_value',
    type: PlutoColumnType.text(),
    titleTextAlign: PlutoColumnTextAlign.center,
    backgroundColor: AppColors.maroon,
    titleSpan: WidgetSpan(
      child: RobotoTextView(
        value: 'Check',
        size: SizeConfig.safeBlockHorizontal * 1.2,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
  ),
];

List<PlutoRow> rows = <PlutoRow>[
  PlutoRow(
    cells: <String, PlutoCell>{
      'number_asset': PlutoCell(value: 1232122),
      'text_asset_name': PlutoCell(value: 'Lenovo'),
      'images_val': PlutoCell(value: 'www.photo.com'),
      'category_value': PlutoCell(value: 'Laptop'),
      'location_value': PlutoCell(value: 'Akti Office'),
      'area_value': PlutoCell(value: 'TLC 1 KRW'),
      'check_value': PlutoCell(value: ''),
    },
  ),
  PlutoRow(
    cells: <String, PlutoCell>{
      'number_asset': PlutoCell(value: 2),
      'text_asset_name': PlutoCell(value: 'Asus'),
      'images_val': PlutoCell(value: 'www.photo.com'),
      'category_value': PlutoCell(value: 'Laptop'),
      'location_value': PlutoCell(value: 'Dojo machining'),
      'area_value': PlutoCell(value: 'TLC 2 KRW'),
      'check_value': PlutoCell(value: ''),
    },
  ),
  PlutoRow(
    cells: <String, PlutoCell>{
      'number_asset': PlutoCell(value: 2),
      'text_asset_name': PlutoCell(value: 'xiaomi'),
      'images_val': PlutoCell(value: 'www.photo.com'),
      'category_value': PlutoCell(value: 'Laptop'),
      'location_value': PlutoCell(value: 'Dojo HPW'),
      'area_value': PlutoCell(value: 'TLC 3 KRW'),
      'check_value': PlutoCell(value: ''),
    },
  ),
  PlutoRow(
    cells: <String, PlutoCell>{
      'number_asset': PlutoCell(value: 2),
      'text_asset_name': PlutoCell(value: 'xiaomi'),
      'images_val': PlutoCell(value: 'www.photo.com'),
      'category_value': PlutoCell(value: 'Laptop'),
      'location_value': PlutoCell(value: 'Dojo HPW'),
      'area_value': PlutoCell(value: 'TLC 3 KRW'),
      'check_value': PlutoCell(value: ''),
    },
  ),
];
