import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../helpers/snackbar.dart';
import '../models/staging_data_user.dart';
import '../utils/enums.dart';

class UpdateSheetController extends GetxController {
  final TextEditingController noAssetTextEditingController =
      TextEditingController();
  final TextEditingController assetNameTextEditingController =
      TextEditingController();

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FocusNode noAssetFocusNode = FocusNode();
  FocusNode assetNameFocusNode = FocusNode();
  RxString dropdownInitialArea = RxString('Area');
  RxString dropdownInitialPIC = RxString('PIC');
  RxString dropdownInitialCoordinator = RxString('PIC');
  final RxList<String> areaPicsUpdate = <String>[].obs;
  final RxList<String> areaLocation = <String>[].obs;
  final RxList<String> coordinatorLocation = <String>[].obs;
  RxString imageUrl = RxString('');
  RxString noAssetUpdate = RxString('');
  Rx<Uint8List?> previewImageBytes = Rx<Uint8List?>(null);
  Rx<Uint8List?> imageAsset = Rx<Uint8List?>(null);
  RxString onChangedDropDownForm = RxString('');
  RxString onChangedDropDownPIC = RxString('');
  RxString onChangedDropDownLocation = RxString('');
  RxString onChangedDropDownCoordinator = RxString('');
  RxString onChangedDropDownCategory = RxString('');
  RxString initialDropDownForm = RxString('');
  RxString initialDropDownFormCoordinator = RxString('');
  RxString areaValue = RxString('');
  RxString picValue = RxString('');
  RxString coordinatorValue = RxString('');
  RxString categoryValue = RxString('');
  RxString locationValue = RxString('');
  RxString formattedTime = RxString('');
  RxBool isLoading = RxBool(false);
  late PlutoGridStateManager stateManager;

