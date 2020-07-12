class NotificationModel {
  final String notiID;
  final String title;
  final String content;
  final String date;
  final String imageURL;

  const NotificationModel({
    this.notiID,
    this.title,
    this.content,
    this.date,
    this.imageURL,
  });

  NotificationModel.fromMap(Map<String, dynamic> data)
      : this(
          notiID: data['notiID'],
          title: data['title'],
          content: data['content'],
          date: data['date'],
          imageURL: data['imageURL'],
        );
  toJson() {
    return {
      'notiID': notiID,
      'title': title,
      'content': content,
      'date': date,
      'imageURL': imageURL,
    };
  }
}
