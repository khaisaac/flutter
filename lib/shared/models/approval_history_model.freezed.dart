// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'approval_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApprovalHistoryModel _$ApprovalHistoryModelFromJson(Map<String, dynamic> json) {
  return _ApprovalHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$ApprovalHistoryModel {
  String get id => throw _privateConstructorUsedError;
  String get actorUid => throw _privateConstructorUsedError;
  String get actorName => throw _privateConstructorUsedError;
  String get actorRole => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get fromStatus => throw _privateConstructorUsedError;
  String get toStatus => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  int get timestampMs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalHistoryModelCopyWith<ApprovalHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalHistoryModelCopyWith<$Res> {
  factory $ApprovalHistoryModelCopyWith(ApprovalHistoryModel value,
          $Res Function(ApprovalHistoryModel) then) =
      _$ApprovalHistoryModelCopyWithImpl<$Res, ApprovalHistoryModel>;
  @useResult
  $Res call(
      {String id,
      String actorUid,
      String actorName,
      String actorRole,
      String action,
      String fromStatus,
      String toStatus,
      String? note,
      int timestampMs});
}

/// @nodoc
class _$ApprovalHistoryModelCopyWithImpl<$Res,
        $Val extends ApprovalHistoryModel>
    implements $ApprovalHistoryModelCopyWith<$Res> {
  _$ApprovalHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actorUid = null,
    Object? actorName = null,
    Object? actorRole = null,
    Object? action = null,
    Object? fromStatus = null,
    Object? toStatus = null,
    Object? note = freezed,
    Object? timestampMs = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actorUid: null == actorUid
          ? _value.actorUid
          : actorUid // ignore: cast_nullable_to_non_nullable
              as String,
      actorName: null == actorName
          ? _value.actorName
          : actorName // ignore: cast_nullable_to_non_nullable
              as String,
      actorRole: null == actorRole
          ? _value.actorRole
          : actorRole // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      fromStatus: null == fromStatus
          ? _value.fromStatus
          : fromStatus // ignore: cast_nullable_to_non_nullable
              as String,
      toStatus: null == toStatus
          ? _value.toStatus
          : toStatus // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      timestampMs: null == timestampMs
          ? _value.timestampMs
          : timestampMs // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalHistoryModelImplCopyWith<$Res>
    implements $ApprovalHistoryModelCopyWith<$Res> {
  factory _$$ApprovalHistoryModelImplCopyWith(_$ApprovalHistoryModelImpl value,
          $Res Function(_$ApprovalHistoryModelImpl) then) =
      __$$ApprovalHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String actorUid,
      String actorName,
      String actorRole,
      String action,
      String fromStatus,
      String toStatus,
      String? note,
      int timestampMs});
}

/// @nodoc
class __$$ApprovalHistoryModelImplCopyWithImpl<$Res>
    extends _$ApprovalHistoryModelCopyWithImpl<$Res, _$ApprovalHistoryModelImpl>
    implements _$$ApprovalHistoryModelImplCopyWith<$Res> {
  __$$ApprovalHistoryModelImplCopyWithImpl(_$ApprovalHistoryModelImpl _value,
      $Res Function(_$ApprovalHistoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actorUid = null,
    Object? actorName = null,
    Object? actorRole = null,
    Object? action = null,
    Object? fromStatus = null,
    Object? toStatus = null,
    Object? note = freezed,
    Object? timestampMs = null,
  }) {
    return _then(_$ApprovalHistoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      actorUid: null == actorUid
          ? _value.actorUid
          : actorUid // ignore: cast_nullable_to_non_nullable
              as String,
      actorName: null == actorName
          ? _value.actorName
          : actorName // ignore: cast_nullable_to_non_nullable
              as String,
      actorRole: null == actorRole
          ? _value.actorRole
          : actorRole // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      fromStatus: null == fromStatus
          ? _value.fromStatus
          : fromStatus // ignore: cast_nullable_to_non_nullable
              as String,
      toStatus: null == toStatus
          ? _value.toStatus
          : toStatus // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      timestampMs: null == timestampMs
          ? _value.timestampMs
          : timestampMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApprovalHistoryModelImpl extends _ApprovalHistoryModel {
  const _$ApprovalHistoryModelImpl(
      {required this.id,
      required this.actorUid,
      required this.actorName,
      required this.actorRole,
      required this.action,
      required this.fromStatus,
      required this.toStatus,
      this.note,
      required this.timestampMs})
      : super._();

  factory _$ApprovalHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String actorUid;
  @override
  final String actorName;
  @override
  final String actorRole;
  @override
  final String action;
  @override
  final String fromStatus;
  @override
  final String toStatus;
  @override
  final String? note;
  @override
  final int timestampMs;

  @override
  String toString() {
    return 'ApprovalHistoryModel(id: $id, actorUid: $actorUid, actorName: $actorName, actorRole: $actorRole, action: $action, fromStatus: $fromStatus, toStatus: $toStatus, note: $note, timestampMs: $timestampMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actorUid, actorUid) ||
                other.actorUid == actorUid) &&
            (identical(other.actorName, actorName) ||
                other.actorName == actorName) &&
            (identical(other.actorRole, actorRole) ||
                other.actorRole == actorRole) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.fromStatus, fromStatus) ||
                other.fromStatus == fromStatus) &&
            (identical(other.toStatus, toStatus) ||
                other.toStatus == toStatus) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.timestampMs, timestampMs) ||
                other.timestampMs == timestampMs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, actorUid, actorName,
      actorRole, action, fromStatus, toStatus, note, timestampMs);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalHistoryModelImplCopyWith<_$ApprovalHistoryModelImpl>
      get copyWith =>
          __$$ApprovalHistoryModelImplCopyWithImpl<_$ApprovalHistoryModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _ApprovalHistoryModel extends ApprovalHistoryModel {
  const factory _ApprovalHistoryModel(
      {required final String id,
      required final String actorUid,
      required final String actorName,
      required final String actorRole,
      required final String action,
      required final String fromStatus,
      required final String toStatus,
      final String? note,
      required final int timestampMs}) = _$ApprovalHistoryModelImpl;
  const _ApprovalHistoryModel._() : super._();

  factory _ApprovalHistoryModel.fromJson(Map<String, dynamic> json) =
      _$ApprovalHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get actorUid;
  @override
  String get actorName;
  @override
  String get actorRole;
  @override
  String get action;
  @override
  String get fromStatus;
  @override
  String get toStatus;
  @override
  String? get note;
  @override
  int get timestampMs;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalHistoryModelImplCopyWith<_$ApprovalHistoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
