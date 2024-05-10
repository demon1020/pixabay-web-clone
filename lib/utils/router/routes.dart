import 'package:flutter/material.dart';
import 'package:gallery/feature/home/view/detail_view.dart';
import 'package:gallery/feature/home/view/home_view.dart';
import 'package:gallery/utils/router/route_names.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/error_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    errorBuilder: (context, state) =>
        ErrorView(errorMessage: state.error!.message),
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        pageBuilder: (context, state) => MaterialPage(child: HomeView()),
        routes: [
          GoRoute(
            // name: AppRoute.detailView,
            path: "${AppRoute.detail}/:id",
            pageBuilder: (BuildContext context, GoRouterState state) =>
                // DetailView(id: state.pathParameters["id"]!),
                MaterialPage(
              child: DetailView(
                id: state.pathParameters["id"]!,
                url: state.extra as String,
              ),
            ),
          ),
        ],
      )
    ],
  );
}
