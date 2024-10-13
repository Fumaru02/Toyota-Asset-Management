import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/get_data_user.dart';
import '../models/get_list_assets.dart';
import '../models/staging_data_user.dart';
import '../pages/dashboard/widgets/dashboard_content.dart';
import 'update_sheet_controller.dart';

class DashboardController extends GetxController {
  UpdateSheetController updateSheetController =
      Get.put(UpdateSheetController());

  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  RxInt sideMenuIndex = RxInt(0);
  RxList<GetDataUser> dataUsers = RxList<GetDataUser>(<GetDataUser>[]);
  RxList<StagingDataUser> stagingData =
      RxList<StagingDataUser>(<StagingDataUser>[]);
  RxList<String> area = RxList<String>(<String>[]);
  RxList<String> category = RxList<String>(<String>[]);
  RxList<String> coordinator = RxList<String>(<String>[]);
  RxList<String> location = RxList<String>(<String>[]);
  RxList<int> checkedAreaByPIC = RxList<int>(<int>[]);
  RxString onChangedDropDownArea = RxString('');
  RxString onChangedDropDownPic = RxString('');
  RxString username = RxString('');
  RxString dropdownInitialArea = RxString('Semua Area');
  RxString dropdownInitialPic = RxString('Semua PIC');
  final RxMap<String, int> picTotals = <String, int>{}.obs;
  RxString monthByName = RxString('');
  RxInt month = RxInt(0);
  RxInt year = RxInt(0);
  RxList<String> allPic = RxList<String>(<String>[]);
  RxList<int> allPicTotalCheck = RxList<int>(<int>[]);
  RxList<int> allPicTotalAssets = RxList<int>(<int>[]);
  RxList<String> sortArea = RxList<String>(<String>[]);
  RxList<GetListAssets> dataList = RxList<GetListAssets>(<GetListAssets>[]);
  RxList<PlutoRow> rows = RxList<PlutoRow>(<PlutoRow>[]);
  RxList<PlutoRow> rowsStagingData = RxList<PlutoRow>(<PlutoRow>[]);
  RxList<PlutoRow> rowListAsset = RxList<PlutoRow>(<PlutoRow>[]);
  List<SalesData> assetHandled = <SalesData>[];
  List<SalesData> totalAssetHandledByPIC = <SalesData>[];
  List<SalesData> totalCheckAllArea = <SalesData>[];
  List<SalesData> totalCheckByArea = <SalesData>[];

  final RxList<String> areaPics = <String>[].obs;

  RxBool isLoading = RxBool(false);
  RxInt handledPICtotal = RxInt(0);
  RxInt selectedAreaTotalAsset = RxInt(0);
  RxInt selectedAreaTotalAssetChecked = RxInt(0);
  RxInt grapicsValueAssetChecked = RxInt(0);
  RxInt grapicsValueTotalHandledbyPIC = RxInt(1);

  RxInt tlc1krw = RxInt(0);
  RxInt tlc3krw = RxInt(0);
  RxInt tlc2str = RxInt(0);
  RxInt sunter1 = RxInt(0);
  RxInt akti = RxInt(0);
  RxInt ho = RxInt(0);

  RxInt tlc1krwChecked = RxInt(0);
  RxInt tlc3krwChecked = RxInt(0);
  RxInt tlc2strChecked = RxInt(0);
  RxInt sunter1Checked = RxInt(0);
  RxInt aktiChecked = RxInt(0);
  RxInt hoChecked = RxInt(0);
  String initialMonth = DateTime.now().month.toString();
  String initialYear = DateTime.now().year.toString();
  final RxMap<String, int> picAssetCounts = <String, int>{}.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxMap<String, int> areaTotals = <String, int>{}.obs;
  List<String> get areas => areaTotals.keys.toList();

