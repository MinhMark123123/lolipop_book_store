class ProvincetModel {
  String name;
  String slug;
  String type;
  String name_with_type;
  String code;
  List<String> quan_huyen;

  ProvincetModel(
      {this.name,
      this.slug,
      this.type,
      this.name_with_type,
      this.code,
      this.quan_huyen});

  ProvincetModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    type = json['type'];
    name_with_type = json['name_with_type'];
    code = json['code'];
    quan_huyen = json['quan_huyen'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['type'] = this.type;
    data['name_with_type'] = this.name_with_type;
    data['code'] = this.code;
    data['quan_huyen'] = this.quan_huyen;
    return data;
  }
}
