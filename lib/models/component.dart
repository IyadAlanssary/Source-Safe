abstract class MyComponent {
  String? icon;
  int id;
  String name;
  int projectId;
  int folderId;
  String createdAt;
  String updatedAt;

  MyComponent({
    required this.id,
    required this.name,
    required this.projectId,
    required this.folderId,
    required this.createdAt,
    required this.updatedAt,
  });
}
