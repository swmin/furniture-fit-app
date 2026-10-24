import 'package:go_router/go_router.dart';

import 'ui/features/editor/editor_screen.dart';
import 'ui/features/home/home_screen.dart';
import 'ui/features/library/library_screen.dart';
import 'ui/features/settings/settings_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'homes/:homeId',
          builder: (context, state) =>
              EditorScreen(homeId: state.pathParameters['homeId']!),
        ),
        GoRoute(
          path: 'library',
          builder: (context, state) => const LibraryScreen(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
