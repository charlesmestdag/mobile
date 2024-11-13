import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/vehicle_bloc.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // Initialiser les notifications
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleBloc(),
      child: MaterialApp(
        home: const LoginScreen(),
      ),
    );
  }
}
