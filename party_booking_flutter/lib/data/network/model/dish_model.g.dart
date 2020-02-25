// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DishModel> _$dishModelSerializer = new _$DishModelSerializer();

class _$DishModelSerializer implements StructuredSerializer<DishModel> {
  @override
  final Iterable<Type> types = const [DishModel, _$DishModel];
  @override
  final String wireName = 'DishModel';

  @override
  Iterable<Object> serialize(Serializers serializers, DishModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'price',
      serializers.serialize(object.price, specifiedType: const FullType(int)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'discount',
      serializers.serialize(object.discount,
          specifiedType: const FullType(int)),
      'image',
      serializers.serialize(object.image,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'updateAt',
      serializers.serialize(object.updateAt,
          specifiedType: const FullType(String)),
      'createAt',
      serializers.serialize(object.createAt,
          specifiedType: const FullType(String)),
      'usercreate',
      serializers.serialize(object.usercreate,
          specifiedType: const FullType(String)),
      'rate',
      serializers.serialize(object.rate,
          specifiedType: const FullType(RateModel)),
    ];

    return result;
  }

  @override
  DishModel deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DishModelBuilder();

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
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'discount':
          result.discount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'image':
          result.image.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<dynamic>);
          break;
        case 'updateAt':
          result.updateAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createAt':
          result.createAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'usercreate':
          result.usercreate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'rate':
          result.rate.replace(serializers.deserialize(value,
              specifiedType: const FullType(RateModel)) as RateModel);
          break;
      }
    }

    return result.build();
  }
}

class _$DishModel extends DishModel {
  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final int price;
  @override
  final String type;
  @override
  final int discount;
  @override
  final BuiltList<String> image;
  @override
  final String updateAt;
  @override
  final String createAt;
  @override
  final String usercreate;
  @override
  final RateModel rate;

  factory _$DishModel([void Function(DishModelBuilder) updates]) =>
      (new DishModelBuilder()..update(updates)).build();

  _$DishModel._(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.type,
      this.discount,
      this.image,
      this.updateAt,
      this.createAt,
      this.usercreate,
      this.rate})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('DishModel', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('DishModel', 'name');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('DishModel', 'description');
    }
    if (price == null) {
      throw new BuiltValueNullFieldError('DishModel', 'price');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('DishModel', 'type');
    }
    if (discount == null) {
      throw new BuiltValueNullFieldError('DishModel', 'discount');
    }
    if (image == null) {
      throw new BuiltValueNullFieldError('DishModel', 'image');
    }
    if (updateAt == null) {
      throw new BuiltValueNullFieldError('DishModel', 'updateAt');
    }
    if (createAt == null) {
      throw new BuiltValueNullFieldError('DishModel', 'createAt');
    }
    if (usercreate == null) {
      throw new BuiltValueNullFieldError('DishModel', 'usercreate');
    }
    if (rate == null) {
      throw new BuiltValueNullFieldError('DishModel', 'rate');
    }
  }

  @override
  DishModel rebuild(void Function(DishModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DishModelBuilder toBuilder() => new DishModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DishModel &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        price == other.price &&
        type == other.type &&
        discount == other.discount &&
        image == other.image &&
        updateAt == other.updateAt &&
        createAt == other.createAt &&
        usercreate == other.usercreate &&
        rate == other.rate;
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
                                    $jc($jc($jc(0, id.hashCode), name.hashCode),
                                        description.hashCode),
                                    price.hashCode),
                                type.hashCode),
                            discount.hashCode),
                        image.hashCode),
                    updateAt.hashCode),
                createAt.hashCode),
            usercreate.hashCode),
        rate.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DishModel')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('price', price)
          ..add('type', type)
          ..add('discount', discount)
          ..add('image', image)
          ..add('updateAt', updateAt)
          ..add('createAt', createAt)
          ..add('usercreate', usercreate)
          ..add('rate', rate))
        .toString();
  }
}

class DishModelBuilder implements Builder<DishModel, DishModelBuilder> {
  _$DishModel _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  int _price;
  int get price => _$this._price;
  set price(int price) => _$this._price = price;

  String _type;
  String get type => _$this._type;
  set type(String type) => _$this._type = type;

  int _discount;
  int get discount => _$this._discount;
  set discount(int discount) => _$this._discount = discount;

  ListBuilder<String> _image;
  ListBuilder<String> get image => _$this._image ??= new ListBuilder<String>();
  set image(ListBuilder<String> image) => _$this._image = image;

  String _updateAt;
  String get updateAt => _$this._updateAt;
  set updateAt(String updateAt) => _$this._updateAt = updateAt;

  String _createAt;
  String get createAt => _$this._createAt;
  set createAt(String createAt) => _$this._createAt = createAt;

  String _usercreate;
  String get usercreate => _$this._usercreate;
  set usercreate(String usercreate) => _$this._usercreate = usercreate;

  RateModelBuilder _rate;
  RateModelBuilder get rate => _$this._rate ??= new RateModelBuilder();
  set rate(RateModelBuilder rate) => _$this._rate = rate;

  DishModelBuilder();

  DishModelBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _description = _$v.description;
      _price = _$v.price;
      _type = _$v.type;
      _discount = _$v.discount;
      _image = _$v.image?.toBuilder();
      _updateAt = _$v.updateAt;
      _createAt = _$v.createAt;
      _usercreate = _$v.usercreate;
      _rate = _$v.rate?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DishModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DishModel;
  }

  @override
  void update(void Function(DishModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DishModel build() {
    _$DishModel _$result;
    try {
      _$result = _$v ??
          new _$DishModel._(
              id: id,
              name: name,
              description: description,
              price: price,
              type: type,
              discount: discount,
              image: image.build(),
              updateAt: updateAt,
              createAt: createAt,
              usercreate: usercreate,
              rate: rate.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'image';
        image.build();

        _$failedField = 'rate';
        rate.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'DishModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
