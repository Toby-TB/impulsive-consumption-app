import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/common.dart';
import '../../../data/repositories/product_repository.dart';
import '../catalog_providers.dart';
import '../widgets/product_card.dart';

/// 搜索页：300ms 防抖 + 排序 chips + 结果网格。
class SearchScreen extends ConsumerStatefulWidget {
  final String initialQuery;

  const SearchScreen({super.key, this.initialQuery = ''});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchControllerProvider.notifier).setQuery(v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(searchControllerProvider);
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: TextField(
          controller: _controller,
          autofocus: widget.initialQuery.isEmpty,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: l.searchHint,
            prefixIcon: const Icon(Icons.search, size: 20),
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: Row(
              children: [
                _SortChip(
                  label: l.sortBest,
                  selected: state.sort == ProductSortMode.best,
                  onTap: () => ref
                      .read(searchControllerProvider.notifier)
                      .setSort(ProductSortMode.best),
                ),
                _SortChip(
                  label: l.sortSales,
                  selected: state.sort == ProductSortMode.sales,
                  onTap: () => ref
                      .read(searchControllerProvider.notifier)
                      .setSort(ProductSortMode.sales),
                ),
                _SortChip(
                  label: l.sortPriceAsc,
                  selected: state.sort == ProductSortMode.priceAsc,
                  onTap: () => ref
                      .read(searchControllerProvider.notifier)
                      .setSort(ProductSortMode.priceAsc),
                ),
                _SortChip(
                  label: l.sortPriceDesc,
                  selected: state.sort == ProductSortMode.priceDesc,
                  onTap: () => ref
                      .read(searchControllerProvider.notifier)
                      .setSort(ProductSortMode.priceDesc),
                ),
              ],
            ),
          ),
          Expanded(
            child: results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (products) {
                if (products.isEmpty) {
                  return _EmptyResult(hasQuery: state.query.isNotEmpty);
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 16),
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 260,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, i) =>
                      ProductCard(product: products[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: .12)
                : Theme.of(context).colorScheme.surfaceContainerHighest
                    .withValues(alpha: .5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  final bool hasQuery;
  const _EmptyResult({required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off,
              size: 64, color: Theme.of(context).hintColor),
          const SizedBox(height: 12),
          Text(context.l10n.emptyResult,
              style: TextStyle(color: Theme.of(context).hintColor)),
        ],
      ),
    );
  }
}
