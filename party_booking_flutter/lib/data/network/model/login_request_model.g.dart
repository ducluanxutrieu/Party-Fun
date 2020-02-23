// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LoginRequestModel> _$loginRequestModelSerializer =
    new _$LoginRequestModelSerializer();

class _$LoginRequestModelSerializer
    implements StructuredSerializer<LoginRequestModel> {
  @override
  final Iterable<Type> types = const [LoginRequestModel, _$LoginRequestModel];
  @override
  final String wireName = 'LoginRequestModel';

  @override
  Iterable<Object> serialize(Serializers serializers, LoginRequestModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'username',
      serializers.serialize(object.username,
          specifiedType: const FullType(String)),
      'password',
      serializers.serialize(object.password,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  LoginRequestModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LoginRequestModelBuilder();

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
        case 'password':
          result.password = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$LoginRequestModel extends LoginRequestModel {
  @override
  final String username;
  @override
  final String password;

  factory _$LoginRequestModel(
          [void Function(LoginRequestModelBuilder) updates]) =>
      (new LoginRequestModelBuilder()..update(updates)).build();

  _$LoginRequestModel._({this.username, this.password}) : super._() {
    if (username == null) {
      throw new BuiltValueNullFieldError('LoginRequestModel', 'username');
    }
    if (password == null) {
      throw new BuiltValueNullFieldError('LoginRequestModel', 'password');
    }
  }

  @override
  LoginRequestModel rebuild(void Function(LoginRequestModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginRequestModelBuilder toBuilder() =>
      new LoginRequestModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginRequestModel &&
        username == other.username &&
        password == other.password;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, username.hashCode), password.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LoginRequestModel')
          ..add('username', username)
          ..add('password', password))
        .toString();
  }
}

class LoginRequestModelBuilder
    implements Builder<LoginRequestModel, LoginRequestModelBuilder> {
  _$LoginRequestModel _$v;

  String _username;
  String get username => _$this._username;
  set username(String username) => _$this._username = username;

  String _password;
  String get password => _$this._password;
  set password(String password) => _$this._password = password;

  LoginRequestModelBuilder();

  LoginRequestModelBuilder get _$this {
    if (_$v != null) {
      _username = _$v.username;
      _password = _$v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginRequestModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LoginRequestModel;
  }

  @override
  void update(void Function(LoginRequestModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LoginRequestModel build() {
    final _$result = _$v ??
        new _$LoginRequestModel._(username: username, password: password);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
