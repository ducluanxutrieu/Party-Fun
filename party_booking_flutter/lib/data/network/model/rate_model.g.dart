// GENERATED CODE - DO NOT MODIFY BY HAND

part of rate_model;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RateModel> _$rateModelSerializer = new _$RateModelSerializer();

class _$RateModelSerializer implements StructuredSerializer<RateModel> {
  @override
  final Iterable<Type> types = const [RateModel, _$RateModel];
  @override
  final String wireName = 'RateModel';

  @override
  Iterable<Object> serialize(Serializers serializers, RateModel object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'average',
      serializers.serialize(object.average,
          specifiedType: const FullType(double)),
      'lishRate',
      serializers.serialize(object.memberRateModel,
          specifiedType: const FullType(
              BuiltList, const [const FullType(MemberRateModel)])),
      'totalpeople',
      serializers.serialize(object.totalPeople,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  RateModel deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RateModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'average':
          result.average = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'lishRate':
          result.memberRateModel.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(MemberRateModel)]))
              as BuiltList<dynamic>);
          break;
        case 'totalpeople':
          result.totalPeople = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$RateModel extends RateModel {
  @override
  final double average;
  @override
  final BuiltList<MemberRateModel> memberRateModel;
  @override
  final int totalPeople;

  factory _$RateModel([void Function(RateModelBuilder) updates]) =>
      (new RateModelBuilder()..update(updates)).build();

  _$RateModel._({this.average, this.memberRateModel, this.totalPeople})
      : super._() {
    if (average == null) {
      throw new BuiltValueNullFieldError('RateModel', 'average');
    }
    if (memberRateModel == null) {
      throw new BuiltValueNullFieldError('RateModel', 'memberRateModel');
    }
    if (totalPeople == null) {
      throw new BuiltValueNullFieldError('RateModel', 'totalPeople');
    }
  }

  @override
  RateModel rebuild(void Function(RateModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RateModelBuilder toBuilder() => new RateModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RateModel &&
        average == other.average &&
        memberRateModel == other.memberRateModel &&
        totalPeople == other.totalPeople;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, average.hashCode), memberRateModel.hashCode),
        totalPeople.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RateModel')
          ..add('average', average)
          ..add('memberRateModel', memberRateModel)
          ..add('totalPeople', totalPeople))
        .toString();
  }
}

class RateModelBuilder implements Builder<RateModel, RateModelBuilder> {
  _$RateModel _$v;

  double _average;
  double get average => _$this._average;
  set average(double average) => _$this._average = average;

  ListBuilder<MemberRateModel> _memberRateModel;
  ListBuilder<MemberRateModel> get memberRateModel =>
      _$this._memberRateModel ??= new ListBuilder<MemberRateModel>();
  set memberRateModel(ListBuilder<MemberRateModel> memberRateModel) =>
      _$this._memberRateModel = memberRateModel;

  int _totalPeople;
  int get totalPeople => _$this._totalPeople;
  set totalPeople(int totalPeople) => _$this._totalPeople = totalPeople;

  RateModelBuilder();

  RateModelBuilder get _$this {
    if (_$v != null) {
      _average = _$v.average;
      _memberRateModel = _$v.memberRateModel?.toBuilder();
      _totalPeople = _$v.totalPeople;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RateModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RateModel;
  }

  @override
  void update(void Function(RateModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RateModel build() {
    _$RateModel _$result;
    try {
      _$result = _$v ??
          new _$RateModel._(
              average: average,
              memberRateModel: memberRateModel.build(),
              totalPeople: totalPeople);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'memberRateModel';
        memberRateModel.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'RateModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
