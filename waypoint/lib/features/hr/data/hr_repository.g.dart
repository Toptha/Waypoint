// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hr_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hrRepository)
final hrRepositoryProvider = HrRepositoryProvider._();

final class HrRepositoryProvider
    extends $FunctionalProvider<HrRepository, HrRepository, HrRepository>
    with $Provider<HrRepository> {
  HrRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hrRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hrRepositoryHash();

  @$internal
  @override
  $ProviderElement<HrRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HrRepository create(Ref ref) {
    return hrRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HrRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HrRepository>(value),
    );
  }
}

String _$hrRepositoryHash() => r'b02b181e21a1445a9d9530cdcf6c7fb06816b5b1';
