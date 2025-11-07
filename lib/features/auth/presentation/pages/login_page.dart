import 'package:easy_travel/core/enums/status.dart';
import 'package:easy_travel/features/auth/presentation/blocs/login_bloc.dart';
import 'package:easy_travel/features/auth/presentation/blocs/login_event.dart';
import 'package:easy_travel/features/auth/presentation/blocs/login_state.dart';
import 'package:easy_travel/features/main/presentation/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == Status.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        } else if (state.status == Status.failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message ?? '')));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                context.read<LoginBloc>().add(OnEmailChanged(email: value));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: BlocSelector<LoginBloc, LoginState, bool>(
              selector: (state) => state.isPasswordVisible,
              builder: (context, isPasswordVisible) {
                return TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(
                          OnTogglePasswordVisibility(),
                        );
                      },
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: !isPasswordVisible,
                    onChanged: (value) {
                context.read<LoginBloc>().add(OnPasswordChanged(password: value));
              },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  context.read<LoginBloc>().add(Login());
                },
                child: Text('Sign in'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
