class ProductModel {
  String? title;
  int? date;
  String? tag;
  ProductModel({
    this.title,
    this.date,
    this.tag,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'tag': tag,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      title: map['title'],
      date: map['date'],
      tag: map['tag'],
    );
  }
}
