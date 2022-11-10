import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_authentication/provider/auth_provider.dart';
import 'package:user_authentication/repository/auth_repository.dart';
import 'package:user_authentication/views/widgets/logout_button.dart';
import 'package:user_authentication/views/widgets/signin_email_button.dart';
import 'package:user_authentication/views/widgets/signin_facebook_button.dart';
import 'package:user_authentication/views/widgets/signin_google_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            authRepository: AuthRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthProvider.of(context).autoLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(authProvider.currentUser?.name ?? "There is no user"),
                authProvider.isLoading
                    ? const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox.shrink(),
                const SigninFacebookButton(),
                const SigninGoogleButton(),
                SignInEmailButton(
                  signinURL:
                      'https://6360f3d6af66cc87dc1ec1d9.mockapi.io/signin',
                  // onPressed: () {},
                  emailController: emailController,
                  passwordController: emailController,
                ),
                const LogoutButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
