// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interviewer_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(interviewerRepository)
final interviewerRepositoryProvider = InterviewerRepositoryProvider._();

final class InterviewerRepositoryProvider
    extends
        $FunctionalProvider<
          InterviewerRepository,
          InterviewerRepository,
          InterviewerRepository
        >
    with $Provider<InterviewerRepository> {
  InterviewerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interviewerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interviewerRepositoryHash();

  @$internal
  @override
  $ProviderElement<InterviewerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InterviewerRepository create(Ref ref) {
    return interviewerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterviewerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterviewerRepository>(value),
    );
  }
}

String _$interviewerRepositoryHash() =>
    r'b50ec924aba615a13649d0758fc69ec5a81118f7';
