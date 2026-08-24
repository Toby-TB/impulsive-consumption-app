import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common.dart';
import '../../../data/database/database.dart';

/// 新增/编辑地址表单（BottomSheet）。
Future<void> showAddressFormSheet(
  BuildContext context, {
  AddressesData? existing,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AddressFormSheet(existing: existing),
  );
}

class _AddressFormSheet extends ConsumerStatefulWidget {
  final AddressesData? existing;

  const _AddressFormSheet({this.existing});

  @override
  ConsumerState<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends ConsumerState<_AddressFormSheet> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _region;
  late final TextEditingController _detail;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _phone = TextEditingController(text: e?.phone ?? '');
    _region = TextEditingController(text: e?.region ?? '');
    _detail = TextEditingController(text: e?.detail ?? '');
    _isDefault = e?.isDefault ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _region.dispose();
    _detail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final editing = widget.existing != null;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(editing ? l.editAddress : l.addAddress,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              decoration: InputDecoration(
                hintText: l.recipientLabel,
                prefixIcon: const Icon(Icons.person_outline, size: 18),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: l.phoneLabel,
                prefixIcon: const Icon(Icons.phone_outlined, size: 18),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _region,
              decoration: InputDecoration(
                hintText: l.regionLabel,
                prefixIcon:
                    const Icon(Icons.location_city_outlined, size: 18),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _detail,
              decoration: InputDecoration(
                hintText: l.detailAddressLabel,
                prefixIcon: const Icon(Icons.home_outlined, size: 18),
              ),
            ),
            const SizedBox(height: 6),
            SwitchListTile(
              title: Text(l.setDefault, style: const TextStyle(fontSize: 14)),
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () async {
                if (_name.text.trim().isEmpty ||
                    _detail.text.trim().isEmpty) {
                  return;
                }
                await ref.read(addressRepositoryProvider).upsert(
                      id: widget.existing?.id,
                      name: _name.text.trim(),
                      phone: _phone.text.trim(),
                      region: _region.text.trim(),
                      detail: _detail.text.trim(),
                      isDefault: _isDefault,
                    );
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
  }
}

/// 地址选择器（结算页用）。
Future<AddressesData?> showAddressPicker(BuildContext context) {
  return showModalBottomSheet<AddressesData>(
    context: context,
    builder: (_) => const _AddressPickerSheet(),
  );
}

class _AddressPickerSheet extends ConsumerWidget {
  const _AddressPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final addresses = ref.watch(_addressesProvider).value ?? const [];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.addressTitle,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: addresses.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final a = addresses[i];
                  return Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      onTap: () => Navigator.pop(context, a),
                      title: Row(
                        children: [
                          Text('${a.name} ${a.phone}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          if (a.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(l.defaultAddressLabel,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text('${a.region} ${a.detail}',
                          style: const TextStyle(fontSize: 12)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () =>
                                showAddressFormSheet(context, existing: a),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(l.deleteAddressConfirm),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: Text(l.cancel),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, true),
                                      child: Text(l.confirm),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                await ref
                                    .read(addressRepositoryProvider)
                                    .remove(a.id);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.tonal(
              onPressed: () => showAddressFormSheet(context),
              child: Text(l.addAddress),
            ),
          ],
        ),
      ),
    );
  }
}

final _addressesProvider = StreamProvider(
  (ref) => ref.watch(addressRepositoryProvider).watchAll(),
);