  RxInt year = RxInt(0);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> updateImageAssetDashboard(String newImage) async {
    try {
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
        final int indexToUpdate = listAssets
            .indexWhere((asset) => asset['no_asset'] == noAssetUpdate.value);

        if (indexToUpdate != -1) {
          // Update only the image field of the asset
          listAssets[indexToUpdate]['image'] = newImage;

          // Update the document with the modified list
          await userDoc.update(<Object, Object?>{
            'list_assets': listAssets,
          });
          updateLastChecked(noAssetUpdate.value);
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

  Future<void> updateImageAsset(String username, String newImage) async {
    try {
      // Reference to the Firestore collection and document
      final DocumentReference userDoc =
          FirebaseFirestore.instance.collection('staging_data').doc(username);

      // Get the current document data
      final DocumentSnapshot docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        // Explicitly cast the data to Map<String, dynamic>
        final Map<String, dynamic> data =
            docSnapshot.data()! as Map<String, dynamic>;

        // Safely get the staging_list_assets and ensure it's a List<dynamic>
        final List<dynamic> stagingListAssets =
            (data['staging_list_assets'] as List<dynamic>?) ?? <dynamic>[];

        // Find the index of the asset to update
        final int indexToUpdate = stagingListAssets
            .indexWhere((asset) => asset['no_asset'] == noAssetUpdate.value);

        if (indexToUpdate != -1) {
          // Update only the image field of the asset
          stagingListAssets[indexToUpdate]['image'] = newImage;

          // Update the document with the modified list
          await userDoc.update(<Object, Object?>{
            'staging_list_assets': stagingListAssets,
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

  Future<void> addOrUpdateAsset(
      Map<String, dynamic> assetData, String username) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }
      final DocumentReference docRef =
          _firestore.collection('staging_data').doc(username);

      // Gunakan set dengan merge: true untuk membuat atau mengupdate dokumen
      await docRef.set(<String, FieldValue>{
        'staging_list_assets': FieldValue.arrayUnion(<dynamic>[assetData])
      }, SetOptions(merge: true));
      Get.back();
      Snack.show(SnackbarType.success, 'Sukses',
          'Data asset berhasil ditambahkan atau diperbarui mohon refresh page jika diperlukan');
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Gagal menambahkan atau memperbarui data: $e');
    }
  }

  Future<void> sendDataToAdmin(dynamic assetData, String username) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('admin_permission')
          .doc(username);

      // Konversi Rx<List> ke List jika perlu
      final List<dynamic> dataList =
          assetData is RxList ? assetData.toList() : assetData as List<dynamic>;

      // Konversi setiap StagingDataUser menjadi Map<String, dynamic> menggunakan JSON
      final List<Map<String, dynamic>> dataToSend = dataList.map((item) {
        if (item is StagingDataUser) {
          // Konversi ke JSON string, lalu parse kembali ke Map
          final String jsonString = jsonEncode(item.toJson());
          return jsonDecode(jsonString) as Map<String, dynamic>;
        } else if (item is Map) {
          // Jika sudah Map, tetap lakukan proses yang sama untuk memastikan
          final String jsonString = jsonEncode(item);
          return jsonDecode(jsonString) as Map<String, dynamic>;
        } else {
          throw Exception('Unsupported data type in list');
        }
      }).toList();

      // Periksa apakah dokumen sudah ada
      final DocumentSnapshot<Object?> docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        // Dokumen ada, update data yang ada
        await docRef.update(<Object, Object?>{
          'staging_list_assets': FieldValue.arrayUnion(dataToSend)
        });
      } else {
        // Dokumen tidak ada, buat baru
        await docRef.set(<String, List<Map<String, dynamic>>>{
          'staging_list_assets': dataToSend
        });
      }
      Get.back();
      Get.snackbar('Sukses', 'Data asset berhasil dikirim');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan atau memperbarui data: $e');
      print('Error detail: $e'); // Untuk debugging
    }
  }

  Future<void> onConfirmAddAsset(String noAsset, double id, bool isCheck,
      String assetName, String username, String year) async {
    isLoading.value = true;

    if (noAsset == '' ||
        assetName == '' ||
        username == '' ||
        year == '0' ||
        areaValue.value.isEmpty ||
        categoryValue.value.isEmpty ||
        picValue.value.isEmpty) {
      Snack.show(SnackbarType.error, 'Error',
          'Data asset gagal di kirim periksa kembali input form');
      Get.back();
      isLoading.value = false;
      return;
    }
    final DateTime now = DateTime.now();
    formattedTime.value = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    await uploadImage(
        imageAsset.value!, '${formattedTime.value}_compressed.jpg');
    addOrUpdateAsset(
      <String, dynamic>{
        'input_time': formattedTime.value,
        'area': areaValue.value.toLowerCase(),
        'image': imageUrl.value,
        'category': categoryValue.value,
        'coordinator': coordinatorValue.value,
        'no_asset': noAsset,
        'id': id,
        'is_check': isCheck,
        'pic': picValue.value,
        'location': locationValue.value.toUpperCase(),
        'asset_name': assetName.toUpperCase(),
        'year': year
      },
      username,
    );
    isLoading.value = false;
  }

  Future<void> getPics(String area) async {
    final String modifiedArea = area.toLowerCase();
    print(modifiedArea);
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
      final List<dynamic> dropdownData = data['pic'] as List<dynamic>;

      for (final dynamic item in dropdownData) {
        if (item is Map<String, dynamic> && item.containsKey(modifiedArea)) {
          final dynamic picinArea = item[modifiedArea];
          if (picinArea is List) {
            areaPicsUpdate.value =
                picinArea.map((dynamic e) => e.toString()).toList();
          } else if (picinArea is String) {
            areaPicsUpdate.value = <String>[picinArea];
          } else {
            log('Unexpected data type for pic');
          }
          break;
        }
      }

      print('Area PICs: ${areaPicsUpdate.join(', ')}');
      update();
    } catch (e) {
      log('Error retrieving data: $e');
    }
  }

  Future<void> removeAssetFromStaging(
      String username, String assetNumber) async {
    try {
      // Referensi ke dokumen pengguna
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('staging_data').doc(username);

      // Mengambil data pengguna
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await docRef.get();
      if (!docSnapshot.exists || docSnapshot.data() == null) {
        print('Dokumen tidak ditemukan untuk pengguna: $username');
        return;
      }

      // Mendapatkan data staging_list_assets
      final Map<String, dynamic> data = docSnapshot.data()!;
      final List<dynamic> stagingListAssets =
          data['staging_list_assets'] as List<dynamic>;

      // Mencari dan menghapus asset berdasarkan nomor asset
      stagingListAssets.removeWhere((asset) =>
          asset is Map<String, dynamic> && asset['no_asset'] == assetNumber);

      // Memperbarui dokumen dengan list yang telah diperbarui
      await docRef
          .update(<Object, Object?>{'staging_list_assets': stagingListAssets});

      print('Asset dengan nomor $assetNumber telah dihapus dari staging');

      // Memperbarui data lokal
    } catch (e) {
      print('Error saat menghapus asset dari staging: $e');
    }
  }

  Future<void> getCoordinatorArea(String area) async {
    final String modifiedArea = area.toLowerCase();
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
      final List<dynamic> dropdownData = data['coordinator'] as List<dynamic>;

      for (final dynamic item in dropdownData) {
        if (item is Map<String, dynamic> && item.containsKey(modifiedArea)) {
          final dynamic coordinatorArea = item[modifiedArea];
          if (coordinatorArea is List) {
            coordinatorLocation.value = coordinatorArea
                .map((dynamic e) => e.toString().toUpperCase())
                .toList();
          } else if (coordinatorArea is String) {
            areaLocation.value = <String>[coordinatorArea];
          } else {
            log('Unexpected data type for pic');
          }
          break;
        }
      }

      print('Coordinator Locations: ${areaLocation.join(', ')}');
      update();
    } catch (e) {
      log('Error retrieving data: $e');
    }
  }

