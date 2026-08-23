import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/preferences_provider.dart';
import '../../../core/utils/localized_text.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/common.dart';
import '../../../data/database/database.dart';
import '../../../l10n/app_localizations.dart';

/// 商品瀑布流卡片。
class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = AppLanguageX.fromLocale(Localizations.localeOf(context));
    final theme = Theme.of(context);
    final region = ref.watch(regionProvider);
    final locale = Localizations.localeOf(context).toString();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: InkWell(
        onTap: () => context.push('/product/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Text(
                product.name.of(lang),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                product.subtitle.of(lang),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: theme.hintColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MoneyText(
                    product.priceCents,
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(width: 6),
                  if (product.originalPriceCents > product.priceCents)
                    Text(
                      formatMoney(product.originalPriceCents,
                          cur: region, locale: locale),
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.hintColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context)!.soldCount(product.sales),
                    style: TextStyle(fontSize: 10, color: theme.hintColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
