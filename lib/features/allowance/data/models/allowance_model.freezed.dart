// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'allowance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AllowanceModel _$AllowanceModelFromJson(Map<String, dynamic> json) {
  return _AllowanceModel.fromJson(json);
}

/// @nodoc
mixin _$AllowanceModel {
  String get id => throw _privateConstructorUsedError;
  String get submittedByUid => throw _privateConstructorUsedError;
  String get submittedByName => throw _privateConstructorUsedError;
  String? get projectId => throw _privateConstructorUsedError;
  String? get projectName => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  double get requestedAmount => throw _privateConstructorUsedError;
  double? get approvedAmount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  int get allowanceDateMs => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get picUid => throw _privateConstructorUsedError;
  String? get financeUid => throw _privateConstructorUsedError;
  String? get picNote => throw _privateConstructorUsedError;
  String? get financeNote => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  int get createdAtMs => throw _privateConstructorUsedError;
  int? get submittedAtMs => throw _privateConstructorUsedError;
  int? get approvedByPicAtMs => throw _privateConstructorUsedError;
  int? get approvedByFinanceAtMs => throw _privateConstructorUsedError;
  int? get rejectedAtMs => throw _privateConstructorUsedError;
  int? get paidAtMs => throw _privateConstructorUsedError;
  int? get updatedAtMs => throw _privateConstructorUsedError;
  List<AttachmentModel> get attachments => throw _privateConstructorUsedError;
  List<ApprovalHistoryModel> get history => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AllowanceModelCopyWith<AllowanceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AllowanceModelCopyWith<$Res> {
  factory $AllowanceModelCopyWith(
          AllowanceModel value, $Res Function(AllowanceModel) then) =
      _$AllowanceModelCopyWithImpl<$Res, AllowanceModel>;
  @useResult
  $Res call(
      {String id,
      String submittedByUid,
      String submittedByName,
      String? projectId,
      String? projectName,
      String type,
      double requestedAmount,
      double? approvedAmount,
      String currency,
      int allowanceDateMs,
      String description,
      String status,
      String? picUid,
      String? financeUid,
      String? picNote,
      String? financeNote,
      String? rejectionReason,
      int createdAtMs,
      int? submittedAtMs,
      int? approvedByPicAtMs,
      int? approvedByFinanceAtMs,
      int? rejectedAtMs,
      int? paidAtMs,
      int? updatedAtMs,
      List<AttachmentModel> attachments,
      List<ApprovalHistoryModel> history});
}

/// @nodoc
class _$AllowanceModelCopyWithImpl<$Res, $Val extends AllowanceModel>
    implements $AllowanceModelCopyWith<$Res> {
  _$AllowanceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? submittedByUid = null,
    Object? submittedByName = null,
    Object? projectId = freezed,
    Object? projectName = freezed,
    Object? type = null,
    Object? requestedAmount = null,
    Object? approvedAmount = freezed,
    Object? currency = null,
    Object? allowanceDateMs = null,
    Object? description = null,
    Object? status = null,
    Object? picUid = freezed,
    Object? financeUid = freezed,
    Object? picNote = freezed,
    Object? financeNote = freezed,
    Object? rejectionReason = freezed,
    Object? createdAtMs = null,
    Object? submittedAtMs = freezed,
    Object? approvedByPicAtMs = freezed,
    Object? approvedByFinanceAtMs = freezed,
    Object? rejectedAtMs = freezed,
    Object? paidAtMs = freezed,
    Object? updatedAtMs = freezed,
    Object? attachments = null,
    Object? history = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      submittedByUid: null == submittedByUid
          ? _value.submittedByUid
          : submittedByUid // ignore: cast_nullable_to_non_nullable
              as String,
      submittedByName: null == submittedByName
          ? _value.submittedByName
          : submittedByName // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      projectName: freezed == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      requestedAmount: null == requestedAmount
          ? _value.requestedAmount
          : requestedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      approvedAmount: freezed == approvedAmount
          ? _value.approvedAmount
          : approvedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      allowanceDateMs: null == allowanceDateMs
          ? _value.allowanceDateMs
          : allowanceDateMs // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      picUid: freezed == picUid
          ? _value.picUid
          : picUid // ignore: cast_nullable_to_non_nullable
              as String?,
      financeUid: freezed == financeUid
          ? _value.financeUid
          : financeUid // ignore: cast_nullable_to_non_nullable
              as String?,
      picNote: freezed == picNote
          ? _value.picNote
          : picNote // ignore: cast_nullable_to_non_nullable
              as String?,
      financeNote: freezed == financeNote
          ? _value.financeNote
          : financeNote // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAtMs: null == createdAtMs
          ? _value.createdAtMs
          : createdAtMs // ignore: cast_nullable_to_non_nullable
              as int,
      submittedAtMs: freezed == submittedAtMs
          ? _value.submittedAtMs
          : submittedAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      approvedByPicAtMs: freezed == approvedByPicAtMs
          ? _value.approvedByPicAtMs
          : approvedByPicAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      approvedByFinanceAtMs: freezed == approvedByFinanceAtMs
          ? _value.approvedByFinanceAtMs
          : approvedByFinanceAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      rejectedAtMs: freezed == rejectedAtMs
          ? _value.rejectedAtMs
          : rejectedAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      paidAtMs: freezed == paidAtMs
          ? _value.paidAtMs
          : paidAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAtMs: freezed == updatedAtMs
          ? _value.updatedAtMs
          : updatedAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<AttachmentModel>,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<ApprovalHistoryModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AllowanceModelImplCopyWith<$Res>
    implements $AllowanceModelCopyWith<$Res> {
  factory _$$AllowanceModelImplCopyWith(_$AllowanceModelImpl value,
          $Res Function(_$AllowanceModelImpl) then) =
      __$$AllowanceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String submittedByUid,
      String submittedByName,
      String? projectId,
      String? projectName,
      String type,
      double requestedAmount,
      double? approvedAmount,
      String currency,
      int allowanceDateMs,
      String description,
      String status,
      String? picUid,
      String? financeUid,
      String? picNote,
      String? financeNote,
      String? rejectionReason,
      int createdAtMs,
      int? submittedAtMs,
      int? approvedByPicAtMs,
      int? approvedByFinanceAtMs,
      int? rejectedAtMs,
      int? paidAtMs,
      int? updatedAtMs,
      List<AttachmentModel> attachments,
      List<ApprovalHistoryModel> history});
}

