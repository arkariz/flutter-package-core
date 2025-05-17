import 'dart:async';

import 'package:firestore/firestore.dart';

/// A service class that provides a clean API for Firestore operations
class FirestoreService {
  final FirebaseFirestore _firestore;

  /// Creates a new instance of [FirestoreService]
  /// 
  /// If [firestore] is provided, it will be used instead of the default instance.
  /// [errorHandler] is an optional callback for handling errors.
  FirestoreService({
    FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? FirebaseFirestore.instance;

  // ====================
  // CRUD Operations
  // ====================


  /// Creates a new document in the specified collection
  /// 
  /// If [id] is provided, the document will be created with the specified ID.
  /// Otherwise, a new document ID will be automatically generated.
  /// 
  /// [options] can be used to specify merge behavior and other write options.
  /// 
  /// Returns the ID of the created document.
  Future<DocumentId> create({
    required CollectionPath collection,
    required DocumentData data,
    DocumentId? id,
    WriteOptions options = const WriteOptions(),
  }) async {
    final docRef = id != null 
        ? _firestore.collection(collection).doc(id)
        : _firestore.collection(collection).doc();
    
    await docRef.set(
      data,
      options.merge 
          ? (options.mergeFields != null 
              ? SetOptions(mergeFields: options.mergeFields!)
              : SetOptions(merge: true))
          : null,
    );
    
    return docRef.id;
  }

  /// Reads a single document from the specified path
  /// 
  /// [path] should be the full document path (e.g., 'users/123').
  /// [serverTimestampBehavior] controls how server timestamps are returned.
  /// 
  /// Returns the document data if it exists, or `null` if it doesn't.
  Future<DocumentData?> read({
    required DocumentPath path,
    ServerTimestampBehavior serverTimestampBehavior = ServerTimestampBehavior.none,
  }) async {
    final doc = await _firestore.doc(path).get(
      GetOptions(
        serverTimestampBehavior: serverTimestampBehavior,
      ),
    );
    return doc.data();
  }

  /// Updates fields in a document at the specified path
  /// 
  /// [path] should be the full document path (e.g., 'users/123').
  /// [data] contains the fields to update. Nested fields can be updated using dot notation.
  Future<void> update({
    required DocumentPath path,
    required DocumentData data,
  }) async {
    // Update without options as the Firestore SDK doesn't support serverTimestampBehavior in update
    await _firestore.doc(path).update(data);
  }

  /// Deletes a document at the specified path
  /// 
  /// [path] should be the full document path (e.g., 'users/123').
  Future<void> delete({
    required DocumentPath path,
  }) async {
    await _firestore.doc(path).delete();
  }

  /// Queries a collection with the specified options
  /// 
  /// [collection] is the name of the collection to query.
  /// [options] can be used to specify filters, ordering, and pagination.
  /// [transformer] is an optional function to transform the query results.
  /// 
  /// Returns a list of documents matching the query.
  /// Queries a collection with the specified options
  /// 
  /// [collection] is the name of the collection to query.
  /// [options] can be used to specify filters, ordering, and pagination.
  /// [transformer] is an optional function to transform the query results.
  /// 
  /// Returns a list of documents matching the query.
  Future<List<T>> query<T extends DocumentData?>({
    required CollectionPath collection,
    QueryOptions options = const QueryOptions(),
    DocumentSnapshotTransformer<T>? transformer,
  }) async {
    final query = _buildQuery(collection, options);

    final snapshot = await query.get();
    
    if (transformer != null) {
      return snapshot.docs
          .map((doc) => transformer(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    }
    return snapshot.docs.map((doc) => doc.data() as T).toList();
  }

  // ====================
  // Query Builder Helper
  // ====================

  Query<Map<String, dynamic>> _buildQuery(
    CollectionPath collection,
    QueryOptions options,
  ) {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);

    // Apply where conditions
    if (options.whereConditions != null) {
      for (final condition in options.whereConditions!) {
        query = _applyWhereCondition(query, condition);
      }
    }

    // Apply order by
    if (options.orderBy != null) {
      for (final order in options.orderBy!) {
        query = query.orderBy(order.field, descending: order.descending);
      }
    }

    // Apply pagination
    if (options.limit != null) {
      query = query.limit(options.limit!);
    }
    if (options.startAfter != null) {
      query = query.startAfterDocument(options.startAfter!);
    }
    if (options.endBefore != null) {
      query = query.endBeforeDocument(options.endBefore!);
    }

    return query;
  }

  // ====================
  // Real-time Updates
  // ====================


  /// Watches a document for changes
  /// 
  /// [path] is the full document path to watch.
  /// [includeMetadataChanges] whether to include metadata changes in the stream.
  /// [transformer] is an optional function to transform the document data.
  /// 
  /// Returns a stream that emits the document data whenever it changes.
  Stream<T?> watchDocument<T extends DocumentData?>({
    required DocumentPath path,
    bool includeMetadataChanges = false,
    DocumentSnapshotTransformer<T>? transformer,
  }) {
    final stream = _firestore
        .doc(path)
        .withConverter<DocumentData>(
          fromFirestore: (doc, _) => doc.data()!,
          toFirestore: (data, _) => data,
        )
        .snapshots(
          includeMetadataChanges: includeMetadataChanges,
        );

    if (transformer != null) {
      return stream.map((snapshot) {
        if (!snapshot.exists) return null;
        return transformer(snapshot);
      });
    }
    
    return stream.map((snapshot) => snapshot.data() as T?);
  }

  /// Watches a collection for changes with the specified options
  /// 
  /// [collection] is the name of the collection to watch.
  /// [options] can be used to specify filters, ordering, and pagination.
  /// [includeMetadataChanges] whether to include metadata changes in the stream.
  /// [transformer] is an optional function to transform the query results.
  /// 
  /// Returns a stream of query results that updates in real-time.
  /// Watches a collection for changes with the specified options
  /// 
  /// [collection] is the name of the collection to watch.
  /// [options] can be used to specify filters, ordering, and pagination.
  /// [includeMetadataChanges] whether to include metadata changes in the stream.
  /// [transformer] is an optional function to transform the query results.
  /// 
  /// Returns a stream of query results that updates in real-time.
  Stream<List<T>> watchCollection<T extends DocumentData?>({
    required CollectionPath collection,
    QueryOptions options = const QueryOptions(),
    bool includeMetadataChanges = false,
    DocumentSnapshotTransformer<T>? transformer,
  }) {
    final query = _buildQuery(collection, options);

    return query
      .snapshots(includeMetadataChanges: includeMetadataChanges)
      .map((snapshot) {
        if (transformer != null) {
          return snapshot.docs
              .map((doc) => transformer(doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList();
        }
        return snapshot.docs.map((doc) => doc.data() as T).toList();
      });
  }

  // ====================
  // Batch Operations
  // ====================


  /// Executes multiple write operations as a single atomic unit
  /// 
  /// [operations] is a list of write operations to perform.
  /// [options] can be used to configure the batch behavior.
  /// [onProgress] is an optional callback that's called after each operation.
  /// 
  /// Returns a list of document references that were modified.
  Future<List<DocumentReference<DocumentData>>> batchWrite({
    required List<WriteOperation> operations,
    BatchOptions options = const BatchOptions(),
    void Function(int completed, int total)? onProgress,
  }) async {
    final batch = _firestore.batch();
    final docRefs = <DocumentReference<DocumentData>>[];
    
    for (var i = 0; i < operations.length; i++) {
      final op = operations[i];
      final docRef = _firestore.doc(op.path);
      docRefs.add(docRef);
      
      switch (op.type) {
        case WriteOperationType.create:
          batch.set(docRef, op.data!);
          break;
        case WriteOperationType.update:
          batch.update(docRef, op.data!);
          break;
        case WriteOperationType.delete:
          batch.delete(docRef);
          break;
      }
      
      onProgress?.call(i + 1, operations.length);
      
      // If we've reached the maximum batch size, commit the current batch
      if (options.maxBatchSize != null && (i + 1) % options.maxBatchSize! == 0) {
        await batch.commit();
      }
    }
    
    if (options.isAtomic || options.maxBatchSize == null) {
      await batch.commit();
    }
    
    return docRefs;
  }
  
  /// Applies a where condition to a query
  Query<Map<String, dynamic>> _applyWhereCondition<T>(
    Query<Map<String, dynamic>> query,
    WhereCondition<T> condition,
  ) {
    switch (condition.operator) {
      case WhereOperator.lessThan:
        return query.where(condition.field, isLessThan: condition.value);
      case WhereOperator.lessThanOrEqualTo:
        return query.where(condition.field, isLessThanOrEqualTo: condition.value);
      case WhereOperator.isEqualTo:
        return query.where(condition.field, isEqualTo: condition.value);
      case WhereOperator.isNotEqualTo:
        return query.where(condition.field, isNotEqualTo: condition.value);
      case WhereOperator.isGreaterThan:
        return query.where(condition.field, isGreaterThan: condition.value);
      case WhereOperator.isGreaterThanOrEqualTo:
        return query.where(condition.field, isGreaterThanOrEqualTo: condition.value);
      case WhereOperator.arrayContains:
        return query.where(condition.field, arrayContains: condition.value);
      case WhereOperator.arrayContainsAny:
        return query.where(condition.field, arrayContainsAny: condition.value as List<T>);
      case WhereOperator.inList:
        return query.where(condition.field, whereIn: condition.value as List<T>);
      case WhereOperator.notInList:
        return query.where(condition.field, whereNotIn: condition.value as List<T>);
      case WhereOperator.isNull:
        return query.where(condition.field, isNull: true);
      case WhereOperator.isNotNull:
        return query.where(condition.field, isNull: false);
    }
  }

  // ====================
  // Transactions
  // ====================


  /// Runs a transaction with the specified handler
  /// 
  /// [handler] is a function that performs the transaction operations.
  /// [maxAttempts] maximum number of attempts for the transaction.
  /// [timeout] optional timeout for the transaction.
  /// 
  /// Returns the result of the transaction handler.
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) handler, {
    int maxAttempts = 5,
    Duration? timeout,
  }) async {
    var attempts = 0;
    final startTime = DateTime.now();
    
    while (true) {
      try {
        if (timeout != null) {
          return await _firestore.runTransaction<T>(
            (transaction) => handler(transaction),
            timeout: timeout,
          );
        } else {
          return await _firestore.runTransaction<T>(
            (transaction) => handler(transaction),
          );
        }
      } catch (e) {
        attempts++;
        
        // Check if we should retry
        if (attempts >= maxAttempts || (timeout != null && DateTime.now().difference(startTime) >= timeout)) {
          rethrow;
        }
        
        // Exponential backoff before retry
        await Future.delayed(Duration(milliseconds: 100 * (1 << attempts)));
      }
    }
  }
  
  /// Executes a paginated query
  /// 
  /// [collection] is the name of the collection to query.
  /// [options] can be used to specify filters and ordering.
  /// [pageSize] is the maximum number of documents to return per page.
  /// [nextPageToken] is an optional token for pagination.
  /// 
  /// Returns a [PaginatedResult] with the query results and pagination info.
  Future<PaginatedResult<DocumentData>> queryPaginated({
    required CollectionPath collection,
    QueryOptions options = const QueryOptions(),
    required int pageSize,
    DocumentSnapshot? nextPageToken,
  }) async {
    var query = _buildQuery(collection, options);
    query = query.limit(pageSize);
    if (nextPageToken != null) {
      query = query.startAfterDocument(nextPageToken);
    }

    final snapshot = await query.get();
    final hasMore = snapshot.docs.length == pageSize;
    final lastDoc = hasMore ? snapshot.docs.last : null;
    
    return PaginatedResult<DocumentData>(
      items: snapshot.docs.map((doc) => doc.data()).toList(),
      lastDocument: lastDoc,
      hasMore: hasMore,
    );
  }
}