  @override
  void onInit() {
    super.onInit();
    getDataUserManagement();
    totalCheckingAssetAllArea('$initialMonth/$initialYear');
    countLocationsTotalAllArea();
    getData();
    getListAsset();
    getListMenu();
    sideMenu.addListener((int index) {
      pageController.jumpToPage(index);
    });
    print('${username.value} lol');
  }

  Future<void> getDataUserManagement() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Referensi ke dokumen user
      final DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Mengambil data dokumen
      final DocumentSnapshot docSnapshot = await userDoc.get();

      // Memeriksa apakah dokumen ada
      if (docSnapshot.exists) {
        // Mengambil data sebagai Map
        final Map<String, dynamic> data =
            docSnapshot.data()! as Map<String, dynamic>;

        // Mengambil username
        username.value = data['username'] as String;
        print('${username.value} test');
        getUserAssetStage(username.value);
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print('Error saat mengambil data: $e');
    }
  }

  Future<void> chooseDate(bool isForm) async {
    final DateTime? pickedDate = await showMonthYearPicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: isForm == true ? DateTime(1920) : DateTime(2021),
      lastDate: DateTime(2099),
      locale: const Locale('id', 'ID'),
    );

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
      month.value = pickedDate.month;
      year.value = pickedDate.year;
      updateSheetController.year.value = pickedDate.year;
      final DateFormat monthFormat = DateFormat('MMMM', 'id_ID');

      monthByName.value = monthFormat.format(pickedDate);
      Get.snackbar(
        'Tanggal Dipilih',
        'Anda telah memilih: ${pickedDate.month}/${pickedDate.year}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> getPics(String area) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _firestore.collection('data').doc('menu_list').get();

      if (!documentSnapshot.exists) {
        log('Document does not exist');
        return;
      }

      final Map<String, dynamic> data =
          documentSnapshot.data()! as Map<String, dynamic>;

      // Mengambil data area
      final List<dynamic> areaData = data['pic'] as List<dynamic>;

      for (final dynamic item in areaData) {
        if (item is Map<String, dynamic> && item.containsKey(area)) {
          final dynamic picinArea = item[area];
          if (picinArea is List) {
            areaPics.value = picinArea
                .map((dynamic e) => e.toString().toUpperCase())
                .toList();
          } else if (picinArea is String) {
            areaPics.value = <String>[picinArea.toUpperCase()];
          } else {
            log('Unexpected data type for pic');
          }
          break;
        }
      }

      print('Area PICs: ${areaPics.join(', ')}');
      update();
    } catch (e) {
      log('Error retrieving data: $e');
    }
  }

  Future<void> getListMenu() async {
    final DocumentSnapshot documentSnapshot =
        await _firestore.collection('data').doc('menu_list').get();
    if (!documentSnapshot.exists) {
      log('Document does not exist');
      return;
    }
    final Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    // Mengkonversi List<dynamic> menjadi List<String>
    area.value = (data['area'] as List<dynamic>)
        .map((dynamic e) => e.toString().toUpperCase())
        .toList();
    category.value = (data['category'] as List<dynamic>)
        .map((dynamic e) => e.toString().toUpperCase())
        .toList();

    coordinator.value = (data['coordinator'] as List<dynamic>)
        .map((dynamic e) => e.toString().toUpperCase())
        .toList();
    location.value = (data['location'] as List<dynamic>)
        .map((dynamic e) => e.toString().toUpperCase())
        .toList();
    log(location.toString());
    update();
  }

  Future<void> countPicHandled(String pic) async {
    totalAssetHandledByPIC.clear();
    final DocumentSnapshot documentSnapshot =
        await _firestore.collection('data').doc('assets').get();

    if (!documentSnapshot.exists) {
      print('Document does not exist');
      return;
    }

    final Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    final List<dynamic> assets = data['list_assets'] as List<dynamic>;

    handledPICtotal.value = 0;
    for (final dynamic asset in assets) {
      if (asset is Map<String, dynamic>) {
        if (asset['pic'] == pic) {
          handledPICtotal.value++;
        }
      }
    }
    totalAssetHandledByPIC
        .add(SalesData('', 0, handledPICtotal.value as double));

    if (onChangedDropDownArea.value != '' && pic != '') {
      handledPICtotal.value = 0;

      for (final dynamic asset in assets) {
        if (asset is Map<String, dynamic>) {
          if (asset['pic'] == pic &&
              asset['area'] == onChangedDropDownArea.value) {
            handledPICtotal.value++;
          }
        }
      }
    }

    update();
  }

  Future<void> totalCheckingAssetAllArea(String date) async {
    totalCheckByArea.clear();
    tlc1krwChecked.value = 0;
    tlc3krwChecked.value = 0;
    tlc2strChecked.value = 0;
    sunter1Checked.value = 0;
    aktiChecked.value = 0;
    hoChecked.value = 0;
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('data')
        .doc('checking_asset')
        .get();

    if (snapshot.exists) {
      final Map<String, dynamic> data =
          snapshot.data()! as Map<String, dynamic>;
      if (data.containsKey(date)) {
        final Map<String, dynamic> monthData =
            data[date] as Map<String, dynamic>;
        if (monthData.containsKey('area')) {
          final List<dynamic> areaList = monthData['area'] as List<dynamic>;

          for (final dynamic areaItem in areaList) {
            if (areaItem is Map<String, dynamic> &&
                areaItem.containsKey('tlc1_krw')) {
              print('Area TLC1_KRW: ${areaItem['tlc1_krw']}');

              tlc1krwChecked.value = areaItem['tlc1_krw'] as int;
            }
            if (areaItem is Map<String, dynamic> &&
                areaItem.containsKey('akti')) {
              print('Area akti: ${areaItem['akti']}');

              aktiChecked.value = areaItem['akti'] as int;
            }
            if (areaItem is Map<String, dynamic> &&
                areaItem.containsKey('tlc2_str')) {
              print('Area tlc2_str: ${areaItem['tlc2_str']}');

              tlc2strChecked.value = areaItem['tlc2_str'] as int;
            }
            if (areaItem is Map<String, dynamic> &&
                areaItem.containsKey('ho')) {
              print('Area ho: ${areaItem['ho']}');

              hoChecked.value = areaItem['ho'] as int;
            }
            if (areaItem is Map<String, dynamic> &&
                areaItem.containsKey('tlc3_krw')) {
              print('Area tlc3_krw: ${areaItem['tlc3_krw']}');

              tlc3krwChecked.value = areaItem['tlc3_krw'] as int;
            }
            if (areaItem is Map<String, dynamic> &&
                areaItem.containsKey('sunter1')) {
              print('Area sunter1: ${areaItem['sunter1']}');

              sunter1Checked.value = areaItem['sunter1'] as int;
            }
          }
        }
      }
    }
  }

