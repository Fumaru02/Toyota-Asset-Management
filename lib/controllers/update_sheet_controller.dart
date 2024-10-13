import 'dart:developer';
import 'dart:io';

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
import 'package:universal_io/io.dart';

import '../helpers/snackbar.dart';
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
  final RxList<String> areaPics = <String>[].obs;
  final RxList<String> areaLocation = <String>[].obs;
  RxString imageUrl = RxString('');
  Rx<Uint8List?> previewImageBytes = Rx<Uint8List?>(null);
  Rx<Uint8List?> imageAsset = Rx<Uint8List?>(null);
  RxString onChangedDropDownForm = RxString('');
  RxString onChangedDropDownPIC = RxString('');
  RxString onChangedDropDownLocation = RxString('');
  RxString onChangedDropDownCoordinator = RxString('');
  RxString onChangedDropDownCategory = RxString('');
  RxString initialDropDownForm = RxString('');
  RxString areaValue = RxString('');
  RxString picValue = RxString('');
  RxString coordinatorValue = RxString('');
  RxString categoryValue = RxString('');
  RxString locationValue = RxString('');
  RxString formattedTime = RxString('');
  RxBool isLoading = RxBool(false);

  RxInt year = RxInt(0);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        final int indexToUpdate =
            stagingListAssets.indexWhere((asset) => asset['id'] == 4);

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
      Snack.show(SnackbarType.success, 'Sukses',
          'Data asset berhasil ditambahkan atau diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan atau memperbarui data: $e');
    }
  }

  Future<void> onConfirmAddAsset(String noAsset, double id, bool isCheck,
      String assetName, String username) async {
    isLoading.value = true;
    final DateTime now = DateTime.now();
    formattedTime.value = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    await uploadImage(
        imageAsset.value!, '${formattedTime.value}_compressed.jpg');
    addOrUpdateAsset(
      <String, dynamic>{
        'input_time': formattedTime.value,
        'area': areaValue.value,
        'image': imageUrl.value,
        'category': categoryValue.value,
        'coordinator': coordinatorValue.value,
        'no_asset': noAsset,
        'id': id,
        'is_check': isCheck,
        'pic': picValue.value,
        'location': locationValue.value,
        'asset_name': assetName
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
            areaPics.value =
                picinArea.map((dynamic e) => e.toString()).toList();
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

  Future<void> pickImage(
      ImageSource source, bool isUpdate, String username) async {
    try {
      isLoading.value = true;
      final XFile? image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        Snack.show(SnackbarType.error, 'Information', 'Failed to pick image');
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
              imageAsset.value!, '${formattedTime.value}_compressed_edit.jpg');

          log('testP ${imageUrl.value}');
          updateImageAsset(username, imageUrl.value);
        }
      }
      isLoading.value = false;
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
    int quality = 85;

    // Kompresi gambar
    List<int> compressedBytes = img.encodeJpg(image, quality: 85);

    // Jika ukuran masih di atas 1MB, kurangi kualitas secara bertahap
    while (compressedBytes.length > 1024 * 1024 && quality > 10) {
      quality -= 5;
      compressedBytes = img.encodeJpg(image, quality: quality);
    }

    return Uint8List.fromList(compressedBytes);
  }

  Future<void> uploadImage(Uint8List imageData, String fileName) async {
    final SettableMetadata metadata =
        SettableMetadata(contentType: 'image/jpeg');
    final Reference ref = firebaseStorage
        .ref('sheet')
        .child('sheet_image')
        .child('test')
        .child(fileName);

    await ref.putData(imageData, metadata);
    final String url = await ref.getDownloadURL();
    Snack.show(SnackbarType.success, 'Image',
        'Image has been uploaded. Image will be replaced after pressing Submit');
    imageUrl.value = url;
    update();
  }

  Future<dynamic> pickImageAndroid(ImageSource source) async {
    try {
      final SettableMetadata metadata =
          SettableMetadata(contentType: 'image/jpeg');
      final XFile? image = await ImagePicker().pickImage(source: source);
      final Reference ref = firebaseStorage
          .ref('sheet')
          .child('sheet_image')
          .child('test')
          .child('test.jpeg');

      if (image == null) {
        return Snack.show(
            SnackbarType.error, 'Information', 'Failed to pick image');
      }
      final File imageTemp = File(image.path);
      await ref.putFile(imageTemp, metadata);
      final String url = await ref.getDownloadURL();
      Get.back();
      Snack.show(SnackbarType.success, 'Image',
          'Image has been uploaded, Image will replaced after pressing Submit');
      await FirebaseFirestore.instance
          .collection('users')
          .doc('test_image')
          .update(<Object, Object?>{'user_image': url});
    } on PlatformException catch (e) {
      if (e.code != null) {
        Snack.show(SnackbarType.error, 'Information', 'Failed to pick image');
      }
    }
    update();
  }
}
