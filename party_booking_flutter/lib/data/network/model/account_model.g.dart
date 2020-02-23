// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AccountModel> _$accountModelSerializer =
    new _$AccountModelSerializer();

class _$AccountModelSerializer implements StructuredSerializer<AccountModel> {
  @override
  final Iterable<Type> types = const [AccountModel, _$AccountModel];
  @override
  final String wireName = 'AccountModel';

  @override
  Iterable<Object> serialize(Serializers serializers, AccountModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'username',
      serializers.serialize(object.username,
          specifiedType: const FullType(String)),
      'fullName',
      serializers.serialize(object.fullName,
          specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'phoneNumber',
      serializers.serialize(object.phoneNumber,
          specifiedType: const FullType(String)),
      'birthday',
      serializers.serialize(object.birthday,
          specifiedType: const FullType(String)),
      'sex',
      serializers.serialize(object.sex, specifiedType: const FullType(String)),
      'role',
      serializers.serialize(object.role, specifiedType: const FullType(String)),
      'imageurl',
      serializers.serialize(object.imageurl,
          specifiedType: const FullType(String)),
      'resetpassword',
      serializers.serialize(object.resetpassword,
          specifiedType: const FullType(String)),
      'createAt',
      serializers.serialize(object.createAt,
          specifiedType: const FullType(String)),
      'updateAt',
      serializers.serialize(object.updateAt,
          specifiedType: const FullType(String)),
      'token',
      serializers.serialize(object.token,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  AccountModel deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AccountModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'username':
          result.username = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'fullName':
          result.fullName = serializers.deserialize(value,
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
        case 'birthday':
          result.birthday = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'sex':
          result.sex = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'role':
          result.role = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'imageurl':
          result.imageurl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'resetpassword':
          result.resetpassword = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createAt':
          result.createAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updateAt':
          result.updateAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'token':
          result.token = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$AccountModel extends AccountModel {
  @override
  final String id;
  @override
  final String username;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String phoneNumber;
  @override
  final String birthday;
  @override
  final String sex;
  @override
  final String role;
  @override
  final String imageurl;
  @override
  final String resetpassword;
  @override
  final String createAt;
  @override
  final String updateAt;
  @override
  final String token;

  factory _$AccountModel([void Function(AccountModelBuilder) updates]) =>
      (new AccountModelBuilder()..update(updates)).build();

  _$AccountModel._(
      {this.id,
      this.username,
      this.fullName,
      this.email,
      this.phoneNumber,
      this.birthday,
      this.sex,
      this.role,
      this.imageurl,
      this.resetpassword,
      this.createAt,
      this.updateAt,
      this.token})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'id');
    }
    if (username == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'username');
    }
    if (fullName == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'fullName');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'email');
    }
    if (phoneNumber == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'phoneNumber');
    }
    if (birthday == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'birthday');
    }
    if (sex == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'sex');
    }
    if (role == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'role');
    }
    if (imageurl == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'imageurl');
    }
    if (resetpassword == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'resetpassword');
    }
    if (createAt == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'createAt');
    }
    if (updateAt == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'updateAt');
    }
    if (token == null) {
      throw new BuiltValueNullFieldError('AccountModel', 'token');
    }
  }

  @override
  AccountModel rebuild(void Function(AccountModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountModelBuilder toBuilder() => new AccountModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountModel &&
        id == other.id &&
        username == other.username &&
        fullName == other.fullName &&
        email == other.email &&
        phoneNumber == other.phoneNumber &&
        birthday == other.birthday &&
        sex == other.sex &&
        role == other.role &&
        imageurl == other.imageurl &&
        resetpassword == other.resetpassword &&
        createAt == other.createAt &&
        updateAt == other.updateAt &&
        token == other.token;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc($jc(0, id.hashCode),
                                                    username.hashCode),
                                                fullName.hashCode),
                                            email.hashCode),
                                        phoneNumber.hashCode),
                                    birthday.hashCode),
                                sex.hashCode),
                            role.hashCode),
                        imageurl.hashCode),
                    resetpassword.hashCode),
                createAt.hashCode),
            updateAt.hashCode),
        token.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AccountModel')
          ..add('id', id)
          ..add('username', username)
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('phoneNumber', phoneNumber)
          ..add('birthday', birthday)
          ..add('sex', sex)
          ..add('role', role)
          ..add('imageurl', imageurl)
          ..add('resetpassword', resetpassword)
          ..add('createAt', createAt)
          ..add('updateAt', updateAt)
          ..add('token', token))
        .toString();
  }
}

class AccountModelBuilder
    implements Builder<AccountModel, AccountModelBuilder> {
  _$AccountModel _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _username;
  String get username => _$this._username;
  set username(String username) => _$this._username = username;

  String _fullName;
  String get fullName => _$this._fullName;
  set fullName(String fullName) => _$this._fullName = fullName;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _phoneNumber;
  String get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String phoneNumber) => _$this._phoneNumber = phoneNumber;

  String _birthday;
  String get birthday => _$this._birthday;
  set birthday(String birthday) => _$this._birthday = birthday;

  String _sex;
  String get sex => _$this._sex;
  set sex(String sex) => _$this._sex = sex;

  String _role;
  String get role => _$this._role;
  set role(String role) => _$this._role = role;

  String _imageurl;
  String get imageurl => _$this._imageurl;
  set imageurl(String imageurl) => _$this._imageurl = imageurl;

  String _resetpassword;
  String get resetpassword => _$this._resetpassword;
  set resetpassword(String resetpassword) =>
      _$this._resetpassword = resetpassword;

  String _createAt;
  String get createAt => _$this._createAt;
  set createAt(String createAt) => _$this._createAt = createAt;

  String _updateAt;
  String get updateAt => _$this._updateAt;
  set updateAt(String updateAt) => _$this._updateAt = updateAt;

  String _token;
  String get token => _$this._token;
  set token(String token) => _$this._token = token;

  AccountModelBuilder();

  AccountModelBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _username = _$v.username;
      _fullName = _$v.fullName;
      _email = _$v.email;
      _phoneNumber = _$v.phoneNumber;
      _birthday = _$v.birthday;
      _sex = _$v.sex;
      _role = _$v.role;
      _imageurl = _$v.imageurl;
      _resetpassword = _$v.resetpassword;
      _createAt = _$v.createAt;
      _updateAt = _$v.updateAt;
      _token = _$v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AccountModel;
  }

  @override
  void update(void Function(AccountModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AccountModel build() {
    final _$result = _$v ??
        new _$AccountModel._(
            id: id,
            username: username,
            fullName: fullName,
            email: email,
            phoneNumber: phoneNumber,
            birthday: birthday,
            sex: sex,
            role: role,
            imageurl: imageurl,
            resetpassword: resetpassword,
            createAt: createAt,
            updateAt: updateAt,
            token: token);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
