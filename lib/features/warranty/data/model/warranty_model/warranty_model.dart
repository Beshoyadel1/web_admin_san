class WarrantyModel {
  final int? id;
  final num? price;
  final int? durationtype;
  final int? durationvalue;

  const WarrantyModel({
    this.id,
    this.price,
    this.durationtype,
    this.durationvalue,
  });

  // =========================================================
  // FROM JSON
  // =========================================================

  factory WarrantyModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return WarrantyModel(
      id: _parseInt(
        json['ID'] ?? json['id'],
      ),

      price: _parseNum(
        json['PRICE'] ?? json['price'],
      ),

      durationtype: _parseInt(
        json['DURATIONTYPE'] ??
            json['durationtype'],
      ),

      durationvalue: _parseInt(
        json['DURATIONVALUE'] ??
            json['durationvalue'],
      ),
    );
  }

  // =========================================================
  // CREATE JSON
  // =========================================================

  Map<String, dynamic> toCreateJson() {
    return {
      'PRICE': price,
      'DURATIONTYPE': durationtype,
      'DURATIONVALUE': durationvalue,
    };
  }

  // =========================================================
  // UPDATE JSON
  // =========================================================

  Map<String, dynamic> toUpdateJson() {
    return {
      'ID': id,
      'PRICE': price,
      'DURATIONTYPE': durationtype,
      'DURATIONVALUE': durationvalue,
    };
  }

  // =========================================================
  // BACKWARD COMPATIBILITY
  // =========================================================

  Map<String, dynamic> toJson() {
    return toCreateJson();
  }

  // =========================================================
  // COPY WITH
  // =========================================================

  WarrantyModel copyWith({
    int? id,
    num? price,
    int? durationtype,
    int? durationvalue,
  }) {
    return WarrantyModel(
      id: id ?? this.id,
      price: price ?? this.price,
      durationtype:
      durationtype ?? this.durationtype,
      durationvalue:
      durationvalue ?? this.durationvalue,
    );
  }

  // =========================================================
  // PARSERS
  // =========================================================

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
    );
  }

  static num? _parseNum(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value;
    }

    return num.tryParse(
      value.toString(),
    );
  }

  // =========================================================
  // TO STRING
  // =========================================================

  @override
  String toString() {
    return '''
WarrantyModel(
  id: $id,
  price: $price,
  durationtype: $durationtype,
  durationvalue: $durationvalue,
)
''';
  }
}