import 'package:json_annotation/json_annotation.dart';

part 'staging_data_user.g.dart';

@JsonSerializable()
class StagingDataUser {
  StagingDataUser({
    required this.area,
    required this.assetName,
    required this.category,
    required this.coordinator,
    required this.id,
    required this.image,
    required this.inputTime,
    required this.isCheck,
    required this.location,
    required this.noAsset,
    required this.pic,
  });
  factory StagingDataUser.fromJson(Map<String, dynamic> json) =>
      _$StagingDataUserFromJson(json);
  @JsonKey(name: 'area')
  String area;
  @JsonKey(name: 'asset_name')
  String assetName;
  @JsonKey(name: 'category')
  String category;
  @JsonKey(name: 'coordinator')
  String coordinator;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'image')
  String image;
  @JsonKey(name: 'input_time')
  String inputTime;
  @JsonKey(name: 'is_check')
  bool isCheck;
  @JsonKey(name: 'location')
  String location;
  @JsonKey(name: 'no_asset')
  String noAsset;
  @JsonKey(name: 'pic')
  String pic;

  Map<String, dynamic> toJson() => _$StagingDataUserToJson(this);
}
