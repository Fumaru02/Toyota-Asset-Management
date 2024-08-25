// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_list_assets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetListAssets _$GetListAssetsFromJson(Map<String, dynamic> json) =>
    GetListAssets(
      area: json['area'] as String,
      assetName: json['asset_name'] as String,
      category: json['category'] as String,
      id: (json['id'] as num).toInt(),
      image: json['image'] as String,
      inputTime: json['input_time'] as String,
      isCheck: json['is_check'] as bool,
      location: json['location'] as String,
      noAsset: json['no_asset'] as String,
      pic: json['pic'] as String,
      coordinator: json['coordinator'] as String,
    );

Map<String, dynamic> _$GetListAssetsToJson(GetListAssets instance) =>
    <String, dynamic>{
      'id': instance.id,
      'area': instance.area,
      'asset_name': instance.assetName,
      'category': instance.category,
      'coordinator': instance.coordinator,
      'image': instance.image,
      'input_time': instance.inputTime,
      'is_check': instance.isCheck,
      'location': instance.location,
      'no_asset': instance.noAsset,
      'pic': instance.pic,
    };
