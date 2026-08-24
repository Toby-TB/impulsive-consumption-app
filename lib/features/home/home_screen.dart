import 'dart:async';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/localized_text.dart';
import '../../../core/widgets/common.dart';
import '../../../data/database/database.dart';
import '../catalog/catalog_providers.dart';
import '../catalog/widgets/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final flash = ref.watch(flashSaleProvider).value ?? const [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: 56,
            title: _SearchBar(hint: l.searchHint),
            actions: [
              IconButton(
                tooltip: l.gachaTitle,
                icon: const Icon(Icons.card_giftcard),
                onPressed: () => context.push('/gacha'),
              ),
            ],
          ),
          SliverToBoxAdapter(child: _BannerCarousel()),
          SliverToBoxAdapter(
            child: _CategoryGrid(categories: categories),
          ),
          if (flash.isNotEmpty) ...[
            SliverToBoxAdapter(child: _FlashSaleHeader()),
            SliverToBoxAdapter(
              child: SizedBox(height: 210, child: _FlashSaleList(items: flash)),
            ),
          ],
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(l.guessYouLike,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
          ),
          const _WaterfallGrid(),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final String hint;
  const _SearchBar({required this.hint});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.search,
                size: 18, color: Theme.of(context).hintColor),
            const SizedBox(width: 6),
            Text(hint, style: TextStyle(color: Theme.of(context).hintColor)),
          ],
        ),
      ),
    );
  }
}

class _BannerCarousel extends StatefulWidget {
  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  final _controller = PageController(viewportFraction: 0.92);
  Timer? _timer;
  int _page = 0;
  int get _slideCount => 4;

  static const _gradients = [
    [Color(0xFFFF5F3C), Color(0xFFFF9A44)],
    [Color(0xFF7B4DFF), Color(0xFFB388FF)],
    [Color(0xFFFF2E63), Color(0xFFFF7A9E)],
    [Color(0xFFFFB300), Color(0xFFFF6F00)],
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;
      _page = (_page + 1) % _slideCount;
      _controller.animateToPage(_page,
          duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final slides = [
      (l.banner1Title, l.banner1Sub),
      (l.banner2Title, l.banner2Sub),
      (l.banner3Title, l.banner3Sub),
      (l.banner4Title, l.banner4Sub),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _controller,
            itemCount: 3,
            itemBuilder: (context, i) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _gradients[i],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(slides[i].$1,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(slides[i].$2,
                      style:
                          TextStyle(color: Colors.white.withValues(alpha: .85))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final List<Category> categories;
  const _CategoryGrid({required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          childAspectRatio: 0.82,
        ),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final lang =
              AppLanguageX.fromLocale(Localizations.localeOf(context));
          final c = categories[i];
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.go('/category'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(c.emoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: 4),
                Text(c.name.of(lang),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FlashSaleHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final left = midnight.difference(now);
    final hh = left.inHours.toString().padLeft(2, '0');
    final mm = (left.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (left.inSeconds % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Text(context.l10n.flashSale,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const Spacer(),
          _ClockCell(t: hh),
          _colon(),
          _ClockCell(t: mm),
          _colon(),
          _ClockCell(t: ss),
        ],
      ),
    );
  }

  Widget _colon() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
      );
}

class _ClockCell extends StatelessWidget {
  final String t;
  const _ClockCell({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(t,
          style: const TextStyle(color: Colors.white, fontSize: 11)),
    );
  }
}

class _FlashSaleList extends ConsumerWidget {
  final List<Product> items;
  const _FlashSaleList({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = AppLanguageX.fromLocale(Localizations.localeOf(context));
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(width: 10),
      itemBuilder: (context, i) {
        final p = items[i];
        return Card(
          child: InkWell(
            onTap: () => context.push('/product/${p.id}'),
            child: SizedBox(
              width: 128,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(p.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            Container(color: Colors.black12)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                    child: MoneyText(p.priceCents,
                        style: const TextStyle(fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                    child: Text(p.name.of(lang),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11, color: Theme.of(context).hintColor)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WaterfallGrid extends ConsumerWidget {
  const _WaterfallGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products =
        ref.watch(guessYouLikeProvider).value ?? const <Product>[];

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 16),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childCount: products.length,
        itemBuilder: (context, i) =>
            ProductCard(product: products[i]),
      ),
    );
  }
}
