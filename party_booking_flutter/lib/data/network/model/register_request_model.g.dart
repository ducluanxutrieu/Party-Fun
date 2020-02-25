// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RegisterRequestModel> _$registerRequestModelSerializer =
    new _$RegisterRequestModelSerializer();

class _$RegisterRequestModelSerializer
    implements StructuredSerializer<RegisterRequestModel> {
  @override
  final Iterable<Type> types = const [
    RegisterRequestModel,
    _$RegisterRequestModel
  ];
  @override
  final String wireName = 'RegisterRequestModel';

  @override
  Iterable<Object> serialize(
      Serializers serializers, RegisterRequestModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'fullName',
      serializers.serialize(object.fullName,
          specifiedType: const FullType(String)),
      'username',
      serializers.serialize(object.username,
          specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'phoneNumber',
      serializers.serialize(object.phoneNumber,
          specifiedType: const FullType(String)),
      'password',
      serializers.serialize(object.password,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  RegisterRequestModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RegisterRequestModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'fullName':
          result.fullName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'username':
          result.username = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'phoneNumber':
          result.phoneNumber = serializers.deserialize(value,
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

class _$RegisterRequestModel extends RegisterRequestModel {
  @override
  final String fullName;
  @override
  final String username;
  @override
  final String email;
  @override
  final String phoneNumber;
  @override
  final String password;

  factory _$RegisterRequestModel(
          [void Function(RegisterRequestModelBuilder) updates]) =>
      (new RegisterRequestModelBuilder()..update(updates)).build();

  _$RegisterRequestModel._(
      {this.fullName,
      this.username,
      this.email,
      this.phoneNumber,
      this.password})
      : super._() {
    if (fullName == null) {
      throw new BuiltValueNullFieldError('RegisterRequestModel', 'fullName');
    }
    if (username == null) {
      throw new BuiltValueNullFieldError('RegisterRequestModel', 'username');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('RegisterRequestModel', 'email');
    }
    if (phoneNumber == null) {
      throw new BuiltValueNullFieldError('RegisterRequestModel', 'phoneNumber');
    }
    if (password == null) {
      throw new BuiltValueNullFieldError('RegisterRequestModel', 'password');
    }
  }

  @override
  RegisterRequestModel rebuild(
          void Function(RegisterRequestModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterRequestModelBuilder toBuilder() =>
      new RegisterRequestModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterRequestModel &&
        fullName == other.fullName &&
        username == other.username &&
        email == other.email &&
        phoneNumber == other.phoneNumber &&
        password == other.password;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, fullName.hashCode), username.hashCode),
                email.hashCode),
            phoneNumber.hashCode),
        password.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RegisterRequestModel')
          ..add('fullName', fullName)
          ..add('username', username)
          ..add('email', email)
          ..add('phoneNumber', phoneNumber)
          ..add('password', password))
        .toString();
  }
}

class RegisterRequestModelBuilder
    implements Builder<RegisterRequestModel, RegisterRequestModelBuilder> {
  _$RegisterRequestModel _$v;

  String _fullName;
  String get fullName => _$this._fullName;
  set fullName(String fullName) => _$this._fullName = fullName;

  String _username;
  String get username => _$this._username;
  set username(String username) => _$this._username = username;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _phoneNumber;
  String get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String phoneNumber) => _$this._phoneNumber = phoneNumber;

  String _password;
  String get password => _$this._password;
  set password(String password) => _$this._password = password;

  RegisterRequestModelBuilder();

  RegisterRequestModelBuilder get _$this {
    if (_$v != null) {
      _fullName = _$v.fullName;
      _username = _$v.username;
      _email = _$v.email;
      _phoneNumber = _$v.phoneNumber;
      _password = _$v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterRequestModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RegisterRequestModel;
  }

  @override
  void update(void Function(RegisterRequestModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RegisterRequestModel build() {
    final _$result = _$v ??
        new _$RegisterRequestModel._(
            fullName: fullName,
            username: username,
            email: email,
            phoneNumber: phoneNumber,
            password: password);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
