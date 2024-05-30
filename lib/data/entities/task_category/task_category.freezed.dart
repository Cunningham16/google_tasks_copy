// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskCategory _$TaskCategoryFromJson(Map<String, dynamic> json) {
  return _TaskCategory.fromJson(json);
}

/// @nodoc
mixin _$TaskCategory {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isDeleteable => throw _privateConstructorUsedError;
  SortTypes get sortType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TaskCategoryCopyWith<TaskCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCategoryCopyWith<$Res> {
  factory $TaskCategoryCopyWith(
          TaskCategory value, $Res Function(TaskCategory) then) =
      _$TaskCategoryCopyWithImpl<$Res, TaskCategory>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      bool isDeleteable,
      SortTypes sortType});
}

/// @nodoc
class _$TaskCategoryCopyWithImpl<$Res, $Val extends TaskCategory>
    implements $TaskCategoryCopyWith<$Res> {
  _$TaskCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? isDeleteable = null,
    Object? sortType = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isDeleteable: null == isDeleteable
          ? _value.isDeleteable
          : isDeleteable // ignore: cast_nullable_to_non_nullable
              as bool,
      sortType: null == sortType
          ? _value.sortType
          : sortType // ignore: cast_nullable_to_non_nullable
              as SortTypes,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskCategoryImplCopyWith<$Res>
    implements $TaskCategoryCopyWith<$Res> {
  factory _$$TaskCategoryImplCopyWith(
          _$TaskCategoryImpl value, $Res Function(_$TaskCategoryImpl) then) =
      __$$TaskCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      bool isDeleteable,
      SortTypes sortType});
}

/// @nodoc
class __$$TaskCategoryImplCopyWithImpl<$Res>
    extends _$TaskCategoryCopyWithImpl<$Res, _$TaskCategoryImpl>
    implements _$$TaskCategoryImplCopyWith<$Res> {
  __$$TaskCategoryImplCopyWithImpl(
      _$TaskCategoryImpl _value, $Res Function(_$TaskCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? isDeleteable = null,
    Object? sortType = null,
  }) {
    return _then(_$TaskCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isDeleteable: null == isDeleteable
          ? _value.isDeleteable
          : isDeleteable // ignore: cast_nullable_to_non_nullable
              as bool,
      sortType: null == sortType
          ? _value.sortType
          : sortType // ignore: cast_nullable_to_non_nullable
              as SortTypes,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskCategoryImpl implements _TaskCategory {
  _$TaskCategoryImpl(
      {required this.id,
      required this.userId,
      required this.name,
      required this.isDeleteable,
      required this.sortType});

  factory _$TaskCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final bool isDeleteable;
  @override
  final SortTypes sortType;

  @override
  String toString() {
    return 'TaskCategory(id: $id, userId: $userId, name: $name, isDeleteable: $isDeleteable, sortType: $sortType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isDeleteable, isDeleteable) ||
                other.isDeleteable == isDeleteable) &&
            (identical(other.sortType, sortType) ||
                other.sortType == sortType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, name, isDeleteable, sortType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskCategoryImplCopyWith<_$TaskCategoryImpl> get copyWith =>
      __$$TaskCategoryImplCopyWithImpl<_$TaskCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskCategoryImplToJson(
      this,
    );
  }
}

abstract class _TaskCategory implements TaskCategory {
  factory _TaskCategory(
      {required final String id,
      required final String userId,
      required final String name,
      required final bool isDeleteable,
      required final SortTypes sortType}) = _$TaskCategoryImpl;

  factory _TaskCategory.fromJson(Map<String, dynamic> json) =
      _$TaskCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  bool get isDeleteable;
  @override
  SortTypes get sortType;
  @override
  @JsonKey(ignore: true)
  _$$TaskCategoryImplCopyWith<_$TaskCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
