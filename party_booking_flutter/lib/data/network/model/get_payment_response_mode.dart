// To parse this JSON data, do
//
//     final getPaymentResponseModel = getPaymentResponseModelFromJson(jsonString);

import 'dart:convert';

GetPaymentResponseModel getPaymentResponseModelFromJson(String str) => GetPaymentResponseModel.fromJson(json.decode(str));

String getPaymentResponseModelToJson(GetPaymentResponseModel data) => json.encode(data.toJson());

class GetPaymentResponseModel {
  String message;
  Data data;

  GetPaymentResponseModel({
    this.message,
    this.data,
  });

  static GetPaymentResponseModel fromJsonFactory(Map<String, dynamic> json) =>
      GetPaymentResponseModel.fromJson(json);

  factory GetPaymentResponseModel.fromJson(Map<String, dynamic> json) => GetPaymentResponseModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String id;
  String object;
  dynamic billingAddressCollection;
  String cancelUrl;
  dynamic clientReferenceId;
  dynamic customer;
  String customerEmail;
  List<DisplayItem> displayItems;
  bool liveMode;
  dynamic locale;
  Metadata metadata;
  String mode;
  String paymentIntent;
  List<String> paymentMethodTypes;
  dynamic setupIntent;
  dynamic shipping;
  dynamic shippingAddressCollection;
  dynamic submitType;
  dynamic subscription;
  String successUrl;

  Data({
    this.id,
    this.object,
    this.billingAddressCollection,
    this.cancelUrl,
    this.clientReferenceId,
    this.customer,
    this.customerEmail,
    this.displayItems,
    this.liveMode,
    this.locale,
    this.metadata,
    this.mode,
    this.paymentIntent,
    this.paymentMethodTypes,
    this.setupIntent,
    this.shipping,
    this.shippingAddressCollection,
    this.submitType,
    this.subscription,
    this.successUrl,
  });

  static Data fromJsonFactory(Map<String, dynamic> json) =>
      Data.fromJson(json);

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    object: json["object"],
    billingAddressCollection: json["billing_address_collection"],
    cancelUrl: json["cancel_url"],
    clientReferenceId: json["client_reference_id"],
    customer: json["customer"],
    customerEmail: json["customer_email"],
    displayItems: List<DisplayItem>.from(json["display_items"].map((x) => DisplayItem.fromJson(x))),
    liveMode: json["livemode"],
    locale: json["locale"],
    metadata: Metadata.fromJson(json["metadata"]),
    mode: json["mode"],
    paymentIntent: json["payment_intent"],
    paymentMethodTypes: List<String>.from(json["payment_method_types"].map((x) => x)),
    setupIntent: json["setup_intent"],
    shipping: json["shipping"],
    shippingAddressCollection: json["shipping_address_collection"],
    submitType: json["submit_type"],
    subscription: json["subscription"],
    successUrl: json["success_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "object": object,
    "billing_address_collection": billingAddressCollection,
    "cancel_url": cancelUrl,
    "client_reference_id": clientReferenceId,
    "customer": customer,
    "customer_email": customerEmail,
    "display_items": List<dynamic>.from(displayItems.map((x) => x.toJson())),
    "livemode": liveMode,
    "locale": locale,
    "metadata": metadata.toJson(),
    "mode": mode,
    "payment_intent": paymentIntent,
    "payment_method_types": List<dynamic>.from(paymentMethodTypes.map((x) => x)),
    "setup_intent": setupIntent,
    "shipping": shipping,
    "shipping_address_collection": shippingAddressCollection,
    "submit_type": submitType,
    "subscription": subscription,
    "success_url": successUrl,
  };
}

class DisplayItem {
  int amount;
  String currency;
  Custom custom;
  int quantity;
  String type;

  DisplayItem({
    this.amount,
    this.currency,
    this.custom,
    this.quantity,
    this.type,
  });

  static DisplayItem fromJsonFactory(Map<String, dynamic> json) =>
      DisplayItem.fromJson(json);

  factory DisplayItem.fromJson(Map<String, dynamic> json) => DisplayItem(
    amount: json["amount"],
    currency: json["currency"],
    custom: Custom.fromJson(json["custom"]),
    quantity: json["quantity"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "currency": currency,
    "custom": custom.toJson(),
    "quantity": quantity,
    "type": type,
  };
}

class Custom {
  String description;
  List<String> images;
  String name;

  Custom({
    this.description,
    this.images,
    this.name,
  });

  static Custom fromJsonFactory(Map<String, dynamic> json) =>
      Custom.fromJson(json);

  factory Custom.fromJson(Map<String, dynamic> json) => Custom(
    description: json["description"],
    images: List<String>.from(json["images"].map((x) => x)),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "images": List<dynamic>.from(images.map((x) => x)),
    "name": name,
  };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
  );

  Map<String, dynamic> toJson() => {
  };
}
