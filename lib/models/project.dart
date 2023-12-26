class Project {
  int? id;
  late String name;
  // int? adminId;
  // String? createdAt;
  // String? updatedAt;

  Project({this.id, required this.name
    // , this.adminId, this.createdAt, this.updatedAt
  });

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // adminId = json['admin_id'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
  }
}
