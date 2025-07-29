
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_lab16_1/cubits/auth_cubit.dart';
// import 'package:flutter_lab16_1/cubits/form_validation/form_validation_cubit.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'screens/login_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final prefs = await SharedPreferences.getInstance();
  
//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => FormValidationCubit()),
//         BlocProvider(create: (_) => AuthCubit()),
//       ],
//       child: MyApp(prefs: prefs),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   final SharedPreferences prefs;
  
//   const MyApp({Key? key, required this.prefs}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'News App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.grey[100],
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//       ),
//       home: BlocBuilder<AuthCubit, AuthState>(
//         builder: (context, state) {
//           if (state is AuthSuccess) {
//             // Return your home screen here when authenticated
//             return const Placeholder(); // Replace with your home screen
//           }
//           return const LoginScreen();
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab16_1/cubits/auth_cubit.dart';
import 'package:flutter_lab16_1/cubits/form_validation/form_validation_cubit.dart';
import 'package:flutter_lab16_1/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FormValidationCubit()),
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: MyApp(prefs: prefs),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}