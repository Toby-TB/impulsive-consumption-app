import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/cart_screen.dart';
import '../../features/catalog/screens/category_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/catalog/screens/product_detail_screen.dart';
import '../../features/catalog/screens/search_screen.dart';
import '../../features/checkout/checkout_screen.dart';
import '../../features/orders/order_detail_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/profile/achievements_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../features/wishlist/wishlist_screen.dart';
import '../../features/catalog/catalog_providers.dart';
import '../../l10n/app_localizations.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// 供 MaterialApp.router 使用。
final routerProvider = Provider<GoRouter>((ref) => buildRouter());

GoRouter buildRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            _ShellScaffold(shell: shell, state: state),
        branches: [
          _branch('/home', const HomeScreen()),
          _branch('/category', const CategoryScreen()),
          _branch('/cart', const CartScreen()),
          _branch('/orders', const OrdersScreen()),
          _branch('/profile', const ProfileScreen()),
        ],
      ),
      GoRoute(
        path: '/product/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => ProductDetailScreen(
          productId: int.tryParse(state.pathParameters['id'] ?? '') ?? 1,
        ),
      ),
      GoRoute(
        path: '/search',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => SearchScreen(
          initialQuery: state.uri.queryParameters['q'] ?? '',
        ),
      ),
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/order/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => OrderDetailScreen(
          orderId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: '/wallet',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/achievements',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AchievementsScreen(),
      ),
    ],
  );
}

StatefulShellBranch _branch(String path, Widget child) =>
    StatefulShellBranch(routes: [
      GoRoute(path: path, builder: (context, state) => child),
    ]);

class _CartBadge extends StatelessWidget {
  final int count;
  final bool selected;

  const _CartBadge({required this.count, required this.selected});

  @override
  Widget build(BuildContext context) {
    final icon = selected
        ? const Icon(Icons.shopping_cart)
        : const Icon(Icons.shopping_cart_outlined);
    if (count == 0) return icon;
    return Badge(
      label: Text('$count'),
      isLabelVisible: true,
      child: icon,
    );
  }
}

class _ShellScaffold extends ConsumerWidget {
  final StatefulNavigationShell shell;
  final GoRouterState state;

  const _ShellScaffold({required this.shell, required this.state});

  static const _tabLocations = {
    '/home', '/category', '/cart', '/orders', '/profile',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = state.uri.toString();
    final isTab = _tabLocations.any((l) => location.startsWith(l));
    if (!isTab) return shell;

    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(
          i,
          initialLocation: i == shell.currentIndex,
        ),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.storefront_outlined), selectedIcon: const Icon(Icons.storefront), label: l.navHome),
          NavigationDestination(icon: const Icon(Icons.grid_view_outlined), selectedIcon: const Icon(Icons.grid_view), label: l.navCategory),
          NavigationDestination(
            icon: _CartBadge(count: ref.watch(cartCountProvider).value ?? 0, selected: false),
            selectedIcon: _CartBadge(count: ref.watch(cartCountProvider).value ?? 0, selected: true),
            label: l.navCart,
          ),
          NavigationDestination(icon: const Icon(Icons.receipt_long_outlined), selectedIcon: const Icon(Icons.receipt_long), label: l.navOrders),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: l.navProfile),
        ],
      ),
    );
  }
}
