import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/login_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_config.dart';
import '../text/roboto_text_view.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.title,
    this.height,
    this.titleFontWeight,
    this.width,
    this.textSize,
    this.borderRadius,
    this.labelText,
    this.hintText,
    this.textColor,
    this.hintTextColor,
    this.borderColor,
    this.isPasswordField = false,
    this.suffixIcon,
    this.onChanged,
    this.autofillHint,
    this.textInputAction,
    this.contentPadding,
    this.prefixIcon,
    this.controller,
    this.passwordController,
    this.textAlignVertical,
    this.onFieldSubmitted,
    this.minLines,
    this.focus,
    this.style,
    this.keyboardType,
  });
  final String title;
  final double? height;
  final FontWeight? titleFontWeight;
  final double? width;
  final double? textSize;
  final double? borderRadius;
  final String? labelText;
  final String? hintText;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? borderColor;
  final bool? isPasswordField;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Iterable<String>? autofillHint;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final TextEditingController? passwordController;
  final TextAlignVertical? textAlignVertical;
  final Function(String)? onFieldSubmitted;
  final int? minLines;
  final FocusNode? focus;
  final TextStyle? style;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title == '')
            const SizedBox.shrink()
          else
            RobotoTextView(
                value: title,
                size: textSize ?? SizeConfig.safeBlockHorizontal * 1.5,
                fontWeight: titleFontWeight ?? FontWeight.w500,
                color: textColor ?? AppColors.black),
          SizedBox(
              width: SizeConfig.horizontal(width ?? 25),
              height: height ?? SizeConfig.vertical(7),
              // ignore: use_if_null_to_convert_nulls_to_bools
              child: isPasswordField == true
                  ? Obx(
                      () => TextFormField(
                          autofillHints: autofillHint,
                          minLines: minLines,
                          controller: controller,
                          focusNode: focus,
                          cursorColor: AppColors.maroon,
                          onChanged: onChanged,
                          keyboardType: TextInputType.text,
                          textInputAction: textInputAction,
                          // ignore: avoid_bool_literals_in_conditional_expressions, use_if_null_to_convert_nulls_to_bools
                          obscureText: isPasswordField == true
                              ? loginController.isObscurePassword.value =
                                  loginController.isObscurePassword.value
                              : false,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.maroon, width: 2.0),
                              ),
                              prefixIcon: prefixIcon,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  loginController.isObscurePassword.value =
                                      !loginController.isObscurePassword.value;
                                },
                                icon: Icon(
                                    loginController.isObscurePassword.isFalse
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                color: loginController.isObscurePassword.isFalse
                                    ? AppColors.black
                                    : AppColors.greyDisabled,
                              ),
                              fillColor: AppColors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(SizeConfig.horizontal(
                                          borderRadius ?? 0.5)))),
                              labelText: hintText,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: RobotoStyle().labelStyle())),
                    )
                  : TextFormField(
                      style: style,
                      autofillHints: autofillHint,
                      minLines: minLines,
                      controller: controller,
                      textAlignVertical: textAlignVertical,
                      focusNode: focus,
                      cursorColor: AppColors.maroon,
                      textInputAction: textInputAction,
                      onChanged: onChanged,
                      onFieldSubmitted: onFieldSubmitted,
                      keyboardType: keyboardType ?? TextInputType.text,
                      // ignore: avoid_bool_literals_in_conditional_expressions, use_if_null_to_convert_nulls_to_bools
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: borderColor ?? AppColors.maroon,
                                width: 2.0),
                          ),
                          contentPadding: contentPadding,
                          prefixIcon: prefixIcon,
                          suffixIcon: suffixIcon,
                          fillColor: AppColors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SizeConfig.horizontal(borderRadius ?? 0.5)))),
                          labelText: labelText,
                          hintText: hintText,
                          hintStyle: RobotoStyle().labelStyle(),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: RobotoStyle().labelStyle())))
        ]);
  }
}
