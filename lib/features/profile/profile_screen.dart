import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations_x.dart';
import '../../core/localization/locale_provider.dart';
import '../../shared/widgets/app_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final localeState = ref.watch(appLocaleProvider);
    final localeNotifier = ref.read(appLocaleProvider.notifier);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            AppCard(child: Text(l10n.profilePlaceholder)),
            const SizedBox(height: 12),
            AppCard(
              child: RadioGroup<AppLocalePreference>(
                groupValue: localeState.preference,
                onChanged: (value) {
                  if (value != null) {
                    localeNotifier.setPreference(value);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsLanguage,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    RadioListTile<AppLocalePreference>(
                      contentPadding: EdgeInsets.zero,
                      value: AppLocalePreference.system,
                      title: Text(l10n.settingsUseSystem),
                    ),
                    RadioListTile<AppLocalePreference>(
                      contentPadding: EdgeInsets.zero,
                      value: AppLocalePreference.de,
                      title: Text(l10n.settingsGerman),
                    ),
                    RadioListTile<AppLocalePreference>(
                      contentPadding: EdgeInsets.zero,
                      value: AppLocalePreference.en,
                      title: Text(l10n.settingsEnglish),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
