class Service {
  final String name;
  final String icon;
  final List<dynamic> actions;
  final List<dynamic> reactions;
  bool connected;

  Service({
    required this.name,
    required this.icon,
    required this.actions,
    required this.reactions,
    required this.connected,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        name: json['name'],
        icon: json['icon'],
        actions: json['actions'],
        reactions: json['reactions'],
        connected: false
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'icon': icon,
        'actions': actions,
        'reactions': reactions,
      };
}