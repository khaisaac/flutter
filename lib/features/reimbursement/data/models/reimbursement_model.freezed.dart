// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reimbursement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReimbursementItemModel _$ReimbursementItemModelFromJson(
    Map<String, dynamic> json) {
  return _ReimbursementItemModel.fromJson(json);
}

/// @nodoc
mixin _$ReimbursementItemModel {
  String get id => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  int get receiptDateMs => throw _privateConstructorUsedError;
  List<AttachmentModel> get receipts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReimbursementItemModelCopyWith<ReimbursementItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReimbursementItemModelCopyWith<$Res> {
  factory $ReimbursementItemModelCopyWith(ReimbursementItemModel value,
          $Res Function(ReimbursementItemModel) then) =
      _$ReimbursementItemModelCopyWithImpl<$Res, ReimbursementItemModel>;
  @useResult
  $Res call(
      {String id,
      String category,
      String description,
      double amount,
      int receiptDateMs,
      List<AttachmentModel> receipts});
}

/// @nodoc
class _$ReimbursementItemModelCopyWithImpl<$Res,
        $Val extends ReimbursementItemModel>
    implements $ReimbursementItemModelCopyWith<$Res> {
  _$ReimbursementItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? description = null,
    Object? amount = null,
    Object? receiptDateMs = null,
    Object? receipts = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      receiptDateMs: null == receiptDateMs
          ? _value.receiptDateMs
          : receiptDateMs // ignore: cast_nullable_to_non_nullable
              as int,
      receipts: null == receipts
          ? _value.receipts
          : receipts // ignore: cast_nullable_to_non_nullable
              as List<AttachmentModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReimbursementItemModelImplCopyWith<$Res>
    implements $ReimbursementItemModelCopyWith<$Res> {
  factory _$$ReimbursementItemModelImplCopyWith(
          _$ReimbursementItemModelImpl value,
          $Res Function(_$ReimbursementItemModelImpl) then) =
      __$$ReimbursementItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String category,
      String description,
      double amount,
      int receiptDateMs,
      List<AttachmentModel> receipts});
}

