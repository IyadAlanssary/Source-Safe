class Project {
  int? id;
  late String name;
  int? adminId;
  String? createdAt;
  String? updatedAt;

  Project({this.id, required this.name, this.adminId, this.createdAt, this.updatedAt});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    adminId = json['admin_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> proj = <String, dynamic>{};
  //   proj['id'] = id;
  //   proj['name'] = name;
  //   proj['admin_id'] = adminId;
  //   proj['created_at'] = createdAt;
  //   proj['updated_at'] = updatedAt;
  //   return proj;
  // }
}
