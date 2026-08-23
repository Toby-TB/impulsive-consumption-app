import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/cart_repository.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final items = ref.watch(_cartItemsProvider).value ?? const [];

    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l.navCart)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove_shopping_cart,
                  size: 72, color: Theme.of(context).hintColor),
              const SizedBox(height: 12),
              Text(l.cartEmptyTitle,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(l.cartEmptySubtitle,
                  style: TextStyle(
                      fontSize: 13, color: Theme.of(context).hintColor)),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.go('/home'),
                child: Text(l.goShopping),
              ),
            ],
          ),
        ),
      );
    }

    final allSelected = items.every((e) => e.item.selected);
    final selectedCount =
        items.where((e) => e.item.selected).length;
    final selectedTotal = items
        .where((e) => e.item.selected)
        .fold<int>(0, (sum, e) => sum + e.lineTotalCents);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navCart),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: l.clearCart,
            onPressed: () => _confirmClear(context, ref),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) => _CartItemTile(entry: items[i]),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () =>
                    ref.read(cartRepositoryProvider).selectAll(!allSelected),
                child: Row(
                  children: [
                    Icon(
                      allSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 20,
                      color: allSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).hintColor,
                    ),
                    const SizedBox(width: 4),
                    Text(l.selectAll, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('${l.total}: ',
                          style: const TextStyle(fontSize: 12)),
                      MoneyText(selectedTotal,
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: selectedCount == 0
                    ? null
                    : () => context.push('/checkout'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(120, 44),
                ),
                child: Text(l.checkoutWithCount(selectedCount)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.clearCart),
        content: Text(l.clearCartConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(cartRepositoryProvider).clear();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l.cleared),
              duration: const Duration(milliseconds: 800)),
        );
      }
    }
  }
}

final _cartItemsProvider = StreamProvider(
  (ref) => ref.watch(cartRepositoryProvider).watchDetailed(),
);

class _CartItemTile extends ConsumerWidget {
  final CartItemWithProduct entry;

  const _CartItemTile({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = currentLang(context);
    final theme = Theme.of(context);
    final item = entry.item;
    final product = entry.product;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: const Color(0xFFE53935),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        await ref.read(cartRepositoryProvider).removeItem(item.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(l.itemRemoved),
                duration: const Duration(milliseconds: 800)),
          );
        }
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => ref
                    .read(cartRepositoryProvider)
                    .toggleSelect(item.id, !item.selected),
                child: Icon(
                  item.selected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: item.selected
                      ? theme.colorScheme.primary
                      : theme.hintColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => context.push('/product/${product.id}'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(product.image,
                      width: 72, height: 72, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name.of(lang),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    MoneyText(product.priceCents,
                        style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _QtyStepper(item: item, stock: product.stock),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyStepper extends ConsumerWidget {
  final CartItem item;
  final int stock;

  const _QtyStepper({required this.item, required this.stock});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            onTap: item.quantity <= 1
                ? null
                : () => ref
                    .read(cartRepositoryProvider)
                    .setQuantity(item.id, item.quantity - 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('${item.quantity}',
                style: const TextStyle(fontSize: 13)),
          ),
          _StepButton(
            icon: Icons.add,
            onTap: item.quantity >= stock
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.maxPerItem(stock)),
                        duration: const Duration(milliseconds: 800),
                      ),
                    );
                  }
                : () => ref
                    .read(cartRepositoryProvider)
                    .setQuantity(item.id, item.quantity + 1),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: Theme.of(context).hintColor),
      ),
    );
  }
}
