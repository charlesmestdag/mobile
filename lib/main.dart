// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'blocs/login/login_bloc.dart';
import 'blocs/vehicle/vehicle_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/vehicle_repository.dart';
import 'screens/login_screen.dart';
import 'screens/vehicle_list_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialisation des notifications
  await NotificationService().init();

  // Création des instances des repositories
  final authRepository = AuthRepository();
  final vehicleRepository = VehicleRepository();

  runApp(MyApp(
    authRepository: authRepository,
    vehicleRepository: vehicleRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final VehicleRepository vehicleRepository;

  const MyApp({
    Key? key,
    required this.authRepository,
    required this.vehicleRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Fourniture du AuthRepository
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        // Fourniture du VehicleRepository
        RepositoryProvider<VehicleRepository>.value(value: vehicleRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          // Fourniture du LoginBloc
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
              authRepository: authRepository,
            ),
          ),
          // Fourniture du VehicleBloc et déclenchement de l'événement LoadVehicles
          BlocProvider<VehicleBloc>(
            create: (context) => VehicleBloc(
              vehicleRepository: vehicleRepository,
            )..add(LoadVehicles()),
          ),
        ],
        child: MaterialApp(
          title: 'Application de suivi de véhicule',
          debugShowCheckedModeBanner: false, // Suppression du banner DEBUG
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(), // Route vers l'écran de login
            '/vehicleList': (context) => const VehicleListScreen(), // Route vers la liste des véhicules
          },
        ),
      ),
    );
  }
}
