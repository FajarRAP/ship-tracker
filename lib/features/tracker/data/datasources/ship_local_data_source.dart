import 'dart:io';

abstract class ShipLocalDataSource {
  Future<List<FileSystemEntity>> getAllFiles(Directory directory);
}

class ShipLocalDataSourceImpl extends ShipLocalDataSource {
  @override
  Future<List<FileSystemEntity>> getAllFiles(Directory directory) async =>
      await Directory(directory.path).list().toList();
}
