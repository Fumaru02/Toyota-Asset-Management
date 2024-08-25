import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/get_data_user.dart';
import '../models/get_list_assets.dart';

class DashboardController extends GetxController {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  RxInt sideMenuIndex = RxInt(0);
  RxList<GetDataUser> dataUsers = RxList<GetDataUser>(<GetDataUser>[]);
  RxList<GetListAssets> dataList = RxList<GetListAssets>(<GetListAssets>[]);
  RxList<PlutoRow> rows = RxList<PlutoRow>(<PlutoRow>[]);
  RxList<PlutoRow> rowListAsset = RxList<PlutoRow>(<PlutoRow>[]);
  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    getData();
    getListAsset();
    super.onInit();
    sideMenu.addListener((int index) {
      pageController.jumpToPage(index);
    });
  }

  Future<void> getListAsset() async {
    try {
      isLoading.value = true;
      await _firestore
          .collection('data')
          .doc('assets')
          .get()
          .then((DocumentSnapshot<dynamic> documentSnapshot) {
        final Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> listData = data['list_assets'] as List<dynamic>;
        log(listData.toString());
        dataList.value = listData
            .map((dynamic e) =>
                GetListAssets.fromJson(e as Map<String, dynamic>))
            .toList();
        rowListAsset.value = convertToListAssetsTabel(dataList);
        log(rowListAsset.toString());
      });
      isLoading.value = false;
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  List<PlutoRow> convertToListAssetsTabel(List<GetListAssets> list) {
    return list
        .map(
          (GetListAssets data) => PlutoRow(
            cells: <String, PlutoCell>{
              'number_asset': PlutoCell(value: data.noAsset),
              'pic_name': PlutoCell(value: data.pic),
              'text_asset_name': PlutoCell(value: data.assetName),
              'category_value': PlutoCell(value: data.category),
              'location_value': PlutoCell(value: data.location),
              'area_value': PlutoCell(value: data.area),
              'koordinator_value': PlutoCell(value: data.coordinator),
            },
          ),
        )
        .toList();
  }

  List<PlutoRow> convertToUserTabel(List<GetDataUser> users) {
    return users
        .map((GetDataUser user) => PlutoRow(
              cells: <String, PlutoCell>{
                'name_field': PlutoCell(value: user.username),
                'role_field': PlutoCell(value: user.role),
                'email_value': PlutoCell(value: user.email),
                'user_uid': PlutoCell(value: user.userUid),
                'time_creation': PlutoCell(value: user.creationTime),
              },
            ))
        .toList();
  }

  Future<void> updateUserRole(String username, String newRole) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(username)
          .update(<Object, Object?>{'role': newRole});
      print('User role updated successfully');
      update();
    } catch (e) {
      print('Error updating user role: $e');
    }
  }

  Future<void> getData() async {
    try {
      // Get docs from collection reference
      final QuerySnapshot querySnapshot =
          await _firestore.collection('users').get();

      // Get data from docs and convert map to List
      dataUsers.value = querySnapshot.docs
          .map((QueryDocumentSnapshot<Object?> doc) =>
              GetDataUser.fromJson(doc.data()! as Map<String, dynamic>))
          .toList();
      rows.value = convertToUserTabel(dataUsers);
      update();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
