import 'package:network_applications/models/component.dart';

class MyFile extends MyComponent {
  String? icon = "assets/icons/file.png";
  String? checkedBy;

  MyFile({
    required super.id,
    required super.name,
    required super.projectId,
    required super.folderId,
    required super.createdAt,
    required super.updatedAt,
    this.checkedBy,
  });
}
