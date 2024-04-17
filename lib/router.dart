import 'package:go_router/go_router.dart';
import 'package:klavi_link_demo_flutter/pages/home.dart';
import 'package:klavi_link_demo_flutter/pages/redirect.dart';
import 'package:klavi_link_demo_flutter/pages/web.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) {
          return const HomePage();
        },
        routes: [
          GoRoute(
            path: 'web',
            builder: (context, state) {
              return const WebPage();
            },
          ),
          GoRoute(
            path: 'redirect',
            builder: (context, state) {
              return const RedirectPage();
            },
          )
        ]),
  ],
);
