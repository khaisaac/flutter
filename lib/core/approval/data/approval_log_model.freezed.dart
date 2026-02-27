// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'approval_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApprovalLogModel _$ApprovalLogModelFromJson(Map<String, dynamic> json) {
  return _ApprovalLogModel.fromJson(json);
}

/// @nodoc
mixin _$ApprovalLogModel {
  String get id => throw _privateConstructorUsedError;

  /// Which financial module this log entry belongs to.
  String get module => throw _privateConstructorUsedError;

  /// The Firestore document ID of the submission.
  String get documentId => throw _privateConstructorUsedError;

  /// Firebase UID of the actor who performed the action.
  String get actorUid => throw _privateConstructorUsedError;

  /// Display name of the actor at the time of the action.
  String get actorName => throw _privateConstructorUsedError;

  /// Role of the actor (e.g. 'pic_project', 'finance').
  String get actorRole => throw _privateConstructorUsedError;

  /// The action performed (matches [ApprovalAction.value]).
  String get action => throw _privateConstructorUsedError;

  /// Status before the action was taken.
  String get fromStatus => throw _privateConstructorUsedError;

  /// Status after the action was taken.
  String get toStatus => throw _privateConstructorUsedError;

  /// Optional note / reason provided by the actor.
  String? get note => throw _privateConstructorUsedError;

  /// Epoch ms of when the transition occurred (set server-side if possible).
  int get timestampMs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalLogModelCopyWith<ApprovalLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalLogModelCopyWith<$Res> {
  factory $ApprovalLogModelCopyWith(
          ApprovalLogModel value, $Res Function(ApprovalLogModel) then) =
      _$ApprovalLogModelCopyWithImpl<$Res, ApprovalLogModel>;
  @useResult
  $Res call(
      {String id,
      String module,
      String documentId,
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
class _$ApprovalLogModelCopyWithImpl<$Res, $Val extends ApprovalLogModel>
    implements $ApprovalLogModelCopyWith<$Res> {
  _$ApprovalLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? module = null,
    Object? documentId = null,
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
      module: null == module
          ? _value.module
          : module // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ApprovalLogModelImplCopyWith<$Res>
    implements $ApprovalLogModelCopyWith<$Res> {
  factory _$$ApprovalLogModelImplCopyWith(_$ApprovalLogModelImpl value,
          $Res Function(_$ApprovalLogModelImpl) then) =
      __$$ApprovalLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String module,
      String documentId,
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
class __$$ApprovalLogModelImplCopyWithImpl<$Res>
    extends _$ApprovalLogModelCopyWithImpl<$Res, _$ApprovalLogModelImpl>
    implements _$$ApprovalLogModelImplCopyWith<$Res> {
  __$$ApprovalLogModelImplCopyWithImpl(_$ApprovalLogModelImpl _value,
      $Res Function(_$ApprovalLogModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? module = null,
    Object? documentId = null,
    Object? actorUid = null,
    Object? actorName = null,
    Object? actorRole = null,
    Object? action = null,
    Object? fromStatus = null,
    Object? toStatus = null,
    Object? note = freezed,
    Object? timestampMs = null,
  }) {
    return _then(_$ApprovalLogModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      module: null == module
          ? _value.module
          : module // ignore: cast_nullable_to_non_nullable
              as String,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
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
class _$ApprovalLogModelImpl extends _ApprovalLogModel {
  const _$ApprovalLogModelImpl(
      {required this.id,
      required this.module,
      required this.documentId,
      required this.actorUid,
      required this.actorName,
      required this.actorRole,
      required this.action,
      required this.fromStatus,
      required this.toStatus,
      this.note,
      required this.timestampMs})
      : super._();

  factory _$ApprovalLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalLogModelImplFromJson(json);

  @override
  final String id;

  /// Which financial module this log entry belongs to.
  @override
  final String module;

  /// The Firestore document ID of the submission.
  @override
  final String documentId;

  /// Firebase UID of the actor who performed the action.
  @override
  final String actorUid;

  /// Display name of the actor at the time of the action.
  @override
  final String actorName;

  /// Role of the actor (e.g. 'pic_project', 'finance').
  @override
  final String actorRole;

  /// The action performed (matches [ApprovalAction.value]).
  @override
  final String action;

  /// Status before the action was taken.
  @override
  final String fromStatus;

  /// Status after the action was taken.
  @override
  final String toStatus;

  /// Optional note / reason provided by the actor.
  @override
  final String? note;

  /// Epoch ms of when the transition occurred (set server-side if possible).
  @override
  final int timestampMs;

  @override
  String toString() {
    return 'ApprovalLogModel(id: $id, module: $module, documentId: $documentId, actorUid: $actorUid, actorName: $actorName, actorRole: $actorRole, action: $action, fromStatus: $fromStatus, toStatus: $toStatus, note: $note, timestampMs: $timestampMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.module, module) || other.module == module) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
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
  int get hashCode => Object.hash(runtimeType, id, module, documentId, actorUid,
      actorName, actorRole, action, fromStatus, toStatus, note, timestampMs);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalLogModelImplCopyWith<_$ApprovalLogModelImpl> get copyWith =>
      __$$ApprovalLogModelImplCopyWithImpl<_$ApprovalLogModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalLogModelImplToJson(
      this,
    );
  }
}

abstract class _ApprovalLogModel extends ApprovalLogModel {
  const factory _ApprovalLogModel(
      {required final String id,
      required final String module,
      required final String documentId,
      required final String actorUid,
      required final String actorName,
      required final String actorRole,
      required final String action,
      required final String fromStatus,
      required final String toStatus,
      final String? note,
      required final int timestampMs}) = _$ApprovalLogModelImpl;
  const _ApprovalLogModel._() : super._();

  factory _ApprovalLogModel.fromJson(Map<String, dynamic> json) =
      _$ApprovalLogModelImpl.fromJson;

  @override
  String get id;
  @override

  /// Which financial module this log entry belongs to.
  String get module;
  @override

  /// The Firestore document ID of the submission.
  String get documentId;
  @override

  /// Firebase UID of the actor who performed the action.
  String get actorUid;
  @override

  /// Display name of the actor at the time of the action.
  String get actorName;
  @override

  /// Role of the actor (e.g. 'pic_project', 'finance').
  String get actorRole;
  @override

  /// The action performed (matches [ApprovalAction.value]).
  String get action;
  @override

  /// Status before the action was taken.
  String get fromStatus;
  @override

  /// Status after the action was taken.
  String get toStatus;
  @override

  /// Optional note / reason provided by the actor.
  String? get note;
  @override

  /// Epoch ms of when the transition occurred (set server-side if possible).
  int get timestampMs;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalLogModelImplCopyWith<_$ApprovalLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
