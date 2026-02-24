// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(applicantRepository)
final applicantRepositoryProvider = ApplicantRepositoryProvider._();

final class ApplicantRepositoryProvider
    extends
        $FunctionalProvider<
          ApplicantRepository,
          ApplicantRepository,
          ApplicantRepository
        >
    with $Provider<ApplicantRepository> {
  ApplicantRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applicantRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applicantRepositoryHash();

  @$internal
  @override
  $ProviderElement<ApplicantRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApplicantRepository create(Ref ref) {
    return applicantRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApplicantRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApplicantRepository>(value),
    );
  }
}

String _$applicantRepositoryHash() =>
    r'67d1ad4d1346baf048ad394713d1682db7a9359d';
