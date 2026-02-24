// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hr_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(allJobs)
final allJobsProvider = AllJobsProvider._();

final class AllJobsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JobListingModel>>,
          List<JobListingModel>,
          FutureOr<List<JobListingModel>>
        >
    with
        $FutureModifier<List<JobListingModel>>,
        $FutureProvider<List<JobListingModel>> {
  AllJobsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allJobsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allJobsHash();

  @$internal
  @override
  $FutureProviderElement<List<JobListingModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<JobListingModel>> create(Ref ref) {
    return allJobs(ref);
  }
}

String _$allJobsHash() => r'7ebba130e4c024ac7eafdaf69a152a2168071599';

@ProviderFor(jobApplications)
final jobApplicationsProvider = JobApplicationsFamily._();

final class JobApplicationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApplicationModel>>,
          List<ApplicationModel>,
          FutureOr<List<ApplicationModel>>
        >
    with
        $FutureModifier<List<ApplicationModel>>,
        $FutureProvider<List<ApplicationModel>> {
  JobApplicationsProvider._({
    required JobApplicationsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'jobApplicationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jobApplicationsHash();

  @override
  String toString() {
    return r'jobApplicationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ApplicationModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ApplicationModel>> create(Ref ref) {
    final argument = this.argument as String;
    return jobApplications(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is JobApplicationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jobApplicationsHash() => r'500369975d6c6cde898e161f2cb9e0d2a75d95cd';

final class JobApplicationsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ApplicationModel>>, String> {
  JobApplicationsFamily._()
    : super(
        retry: null,
        name: r'jobApplicationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  JobApplicationsProvider call(String jobId) =>
      JobApplicationsProvider._(argument: jobId, from: this);

  @override
  String toString() => r'jobApplicationsProvider';
}

@ProviderFor(availableInterviewers)
final availableInterviewersProvider = AvailableInterviewersProvider._();

final class AvailableInterviewersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserModel>>,
          List<UserModel>,
          FutureOr<List<UserModel>>
        >
    with $FutureModifier<List<UserModel>>, $FutureProvider<List<UserModel>> {
  AvailableInterviewersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableInterviewersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableInterviewersHash();

  @$internal
  @override
  $FutureProviderElement<List<UserModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserModel>> create(Ref ref) {
    return availableInterviewers(ref);
  }
}

String _$availableInterviewersHash() =>
    r'0a3a2ea603e4c36995472dbefad60801bd03ce43';

@ProviderFor(JobCreationController)
final jobCreationControllerProvider = JobCreationControllerProvider._();

final class JobCreationControllerProvider
    extends $AsyncNotifierProvider<JobCreationController, void> {
  JobCreationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobCreationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobCreationControllerHash();

  @$internal
  @override
  JobCreationController create() => JobCreationController();
}

String _$jobCreationControllerHash() =>
    r'5ba48bab31021a2ec0a71ea995dec4e606815e54';

abstract class _$JobCreationController extends $AsyncNotifier<void> {
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

@ProviderFor(JobUpdateController)
final jobUpdateControllerProvider = JobUpdateControllerProvider._();

final class JobUpdateControllerProvider
    extends $AsyncNotifierProvider<JobUpdateController, void> {
  JobUpdateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobUpdateControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobUpdateControllerHash();

  @$internal
  @override
  JobUpdateController create() => JobUpdateController();
}

String _$jobUpdateControllerHash() =>
    r'137a4c2869e081833e8f6d3d297a8827486f1b0a';

abstract class _$JobUpdateController extends $AsyncNotifier<void> {
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

@ProviderFor(ApplicationUpdateController)
final applicationUpdateControllerProvider =
    ApplicationUpdateControllerProvider._();

final class ApplicationUpdateControllerProvider
    extends $AsyncNotifierProvider<ApplicationUpdateController, void> {
  ApplicationUpdateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applicationUpdateControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applicationUpdateControllerHash();

  @$internal
  @override
  ApplicationUpdateController create() => ApplicationUpdateController();
}

String _$applicationUpdateControllerHash() =>
    r'44939d85aab86341d916f1531e235043493fa0c7';

abstract class _$ApplicationUpdateController extends $AsyncNotifier<void> {
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