//dummy
  Future<void> totalCheckingAssetByArea(
      String selectedArea, String date) async {
    totalCheckByArea.clear();
    if (onChangedDropDownPic.value == 'Semua PIC') {
      totalAssetHandledByPIC.clear();
      assetHandled.clear();
    }

    allPic.clear();
    totalPicByArea(date, selectedArea);
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('data')
        .doc('checking_asset')
        .get();

    if (snapshot.exists) {
      final Map<String, dynamic> data =
          snapshot.data()! as Map<String, dynamic>;
      if (data.containsKey(date)) {
        final Map<String, dynamic> monthData =
            data[date] as Map<String, dynamic>;
        if (monthData.containsKey('area')) {
          final List<dynamic> areaList = monthData['area'] as List<dynamic>;

          for (final dynamic areaItem in areaList) {
            if (areaItem is Map<String, dynamic> &&
                areaItem.containsKey(selectedArea)) {
              log(selectedArea);

              print('Area TLC1 KRW: ${areaItem[selectedArea]}');
              totalCheckByArea
                  .add(SalesData('', 1, areaItem[selectedArea] as double));
              return;
            }
          }
        }
      }
    }
    update();
  }

  Future<void> totalPicByArea(String date, String area) async {
    print('$area ini area');
    isLoading.value = true;
    picTotals.clear();
    allPicTotalCheck.clear();
    assetHandled.clear();

    final String modifyStringArea = area.toLowerCase().replaceAll(' ', '_');

    print('$modifyStringArea ini area');

    if (date == '0/0') {
      date = '$initialMonth/$initialYear';
    }

    try {
      // Fetch checking_asset document
      final DocumentSnapshot checkingAssetSnapshot = await FirebaseFirestore
          .instance
          .collection('data')
          .doc('checking_asset')
          .get();

      if (checkingAssetSnapshot.exists) {
        final Map<String, dynamic> data =
            checkingAssetSnapshot.data()! as Map<String, dynamic>;

        if (data.containsKey(date)) {
          final Map<String, dynamic> monthData =
              data[date] as Map<String, dynamic>;
          if (monthData.containsKey('PIC')) {
            final List<dynamic> picList = monthData['PIC'] as List<dynamic>;

            for (final dynamic picItem in picList) {
              if (picItem is Map<String, dynamic>) {
                picItem.forEach((String name, dynamic value) {
                  if (value is List<dynamic> &&
                      value.isNotEmpty &&
                      value[0] is Map<String, dynamic>) {
                    final Map<String, dynamic> firstItem =
                        value[0] as Map<String, dynamic>;
                    // Check if the PIC has tlc1_krw
                    if (firstItem.containsKey(modifyStringArea)) {
                      final int total = firstItem[modifyStringArea] as int;
                      if (!allPic.contains(name)) {
                        allPic.add(name);
                      }
                      picTotals[name] = (picTotals[name] ?? 0) + total;
                      log('$name has $area: $total');
                    }
                  }
                });
              }
            }

            allPic.sort();

            // Add totals to allPicTotalCheck in the same order as allPic
            for (final String name in allPic) {
              allPicTotalCheck.add(picTotals[name] ?? 0);
            }
          }
        }
      }

      // Fetch assets document
      final DocumentSnapshot assetSnapshot = await FirebaseFirestore.instance
          .collection('data')
          .doc('assets')
          .get();

      if (assetSnapshot.exists) {
        final Map<String, dynamic> assetData =
            assetSnapshot.data()! as Map<String, dynamic>;
        final List<dynamic> assetList =
            assetData['list_assets'] as List<dynamic>;
        for (final asset in assetList) {
          if (asset is Map<String, dynamic>) {
            final String? pic = asset['pic'] as String?;
            if (pic != null) {
              picAssetCounts[pic] = (picAssetCounts[pic] ?? 0) + 1;
            }
          }
        }
      }

      // Print the results
      for (final String name in allPic) {
        log('$name total check ${picTotals[name]} and total handle asset ${picAssetCounts[name] ?? 0}');
        allPicTotalAssets.add(picAssetCounts[name] ?? 0);
      }
      update();
    } catch (e) {
      log('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<SalesData> getDataHandledAssetPic() {
    // Use the actual length of allPicTotalCheck
    final int dataLength = allPicTotalCheck.length;

    return List.generate(dataLength, (int index) {
      return SalesData(
        'TLC#1',
        index + 1,
        allPicTotalAssets[index].toDouble(),
      );
    });
  }

  List<SalesData> getTLC1DataSource() {
    // Use the actual length of allPicTotalCheck
    final int dataLength = allPicTotalCheck.length;

    return List.generate(dataLength, (int index) {
      return SalesData(
        'TLC#1',
        index + 1,
        allPicTotalCheck[index].toDouble(),
      );
    });
  }

  Future<void> totalCheckingAsset(String selectedPerson, String date) async {
    isLoading.value = true;
    assetHandled.clear();
    if (date == '0/0') {
      date = '$initialMonth/$initialYear';
    }
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('data')
          .doc('checking_asset')
          .get();

      int total = 0;
      if (snapshot.exists) {
        final Map<String, dynamic> data =
            snapshot.data()! as Map<String, dynamic>;

        if (data.containsKey(date)) {
          final Map<String, dynamic> monthData =
              data[date] as Map<String, dynamic>;
          if (monthData.containsKey('PIC')) {
            final List<dynamic> picList = monthData['PIC'] as List<dynamic>;
            print('$picList LISTT');
            for (final dynamic picItem in picList) {
              if (picItem is Map<String, dynamic>) {}
              if (picItem is Map<String, dynamic> &&
                  picItem.containsKey(selectedPerson)) {
                final List<dynamic> locations =
                    picItem[selectedPerson] as List<dynamic>;
                print('$selectedPerson:');
                for (final dynamic location in locations) {
                  if (location is Map<String, dynamic>) {
                    location.forEach((String locationName, dynamic value) {
                      print('L  $locationName: $value');
                      sortArea.add(locationName);
                      checkedAreaByPIC.add(value as int);
                      total += value;
                    });
                  }
                }
                assetHandled.add(SalesData(
                    '', grapicsValueAssetChecked.value, total as double));

                isLoading.value = false;

                return;
              }
            }
            isLoading.value = false;

            print('Data untuk $selectedPerson tidak ditemukan');
          }
        } else {
          isLoading.value = false;

          print('Data untuk bulan $date tidak ditemukan');
        }
      } else {
        isLoading.value = false;

        print('Dokumen Asset tidak ditemukan');
      }
      Future.delayed(const Duration(seconds: 1));
      isLoading.value = false;
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> countSelectedLocations(String selectedArea) async {
    final String modifiedArea = selectedArea.toLowerCase();

    areaPics.clear();
    getPics(modifiedArea);
    if (modifiedArea == 'tlc1 krw') {
      selectedAreaTotalAsset.value = tlc1krw.value;
      selectedAreaTotalAssetChecked.value = tlc1krwChecked.value;
    } else if (modifiedArea == 'tlc3 krw') {
      selectedAreaTotalAsset.value = tlc3krw.value;
      selectedAreaTotalAssetChecked.value = tlc3krwChecked.value;
    } else if (modifiedArea == 'tlc2 str') {
      selectedAreaTotalAsset.value = tlc2str.value;
      selectedAreaTotalAssetChecked.value = tlc2strChecked.value;
    } else if (modifiedArea == 'sunter 1') {
      selectedAreaTotalAsset.value = sunter1.value;
      selectedAreaTotalAssetChecked.value = sunter1Checked.value;
    } else if (modifiedArea == 'akti') {
      selectedAreaTotalAsset.value = akti.value;
      selectedAreaTotalAssetChecked.value = aktiChecked.value;
    } else if (modifiedArea == 'ho') {
      selectedAreaTotalAsset.value = ho.value;
      selectedAreaTotalAssetChecked.value = hoChecked.value;
    }
    update();
  }

  Future<void> countLocationsTotalAllAreaChecked() async {
    isLoading.value = true;

    // Mengambil dokumen dari koleksi 'data' dengan ID 'assets'
    final DocumentSnapshot documentSnapshot =
        await _firestore.collection('data').doc('assets').get();

    if (!documentSnapshot.exists) {
      log('Document does not exist');
      return;
    }

    final Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    tlc1krw.value = 0;
    tlc2str.value = 0;
    ho.value = 0;
    akti.value = 0;
    sunter1.value = 0;

    // Data Anda adalah list of maps, bukan map of maps
    final List<dynamic> assets = data['list_assets'] as List<dynamic>;
    for (final dynamic asset in assets) {
      if (asset is Map) {
        if (asset['area'] == 'tlc1 krw') {
          tlc1krw.value++;
        } else if (asset['area'] == 'tlc3 krw') {
          tlc3krw.value++;
        } else if (asset['area'] == 'tlc2 str') {
          tlc2str.value++;
        } else if (asset['area'] == 'sunter 1') {
          sunter1.value++;
        } else if (asset['area'] == 'akti') {
          akti.value++;
        } else if (asset['area'] == 'ho') {
          ho.value++;
        }
      }
    }

    update();
    isLoading.value = false;
  }

  Future<void> countLocationsTotalAllArea() async {
    isLoading.value = true;

    // Mengambil dokumen dari koleksi 'data' dengan ID 'assets'
    final DocumentSnapshot documentSnapshot =
        await _firestore.collection('data').doc('assets').get();

    if (!documentSnapshot.exists) {
      log('Document does not exist');
      return;
    }

    final Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    tlc1krw.value = 0;
    tlc2str.value = 0;
    ho.value = 0;
    akti.value = 0;
    sunter1.value = 0;

    final List<dynamic> assets = data['list_assets'] as List<dynamic>;
    for (final dynamic asset in assets) {
      if (asset is Map) {
        if (asset['area'] == 'tlc1 krw') {
          tlc1krw.value++;
        } else if (asset['area'] == 'tlc3 krw') {
          tlc3krw.value++;
        } else if (asset['area'] == 'tlc2 str') {
          tlc2str.value++;
        } else if (asset['area'] == 'sunter 1') {
          sunter1.value++;
        } else if (asset['area'] == 'akti') {
          akti.value++;
        } else if (asset['area'] == 'ho') {
          ho.value++;
        }
      }
    }

    update();
    isLoading.value = false;
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
              'area_value': PlutoCell(value: data.area.toUpperCase()),
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

  List<PlutoRow> convertToStagingTabel(List<StagingDataUser> users) {
    return users
        .map((StagingDataUser data) => PlutoRow(
              cells: <String, PlutoCell>{
                'asset_name': PlutoCell(value: data.assetName),
                'area_field': PlutoCell(value: data.area),
                'category_field': PlutoCell(value: data.category),
                'coordinator_field': PlutoCell(value: data.coordinator),
                'image_field': PlutoCell(value: data.image),
                'input_time_field': PlutoCell(value: data.inputTime),
                'is_check_field': PlutoCell(value: data.isCheck),
                'location_field': PlutoCell(value: data.location),
                'no_asset': PlutoCell(value: data.noAsset),
                'pic_field': PlutoCell(value: data.pic),
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

  Future<void> getUserAssetStage(String name) async {
    try {
      print('Starting getUserAssetStage for user: $name');
      isLoading.value = true;

      if (name.isEmpty) {
        print('Error: Username is empty');
        return;
      }

      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firestore.collection('staging_data').doc(name).get();

      print('Document exists: ${docSnapshot.exists}');
      print('Document data: ${docSnapshot.data()}');

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final Map<String, dynamic> data = docSnapshot.data()!;
        if (data['staging_list_assets'] is List) {
          final List<dynamic> assets =
              data['staging_list_assets'] as List<dynamic>;
          print('Raw assets data: $assets');

          stagingData.value = assets
              .map((asset) =>
                  StagingDataUser.fromJson(asset as Map<String, dynamic>))
              .toList();

          // print(
          //     'Parsed staging data: ${stagingData.map((StagingDataUser e) => e.toJson()).toList()}');
          print('Staging data length: ${stagingData.length}');

          rowsStagingData.value = convertToStagingTabel(stagingData);
          print('Converted rows length: ${rowsStagingData.length}');
        } else {
          print('staging_list_assets is not a List or is null');
          stagingData.clear();
          rowsStagingData.clear();
        }
      } else {
        print('No data found for user: $name');
        stagingData.clear();
        rowsStagingData.clear();
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e');
      print('Stack trace: $stackTrace');
      stagingData.clear();
      rowsStagingData.clear();
    } finally {
      isLoading.value = false;
      update();
      print(
          'getUserAssetStage completed. Final staging data length: ${stagingData.length}');
    }
  }
}
