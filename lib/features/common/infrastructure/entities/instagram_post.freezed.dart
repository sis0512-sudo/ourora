// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instagram_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InstagramPost {

 String get id; String get mediaType; String get mediaUrl; String? get thumbnailUrl; String get permalink; DateTime get timestamp; String? get caption;
/// Create a copy of InstagramPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstagramPostCopyWith<InstagramPost> get copyWith => _$InstagramPostCopyWithImpl<InstagramPost>(this as InstagramPost, _$identity);

  /// Serializes this InstagramPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstagramPost&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.permalink, permalink) || other.permalink == permalink)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.caption, caption) || other.caption == caption));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaType,mediaUrl,thumbnailUrl,permalink,timestamp,caption);

@override
String toString() {
  return 'InstagramPost(id: $id, mediaType: $mediaType, mediaUrl: $mediaUrl, thumbnailUrl: $thumbnailUrl, permalink: $permalink, timestamp: $timestamp, caption: $caption)';
}


}

/// @nodoc
abstract mixin class $InstagramPostCopyWith<$Res>  {
  factory $InstagramPostCopyWith(InstagramPost value, $Res Function(InstagramPost) _then) = _$InstagramPostCopyWithImpl;
@useResult
$Res call({
 String id, String mediaType, String mediaUrl, String? thumbnailUrl, String permalink, DateTime timestamp, String? caption
});




}
/// @nodoc
class _$InstagramPostCopyWithImpl<$Res>
    implements $InstagramPostCopyWith<$Res> {
  _$InstagramPostCopyWithImpl(this._self, this._then);

  final InstagramPost _self;
  final $Res Function(InstagramPost) _then;

/// Create a copy of InstagramPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mediaType = null,Object? mediaUrl = null,Object? thumbnailUrl = freezed,Object? permalink = null,Object? timestamp = null,Object? caption = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,permalink: null == permalink ? _self.permalink : permalink // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InstagramPost].
extension InstagramPostPatterns on InstagramPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstagramPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstagramPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstagramPost value)  $default,){
final _that = this;
switch (_that) {
case _InstagramPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstagramPost value)?  $default,){
final _that = this;
switch (_that) {
case _InstagramPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String mediaType,  String mediaUrl,  String? thumbnailUrl,  String permalink,  DateTime timestamp,  String? caption)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstagramPost() when $default != null:
return $default(_that.id,_that.mediaType,_that.mediaUrl,_that.thumbnailUrl,_that.permalink,_that.timestamp,_that.caption);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String mediaType,  String mediaUrl,  String? thumbnailUrl,  String permalink,  DateTime timestamp,  String? caption)  $default,) {final _that = this;
switch (_that) {
case _InstagramPost():
return $default(_that.id,_that.mediaType,_that.mediaUrl,_that.thumbnailUrl,_that.permalink,_that.timestamp,_that.caption);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String mediaType,  String mediaUrl,  String? thumbnailUrl,  String permalink,  DateTime timestamp,  String? caption)?  $default,) {final _that = this;
switch (_that) {
case _InstagramPost() when $default != null:
return $default(_that.id,_that.mediaType,_that.mediaUrl,_that.thumbnailUrl,_that.permalink,_that.timestamp,_that.caption);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstagramPost extends InstagramPost {
  const _InstagramPost({required this.id, required this.mediaType, required this.mediaUrl, this.thumbnailUrl, required this.permalink, required this.timestamp, this.caption}): super._();
  factory _InstagramPost.fromJson(Map<String, dynamic> json) => _$InstagramPostFromJson(json);

@override final  String id;
@override final  String mediaType;
@override final  String mediaUrl;
@override final  String? thumbnailUrl;
@override final  String permalink;
@override final  DateTime timestamp;
@override final  String? caption;

/// Create a copy of InstagramPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstagramPostCopyWith<_InstagramPost> get copyWith => __$InstagramPostCopyWithImpl<_InstagramPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstagramPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstagramPost&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.permalink, permalink) || other.permalink == permalink)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.caption, caption) || other.caption == caption));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaType,mediaUrl,thumbnailUrl,permalink,timestamp,caption);

@override
String toString() {
  return 'InstagramPost(id: $id, mediaType: $mediaType, mediaUrl: $mediaUrl, thumbnailUrl: $thumbnailUrl, permalink: $permalink, timestamp: $timestamp, caption: $caption)';
}


}

/// @nodoc
abstract mixin class _$InstagramPostCopyWith<$Res> implements $InstagramPostCopyWith<$Res> {
  factory _$InstagramPostCopyWith(_InstagramPost value, $Res Function(_InstagramPost) _then) = __$InstagramPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String mediaType, String mediaUrl, String? thumbnailUrl, String permalink, DateTime timestamp, String? caption
});




}
/// @nodoc
class __$InstagramPostCopyWithImpl<$Res>
    implements _$InstagramPostCopyWith<$Res> {
  __$InstagramPostCopyWithImpl(this._self, this._then);

  final _InstagramPost _self;
  final $Res Function(_InstagramPost) _then;

/// Create a copy of InstagramPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mediaType = null,Object? mediaUrl = null,Object? thumbnailUrl = freezed,Object? permalink = null,Object? timestamp = null,Object? caption = freezed,}) {
  return _then(_InstagramPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,permalink: null == permalink ? _self.permalink : permalink // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
