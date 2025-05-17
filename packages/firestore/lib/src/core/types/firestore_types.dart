import 'package:cloud_firestore/cloud_firestore.dart';

/// Type definition for a document ID
typedef DocumentId = String;

/// Type definition for a collection path
typedef CollectionPath = String;

/// Type definition for a document path
typedef DocumentPath = String;

/// Type definition for a document data map
typedef DocumentData = Map<String, dynamic>;

/// Type definition for a query builder function
typedef QueryBuilder<T> = Query<T> Function(Query<T> query);

/// Type definition for a document snapshot transformer
typedef DocumentSnapshotTransformer<T> = T Function(DocumentSnapshot<Map<String, dynamic>> snapshot);

/// Type definition for a query snapshot transformer
typedef QuerySnapshotTransformer<T> = List<T> Function(QuerySnapshot<Map<String, dynamic>> snapshot);

/// Type definition for a batch operation callback
typedef BatchOperation = void Function(WriteBatch batch);

/// Type definition for error handler callback
typedef ErrorHandler = void Function(dynamic error, StackTrace stackTrace);

/// Options for query operations
class QueryOptions {
  /// Maximum number of documents to return
  final int? limit;
  
  /// Fields to order by
  final List<OrderByOption>? orderBy;
  
  /// Fields to filter by
  final List<WhereCondition>? whereConditions;
  
  /// Document to start after (for pagination)
  final DocumentSnapshot? startAfter;
  
  /// Document to end before (for pagination)
  final DocumentSnapshot? endBefore;

  const QueryOptions({
    this.limit,
    this.orderBy,
    this.whereConditions,
    this.startAfter,
    this.endBefore,
  });
}

/// Represents an order by option for queries
class OrderByOption {
  /// The field to order by
  final String field;
  
  /// Whether to sort in descending order
  final bool descending;

  const OrderByOption(this.field, {this.descending = false});
}

/// Represents a where condition for queries
class WhereCondition<T> {
  /// The field to filter on
  final String field;
  
  /// The operator to use for the condition
  final WhereOperator operator;
  
  /// The value to compare against
  final T value;

  const WhereCondition({
    required this.field,
    required this.operator,
    required this.value,
  });
}

/// Supported where operators for queries
enum WhereOperator {
  lessThan,
  lessThanOrEqualTo,
  isEqualTo,
  isNotEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  arrayContains,
  arrayContainsAny,
  inList,
  notInList,
  isNull,
  isNotNull,
}

/// Options for write operations
class WriteOptions {
  /// Whether to merge the data with existing document
  final bool merge;
  
  /// Fields to merge (if merge is true)
  final List<String>? mergeFields;
  
  /// Server timestamp behavior
  final ServerTimestampBehavior? serverTimestampBehavior;

  const WriteOptions({
    this.merge = false,
    this.mergeFields,
    this.serverTimestampBehavior,
  });
}

/// Options for batch operations
class BatchOptions {
  /// Whether to commit the batch atomically
  final bool isAtomic;
  
  /// Maximum number of operations per batch
  final int? maxBatchSize;

  const BatchOptions({
    this.isAtomic = true,
    this.maxBatchSize,
  });
}

/// Options for transaction operations
class TransactionOptions {
  /// Maximum number of attempts for the transaction
  final int maxAttempts;
  
  /// Timeout for the transaction
  final Duration? timeout;

  const TransactionOptions({
    this.maxAttempts = 5,
    this.timeout,
  });
}

/// Represents a paginated query result
class PaginatedResult<T> {
  /// The list of items in the current page
  final List<T> items;
  
  /// The last document snapshot (for pagination)
  final DocumentSnapshot? lastDocument;
  
  /// Whether there are more documents
  final bool hasMore;

  const PaginatedResult({
    required this.items,
    this.lastDocument,
    this.hasMore = false,
  });
}
