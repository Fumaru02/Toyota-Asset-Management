import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../pages/dashboard/dashboard_pages.dart';
import '../pages/login/login_pages.dart';

final GoRouter router = GoRouter(
  navigatorKey: Get.key, //Important, add this code
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPages();
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'dashboard',
          path: 'dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardPages();
          },
        ),
      ],
    )
  ],
);
