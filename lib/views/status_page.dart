import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/views/dashboard_page.dart';
import '../providers/auth_provider.dart';
import 'auth/login_page.dart';





class StatusPage extends ConsumerWidget {
  const StatusPage({super.key});


  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Consumer(
            builder: (context, ref, child) {
             final authData = ref.watch(authProvider);
             return authData.user.isEmpty ? LoginPage() : DashBoardPage();
            }
        )
    );
  }
}