/// @nodoc
class __$$ReimbursementItemModelImplCopyWithImpl<$Res>
    extends _$ReimbursementItemModelCopyWithImpl<$Res,
        _$ReimbursementItemModelImpl>
    implements _$$ReimbursementItemModelImplCopyWith<$Res> {
  __$$ReimbursementItemModelImplCopyWithImpl(
      _$ReimbursementItemModelImpl _value,
      $Res Function(_$ReimbursementItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? description = null,
    Object? amount = null,
    Object? receiptDateMs = null,
    Object? receipts = null,
  }) {
    return _then(_$ReimbursementItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      receiptDateMs: null == receiptDateMs
          ? _value.receiptDateMs
          : receiptDateMs // ignore: cast_nullable_to_non_nullable
              as int,
      receipts: null == receipts
          ? _value._receipts
          : receipts // ignore: cast_nullable_to_non_nullable
              as List<AttachmentModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReimbursementItemModelImpl extends _ReimbursementItemModel {
  const _$ReimbursementItemModelImpl(
      {required this.id,
      this.category = 'other',
      this.description = '',
      required this.amount,
      required this.receiptDateMs,
      final List<AttachmentModel> receipts = const []})
      : _receipts = receipts,
        super._();

  factory _$ReimbursementItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReimbursementItemModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final String description;
  @override
  final double amount;
  @override
  final int receiptDateMs;
  final List<AttachmentModel> _receipts;
  @override
  @JsonKey()
  List<AttachmentModel> get receipts {
    if (_receipts is EqualUnmodifiableListView) return _receipts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_receipts);
  }

  @override
  String toString() {
    return 'ReimbursementItemModel(id: $id, category: $category, description: $description, amount: $amount, receiptDateMs: $receiptDateMs, receipts: $receipts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReimbursementItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.receiptDateMs, receiptDateMs) ||
                other.receiptDateMs == receiptDateMs) &&
            const DeepCollectionEquality().equals(other._receipts, _receipts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, category, description,
      amount, receiptDateMs, const DeepCollectionEquality().hash(_receipts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReimbursementItemModelImplCopyWith<_$ReimbursementItemModelImpl>
      get copyWith => __$$ReimbursementItemModelImplCopyWithImpl<
          _$ReimbursementItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReimbursementItemModelImplToJson(
      this,
    );
  }
}

abstract class _ReimbursementItemModel extends ReimbursementItemModel {
  const factory _ReimbursementItemModel(
      {required final String id,
      final String category,
      final String description,
      required final double amount,
      required final int receiptDateMs,
      final List<AttachmentModel> receipts}) = _$ReimbursementItemModelImpl;
  const _ReimbursementItemModel._() : super._();

  factory _ReimbursementItemModel.fromJson(Map<String, dynamic> json) =
      _$ReimbursementItemModelImpl.fromJson;

  @override
  String get id;
  @override
  String get category;
  @override
  String get description;
  @override
  double get amount;
  @override
  int get receiptDateMs;
  @override
  List<AttachmentModel> get receipts;
  @override
  @JsonKey(ignore: true)
  _$$ReimbursementItemModelImplCopyWith<_$ReimbursementItemModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReimbursementModel _$ReimbursementModelFromJson(Map<String, dynamic> json) {
  return _ReimbursementModel.fromJson(json);
}

/// @nodoc
mixin _$ReimbursementModel {
  String get id => throw _privateConstructorUsedError;
  String get submittedByUid => throw _privateConstructorUsedError;
  String get submittedByName => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get projectName => throw _privateConstructorUsedError;
  List<ReimbursementItemModel> get items => throw _privateConstructorUsedError;
  double get totalRequestedAmount => throw _privateConstructorUsedError;
  double? get totalApprovedAmount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
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
  $ReimbursementModelCopyWith<ReimbursementModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReimbursementModelCopyWith<$Res> {
  factory $ReimbursementModelCopyWith(
          ReimbursementModel value, $Res Function(ReimbursementModel) then) =
      _$ReimbursementModelCopyWithImpl<$Res, ReimbursementModel>;
  @useResult
  $Res call(
      {String id,
      String submittedByUid,
      String submittedByName,
      String projectId,
      String projectName,
      List<ReimbursementItemModel> items,
      double totalRequestedAmount,
      double? totalApprovedAmount,
      String currency,
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
class _$ReimbursementModelCopyWithImpl<$Res, $Val extends ReimbursementModel>
    implements $ReimbursementModelCopyWith<$Res> {
  _$ReimbursementModelCopyWithImpl(this._value, this._then);

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
    Object? projectId = null,
    Object? projectName = null,
    Object? items = null,
    Object? totalRequestedAmount = null,
    Object? totalApprovedAmount = freezed,
    Object? currency = null,
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
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      projectName: null == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReimbursementItemModel>,
      totalRequestedAmount: null == totalRequestedAmount
          ? _value.totalRequestedAmount
          : totalRequestedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalApprovedAmount: freezed == totalApprovedAmount
          ? _value.totalApprovedAmount
          : totalApprovedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$ReimbursementModelImplCopyWith<$Res>
    implements $ReimbursementModelCopyWith<$Res> {
  factory _$$ReimbursementModelImplCopyWith(_$ReimbursementModelImpl value,
          $Res Function(_$ReimbursementModelImpl) then) =
      __$$ReimbursementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String submittedByUid,
      String submittedByName,
      String projectId,
      String projectName,
      List<ReimbursementItemModel> items,
      double totalRequestedAmount,
      double? totalApprovedAmount,
      String currency,
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
class __$$ReimbursementModelImplCopyWithImpl<$Res>
    extends _$ReimbursementModelCopyWithImpl<$Res, _$ReimbursementModelImpl>
    implements _$$ReimbursementModelImplCopyWith<$Res> {
  __$$ReimbursementModelImplCopyWithImpl(_$ReimbursementModelImpl _value,
      $Res Function(_$ReimbursementModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? submittedByUid = null,
    Object? submittedByName = null,
    Object? projectId = null,
    Object? projectName = null,
    Object? items = null,
    Object? totalRequestedAmount = null,
    Object? totalApprovedAmount = freezed,
    Object? currency = null,
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
    return _then(_$ReimbursementModelImpl(
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
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      projectName: null == projectName
          ? _value.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReimbursementItemModel>,
      totalRequestedAmount: null == totalRequestedAmount
          ? _value.totalRequestedAmount
          : totalRequestedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalApprovedAmount: freezed == totalApprovedAmount
          ? _value.totalApprovedAmount
          : totalApprovedAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$ReimbursementModelImpl extends _ReimbursementModel {
  const _$ReimbursementModelImpl(
      {required this.id,
      required this.submittedByUid,
      required this.submittedByName,
      required this.projectId,
      required this.projectName,
      final List<ReimbursementItemModel> items = const [],
      required this.totalRequestedAmount,
      this.totalApprovedAmount,
      this.currency = 'IDR',
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
      : _items = items,
        _attachments = attachments,
        _history = history,
        super._();

  factory _$ReimbursementModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReimbursementModelImplFromJson(json);

  @override
  final String id;
  @override
  final String submittedByUid;
  @override
  final String submittedByName;
  @override
  final String projectId;
  @override
  final String projectName;
  final List<ReimbursementItemModel> _items;
  @override
  @JsonKey()
  List<ReimbursementItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double totalRequestedAmount;
  @override
  final double? totalApprovedAmount;
  @override
  @JsonKey()
  final String currency;
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
    return 'ReimbursementModel(id: $id, submittedByUid: $submittedByUid, submittedByName: $submittedByName, projectId: $projectId, projectName: $projectName, items: $items, totalRequestedAmount: $totalRequestedAmount, totalApprovedAmount: $totalApprovedAmount, currency: $currency, description: $description, status: $status, picUid: $picUid, financeUid: $financeUid, picNote: $picNote, financeNote: $financeNote, rejectionReason: $rejectionReason, createdAtMs: $createdAtMs, submittedAtMs: $submittedAtMs, approvedByPicAtMs: $approvedByPicAtMs, approvedByFinanceAtMs: $approvedByFinanceAtMs, rejectedAtMs: $rejectedAtMs, paidAtMs: $paidAtMs, updatedAtMs: $updatedAtMs, attachments: $attachments, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReimbursementModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.submittedByUid, submittedByUid) ||
                other.submittedByUid == submittedByUid) &&
            (identical(other.submittedByName, submittedByName) ||
                other.submittedByName == submittedByName) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalRequestedAmount, totalRequestedAmount) ||
                other.totalRequestedAmount == totalRequestedAmount) &&
            (identical(other.totalApprovedAmount, totalApprovedAmount) ||
                other.totalApprovedAmount == totalApprovedAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
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
        const DeepCollectionEquality().hash(_items),
        totalRequestedAmount,
        totalApprovedAmount,
        currency,
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
  _$$ReimbursementModelImplCopyWith<_$ReimbursementModelImpl> get copyWith =>
      __$$ReimbursementModelImplCopyWithImpl<_$ReimbursementModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReimbursementModelImplToJson(
      this,
    );
  }
}

abstract class _ReimbursementModel extends ReimbursementModel {
  const factory _ReimbursementModel(
      {required final String id,
      required final String submittedByUid,
      required final String submittedByName,
      required final String projectId,
      required final String projectName,
      final List<ReimbursementItemModel> items,
      required final double totalRequestedAmount,
      final double? totalApprovedAmount,
      final String currency,
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
      final List<ApprovalHistoryModel> history}) = _$ReimbursementModelImpl;
  const _ReimbursementModel._() : super._();

  factory _ReimbursementModel.fromJson(Map<String, dynamic> json) =
      _$ReimbursementModelImpl.fromJson;

  @override
  String get id;
  @override
  String get submittedByUid;
  @override
  String get submittedByName;
  @override
  String get projectId;
  @override
  String get projectName;
  @override
  List<ReimbursementItemModel> get items;
  @override
  double get totalRequestedAmount;
  @override
  double? get totalApprovedAmount;
  @override
  String get currency;
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
  _$$ReimbursementModelImplCopyWith<_$ReimbursementModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
