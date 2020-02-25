// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_rate_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<MemberRateModel> _$memberRateModelSerializer =
    new _$MemberRateModelSerializer();

class _$MemberRateModelSerializer
    implements StructuredSerializer<MemberRateModel> {
  @override
  final Iterable<Type> types = const [MemberRateModel, _$MemberRateModel];
  @override
  final String wireName = 'MemberRateModel';

  @override
  Iterable<Object> serialize(Serializers serializers, MemberRateModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'username',
      serializers.serialize(object.username,
          specifiedType: const FullType(String)),
      'imageurl',
      serializers.serialize(object.imageurl,
          specifiedType: const FullType(String)),
      '_iddish',
      serializers.serialize(object.iddish,
          specifiedType: const FullType(String)),
      'scorerate',
      serializers.serialize(object.scorerate,
          specifiedType: const FullType(int)),
      'content',
      serializers.serialize(object.content,
          specifiedType: const FullType(String)),
      'updateAt',
      serializers.serialize(object.updateAt,
          specifiedType: const FullType(String)),
      'createAt',
      serializers.serialize(object.createAt,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  MemberRateModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MemberRateModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'username':
          result.username = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'imageurl':
          result.imageurl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case '_iddish':
          result.iddish = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'scorerate':
          result.scorerate = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'content':
          result.content = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updateAt':
          result.updateAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createAt':
          result.createAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$MemberRateModel extends MemberRateModel {
  @override
  final String username;
  @override
  final String imageurl;
  @override
  final String iddish;
  @override
  final int scorerate;
  @override
  final String content;
  @override
  final String updateAt;
  @override
  final String createAt;

  factory _$MemberRateModel([void Function(MemberRateModelBuilder) updates]) =>
      (new MemberRateModelBuilder()..update(updates)).build();

  _$MemberRateModel._(
      {this.username,
      this.imageurl,
      this.iddish,
      this.scorerate,
      this.content,
      this.updateAt,
      this.createAt})
      : super._() {
    if (username == null) {
      throw new BuiltValueNullFieldError('MemberRateModel', 'username');
    }
    if (imageurl == null) {
      throw new BuiltValueNullFieldError('MemberRateModel', 'imageurl');
    }
    if (iddish == null) {
      throw new BuiltValueNullFieldError('MemberRateModel', 'iddish');
    }
    if (scorerate == null) {
      throw new BuiltValueNullFieldError('MemberRateModel', 'scorerate');
    }
    if (content == null) {
      throw new BuiltValueNullFieldError('MemberRateModel', 'content');
    }
    if (updateAt == null) {
      throw new BuiltValueNullFieldError('MemberRateModel', 'updateAt');
    }
    if (createAt == null) {
      throw new BuiltValueNullFieldError('MemberRateModel', 'createAt');
    }
  }

  @override
  MemberRateModel rebuild(void Function(MemberRateModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberRateModelBuilder toBuilder() =>
      new MemberRateModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberRateModel &&
        username == other.username &&
        imageurl == other.imageurl &&
        iddish == other.iddish &&
        scorerate == other.scorerate &&
        content == other.content &&
        updateAt == other.updateAt &&
        createAt == other.createAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, username.hashCode), imageurl.hashCode),
                        iddish.hashCode),
                    scorerate.hashCode),
                content.hashCode),
            updateAt.hashCode),
        createAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MemberRateModel')
          ..add('username', username)
          ..add('imageurl', imageurl)
          ..add('iddish', iddish)
          ..add('scorerate', scorerate)
          ..add('content', content)
          ..add('updateAt', updateAt)
          ..add('createAt', createAt))
        .toString();
  }
}

class MemberRateModelBuilder
    implements Builder<MemberRateModel, MemberRateModelBuilder> {
  _$MemberRateModel _$v;

  String _username;
  String get username => _$this._username;
  set username(String username) => _$this._username = username;

  String _imageurl;
  String get imageurl => _$this._imageurl;
  set imageurl(String imageurl) => _$this._imageurl = imageurl;

  String _iddish;
  String get iddish => _$this._iddish;
  set iddish(String iddish) => _$this._iddish = iddish;

  int _scorerate;
  int get scorerate => _$this._scorerate;
  set scorerate(int scorerate) => _$this._scorerate = scorerate;

  String _content;
  String get content => _$this._content;
  set content(String content) => _$this._content = content;

  String _updateAt;
  String get updateAt => _$this._updateAt;
  set updateAt(String updateAt) => _$this._updateAt = updateAt;

  String _createAt;
  String get createAt => _$this._createAt;
  set createAt(String createAt) => _$this._createAt = createAt;

  MemberRateModelBuilder();

  MemberRateModelBuilder get _$this {
    if (_$v != null) {
      _username = _$v.username;
      _imageurl = _$v.imageurl;
      _iddish = _$v.iddish;
      _scorerate = _$v.scorerate;
      _content = _$v.content;
      _updateAt = _$v.updateAt;
      _createAt = _$v.createAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberRateModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MemberRateModel;
  }

  @override
  void update(void Function(MemberRateModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MemberRateModel build() {
    final _$result = _$v ??
        new _$MemberRateModel._(
            username: username,
            imageurl: imageurl,
            iddish: iddish,
            scorerate: scorerate,
            content: content,
            updateAt: updateAt,
            createAt: createAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
