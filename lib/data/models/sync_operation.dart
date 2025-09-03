import 'package:hive/hive.dart';

part 'sync_operation.g.dart';

@HiveType(typeId: 4)
class SyncOperation {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String type; // 'create', 'update', 'delete'
  
  @HiveField(2)
  final String collection; // 'notes', 'hashtags', 'users'
  
  @HiveField(3)
  final Map<String, dynamic> data;
  
  @HiveField(4)
  final DateTime timestamp;
  
  @HiveField(5)
  final bool synced;
  
  @HiveField(6)
  final String? documentId;
  
  @HiveField(7)
  final int retryCount;
  
  @HiveField(8)
  final bool failed;
  
  @HiveField(9)
  final String? error;

  SyncOperation({
    required this.id,
    required this.type,
    required this.collection,
    required this.data,
    required this.timestamp,
    this.synced = false,
    this.documentId,
    this.retryCount = 0,
    this.failed = false,
    this.error,
  });

  SyncOperation copyWith({
    String? id,
    String? type,
    String? collection,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    bool? synced,
    String? documentId,
    int? retryCount,
    bool? failed,
    String? error,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      type: type ?? this.type,
      collection: collection ?? this.collection,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      synced: synced ?? this.synced,
      documentId: documentId ?? this.documentId,
      retryCount: retryCount ?? this.retryCount,
      failed: failed ?? this.failed,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'collection': collection,
      'data': data,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'synced': synced,
      'documentId': documentId,
      'retryCount': retryCount,
      'failed': failed,
      'error': error,
    };
  }

  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      id: json['id'],
      type: json['type'],
      collection: json['collection'],
      data: Map<String, dynamic>.from(json['data']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      synced: json['synced'] ?? false,
      documentId: json['documentId'],
      retryCount: json['retryCount'] ?? 0,
      failed: json['failed'] ?? false,
      error: json['error'],
    );
  }
}
