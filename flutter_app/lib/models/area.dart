class Area{
  final String name;

  Area({
    required this.name,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
      name:  json['name'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
  };
}