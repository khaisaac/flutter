// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AttachmentModel _$AttachmentModelFromJson(Map<String, dynamic> json) {
  return _AttachmentModel.fromJson(json);
}

/// @nodoc
mixin _$AttachmentModel {
  String get id => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  String get fileType => throw _privateConstructorUsedError;
  int get fileSizeBytes => throw _privateConstructorUsedError;
  int get uploadedAtMs =>
      throw _privateConstructorUsedError; // stored as millisecondsSinceEpoch
  String get uploadedByUid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AttachmentModelCopyWith<AttachmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachmentModelCopyWith<$Res> {
  factory $AttachmentModelCopyWith(
          AttachmentModel value, $Res Function(AttachmentModel) then) =
      _$AttachmentModelCopyWithImpl<$Res, AttachmentModel>;
  @useResult
  $Res call(
      {String id,
      String fileName,
      String fileUrl,
      String fileType,
      int fileSizeBytes,
      int uploadedAtMs,
      String uploadedByUid});
}

/// @nodoc
class _$AttachmentModelCopyWithImpl<$Res, $Val extends AttachmentModel>
    implements $AttachmentModelCopyWith<$Res> {
  _$AttachmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? fileUrl = null,
    Object? fileType = null,
    Object? fileSizeBytes = null,
    Object? uploadedAtMs = null,
    Object? uploadedByUid = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      uploadedAtMs: null == uploadedAtMs
          ? _value.uploadedAtMs
          : uploadedAtMs // ignore: cast_nullable_to_non_nullable
              as int,
      uploadedByUid: null == uploadedByUid
          ? _value.uploadedByUid
          : uploadedByUid // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttachmentModelImplCopyWith<$Res>
    implements $AttachmentModelCopyWith<$Res> {
  factory _$$AttachmentModelImplCopyWith(_$AttachmentModelImpl value,
          $Res Function(_$AttachmentModelImpl) then) =
      __$$AttachmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fileName,
      String fileUrl,
      String fileType,
      int fileSizeBytes,
      int uploadedAtMs,
      String uploadedByUid});
}

/// @nodoc
class __$$AttachmentModelImplCopyWithImpl<$Res>
    extends _$AttachmentModelCopyWithImpl<$Res, _$AttachmentModelImpl>
    implements _$$AttachmentModelImplCopyWith<$Res> {
  __$$AttachmentModelImplCopyWithImpl(
      _$AttachmentModelImpl _value, $Res Function(_$AttachmentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? fileUrl = null,
    Object? fileType = null,
    Object? fileSizeBytes = null,
    Object? uploadedAtMs = null,
    Object? uploadedByUid = null,
  }) {
    return _then(_$AttachmentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileType: null == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      uploadedAtMs: null == uploadedAtMs
          ? _value.uploadedAtMs
          : uploadedAtMs // ignore: cast_nullable_to_non_nullable
              as int,
      uploadedByUid: null == uploadedByUid
          ? _value.uploadedByUid
          : uploadedByUid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttachmentModelImpl extends _AttachmentModel {
  const _$AttachmentModelImpl(
      {required this.id,
      required this.fileName,
      required this.fileUrl,
      this.fileType = 'image',
      this.fileSizeBytes = 0,
      required this.uploadedAtMs,
      required this.uploadedByUid})
      : super._();

  factory _$AttachmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttachmentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fileName;
  @override
  final String fileUrl;
  @override
  @JsonKey()
  final String fileType;
  @override
  @JsonKey()
  final int fileSizeBytes;
  @override
  final int uploadedAtMs;
// stored as millisecondsSinceEpoch
  @override
  final String uploadedByUid;

  @override
  String toString() {
    return 'AttachmentModel(id: $id, fileName: $fileName, fileUrl: $fileUrl, fileType: $fileType, fileSizeBytes: $fileSizeBytes, uploadedAtMs: $uploadedAtMs, uploadedByUid: $uploadedByUid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttachmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.uploadedAtMs, uploadedAtMs) ||
                other.uploadedAtMs == uploadedAtMs) &&
            (identical(other.uploadedByUid, uploadedByUid) ||
                other.uploadedByUid == uploadedByUid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, fileName, fileUrl, fileType,
      fileSizeBytes, uploadedAtMs, uploadedByUid);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AttachmentModelImplCopyWith<_$AttachmentModelImpl> get copyWith =>
      __$$AttachmentModelImplCopyWithImpl<_$AttachmentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttachmentModelImplToJson(
      this,
    );
  }
}

abstract class _AttachmentModel extends AttachmentModel {
  const factory _AttachmentModel(
      {required final String id,
      required final String fileName,
      required final String fileUrl,
      final String fileType,
      final int fileSizeBytes,
      required final int uploadedAtMs,
      required final String uploadedByUid}) = _$AttachmentModelImpl;
  const _AttachmentModel._() : super._();

  factory _AttachmentModel.fromJson(Map<String, dynamic> json) =
      _$AttachmentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fileName;
  @override
  String get fileUrl;
  @override
  String get fileType;
  @override
  int get fileSizeBytes;
  @override
  int get uploadedAtMs;
  @override // stored as millisecondsSinceEpoch
  String get uploadedByUid;
  @override
  @JsonKey(ignore: true)
  _$$AttachmentModelImplCopyWith<_$AttachmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
