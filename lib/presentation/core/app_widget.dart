import 'package:catatan/presentation/pages/desktop_pages.dart';
import 'package:catatan/presentation/pages/mobile_pages.dart';
import 'package:flutter/material.dart';
import 'package:catatan/presentation/core/responsive_widget.dart';
// import 'package:catatan/presentation/pages/chats/desktop/desktop_chats_page.dart';
// import 'package:catatan/presentation/pages/chats/mobile/mobile_chats_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catatan',
      home: ResponsiveLayout(
        mobileLayout: MobileMain(),
        desktopLayout: DesktopMain(),
      ),
    );
  }
}
