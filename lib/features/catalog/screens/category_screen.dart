import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_riverpod/legacy.dart';

import '../../../core/utils/localized_text.dart';
import '../../../core/widgets/common.dart';
import '../catalog_providers.dart';
import '../widgets/product_card.dart';

/// 分类页：左侧竖排分类 + 右侧商品网格。
class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final selected = ref.watch(_selectedCategoryProvider);
    final current =
        selected ?? (categories.isEmpty ? null : categories.first.id);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navCategory)),
      body: Row(
        children: [
          SizedBox(
            width: 92,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, i) {
                  final lang =
                      AppLanguageX.fromLocale(Localizations.localeOf(context));
                  final c = categories[i];
                  final isSel = c.id == current;
                  return InkWell(
                    onTap: () =>
                        ref.read(_selectedCategoryProvider.notifier).state =
                            c.id,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSel
                            ? Theme.of(context).colorScheme.surface
                            : Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            width: 3,
                            color: isSel
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(c.emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 4),
                          Text(c.name.of(lang),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    isSel ? FontWeight.bold : FontWeight.normal,
                                color: isSel
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: current == null
                ? const SizedBox.shrink()
                : _CategoryProducts(categoryId: current),
          ),
        ],
      ),
    );
  }
}

final _selectedCategoryProvider = StateProvider<int?>((ref) => null);

class _CategoryProducts extends ConsumerWidget {
  final int categoryId;
  const _CategoryProducts({required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products =
        ref.watch(categoryProductsProvider(categoryId)).value ?? const [];

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 0.62,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) => LayoutBuilder(
        builder: (context, constraints) => ProductCard(product: products[i]),
      ),
    );
  }
}
