// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_response_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AccountResponseModel> _$accountResponseModelSerializer =
    new _$AccountResponseModelSerializer();

class _$AccountResponseModelSerializer
    implements StructuredSerializer<AccountResponseModel> {
  @override
  final Iterable<Type> types = const [
    AccountResponseModel,
    _$AccountResponseModel
  ];
  @override
  final String wireName = 'AccountResponseModel';

  @override
  Iterable<Object> serialize(
      Serializers serializers, AccountResponseModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'success',
      serializers.serialize(object.success,
          specifiedType: const FullType(bool)),
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
      'account',
      serializers.serialize(object.account,
          specifiedType: const FullType(AccountModel)),
    ];

    return result;
  }

  @override
  AccountResponseModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AccountResponseModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'success':
          result.success = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'account':
          result.account.replace(serializers.deserialize(value,
              specifiedType: const FullType(AccountModel)) as AccountModel);
          break;
      }
    }

    return result.build();
  }
}

class _$AccountResponseModel extends AccountResponseModel {
  @override
  final bool success;
  @override
  final String message;
  @override
  final AccountModel account;

  factory _$AccountResponseModel(
          [void Function(AccountResponseModelBuilder) updates]) =>
      (new AccountResponseModelBuilder()..update(updates)).build();

  _$AccountResponseModel._({this.success, this.message, this.account})
      : super._() {
    if (success == null) {
      throw new BuiltValueNullFieldError('AccountResponseModel', 'success');
    }
    if (message == null) {
      throw new BuiltValueNullFieldError('AccountResponseModel', 'message');
    }
    if (account == null) {
      throw new BuiltValueNullFieldError('AccountResponseModel', 'account');
    }
  }

  @override
  AccountResponseModel rebuild(
          void Function(AccountResponseModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountResponseModelBuilder toBuilder() =>
      new AccountResponseModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountResponseModel &&
        success == other.success &&
        message == other.message &&
        account == other.account;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, success.hashCode), message.hashCode), account.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AccountResponseModel')
          ..add('success', success)
          ..add('message', message)
          ..add('account', account))
        .toString();
  }
}

class AccountResponseModelBuilder
    implements Builder<AccountResponseModel, AccountResponseModelBuilder> {
  _$AccountResponseModel _$v;

  bool _success;
  bool get success => _$this._success;
  set success(bool success) => _$this._success = success;

  String _message;
  String get message => _$this._message;
  set message(String message) => _$this._message = message;

  AccountModelBuilder _account;
  AccountModelBuilder get account =>
      _$this._account ??= new AccountModelBuilder();
  set account(AccountModelBuilder account) => _$this._account = account;

  AccountResponseModelBuilder();

  AccountResponseModelBuilder get _$this {
    if (_$v != null) {
      _success = _$v.success;
      _message = _$v.message;
      _account = _$v.account?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountResponseModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AccountResponseModel;
  }

  @override
  void update(void Function(AccountResponseModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AccountResponseModel build() {
    _$AccountResponseModel _$result;
    try {
      _$result = _$v ??
          new _$AccountResponseModel._(
              success: success, message: message, account: account.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'account';
        account.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AccountResponseModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
