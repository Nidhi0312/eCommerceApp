import 'package:json_annotation/json_annotation.dart';

import 'product_list_model.dart';

class PagingResponse<T> {
  @JsonKey(name: 'status')
  int? status;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'data')
  List<T>? items;
  @JsonKey(name: 'totalRecord')
  int? totalRecord;
  @JsonKey(name: 'totalPage')
  int? totalPage;

  PagingResponse(
      {this.status,
      this.items,
      this.message,
      this.totalRecord,
      this.totalPage});

  factory PagingResponse.fromJson(Map<String, dynamic> json) =>
      _$PagingResponseFromJson<T>(json);

  Map<String, dynamic> toJson() => _$PagingResponseToJson<T>(this);
}

PagingResponse<T> _$PagingResponseFromJson<T>(Map<String, dynamic> json) {
  // TODO: Changed e as, to e['data'] as

  final _typeMappers = <Type, Function>{
    ProductListModelData: (e) =>
        ProductListModelData.fromJson(e as Map<String, dynamic>),
  };
  final results = (json['data'] as List<dynamic>?)
      ?.map(
        (e) => _typeMappers[T]!(e as Map<String, dynamic>) as T,
      )
      .toList();
  final message = json['message'] as String;
  final status = json['status'] as int;
  final totalPage = json['totalRecord'] as int;
  final totalRecord = json['totalPage'] as int;

  return PagingResponse(
      items: results,
      message: message,
      status: status,
      totalPage: totalPage,
      totalRecord: totalRecord);
}

Map<String, dynamic> _$PagingResponseToJson<T>(PagingResponse<T> instance) =>
    <String, dynamic>{
      'data': instance.items,
      'message': instance.message,
      'status': instance.status,
      'totalRecord': instance.totalRecord,
      'totalPage': instance.totalPage,
    };
