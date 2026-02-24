// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interviewer_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myInterviews)
final myInterviewsProvider = MyInterviewsProvider._();

final class MyInterviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InterviewModel>>,
          List<InterviewModel>,
          FutureOr<List<InterviewModel>>
        >
    with
        $FutureModifier<List<InterviewModel>>,
        $FutureProvider<List<InterviewModel>> {
  MyInterviewsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myInterviewsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myInterviewsHash();

  @$internal
  @override
  $FutureProviderElement<List<InterviewModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InterviewModel>> create(Ref ref) {
    return myInterviews(ref);
  }
}

String _$myInterviewsHash() => r'8d94d0487c7b16cbe6f4fd8a8b29570511a6bce5';

@ProviderFor(interviewApplication)
final interviewApplicationProvider = InterviewApplicationFamily._();

final class InterviewApplicationProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApplicationModel>,
          ApplicationModel,
          FutureOr<ApplicationModel>
        >
    with $FutureModifier<ApplicationModel>, $FutureProvider<ApplicationModel> {
  InterviewApplicationProvider._({
    required InterviewApplicationFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'interviewApplicationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$interviewApplicationHash();

  @override
  String toString() {
    return r'interviewApplicationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ApplicationModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApplicationModel> create(Ref ref) {
    final argument = this.argument as String;
    return interviewApplication(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InterviewApplicationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$interviewApplicationHash() =>
    r'e276dcb6903b8b236515e45ec8ad8093971d7e01';

final class InterviewApplicationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ApplicationModel>, String> {
  InterviewApplicationFamily._()
    : super(
        retry: null,
        name: r'interviewApplicationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InterviewApplicationProvider call(String applicationId) =>
      InterviewApplicationProvider._(argument: applicationId, from: this);

  @override
  String toString() => r'interviewApplicationProvider';
}

@ProviderFor(interviewFeedbackStatus)
final interviewFeedbackStatusProvider = InterviewFeedbackStatusFamily._();

final class InterviewFeedbackStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  InterviewFeedbackStatusProvider._({
    required InterviewFeedbackStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'interviewFeedbackStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$interviewFeedbackStatusHash();

  @override
  String toString() {
    return r'interviewFeedbackStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return interviewFeedbackStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is InterviewFeedbackStatusProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$interviewFeedbackStatusHash() =>
    r'4170a245b6244a8b661738b1e3ed60a4dc66ba22';

final class InterviewFeedbackStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  InterviewFeedbackStatusFamily._()
    : super(
        retry: null,
        name: r'interviewFeedbackStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InterviewFeedbackStatusProvider call(String interviewId) =>
      InterviewFeedbackStatusProvider._(argument: interviewId, from: this);

  @override
  String toString() => r'interviewFeedbackStatusProvider';
}

@ProviderFor(InterviewFeedbackController)
final interviewFeedbackControllerProvider =
    InterviewFeedbackControllerProvider._();

final class InterviewFeedbackControllerProvider
    extends $AsyncNotifierProvider<InterviewFeedbackController, void> {
  InterviewFeedbackControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interviewFeedbackControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interviewFeedbackControllerHash();

  @$internal
  @override
  InterviewFeedbackController create() => InterviewFeedbackController();
}

String _$interviewFeedbackControllerHash() =>
    r'03fe1066b1dbb306d5af08a6b47790de709b80ec';

abstract class _$InterviewFeedbackController extends $AsyncNotifier<void> {
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
