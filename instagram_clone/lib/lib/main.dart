import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_clone/lib/firebase_options.dart';

import 'dart:developer' as devtools show log;

import 'state/auth/providers/auth_state_provider.dart';
import 'state/auth/providers/is_logged_in_providers.dart';
import 'state/providers/is_loading_provider.dart';
import 'views/components/loading/loading_screen.dart';

extension Log on Object{
  void log() => devtools.log(toString());
}

//for when you are already logged in
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    // LoadingScreen.instance().show(context: context, text: 'Hello World');
    return Scaffold(
      appBar: AppBar(
          title: const Text('Main View')
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return TextButton(
              onPressed: () async{
                await ref.read(authStateProvider.notifier).logOut();
              },
              child: const Text('Log out')
          );
        },
      ),
    );
  }
}

//for when you are not logged in
class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Login View')
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
            // То как делать не нужно, так как каждый раз создается новый экземпляр
            // () async{
            //   final result = const Authenticator().loginWithGoogle();
            //   result.log();
            // },
            child: Text('Sign In with Google'),
          ),
          TextButton(
            onPressed: ref.read(authStateProvider.notifier).loginWithFacebook,
            child: Text('Sign In with Facebook'),
          ),
        ],
      ),
    );
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          indicatorColor: Colors.blueGrey,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: Consumer(
            builder: (context, ref, child) {
              ref.listen<bool>(
                  isLoadingProvider,
                      (_, isLoading) {
                    if (isLoading) {
                      LoadingScreen.instance().show(
                          context: context
                      );
                    } else {
                      LoadingScreen.instance().hide();
                    }
                  }
              );
              final isLoggedIn = ref.watch(isLoggedInProvider);
              if (isLoggedIn) {
                return const MainView();
              } else {
               return const LoginView();
              }
            },
      ),
    );
  }
}
