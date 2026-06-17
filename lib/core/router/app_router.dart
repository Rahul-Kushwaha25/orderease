import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/catalog/presentation/screens/catalog_screen.dart';
import '../../features/order/domain/entities/order_line_item_entity.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/order/presentation/screens/order_preview_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter(this._authBloc);

  final AuthBloc _authBloc;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: _GoRouterRefreshStream(_authBloc.stream),
    redirect: (context, state) {
      final authState = _authBloc.state;
      final bool loggingIn = state.matchedLocation == AppRoutes.signIn;

      if (authState is AuthUnauthenticated) {
        return AppRoutes.signIn;
      }

      if (authState is AuthAuthenticated) {
        if (loggingIn) {
          return AppRoutes.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: _CustomBottomNavBar(
              currentIndex: _getSelectedIndex(state.matchedLocation),
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go(AppRoutes.home);
                    break;
                  case 1:
                    context.go(AppRoutes.catalog);
                    break;
                  case 2:
                    context.go(AppRoutes.profile);
                    break;
                }
              },
            ),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.catalog,
            builder: (context, state) => const CatalogScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.orderPreview,
        builder: (context, state) {
          final cartItems = state.extra as List<OrderLineItemEntity>;
          return OrderPreviewScreen(items: cartItems);
        },
      ),
    ],
  );

  int _getSelectedIndex(String location) {
    if (location == AppRoutes.catalog) return 1;
    if (location == AppRoutes.profile) return 2;
    return 0;
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  const _CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9F7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
              ),
              _buildItem(
                index: 1,
                icon: Icons.inventory_2_outlined,
                activeIcon: Icons.inventory_2,
                label: 'Catalog',
              ),
              _buildItem(
                index: 2,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1E6F5C) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? Colors.white : const Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF1E6F5C) : const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
