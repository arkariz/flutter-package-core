/// Represents a write operation to be performed in a batch
class WriteOperation {
  /// The type of write operation to perform
  final WriteOperationType type;
  
  /// The path to the document
  final String path;
  
  /// The data to write (for create and update operations)
  final Map<String, dynamic>? data;

  WriteOperation._({
    required this.type,
    required this.path,
    this.data,
  });

  /// Creates a new document at the specified path
  factory WriteOperation.create({
    required String path,
    required Map<String, dynamic> data,
  }) =>
      WriteOperation._(
        type: WriteOperationType.create,
        path: path,
        data: data,
      );

  /// Updates a document at the specified path
  factory WriteOperation.update({
    required String path,
    required Map<String, dynamic> data,
  }) =>
      WriteOperation._(
        type: WriteOperationType.update,
        path: path,
        data: data,
      );

  /// Deletes a document at the specified path
  factory WriteOperation.delete(String path) => WriteOperation._(
        type: WriteOperationType.delete,
        path: path,
      );
}

/// The type of write operation to perform
enum WriteOperationType {
  /// Create a new document
  create,
  
  /// Update an existing document
  update,
  
  /// Delete a document
  delete,
}
