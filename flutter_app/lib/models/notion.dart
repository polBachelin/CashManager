class NotionDB {
  final String name;
  final String id;


  NotionDB({
    required this.name,
    required this.id,
    
  });

  factory NotionDB.fromJson(Map<String, dynamic> json) => NotionDB(
        name: json['title']['text']['content'],
        id: json['id'],
      );
}