/// @nodoc
class __$$AllowanceModelImplCopyWithImpl<$Res>
    extends _$AllowanceModelCopyWithImpl<$Res, _$AllowanceModelImpl>
    implements _$$AllowanceModelImplCopyWith<$Res> {
  __$$AllowanceModelImplCopyWithImpl(
      _$AllowanceModelImpl _value, $Res Function(_$AllowanceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? submittedByUid = null,
    Object? submittedByName = null,
    Object? projectId = freezed,
    Object? projectName = freezed,
    Object? type = null,
    Object? requestedAmount = null,
    Object? approvedAmount = freezed,
    Object? currency = null,
    Object? allowanceDateMs = null,
    Object? description = null,
    Object? status = null,
    Object? picUid = freezed,
    Object? financeUid = freezed,
    Object? picNote = freezed,
    Object? financeNote = freezed,
    Object? rejectionReason = freezed,
    Object? createdAtMs = null,
    Object? submittedAtMs = freezed,
    Object? approvedByPicAtMs = freezed,
    Object? approvedByFinanceAtMs = freezed,
    Object? rejectedAtMs = freezed,
    Object? paidAtMs = freezed,
    Object? updatedAtMs = freezed,
    Object? attachments = null,
    Object? history = null,
  }) {
    return _then(_$AllowanceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      submittedByUid: null == submittedByUid
          ? _value.submittedByUid
          : submittedByUid // ignore: cast_nullable_to_non_nullable
              as String,
      submittedByName: null == submittedByName
          ? _value.submittedByName
          : submittedByName // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      projectName: freezed == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      requestedAmount: null == requestedAmount
          ? _value.requestedAmount
          : requestedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      approvedAmount: freezed == approvedAmount
          ? _value.approvedAmount
          : approvedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      allowanceDateMs: null == allowanceDateMs
          ? _value.allowanceDateMs
          : allowanceDateMs // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      picUid: freezed == picUid
          ? _value.picUid
          : picUid // ignore: cast_nullable_to_non_nullable
              as String?,
      financeUid: freezed == financeUid
          ? _value.financeUid
          : financeUid // ignore: cast_nullable_to_non_nullable
              as String?,
      picNote: freezed == picNote
          ? _value.picNote
          : picNote // ignore: cast_nullable_to_non_nullable
              as String?,
      financeNote: freezed == financeNote
          ? _value.financeNote
          : financeNote // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAtMs: null == createdAtMs
          ? _value.createdAtMs
          : createdAtMs // ignore: cast_nullable_to_non_nullable
              as int,
      submittedAtMs: freezed == submittedAtMs
          ? _value.submittedAtMs
          : submittedAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      approvedByPicAtMs: freezed == approvedByPicAtMs
          ? _value.approvedByPicAtMs
          : approvedByPicAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      approvedByFinanceAtMs: freezed == approvedByFinanceAtMs
          ? _value.approvedByFinanceAtMs
          : approvedByFinanceAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      rejectedAtMs: freezed == rejectedAtMs
          ? _value.rejectedAtMs
          : rejectedAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      paidAtMs: freezed == paidAtMs
          ? _value.paidAtMs
          : paidAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedAtMs: freezed == updatedAtMs
          ? _value.updatedAtMs
          : updatedAtMs // ignore: cast_nullable_to_non_nullable
              as int?,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<AttachmentModel>,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<ApprovalHistoryModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AllowanceModelImpl extends _AllowanceModel {
  const _$AllowanceModelImpl(
      {required this.id,
      required this.submittedByUid,
      required this.submittedByName,
      this.projectId,
      this.projectName,
      this.type = 'other',
      required this.requestedAmount,
      this.approvedAmount,
      this.currency = 'IDR',
      required this.allowanceDateMs,
      this.description = '',
      this.status = 'draft',
      this.picUid,
      this.financeUid,
      this.picNote,
      this.financeNote,
      this.rejectionReason,
      required this.createdAtMs,
      this.submittedAtMs,
      this.approvedByPicAtMs,
      this.approvedByFinanceAtMs,
      this.rejectedAtMs,
      this.paidAtMs,
      this.updatedAtMs,
      final List<AttachmentModel> attachments = const [],
      final List<ApprovalHistoryModel> history = const []})
      : _attachments = attachments,
        _history = history,
        super._();

  factory _$AllowanceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AllowanceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String submittedByUid;
  @override
  final String submittedByName;
  @override
  final String? projectId;
  @override
  final String? projectName;
  @override
  @JsonKey()
  final String type;
  @override
  final double requestedAmount;
  @override
  final double? approvedAmount;
  @override
  @JsonKey()
  final String currency;
  @override
  final int allowanceDateMs;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String status;
  @override
  final String? picUid;
  @override
  final String? financeUid;
  @override
  final String? picNote;
  @override
  final String? financeNote;
  @override
  final String? rejectionReason;
  @override
  final int createdAtMs;
  @override
  final int? submittedAtMs;
  @override
  final int? approvedByPicAtMs;
  @override
  final int? approvedByFinanceAtMs;
  @override
  final int? rejectedAtMs;
  @override
  final int? paidAtMs;
  @override
  final int? updatedAtMs;
  final List<AttachmentModel> _attachments;
  @override
  @JsonKey()
  List<AttachmentModel> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final List<ApprovalHistoryModel> _history;
  @override
  @JsonKey()
  List<ApprovalHistoryModel> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'AllowanceModel(id: $id, submittedByUid: $submittedByUid, submittedByName: $submittedByName, projectId: $projectId, projectName: $projectName, type: $type, requestedAmount: $requestedAmount, approvedAmount: $approvedAmount, currency: $currency, allowanceDateMs: $allowanceDateMs, description: $description, status: $status, picUid: $picUid, financeUid: $financeUid, picNote: $picNote, financeNote: $financeNote, rejectionReason: $rejectionReason, createdAtMs: $createdAtMs, submittedAtMs: $submittedAtMs, approvedByPicAtMs: $approvedByPicAtMs, approvedByFinanceAtMs: $approvedByFinanceAtMs, rejectedAtMs: $rejectedAtMs, paidAtMs: $paidAtMs, updatedAtMs: $updatedAtMs, attachments: $attachments, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AllowanceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.submittedByUid, submittedByUid) ||
                other.submittedByUid == submittedByUid) &&
            (identical(other.submittedByName, submittedByName) ||
                other.submittedByName == submittedByName) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.requestedAmount, requestedAmount) ||
                other.requestedAmount == requestedAmount) &&
            (identical(other.approvedAmount, approvedAmount) ||
                other.approvedAmount == approvedAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.allowanceDateMs, allowanceDateMs) ||
                other.allowanceDateMs == allowanceDateMs) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.picUid, picUid) || other.picUid == picUid) &&
            (identical(other.financeUid, financeUid) ||
                other.financeUid == financeUid) &&
            (identical(other.picNote, picNote) || other.picNote == picNote) &&
            (identical(other.financeNote, financeNote) ||
                other.financeNote == financeNote) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.createdAtMs, createdAtMs) ||
                other.createdAtMs == createdAtMs) &&
            (identical(other.submittedAtMs, submittedAtMs) ||
                other.submittedAtMs == submittedAtMs) &&
            (identical(other.approvedByPicAtMs, approvedByPicAtMs) ||
                other.approvedByPicAtMs == approvedByPicAtMs) &&
            (identical(other.approvedByFinanceAtMs, approvedByFinanceAtMs) ||
                other.approvedByFinanceAtMs == approvedByFinanceAtMs) &&
            (identical(other.rejectedAtMs, rejectedAtMs) ||
                other.rejectedAtMs == rejectedAtMs) &&
            (identical(other.paidAtMs, paidAtMs) ||
                other.paidAtMs == paidAtMs) &&
            (identical(other.updatedAtMs, updatedAtMs) ||
                other.updatedAtMs == updatedAtMs) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        submittedByUid,
        submittedByName,
        projectId,
        projectName,
        type,
        requestedAmount,
        approvedAmount,
        currency,
        allowanceDateMs,
        description,
        status,
        picUid,
        financeUid,
        picNote,
        financeNote,
        rejectionReason,
        createdAtMs,
        submittedAtMs,
        approvedByPicAtMs,
        approvedByFinanceAtMs,
        rejectedAtMs,
        paidAtMs,
        updatedAtMs,
        const DeepCollectionEquality().hash(_attachments),
        const DeepCollectionEquality().hash(_history)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AllowanceModelImplCopyWith<_$AllowanceModelImpl> get copyWith =>
      __$$AllowanceModelImplCopyWithImpl<_$AllowanceModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AllowanceModelImplToJson(
      this,
    );
  }
}

