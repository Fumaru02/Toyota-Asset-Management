import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../pages/dashboard_desktop/dashboard_content.dart';

class CheckSheetController extends GetxController {
  final RxInt selectedAreaTotalAsset = RxInt(0);
  final RxInt selectedAreaTotalAssetChecked = RxInt(0);
  final RxInt tlc1krw = RxInt(0);
  final RxInt tlc3krw = RxInt(0);
  final RxInt tlc2str = RxInt(0);
  final RxInt sunter1 = RxInt(0);

  RxInt tlc1krwChecked = RxInt(0);
  RxInt tlc3krwChecked = RxInt(0);
  RxInt tlc2strChecked = RxInt(0);
  RxInt sunter1Checked = RxInt(0);
  RxInt aktiChecked = RxInt(0);
  RxInt hoChecked = RxInt(0);
  final RxInt akti = RxInt(0);
  final RxInt ho = RxInt(0);

  RxInt picTotalCheck = RxInt(0);

  final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  final RxString onChangedDropDownArea = RxString('');
  final RxString onChangedDropDownPic = RxString('');
  final RxString onChangedDropDownForm = RxString('');
  final RxString noAssetCheck = RxString('');
  final RxString picAssetCheck = RxString('');
  final RxString locationAssetCheck = RxString('');
  final RxString areaAssetCheck = RxString('');
  List<SalesData> totalCheckByArea = <SalesData>[];
  final Rx<Map<String, dynamic>> assetData =
      Rx<Map<String, dynamic>>(<String, dynamic>{});
  final RxBool isLoading = RxBool(false);

  String initialMonth = DateTime.now().month.toString();
  String initialYear = DateTime.now().year.toString();

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

  void liveDataCheckSheet(Map<String, dynamic> data) {
    final String date = '$initialMonth/$initialYear';
    if (data.containsKey(date)) {
      final Map<String, dynamic> monthData = data[date] as Map<String, dynamic>;
      if (monthData.containsKey('area')) {
        final List<dynamic> areaList = monthData['area'] as List<dynamic>;
        for (final dynamic area in areaList) {
          processAreaData(area as Map<String, dynamic>);
        }
      }
    }
  }

  void liveDataCheckSheetPIC(
      String area, String picName, Map<String, dynamic> data) {
    picTotalCheck.value = 0;
    final String modifiedArea = area.toLowerCase();
    if (data.containsKey('$initialMonth/$initialYear')) {
      final monthData = data['$initialMonth/$initialYear'];
      if (monthData is Map && monthData.containsKey('area')) {
        final List<dynamic> areas = monthData['area'] as List;

        for (final area in areas) {
          if (area is Map && area.containsKey(modifiedArea)) {
            final List<dynamic> areaData = area[modifiedArea] as List;

            for (final record in areaData) {
              if (record is Map &&
                  record.containsKey('pic') &&
                  record['pic'] == picName) {
                picTotalCheck.value++;
              }
            }
          }
        }
      }
    }
  }

  Future<void> updateLastChecked(String noAsset) async {
    try {
      final DateTime now = DateTime.now();
      final String formattedTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      // Reference to the Firestore collection and document
      final DocumentReference userDoc =
          FirebaseFirestore.instance.collection('data').doc('assets');

      // Get the current document data
      final DocumentSnapshot docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        // Explicitly cast the data to Map<String, dynamic>
        final Map<String, dynamic> data =
            docSnapshot.data()! as Map<String, dynamic>;

        // Safely get the staging_list_assets and ensure it's a List<dynamic>
        final List<dynamic> listAssets =
            (data['list_assets'] as List<dynamic>?) ?? <dynamic>[];

        // Find the index of the asset to update
        final int indexToUpdate =
            listAssets.indexWhere((asset) => asset['no_asset'] == noAsset);

        if (indexToUpdate != -1) {
          // Update only the image field of the asset
          listAssets[indexToUpdate]['input_time'] = formattedTime;

          // Update the document with the modified list
          await userDoc.update(<Object, Object?>{
            'list_assets': listAssets,
          });

          print('Asset image updated successfully');
        } else {
          print('Asset with ID 4 not found in the list');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error updating asset image: $e');
    }
  }

  Future<void> addOrUpdateCheckAsset({
    required String area,
    required String location,
    required String pic,
    required String noAsset,
  }) async {
    try {
      isLoading.value = true;
      final DocumentReference userDoc =
          FirebaseFirestore.instance.collection('data').doc('checking_asset');

      // Get the current document data
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await userDoc.get() as DocumentSnapshot<Map<String, dynamic>>;

      // Initialize the data map
      Map<String, dynamic> currentData;
      if (docSnapshot.exists && docSnapshot.data() != null) {
        currentData = Map<String, dynamic>.from(docSnapshot.data()!);
        log('Existing data: $currentData');
      } else {
        currentData = <String, dynamic>{};
      }
      final String period = '$initialMonth/$initialYear';
      final DateTime now = DateTime.now();
      final String formattedTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      // Initialize period if it doesn't exist
      if (!currentData.containsKey(period)) {
        currentData[period] = <String, List<dynamic>>{
          'area': <dynamic>[],
        };
      }

      if (currentData[period] is Map<String, dynamic>) {
        final Map<String, dynamic> periodData =
            currentData[period] as Map<String, dynamic>;
        if (!periodData.containsKey('area')) {
          periodData['area'] = <dynamic>[];
        }
      } else {
        currentData[period] = <String, List<dynamic>>{
          'area': <dynamic>[],
        };
      }
      final List<dynamic> areaList =
          currentData[period]['area'] as List<dynamic>;

      // Find area index
      final int areaIndex = areaList
          .indexWhere((areaMap) => areaMap is Map && areaMap.containsKey(area));

      if (areaIndex == -1) {
        // Add new area with asset
        final Map<String, dynamic> newArea = <String, dynamic>{
          area: <Map<String, String>>[
            <String, String>{
              'location': location,
              'pic': pic,
              'no_asset': noAsset,
              'last_checked': formattedTime,
            }
          ]
        };
        areaList.add(newArea);
      } else {
        // Get the existing area map
        final Map<String, dynamic> areaMap =
            areaList[areaIndex] as Map<String, dynamic>;

        // Ensure the area list exists
        if (!areaMap.containsKey(area)) {
          areaMap[area] = <dynamic>[];
        }

        final List<dynamic> assetList = areaMap[area] as List<dynamic>;

        // Find existing asset
        final int assetIndex = assetList.indexWhere(
            (asset) => asset is Map && asset['no_asset'] == noAsset);

        final Map<String, dynamic> newAsset = <String, dynamic>{
          'location': location,
          'pic': pic,
          'no_asset': noAsset,
          'last_checked': formattedTime,
        };

        if (assetIndex == -1) {
          // Add new asset
          assetList.add(newAsset);
        } else {
          // Update existing asset
          assetList[assetIndex] = newAsset;
        }

        // Update the area in the list
        areaList[areaIndex] = areaMap;
      }

      // Update the period data
      currentData[period]['area'] = areaList;

      // Log the final data structure
      log('Updated data structure: $currentData');

      // Update Firebase
      await userDoc.set(currentData, SetOptions(merge: true));

      // Update local data - Modified this line to match the actual data structure
      assetData.value = currentData;

      Get.snackbar(
        'Success',
        'Asset data has been updated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      log('Error updating asset', error: e, stackTrace: stackTrace);
      Get.snackbar(
        'Error',
        'Failed to update asset: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
