// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkItem {

 String get id; String get title; String get description; List<String> get imageUrls; List<String> get lightImageUrls; String? get youtubeUrl; WorkType get type; DateTime get createdAt;
/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkItemCopyWith<WorkItem> get copyWith => _$WorkItemCopyWithImpl<WorkItem>(this as WorkItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&const DeepCollectionEquality().equals(other.lightImageUrls, lightImageUrls)&&(identical(other.youtubeUrl, youtubeUrl) || other.youtubeUrl == youtubeUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(imageUrls),const DeepCollectionEquality().hash(lightImageUrls),youtubeUrl,type,createdAt);

@override
String toString() {
  return 'WorkItem(id: $id, title: $title, description: $description, imageUrls: $imageUrls, lightImageUrls: $lightImageUrls, youtubeUrl: $youtubeUrl, type: $type, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WorkItemCopyWith<$Res>  {
  factory $WorkItemCopyWith(WorkItem value, $Res Function(WorkItem) _then) = _$WorkItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, List<String> imageUrls, List<String> lightImageUrls, String? youtubeUrl, WorkType type, DateTime createdAt
});




}
/// @nodoc
class _$WorkItemCopyWithImpl<$Res>
    implements $WorkItemCopyWith<$Res> {
  _$WorkItemCopyWithImpl(this._self, this._then);

  final WorkItem _self;
  final $Res Function(WorkItem) _then;

/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imageUrls = null,Object? lightImageUrls = null,Object? youtubeUrl = freezed,Object? type = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,lightImageUrls: null == lightImageUrls ? _self.lightImageUrls : lightImageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,youtubeUrl: freezed == youtubeUrl ? _self.youtubeUrl : youtubeUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WorkType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkItem].
extension WorkItemPatterns on WorkItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkItem value)  $default,){
final _that = this;
switch (_that) {
case _WorkItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkItem value)?  $default,){
final _that = this;
switch (_that) {
case _WorkItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<String> imageUrls,  List<String> lightImageUrls,  String? youtubeUrl,  WorkType type,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkItem() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imageUrls,_that.lightImageUrls,_that.youtubeUrl,_that.type,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  List<String> imageUrls,  List<String> lightImageUrls,  String? youtubeUrl,  WorkType type,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WorkItem():
return $default(_that.id,_that.title,_that.description,_that.imageUrls,_that.lightImageUrls,_that.youtubeUrl,_that.type,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  List<String> imageUrls,  List<String> lightImageUrls,  String? youtubeUrl,  WorkType type,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkItem() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.imageUrls,_that.lightImageUrls,_that.youtubeUrl,_that.type,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _WorkItem extends WorkItem {
  const _WorkItem({required this.id, required this.title, required this.description, required final  List<String> imageUrls, required final  List<String> lightImageUrls, this.youtubeUrl, required this.type, required this.createdAt}): _imageUrls = imageUrls,_lightImageUrls = lightImageUrls,super._();
  

@override final  String id;
@override final  String title;
@override final  String description;
 final  List<String> _imageUrls;
@override List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

 final  List<String> _lightImageUrls;
@override List<String> get lightImageUrls {
  if (_lightImageUrls is EqualUnmodifiableListView) return _lightImageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lightImageUrls);
}

@override final  String? youtubeUrl;
@override final  WorkType type;
@override final  DateTime createdAt;

/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkItemCopyWith<_WorkItem> get copyWith => __$WorkItemCopyWithImpl<_WorkItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&const DeepCollectionEquality().equals(other._lightImageUrls, _lightImageUrls)&&(identical(other.youtubeUrl, youtubeUrl) || other.youtubeUrl == youtubeUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,const DeepCollectionEquality().hash(_imageUrls),const DeepCollectionEquality().hash(_lightImageUrls),youtubeUrl,type,createdAt);

@override
String toString() {
  return 'WorkItem(id: $id, title: $title, description: $description, imageUrls: $imageUrls, lightImageUrls: $lightImageUrls, youtubeUrl: $youtubeUrl, type: $type, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WorkItemCopyWith<$Res> implements $WorkItemCopyWith<$Res> {
  factory _$WorkItemCopyWith(_WorkItem value, $Res Function(_WorkItem) _then) = __$WorkItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, List<String> imageUrls, List<String> lightImageUrls, String? youtubeUrl, WorkType type, DateTime createdAt
});




}
/// @nodoc
class __$WorkItemCopyWithImpl<$Res>
    implements _$WorkItemCopyWith<$Res> {
  __$WorkItemCopyWithImpl(this._self, this._then);

  final _WorkItem _self;
  final $Res Function(_WorkItem) _then;

/// Create a copy of WorkItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? imageUrls = null,Object? lightImageUrls = null,Object? youtubeUrl = freezed,Object? type = null,Object? createdAt = null,}) {
  return _then(_WorkItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,lightImageUrls: null == lightImageUrls ? _self._lightImageUrls : lightImageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,youtubeUrl: freezed == youtubeUrl ? _self.youtubeUrl : youtubeUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WorkType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
