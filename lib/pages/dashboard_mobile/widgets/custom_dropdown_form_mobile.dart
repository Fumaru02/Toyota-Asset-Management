import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../../widgets/text/roboto_text_view.dart';

class CustomDropDownFormMobile extends StatelessWidget {
  const CustomDropDownFormMobile({
    super.key,
    required this.list,
    required this.titleDropDown,
    required this.onChangedDropDownValue,
    required this.initialDropdown,
    required this.selectedDropdown,
  });

  final RxList<String> list;
  final String titleDropDown;
  final RxString onChangedDropDownValue;
  final RxString initialDropdown;
  final Function() selectedDropdown;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RobotoTextView(
            value: titleDropDown,
            size: SizeConfig.safeBlockHorizontal * 3,
            fontWeight: FontWeight.w500,
          ),
          Container(
            width: SizeConfig.horizontal(50),
            height: SizeConfig.horizontal(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(SizeConfig.horizontal(0.2))),
                border: Border.all(color: AppColors.greySmooth)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: onChangedDropDownValue.value.isEmpty
                    ? null
                    : (list.contains(onChangedDropDownValue.value)
                        ? onChangedDropDownValue.value
                        : null),
                icon: const Icon(Icons.arrow_drop_down),
                style: RobotoStyle().dropdownStyle(),
                onChanged: (String? value) {
                  value ??= initialDropdown.value;
                  onChangedDropDownValue.value = value;
                  selectedDropdown();
                },
                items: <String>['', ...list.toSet()]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value.isEmpty ? null : value,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.horizontal(0.8)),
                      child: RobotoTextView(
                        value: value.isEmpty ? initialDropdown.value : value,
                        size: SizeConfig.safeBlockHorizontal * 3,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