  Future<void> getLocationArea(String area) async {
    final String modifiedArea = area.toLowerCase();
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
      final List<dynamic> dropdownData = data['location'] as List<dynamic>;

      for (final dynamic item in dropdownData) {
        if (item is Map<String, dynamic> && item.containsKey(modifiedArea)) {
          final dynamic areaLocations = item[modifiedArea];
          if (areaLocations is List) {
            areaLocation.value =
                areaLocations.map((dynamic e) => e.toString()).toList();
          } else if (areaLocations is String) {
            areaLocation.value = <String>[areaLocations];
          } else {
            log('Unexpected data type for pic');
          }
          break;
        }
      }

      print('Area Locations: ${areaLocation.join(', ')}');
      update();
    } catch (e) {
      log('Error retrieving data: $e');
    }
  }

  Future<void> pickImageSuperAdmin(
      ImageSource source, bool isUpdate, String username) async {
    final DateTime now = DateTime.now();
    final String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    try {
      isLoading.value = true;
      final XFile? image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        Snack.show(SnackbarType.error, 'Information', 'Failed to pick image');
        isLoading.value = false;
        return;
      }
      // Baca gambar sebagai bytes
      previewImageBytes.value = await image.readAsBytes();

      // Kompresi gambar
      final Uint8List compressedImage =
          await compressImage(previewImageBytes.value!);
      imageAsset.value = compressedImage;

      await uploadImage(
          imageAsset.value!, '${formattedTime}_compressed_edit.jpg');
      updateImageAssetDashboard(
        imageUrl.value,
      );
      isLoading.value = false;
      update();
    } catch (e) {
      Snack.show(SnackbarType.error, 'Error', 'Failed to pick image: $e');
    }
    update();
  }

  Future<void> pickImage(
      ImageSource source, bool isUpdate, String username) async {
    final DateTime now = DateTime.now();
    final String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    try {
      isLoading.value = true;
      final XFile? image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        Snack.show(SnackbarType.error, 'Information', 'Failed to pick image');
        isLoading.value = false;
        return;
      }
      // Baca gambar sebagai bytes
      previewImageBytes.value = await image.readAsBytes();

      // Kompresi gambar
      final Uint8List compressedImage =
          await compressImage(previewImageBytes.value!);
      imageAsset.value = compressedImage;
      if (isUpdate == true) {
        if (username != null) {
          await uploadImage(
              imageAsset.value!, '${formattedTime}_compressed_edit.jpg');
          updateImageAsset(
            username,
            imageUrl.value,
          );
        }
      }
      isLoading.value = false;
      update();
    } catch (e) {
      Snack.show(SnackbarType.error, 'Error', 'Failed to pick image: $e');
    }
    update();
  }

  Future<Uint8List> compressImage(Uint8List imageData) async {
    // Decode gambar
    img.Image? image = img.decodeImage(imageData);
    if (image == null) {
      return imageData;
    }

    // Resize gambar jika terlalu besar
    if (image.width > 1024 || image.height > 1024) {
      image = img.copyResize(image, width: 1024, height: 1024);
    }
    int quality = 95;

    // Kompresi gambar
    List<int> compressedBytes = img.encodeJpg(image, quality: 95);

    // Jika ukuran masih di atas 1MB, kurangi kualitas secara bertahap
    while (compressedBytes.length > 1024 * 1024 && quality > 10) {
      quality -= 5;
      compressedBytes = img.encodeJpg(image, quality: quality);
    }

    return Uint8List.fromList(compressedBytes);
  }

  Future<void> uploadImage(Uint8List imageData, String fileName) async {
    final DateTime now = DateTime.now();
    final String monthPickedImage = DateFormat('MM').format(now);
    final SettableMetadata metadata =
        SettableMetadata(contentType: 'image/jpeg');
    final Reference ref = firebaseStorage
        .ref('sheet')
        .child('sheet_image')
        .child(monthPickedImage)
        .child(fileName);

    await ref.putData(imageData, metadata);
    final String url = await ref.getDownloadURL();
    Snack.show(SnackbarType.success, 'Image',
        'Image berhasil di tambahkan mohon refresh jika image tidak terupdate');
    imageUrl.value = url;
    update();
  }

  Future<void> updateTableUpdateSheet(String fieldName, String username,
      String newValue, String noAsset) async {
    try {
      // 1. Ambil dokumen saat ini
      final DocumentReference userDoc =
          FirebaseFirestore.instance.collection('staging_data').doc(username);

      // Get the current document data
      final DocumentSnapshot docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        // Explicitly cast the data to Map<String, dynamic>
        final Map<String, dynamic> data =
            docSnapshot.data()! as Map<String, dynamic>;

        // Safely get the staging_list_assets and ensure it's a List<dynamic>
        final List<dynamic> stagingListAssets =
            (data['staging_list_assets'] as List<dynamic>?) ?? <dynamic>[];

        // 2. Temukan indeks elemen yang ingin diupdate
        // Asumsikan kita ingin update berdasarkan asset_name yang sama
        final int indexToUpdate = stagingListAssets
            .indexWhere((asset) => asset['no_asset'] == noAssetUpdate.value);
        if (indexToUpdate != -1) {
          // Update only the image field of the asset
          stagingListAssets[indexToUpdate][fieldName] = newValue;

          // Update the document with the modified list
          await userDoc.update(<Object, Object?>{
            'staging_list_assets': stagingListAssets,
          });

          print('Asset updated successfully');
          update();
        }
      }
    } catch (e) {
      print('Error updating asset: $e');
    }
  }
}
