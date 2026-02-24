import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/data/auth_controller.dart';
import '../../features/applicant/applicant_dashboard.dart';
import '../../features/hr/hr_dashboard.dart';
import '../../features/hr/hr_job_detail_screen.dart';
import '../../features/interviewer/interviewer_dashboard.dart';
import '../../features/interviewer/evaluation_screen.dart';
import '../../../models/interview_model.dart';

part 'app_router.g.dart';

// Key for navigation
final rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  // We can just listen to the auth state
  final listenable = _AuthStateRefreshStream(ref);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: listenable,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isAuthLoading = authState.isLoading;
      final user = authState.value;
      
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToSignup = state.matchedLocation == '/signup';

      if (isAuthLoading) return null; // Don't redirect while loading

      if (user == null) {
        // If not logged in and not going to auth pages, send to login
        if (!isGoingToLogin && !isGoingToSignup) {
          return '/login';
        }
        return null;
      }

      // If logged in but trying to go to auth pages, send to dashboard
      if (isGoingToLogin || isGoingToSignup || state.matchedLocation == '/') {
        switch (user.role) {
          case 'applicant':
            return '/applicant';
          case 'hr':
            return '/hr';
          case 'interviewer':
            return '/interviewer';
          default:
            return '/login'; // Invalid role fallback
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      // Dashboards
      GoRoute(
        path: '/applicant',
        builder: (context, state) => const ApplicantDashboard(),
      ),
      GoRoute(
        path: '/hr',
        builder: (context, state) => const HrDashboard(),
        routes: [
          GoRoute(
            path: 'job/:id',
            builder: (context, state) {
              final jobId = state.pathParameters['id']!;
              return HrJobDetailScreen(jobId: jobId);
            },
          ),
        ]
      ),
      GoRoute(
        path: '/interviewer',
        builder: (context, state) => const InterviewerDashboard(),
        routes: [
           GoRoute(
             path: 'eval/:id',
             builder: (context, state) {
               final interviewId = state.pathParameters['id']!;
               final interview = state.extra as InterviewModel;
               return EvaluationScreen(interviewId: interviewId, interview: interview);
             }
           )
        ]
      ),
    ],
  );
}

// Helper class to convert AuthController states into a Listenable for GoRouter
class _AuthStateRefreshStream extends ChangeNotifier {
  _AuthStateRefreshStream(Ref ref) {
    ref.listen(authControllerProvider, (_, __) {
      notifyListeners();
    });
  }
}
