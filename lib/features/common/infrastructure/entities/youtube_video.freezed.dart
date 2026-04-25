// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube_video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$YoutubeVideo {

 String get videoId; String get title; String get description; String get thumbnailUrl; String get duration;
/// Create a copy of YoutubeVideo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YoutubeVideoCopyWith<YoutubeVideo> get copyWith => _$YoutubeVideoCopyWithImpl<YoutubeVideo>(this as YoutubeVideo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YoutubeVideo&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,videoId,title,description,thumbnailUrl,duration);

@override
String toString() {
  return 'YoutubeVideo(videoId: $videoId, title: $title, description: $description, thumbnailUrl: $thumbnailUrl, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $YoutubeVideoCopyWith<$Res>  {
  factory $YoutubeVideoCopyWith(YoutubeVideo value, $Res Function(YoutubeVideo) _then) = _$YoutubeVideoCopyWithImpl;
@useResult
$Res call({
 String videoId, String title, String description, String thumbnailUrl, String duration
});




}
/// @nodoc
class _$YoutubeVideoCopyWithImpl<$Res>
    implements $YoutubeVideoCopyWith<$Res> {
  _$YoutubeVideoCopyWithImpl(this._self, this._then);

  final YoutubeVideo _self;
  final $Res Function(YoutubeVideo) _then;

/// Create a copy of YoutubeVideo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? videoId = null,Object? title = null,Object? description = null,Object? thumbnailUrl = null,Object? duration = null,}) {
  return _then(_self.copyWith(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [YoutubeVideo].
extension YoutubeVideoPatterns on YoutubeVideo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YoutubeVideo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YoutubeVideo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YoutubeVideo value)  $default,){
final _that = this;
switch (_that) {
case _YoutubeVideo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YoutubeVideo value)?  $default,){
final _that = this;
switch (_that) {
case _YoutubeVideo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String videoId,  String title,  String description,  String thumbnailUrl,  String duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YoutubeVideo() when $default != null:
return $default(_that.videoId,_that.title,_that.description,_that.thumbnailUrl,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String videoId,  String title,  String description,  String thumbnailUrl,  String duration)  $default,) {final _that = this;
switch (_that) {
case _YoutubeVideo():
return $default(_that.videoId,_that.title,_that.description,_that.thumbnailUrl,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String videoId,  String title,  String description,  String thumbnailUrl,  String duration)?  $default,) {final _that = this;
switch (_that) {
case _YoutubeVideo() when $default != null:
return $default(_that.videoId,_that.title,_that.description,_that.thumbnailUrl,_that.duration);case _:
  return null;

}
}

}

/// @nodoc


class _YoutubeVideo implements YoutubeVideo {
  const _YoutubeVideo({required this.videoId, required this.title, required this.description, required this.thumbnailUrl, required this.duration});
  

@override final  String videoId;
@override final  String title;
@override final  String description;
@override final  String thumbnailUrl;
@override final  String duration;

/// Create a copy of YoutubeVideo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YoutubeVideoCopyWith<_YoutubeVideo> get copyWith => __$YoutubeVideoCopyWithImpl<_YoutubeVideo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _YoutubeVideo&&(identical(other.videoId, videoId) || other.videoId == videoId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,videoId,title,description,thumbnailUrl,duration);

@override
String toString() {
  return 'YoutubeVideo(videoId: $videoId, title: $title, description: $description, thumbnailUrl: $thumbnailUrl, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$YoutubeVideoCopyWith<$Res> implements $YoutubeVideoCopyWith<$Res> {
  factory _$YoutubeVideoCopyWith(_YoutubeVideo value, $Res Function(_YoutubeVideo) _then) = __$YoutubeVideoCopyWithImpl;
@override @useResult
$Res call({
 String videoId, String title, String description, String thumbnailUrl, String duration
});




}
/// @nodoc
class __$YoutubeVideoCopyWithImpl<$Res>
    implements _$YoutubeVideoCopyWith<$Res> {
  __$YoutubeVideoCopyWithImpl(this._self, this._then);

  final _YoutubeVideo _self;
  final $Res Function(_YoutubeVideo) _then;

/// Create a copy of YoutubeVideo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? videoId = null,Object? title = null,Object? description = null,Object? thumbnailUrl = null,Object? duration = null,}) {
  return _then(_YoutubeVideo(
videoId: null == videoId ? _self.videoId : videoId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
