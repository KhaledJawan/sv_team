import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class CateringApp extends StatelessWidget {
  const CateringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SV Team Catering',
      theme: AppTheme.lightTheme,
      scrollBehavior: const _IosLikeScrollBehavior(),
      initialRoute: AppRouter.shell,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

class _IosLikeScrollBehavior extends MaterialScrollBehavior {
  const _IosLikeScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}
