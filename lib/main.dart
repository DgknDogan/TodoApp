import 'package:firebase_demo/utils/theme/themedata.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/user/api/firebase_api.dart';
import 'features/user/cubit/home_cubit.dart';
import 'services/notification_service.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  NotificationService().initializeNotifiacitons();
  runApp(const MyApp());
}

final _appRouter = AppRouter();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 852),
      builder: (context, child) {
        return BlocProvider(
          create: (context) => HomeCubit(),
          child: MaterialApp.router(
            theme: theme,
            debugShowCheckedModeBanner: false,
            routerConfig: _appRouter.config(),
            title: 'TodoApp',
          ),
        );
      },
    );
  }
}
