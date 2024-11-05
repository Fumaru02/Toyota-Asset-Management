import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../models/staging_data_user.dart';

class AdminController extends GetxController {
  RxInt totalData = RxInt(0);
  RxList<String> dataUsername = RxList<String>(<String>[]);
  Rx<String> usernameStaging = RxString('');
  RxBool isLoading = RxBool(false);
  RxBool isShowTableStaging = RxBool(false);
  RxBool isOpenDashboardTabel = RxBool(false);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<StagingDataUser> stagingData =
      RxList<StagingDataUser>(<StagingDataUser>[]);
  RxList<StagingDataUser> dashboardTabelData =
      RxList<StagingDataUser>(<StagingDataUser>[]);
  RxList<PlutoRow> rowsStagingData = RxList<PlutoRow>(<PlutoRow>[]);
  RxList<PlutoRow> rowsDashboardDataTabel = RxList<PlutoRow>(<PlutoRow>[]);

  @override
  void onInit() {
    super.onInit();
    getUserRequest();
  }

  Future<void> getUserRequest() async {
    try {
      // Referensi ke koleksi 'staging_data'
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('admin_permission');

      // Mengambil semua dokumen dari koleksi
      final QuerySnapshot querySnapshot = await usersCollection.get();

      // Menghitung total dokumen
      totalData.value = querySnapshot.docs.length;

      // Menampilkan nama dokumen dan total dokumen
      for (final QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
        dataUsername.add(doc.id);
        print('Document ID: ${doc.id}');
      }

      print('Total Documents: $totalData');
    } catch (e) {
      print('Error saat mengambil data: $e');
    }
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
                'year_field': PlutoCell(value: data.year),
              },
            ))
        .toList();
  }



  Future<void> getDashboardTabelData() async {
    try {
      isLoading.value = true;

      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firestore.collection('data').doc('assets').get();

      print('Document exists: ${docSnapshot.exists}');
      print('Document data: ${docSnapshot.data()}');

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final Map<String, dynamic> data = docSnapshot.data()!;
        if (data['list_assets'] is List) {
          final List<dynamic> assets = data['list_assets'] as List<dynamic>;
          print('Raw assets data: $assets');

          dashboardTabelData.value = assets
              .map((asset) =>
                  StagingDataUser.fromJson(asset as Map<String, dynamic>))
              .toList();

          rowsDashboardDataTabel.value =
              convertToStagingTabel(dashboardTabelData);
        } else {
          isLoading.value = false;
          return;
        }
      } else {
        isLoading.value = false;
        return;
      }
      isLoading.value = false;
      isOpenDashboardTabel.value = true;
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

  Future<void> getUserAssetStage(String name) async {
    try {
      print('Starting getUserAssetStage for user: $name');
      isLoading.value = true;
      usernameStaging.value = name;
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

          // print(
          //     'Parsed staging data: ${stagingData.map((StagingDataUser e) => e.toJson()).toList()}');
          print('Staging data length: ${stagingData.length}');

          rowsStagingData.value = convertToStagingTabel(stagingData);
          print('Converted rows length: ${rowsStagingData.length}');
          isShowTableStaging.value = true;
          isLoading.value = false;
        } else {
          print('staging_list_assets is not a List or is null');
          stagingData.clear();
          rowsStagingData.clear();
          isLoading.value = false;
        }
        isLoading.value = false;
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

  Future<void> addBackAssetFromAdminStaging(
      List<dynamic> stagingData, String username, String assetNumber) async {
    try {
      // Referensi ke dokumen pengguna
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('staging_data').doc(username);

      // Mencari dan menghapus asset berdasarkan nomor asset
      stagingData.indexWhere((asset) =>
          asset is Map<String, dynamic> && asset['no_asset'] == assetNumber);

      // Memperbarui dokumen dengan list yang telah diperbarui
      await docRef
          .update(<Object, Object?>{'staging_list_assets': stagingData});

      print('Asset dengan nomor $assetNumber telah dihapus dari staging');
    } catch (e) {
      print('Error saat menghapus asset dari staging: $e');
    }
  }

  Future<void> updateTableDashboardSheet(
      String fieldName, String newValue, String noAsset) async {
    try {
      // 1. Ambil dokumen saat ini
      final DocumentReference userDoc =
          FirebaseFirestore.instance.collection('data').doc('assets');

      // Get the current document data
      final DocumentSnapshot docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        // Explicitly cast the data to Map<String, dynamic>
        final Map<String, dynamic> data =
            docSnapshot.data()! as Map<String, dynamic>;

        // Safely get the staging_list_assets and ensure it's a List<dynamic>
        final List<dynamic> stagingListAssets =
            (data['list_assets'] as List<dynamic>?) ?? <dynamic>[];

        // 2. Temukan indeks elemen yang ingin diupdate
        // Asumsikan kita ingin update berdasarkan asset_name yang sama
        final int indexToUpdate = stagingListAssets
            .indexWhere((asset) => asset['no_asset'] == noAsset);
        if (indexToUpdate != -1) {
          // Update only the image field of the asset
          stagingListAssets[indexToUpdate][fieldName] = newValue;

          // Update the document with the modified list
          await userDoc.update(<Object, Object?>{
            'list_assets': stagingListAssets,
          });

          print('Asset updated successfully');
          update();
        }
      }
    } catch (e) {
      print('Error updating asset: $e');
    }
  }

  Future<void> removeAssetFromDashboard(String assetNumber) async {
    try {
      isLoading.value = true;
      // Referensi ke dokumen pengguna
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('data').doc('assets');

      // Mengambil data pengguna
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await docRef.get();
      if (!docSnapshot.exists || docSnapshot.data() == null) {
        isLoading.value = false;

        return;
      }

      // Mendapatkan data staging_list_assets
      final Map<String, dynamic> data = docSnapshot.data()!;
      final List<dynamic> stagingListAssets =
          data['list_assets'] as List<dynamic>;

      // Mencari dan menghapus asset berdasarkan nomor asset
      stagingListAssets.removeWhere((asset) =>
          asset is Map<String, dynamic> && asset['no_asset'] == assetNumber);

      // Memperbarui dokumen dengan list yang telah diperbarui
      await docRef.update(<Object, Object?>{'list_assets': stagingListAssets});

      print('Asset dengan nomor $assetNumber telah dihapus dari dashboard');
      await getDashboardTabelData();
      // Memperbarui data lokal
      isLoading.value = false;
    } catch (e) {
      print('Error saat menghapus asset dari dashboard: $e');
    }
  }

  Future<void> removeAssetFromStaging(
      String username, String assetNumber) async {
    try {
      // Referensi ke dokumen pengguna
      final DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection('admin_permission').doc(username);

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

      await addBackAssetFromAdminStaging(
          stagingListAssets, username, assetNumber);
      // Mencari dan menghapus asset berdasarkan nomor asset
      stagingListAssets.removeWhere((asset) =>
          asset is Map<String, dynamic> && asset['no_asset'] == assetNumber);

      // Memperbarui dokumen dengan list yang telah diperbarui
      await docRef
          .update(<Object, Object?>{'staging_list_assets': stagingListAssets});

      print('Asset dengan nomor $assetNumber telah dihapus dari staging');

      // Memperbarui data lokal
      await getUserAssetStage(username);
    } catch (e) {
      print('Error saat menghapus asset dari staging: $e');
    }
  }

  Future<void> sendDataToDashboard(
    dynamic assetData,
  ) async {
    try {
      if (assetData == null) {
        return;
      }

      final DocumentReference docRef =
          FirebaseFirestore.instance.collection('data').doc('assets');

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
          'list_assets': FieldValue.arrayUnion(dataToSend)
        });
      }

      Get.snackbar('Sukses', 'Data asset berhasil dikirim');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan atau memperbarui data: $e');
      print('Error detail: $e'); // Untuk debugging
    }
  }

  Future<void> deleteUserDocument(String name) async {
    try {
      print('Starting deleteUserDocument for user: $name');
      isLoading.value = true;

      if (name.isEmpty) {
        print('Error: Username is empty');
        return;
      }

      // Hapus seluruh dokumen user
      await _firestore.collection('admin_permission').doc(name).delete();
      print('User document deleted from Firebase');

      // Clear local data
      stagingData.clear();
      rowsStagingData.clear();
    } catch (e, stackTrace) {
      print('Error deleting user document: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
      update();
      print('deleteUserDocument completed.');
    }
  }
}
