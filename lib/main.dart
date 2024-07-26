import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'route/app_routes.dart';
import 'utils/size_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCXUHtmHjGXGysfNH3Vx_aVRNUSsnJ6Cno',
          appId: '1:473770049962:web:5ddd359ed90735b63f2bd3',
          messagingSenderId: '473770049962',
          projectId: 'tyt-asset-management'));

  runApp(const AssetManagement());
}

class AssetManagement extends StatelessWidget {
  const AssetManagement({super.key});

  @override
  Widget build(BuildContext context) {
    //init sizeconfig
    SizeConfig().init(context);
    return GetMaterialApp.router(
      theme: ThemeData(useMaterial3: false),
      title: 'Asset Management',
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.noTransition,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}