import 'package:app_ecomerce/Les_commandes/Cart_Items.dart';
import 'package:app_ecomerce/models/jus/Cart_jus.dart';
import 'package:app_ecomerce/models/sandwich/Cart_Sandwish.dart';
import 'package:app_ecomerce/pages/IntroPage.dart';
import 'package:app_ecomerce/showdialogue/Admin/code_notifier.dart';
import 'package:app_ecomerce/showdialogue/Emport%C3%A9/Emport%C3%A9%20Form.dart';
import 'package:app_ecomerce/showdialogue/Emport%C3%A9/location_form_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yzokbqnrqxzftmewypzx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6b2ticW5ycXh6ZnRtZXd5cHp4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM1MDE2OTcsImV4cCI6MjA0OTA3NzY5N30.cWpQb0FDFeN07n1tRz4ubyHS_8ub7VOYdXdHN0HTGb0',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       // ChangeNotifierProvider(create: (context) => LocationFormModel()),
        ChangeNotifierProvider(create: (context) => CodeNotifier()),
        ChangeNotifierProvider(create: (context) => Cart_Sandwish()),
        ChangeNotifierProvider(create: (context) => Cart_Juice()),
        ChangeNotifierProvider(create: (context) => CombinedCart()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IntroPage(),
      ),
    );
  }
}
