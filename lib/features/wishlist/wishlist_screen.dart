import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common.dart';
import '../../../data/database/database.dart';
import '../catalog/catalog_providers.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ids = ref.watch(wishlistIdsProvider).value ?? const <int>{};
    final allProducts = ref.watch(guessYouLikeProvider).value ?? const [];
    final items = allProducts.where((p) => ids.contains(p.id)).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l.wishlistTitle)),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 72, color: Theme.of(context).hintColor),
                  const SizedBox(height: 12),
                  Text(l.wishlistEmpty,
                      style: TextStyle(color: Theme.of(context).hintColor)),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => context.go('/home'),
                    child: Text(l.goShopping),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.58,
              ),
              itemCount: items.length,
              itemBuilder: (context, i) =>
                  _WishlistCard(product: items[i]),
            ),
    );
  }
}

class _WishlistCard extends ConsumerWidget {
  final Product product;

  const _WishlistCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = currentLang(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push('/product/${product.id}'),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: Image.asset(product.image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Text(
              product.name.of(lang),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
            child: MoneyText(product.priceCents,
                style: const TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await ref
                          .read(wishlistRepositoryProvider)
                          .toggle(product.id);
                      final unlocked = await ref
                          .read(gamificationServiceProvider)
                          .evaluateActivity();
                      if (unlocked.isNotEmpty && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${context.l10n.achievementUnlocked} ${unlocked.map((a) => achievementL10n(context, a.key)).join(' · ')}',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(32),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.favorite_border, size: 16),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () async {
                      await ref.read(cartRepositoryProvider).add(product.id);
                      await ref
                          .read(gamificationServiceProvider)
                          .evaluateActivity();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(l.addedToCart),
                              duration:
                                  const Duration(milliseconds: 800)),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(32),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.add_shopping_cart, size: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
