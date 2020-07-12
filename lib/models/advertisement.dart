class Advertisement {
  final String tenQC;
  final String imageURL;

  Advertisement({this.tenQC, this.imageURL});

  Advertisement.fromMap(Map<String, dynamic> data)
      : this(
          tenQC: data['tenQC'],
          imageURL: data['imageURL'],
        );

  toJson() {
    return {
      'tenQC': this.tenQC,
      'imageURL': this.imageURL,
    };
  }
}
