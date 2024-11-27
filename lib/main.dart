// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import nécessaire pour Firebase options

import 'blocs/login/login_bloc.dart';
import 'blocs/vehicle/vehicle_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/vehicle_repository.dart'; // Import du VehicleRepository
import 'screens/login_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialisation avec les options
  );
  await NotificationService().init(); // Initialiser les notifications

  final authRepository = AuthRepository();
  final vehicleRepository = VehicleRepository(); // Création du VehicleRepository

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
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: vehicleRepository),
      ],
      child: MaterialApp(
        title: 'Application de suivi de véhicule',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<VehicleBloc>(
                create: (context) => VehicleBloc(
                  vehicleRepository: vehicleRepository,
                ),
              ),
              BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(
                  authRepository: authRepository,
                ),
              ),
              // Le SignupBloc sera fourni lors de la navigation vers le SignupScreen
            ],
            child: child!,
          );
        },
        home: const LoginScreen(),
      ),
    );
  }
}
