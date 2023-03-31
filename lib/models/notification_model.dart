class NotificationModelApp {
  String id;
  String title;
  String body;
  String? link;
  List<String>? actions;
  DateTime createdAt;

  NotificationModelApp({
    required this.id,
    required this.title,
    required this.body,
    this.link,
    this.actions,
    required this.createdAt,
  });

  factory NotificationModelApp.fromJson(Map<String, dynamic> json) {
    return NotificationModelApp(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      link: json['link'],
      actions:
          json['actions'] != null ? List<String>.from(json['actions']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'link': link,
      'actions': actions,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
