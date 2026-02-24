// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(openJobs)
final openJobsProvider = OpenJobsProvider._();

final class OpenJobsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JobListingModel>>,
          List<JobListingModel>,
          FutureOr<List<JobListingModel>>
        >
    with
        $FutureModifier<List<JobListingModel>>,
        $FutureProvider<List<JobListingModel>> {
  OpenJobsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openJobsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openJobsHash();

  @$internal
  @override
  $FutureProviderElement<List<JobListingModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<JobListingModel>> create(Ref ref) {
    return openJobs(ref);
  }
}

String _$openJobsHash() => r'1fe7a5828211b0d1b72b66e4da8f045c23cf8194';

@ProviderFor(myApplications)
final myApplicationsProvider = MyApplicationsProvider._();

final class MyApplicationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApplicationModel>>,
          List<ApplicationModel>,
          FutureOr<List<ApplicationModel>>
        >
    with
        $FutureModifier<List<ApplicationModel>>,
        $FutureProvider<List<ApplicationModel>> {
  MyApplicationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myApplicationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myApplicationsHash();

  @$internal
  @override
  $FutureProviderElement<List<ApplicationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ApplicationModel>> create(Ref ref) {
    return myApplications(ref);
  }
}

String _$myApplicationsHash() => r'2206972bb5317b41aebaa6446ecb92f1f2614861';

@ProviderFor(ApplicationSubmitController)
final applicationSubmitControllerProvider =
    ApplicationSubmitControllerProvider._();

final class ApplicationSubmitControllerProvider
    extends $AsyncNotifierProvider<ApplicationSubmitController, void> {
  ApplicationSubmitControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applicationSubmitControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applicationSubmitControllerHash();

  @$internal
  @override
  ApplicationSubmitController create() => ApplicationSubmitController();
}

String _$applicationSubmitControllerHash() =>
    r'1ced0d3e7d959339e202662f3495ac0eded978e8';

abstract class _$ApplicationSubmitController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
