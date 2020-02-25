// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_dishes_response_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ListDishesResponseModel> _$listDishesResponseModelSerializer =
    new _$ListDishesResponseModelSerializer();

class _$ListDishesResponseModelSerializer
    implements StructuredSerializer<ListDishesResponseModel> {
  @override
  final Iterable<Type> types = const [
    ListDishesResponseModel,
    _$ListDishesResponseModel
  ];
  @override
  final String wireName = 'ListDishesResponseModel';

  @override
  Iterable<Object> serialize(
      Serializers serializers, ListDishesResponseModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'success',
      serializers.serialize(object.success,
          specifiedType: const FullType(bool)),
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
      'lishDishs',
      serializers.serialize(object.dishModel,
          specifiedType:
              const FullType(BuiltList, const [const FullType(DishModel)])),
    ];

    return result;
  }

  @override
  ListDishesResponseModel deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ListDishesResponseModelBuilder();

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
        case 'lishDishs':
          result.dishModel.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(DishModel)]))
              as BuiltList<dynamic>);
          break;
      }
    }

    return result.build();
  }
}

class _$ListDishesResponseModel extends ListDishesResponseModel {
  @override
  final bool success;
  @override
  final String message;
  @override
  final BuiltList<DishModel> dishModel;

  factory _$ListDishesResponseModel(
          [void Function(ListDishesResponseModelBuilder) updates]) =>
      (new ListDishesResponseModelBuilder()..update(updates)).build();

  _$ListDishesResponseModel._({this.success, this.message, this.dishModel})
      : super._() {
    if (success == null) {
      throw new BuiltValueNullFieldError('ListDishesResponseModel', 'success');
    }
    if (message == null) {
      throw new BuiltValueNullFieldError('ListDishesResponseModel', 'message');
    }
    if (dishModel == null) {
      throw new BuiltValueNullFieldError(
          'ListDishesResponseModel', 'dishModel');
    }
  }

  @override
  ListDishesResponseModel rebuild(
          void Function(ListDishesResponseModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListDishesResponseModelBuilder toBuilder() =>
      new ListDishesResponseModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListDishesResponseModel &&
        success == other.success &&
        message == other.message &&
        dishModel == other.dishModel;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, success.hashCode), message.hashCode), dishModel.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ListDishesResponseModel')
          ..add('success', success)
          ..add('message', message)
          ..add('dishModel', dishModel))
        .toString();
  }
}

class ListDishesResponseModelBuilder
    implements
        Builder<ListDishesResponseModel, ListDishesResponseModelBuilder> {
  _$ListDishesResponseModel _$v;

  bool _success;
  bool get success => _$this._success;
  set success(bool success) => _$this._success = success;

  String _message;
  String get message => _$this._message;
  set message(String message) => _$this._message = message;

  ListBuilder<DishModel> _dishModel;
  ListBuilder<DishModel> get dishModel =>
      _$this._dishModel ??= new ListBuilder<DishModel>();
  set dishModel(ListBuilder<DishModel> dishModel) =>
      _$this._dishModel = dishModel;

  ListDishesResponseModelBuilder();

  ListDishesResponseModelBuilder get _$this {
    if (_$v != null) {
      _success = _$v.success;
      _message = _$v.message;
      _dishModel = _$v.dishModel?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListDishesResponseModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ListDishesResponseModel;
  }

  @override
  void update(void Function(ListDishesResponseModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ListDishesResponseModel build() {
    _$ListDishesResponseModel _$result;
    try {
      _$result = _$v ??
          new _$ListDishesResponseModel._(
              success: success, message: message, dishModel: dishModel.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'dishModel';
        dishModel.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ListDishesResponseModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
