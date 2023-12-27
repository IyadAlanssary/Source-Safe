import 'package:network_applications/models/component.dart';

class MyFolder extends MyComponent {
  String? icon = "assets/icons/folder.png";

  MyFolder({
    required super.id,
    required super.name,
    required super.projectId,
    required super.folderId,
    required super.createdAt,
    required super.updatedAt,
  });
}
