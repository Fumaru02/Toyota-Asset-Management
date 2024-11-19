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
import '../pages/dashboard_desktop/dashboard_content.dart';
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
  RxString userRole = RxString('');
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
  RxList<String> sortedPic = RxList<String>(<String>[]);
  RxList<String> sortedPicCheck = RxList<String>(<String>[]);
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
  final RxDouble totalPersentase = RxDouble(0);
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
  final RxMap<String, int> picAssetCheckedAsset = <String, int>{}.obs;
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
        userRole.value = data['role'] as String;
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
      final String modifiedArea = area.toLowerCase();
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
        if (item is Map<String, dynamic> && item.containsKey(modifiedArea)) {
          final dynamic picinArea = item[modifiedArea];
          if (picinArea is List) {
            areaPics.value = picinArea
                .map((dynamic e) => e.toString().toUpperCase())
                .toList();
          } else if (picinArea is String) {
            areaPics.value = <String>[picinArea];
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

  Stream<DocumentSnapshot> getAssetCheckingStream() {
    return FirebaseFirestore.instance
        .collection('data')
        .doc('checking_asset')
        .snapshots();
  }

  // Method untuk mengolah data dari snapshot
  void processAreaData(Map<String, dynamic> areaMap) {
    if (areaMap.containsKey('tlc1 krw')) {
      final List<dynamic> tlc1List = areaMap['tlc1 krw'] as List<dynamic>;
      tlc1krwChecked.value = tlc1List.length;
    }
    if (areaMap.containsKey('tlc2 str')) {
      final List<dynamic> tlc2StrList = areaMap['tlc2 str'] as List<dynamic>;
      tlc2strChecked.value = tlc2StrList.length;
    }
    if (areaMap.containsKey('tlc3 krw')) {
      final List<dynamic> tlc3List = areaMap['tlc3 krw'] as List<dynamic>;
      tlc3krwChecked.value = tlc3List.length;
    }
    if (areaMap.containsKey('sunter 1')) {
      final List<dynamic> sunter1List = areaMap['sunter 1'] as List<dynamic>;
      sunter1Checked.value = sunter1List.length;
    }
    if (areaMap.containsKey('akti')) {
      final List<dynamic> aktiList = areaMap['akti'] as List<dynamic>;
      aktiChecked.value = aktiList.length;
    }
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

          for (final dynamic area in areaList) {
            // Pastikan area adalah Map
            final Map<String, dynamic> areaMap = area as Map<String, dynamic>;

            if (areaMap.containsKey('tlc1 krw')) {
              final List<dynamic> tlc1List =
                  areaMap['tlc1 krw'] as List<dynamic>;
              tlc1krwChecked.value = tlc1List.length;
            }

            if (areaMap.containsKey('tlc2 str')) {
              final List<dynamic> tlc2StrList =
                  areaMap['tlc2 str'] as List<dynamic>;
              tlc2strChecked.value = tlc2StrList.length;
            }

            if (areaMap.containsKey('tlc3 krw')) {
              final List<dynamic> tlc3List =
                  areaMap['tlc3 krw'] as List<dynamic>;
              tlc3krwChecked.value = tlc3List.length;
            }
            if (areaMap.containsKey('sunter 1')) {
              final List<dynamic> sunter1List =
                  areaMap['sunter 1'] as List<dynamic>;
              sunter1Checked.value = sunter1List.length;
            }

            if (areaMap.containsKey('akti')) {
              final List<dynamic> aktiList = areaMap['akti'] as List<dynamic>;
              aktiChecked.value = aktiList.length;
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
    sortedPic.clear();
    allPic.clear();
    final String modifiedSelectedArea = selectedArea.toLowerCase();
    totalPicByArea(date, modifiedSelectedArea);
    getPicsWithCheckedCount(modifiedSelectedArea);
  }

  Future<void> getPicsWithCheckedCount(String targetArea) async {
    final Map<String, int> picAssetCheckedAsset = <String, int>{};
    // List untuk menyimpan nama-nama PIC
    List<String> picNames = <String>[];
    List<int> assetCounts = <int>[];
    try {
      final DocumentSnapshot checkingAssetSnapshot = await FirebaseFirestore
          .instance
          .collection('data')
          .doc('checking_asset')
          .get();

      if (checkingAssetSnapshot.exists) {
        final Map<String, dynamic> data =
            checkingAssetSnapshot.data()! as Map<String, dynamic>;

        data.forEach((String month, dynamic monthData) {
          if (monthData is Map<String, dynamic> &&
              monthData.containsKey('area')) {
            final List<dynamic> areas = monthData['area'] as List<dynamic>;

            for (final area in areas) {
              if (area is Map<String, dynamic> &&
                  area.containsKey(targetArea)) {
                final List<dynamic> assets = area[targetArea] as List<dynamic>;

                for (final asset in assets) {
                  if (asset is Map<String, dynamic> &&
                      asset.containsKey('pic')) {
                    final String pic = asset['pic'] as String;
                    picAssetCheckedAsset[pic] =
                        (picAssetCheckedAsset[pic] ?? 0) + 1;
                  }
                }
              }
            }
          }
        });

        if (picAssetCheckedAsset.isEmpty) {
          print('No PICs found in $targetArea');
        } else {
          // Sort dan convert ke List<MapEntry>
          final List<MapEntry<String, int>> sortedEntries =
              picAssetCheckedAsset.entries.toList()
                ..sort((MapEntry<String, int> a, MapEntry<String, int> b) =>
                    a.key.compareTo(b.key));

          // Mengambil hanya nama PIC yang sudah diurutkan
          picNames = sortedEntries
              .map((MapEntry<String, int> entry) => entry.key)
              .toList();

          assetCounts = sortedEntries
              .map((MapEntry<String, int> entry) => entry.value)
              .toList();
          allPicTotalCheck.value = assetCounts;
          // Assign ke sortedPicCheck untuk digunakan di UI
          sortedPicCheck.value = picNames;

          // Print hasil untuk verifikasi
          print('\nPIC Names in $targetArea:');
          for (int i = 0; i < picNames.length; i++) {
            print(
                '${i + 1}. ${picNames[i]}: ${picAssetCheckedAsset[picNames[i]]} assets');
          }
        }
      }
    } catch (e) {
      print('Error fetching PIC data: $e');
      rethrow;
    }
  }

  Future<void> totalPicByArea(String date, String area) async {
    isLoading.value = true;
    picTotals.clear();
    allPicTotalCheck.clear();
    allPicTotalAssets.clear();
    sortedPic.value = <String>[];
    assetHandled.clear();
    picAssetCounts.clear();

    final Set<String> picNames = <String>{};
    if (date == '0/0') {
      date = '$initialMonth/$initialYear';
    }

    try {
      // Ambil dokumen dari collection 'data' dengan dokumen 'assets'
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('data')
          .doc('assets')
          .get();

      if (!snapshot.exists) {
        log('Document does not exist');
      }

      // Cast data ke Map
      final Map<String, dynamic> data =
          snapshot.data()! as Map<String, dynamic>;

      // Ambil list_assets dari data
      if (data.containsKey('list_assets')) {
        final List<dynamic> assets = data['list_assets'] as List<dynamic>;

        // Filter assets berdasarkan area yang ditentukan
        for (final asset in assets) {
          if (asset is Map<String, dynamic> &&
              asset.containsKey('area') &&
              asset.containsKey('pic') &&
              asset['area'].toString().toLowerCase() == area.toLowerCase()) {
            picNames.add(asset['pic'] as String);
          }
        }
      }
      // Convert Set ke List dan sort
      sortedPic.value = picNames.toList()..sort();

      // Log untuk debugging
      log('Found ${sortedPic.length} PICs in area $area');
      for (final String pic in sortedPic) {
        log('PIC: $pic');
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
      for (final String name in sortedPic) {
        allPicTotalAssets.add(picAssetCounts[name] ?? 0);
      }
      log('test ${allPicTotalAssets[0]}');

      update();
    } catch (e) {
      log('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<SalesData> getDataHandledAssetPic() {
    // Use the actual length of allPicTotalCheck
    final int dataLength = sortedPic.length;

    return List.generate(dataLength, (int index) {
      return SalesData(
        allPicTotalAssets[index].toString(),
        index + 1,
        allPicTotalAssets[index].toDouble(),
      );
    });
  }

  List<SalesData> getTLC1DataSource() {
    // Use the actual length of allPicTotalCheck
    final int dataLength = sortedPicCheck.length;

    return List.generate(dataLength, (int index) {
      return SalesData(
        'TLC#1',
        index + 1,
        allPicTotalCheck[index].toDouble(),
      );
    });
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
    if (assets.isEmpty) {
      return;
    }
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
        dataList.value = listData
            .map((dynamic e) =>
                GetListAssets.fromJson(e as Map<String, dynamic>))
            .toList();
        rowListAsset.value = convertToListAssetsTabel(dataList);
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
              'year_field': PlutoCell(value: data.year),
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

  List<PlutoRow> convertToStagingTabel(List<dynamic> users) {
    return users
        .map((dynamic data) => PlutoRow(
              cells: <String, PlutoCell>{
                'asset_name': PlutoCell(value: data.assetName),
                'area_field': PlutoCell(value: data.area.toUpperCase()),
                'category_field': PlutoCell(value: data.category),
                'coordinator_field': PlutoCell(value: data.coordinator),
                'image_field': PlutoCell(value: data.image),
                'input_time_field': PlutoCell(value: data.inputTime),
                'is_check_field': PlutoCell(value: data.isCheck),
                'location_field': PlutoCell(value: data.location),
                'no_asset': PlutoCell(value: data.noAsset),
                'pic_field': PlutoCell(value: data.pic),
                'year_field': PlutoCell(value: data.year),
              },
            ))
        .toList();
  }

  Future<void> deleteDataAfterUploading(String name) async {
    try {
      print('Starting getUserAssetStage for user: $name');
      isLoading.value = true;

      if (name.isEmpty) {
        print('Error: Username is empty');
        return;
      }

      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firestore.collection('admin_permission').doc(name).get();

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

          print('Staging data length: ${stagingData.length}');

          rowsStagingData.value = convertToStagingTabel(stagingData);
          print('Converted rows length: ${rowsStagingData.length}');

          // Hapus data stagelist dari Firebase
          await _firestore
              .collection('staging_data')
              .doc(name)
              .update(<Object, Object?>{
            'staging_list_assets': FieldValue.delete(),
          });
          print('Staging list data deleted from Firebase');
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
      print('Error fetching or deleting data: $e');
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

  Stream<List<dynamic>> streamRowCheckSheet() {
    return FirebaseFirestore.instance
        .collection('data')
        .doc('assets')
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> docSnapshot) {
      if (docSnapshot.exists && docSnapshot.data() != null) {
        final Map<String, dynamic> data = docSnapshot.data()!;
        if (data['list_assets'] is List) {
          final List<dynamic> assets = data['list_assets'] as List<dynamic>;
          return assets
              .map((asset) =>
                  StagingDataUser.fromJson(asset as Map<String, dynamic>))
              .toList();
        } else {
          print('list_assets is not a List or is null');
          return <dynamic>[];
        }
      } else {
        return <dynamic>[];
      }
    }).handleError((dynamic error, dynamic stackTrace) {
      print('Error fetching data: $error');
      print('Stack trace: $stackTrace');
      return <dynamic>[];
    });
  }

  Stream<List<dynamic>> streamRowUpdateSheet(String name) {
    return FirebaseFirestore.instance
        .collection('staging_data')
        .doc(name)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> docSnapshot) {
      if (docSnapshot.exists && docSnapshot.data() != null) {
        final Map<String, dynamic> data = docSnapshot.data()!;
        if (data['staging_list_assets'] is List) {
          final List<dynamic> assets =
              data['staging_list_assets'] as List<dynamic>;
          return assets
              .map((asset) =>
                  StagingDataUser.fromJson(asset as Map<String, dynamic>))
              .toList();
        } else {
          print('staging_list_assets is not a List or is null');
          return <dynamic>[];
        }
      } else {
        print('No data found for user: $name');
        return <dynamic>[];
      }
    }).handleError((dynamic error, dynamic stackTrace) {
      print('Error fetching data: $error');
      print('Stack trace: $stackTrace');
      return <dynamic>[];
    });
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
