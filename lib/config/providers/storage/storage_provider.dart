import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_tastyhub/data/datasources/remote/firebase_storage_datasource.dart';
import 'package:flutter_tastyhub/data/repositories/repository_storage_impl.dart';
import 'package:flutter_tastyhub/domain/repositories/storage_repository.dart';

// ========== DATASOURCE ==========
final firebaseStorageDataSourceProvider = Provider<FirebaseStorageDataSource>((
  ref,
) {
  return FirebaseStorageDataSourceImpl();
});

// ========== REPOSITORY ==========
final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final ds = ref.watch(firebaseStorageDataSourceProvider);
  return StorageRepositoryImpl(dataSource: ds);
});