abstract class _AllowanceModel extends AllowanceModel {
  const factory _AllowanceModel(
      {required final String id,
      required final String submittedByUid,
      required final String submittedByName,
      final String? projectId,
      final String? projectName,
      final String type,
      required final double requestedAmount,
      final double? approvedAmount,
      final String currency,
      required final int allowanceDateMs,
      final String description,
      final String status,
      final String? picUid,
      final String? financeUid,
      final String? picNote,
      final String? financeNote,
      final String? rejectionReason,
      required final int createdAtMs,
      final int? submittedAtMs,
      final int? approvedByPicAtMs,
      final int? approvedByFinanceAtMs,
      final int? rejectedAtMs,
      final int? paidAtMs,
      final int? updatedAtMs,
      final List<AttachmentModel> attachments,
      final List<ApprovalHistoryModel> history}) = _$AllowanceModelImpl;
  const _AllowanceModel._() : super._();

  factory _AllowanceModel.fromJson(Map<String, dynamic> json) =
      _$AllowanceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get submittedByUid;
  @override
  String get submittedByName;
  @override
  String? get projectId;
  @override
  String? get projectName;
  @override
  String get type;
  @override
  double get requestedAmount;
  @override
  double? get approvedAmount;
  @override
  String get currency;
  @override
  int get allowanceDateMs;
  @override
  String get description;
  @override
  String get status;
  @override
  String? get picUid;
  @override
  String? get financeUid;
  @override
  String? get picNote;
  @override
  String? get financeNote;
  @override
  String? get rejectionReason;
  @override
  int get createdAtMs;
  @override
  int? get submittedAtMs;
  @override
  int? get approvedByPicAtMs;
  @override
  int? get approvedByFinanceAtMs;
  @override
  int? get rejectedAtMs;
  @override
  int? get paidAtMs;
  @override
  int? get updatedAtMs;
  @override
  List<AttachmentModel> get attachments;
  @override
  List<ApprovalHistoryModel> get history;
  @override
  @JsonKey(ignore: true)
  _$$AllowanceModelImplCopyWith<_$AllowanceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
