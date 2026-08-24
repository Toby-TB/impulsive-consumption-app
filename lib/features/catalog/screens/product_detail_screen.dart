import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/juice/combo_controller.dart';
import '../../../core/providers/preferences_provider.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/common.dart';
import '../../../data/database/database.dart';
import '../catalog_providers.dart';

/// 商品详情页。
class ProductDetailScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = currentLang(context);
    final async = ref.watch(productByIdProvider(productId));
    final product = async.value;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final theme = Theme.of(context);
    final wishlisted =
        ref.watch(wishlistIdsProvider).value?.contains(productId) ?? false;

    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: Icon(
            wishlisted ? Icons.favorite : Icons.favorite_border,
            color: wishlisted ? const Color(0xFFFF2E63) : null,
          ),
          onPressed: () async {
            final added = await ref
                .read(wishlistRepositoryProvider)
                .toggle(productId);
            // 收藏类成就（如种草达人）
            final unlocked = await ref
                .read(gamificationServiceProvider)
                .evaluateActivity();
            if (!context.mounted) return;
            final extra = unlocked.isEmpty
                ? ''
                : ' · ${unlocked.map((a) => achievementL10n(context, a.key)).join(' · ')}';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '${added ? context.l10n.wishlistTitle : context.l10n.itemRemoved}$extra'),
                duration: const Duration(milliseconds: 1000),
              ),
            );
          },
        ),
      ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-${product.id}',
              child: AspectRatio(
                aspectRatio: 1.15,
                child: Image.asset(product.image, fit: BoxFit.cover),
              ),
            ),

            // 价格区
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  MoneyText(product.priceCents,
                      style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 8),
                  if (product.originalPriceCents > product.priceCents) ...[
                    Text(
                      formatMoney(
                        product.originalPriceCents,
                        cur: ref.watch(regionProvider),
                        locale: Localizations.localeOf(context).toString(),
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.hintColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _DiscountChip(product: product),
                  ],
                ],
              ),
            ),

            // 名称与卖点
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Text(
                product.name.of(lang),
                style: const TextStyle(
                    fontSize: 17, height: 1.35, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
              child: Text(
                product.subtitle.of(lang),
                style: TextStyle(fontSize: 13, color: theme.hintColor),
              ),
            ),

            // 标签
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final t in product.tags.values)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(t,
                          style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.primary)),
                    ),
                ],
              ),
            ),

            // 销量/评分/库存
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 12, color: theme.hintColor),
                child: Row(
                  children: [
                    Text(l.soldCount(product.sales)),
                    const Spacer(),
                    Icon(Icons.star,
                        size: 13, color: Colors.amber.shade700),
                    Text(' ${product.rating}'),
                    const Spacer(),
                    Text(l.stockLeft(product.stock)),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: theme.dividerColor),

            // 描述
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.productDescription,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    product.description.of(lang),
                    style: const TextStyle(fontSize: 14, height: 1.7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // 底部操作栏
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: theme.cardColor),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Builder(builder: (btnCtx) => FilledButton.tonal(
                  onPressed: () => _addToCart(context, ref, product,
                      anchor: _centerOf(btnCtx)),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                  ),
                  child: Text(l.addToCart),
                )),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Builder(builder: (btnCtx) => FilledButton(
                  onPressed: () async {
                    await _addToCart(context, ref, product,
                        anchor: _centerOf(btnCtx));
                    if (context.mounted) context.push('/checkout');
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                  ),
                  child: Text(l.buyNow),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Offset? _centerOf(BuildContext btnContext) {
    final box = btnContext.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(box.size.center(Offset.zero));
  }

  Future<void> _addToCart(
    BuildContext context,
    WidgetRef ref,
    Product product, {
    Offset? anchor,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final combo = ref.read(comboProvider.notifier);
    combo.attachContext(context);
    await ref.read(cartRepositoryProvider).add(product.id);
    combo.registerAdd(anchor: anchor);
    // 活动类成就（如购物车满员）
    final unlocked =
        await ref.read(gamificationServiceProvider).evaluateActivity();
    if (!context.mounted) return;
    final l = context.l10n;
    final message = unlocked.isEmpty
        ? l.addedToCart
        : '${l.achievementUnlocked} ${unlocked.map((a) => achievementL10n(context, a.key)).join(' · ')}';
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }
}

class _DiscountChip extends StatelessWidget {
  final Product product;
  const _DiscountChip({required this.product});

  @override
  Widget build(BuildContext context) {
    final percent =
        ((product.priceCents / product.originalPriceCents) * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9E5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$percent%',
        style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFE02020)),
      ),
    );
  }
}
