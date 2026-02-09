import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import '../services/notification_service.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthSuccess;
  const AuthScreen({super.key, required this.onAuthSuccess});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isLogin = true;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // Вход
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        
        // Уведомление о входе
        NotificationService.showInstantNotification(
          title: 'С возвращением! 👋',
          body: 'Вы успешно вошли в свой профиль.',
        );
      } else {
        // Регистрация
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        
        // Обновление имени пользователя
        if (userCredential.user != null) {
          await userCredential.user!.updateDisplayName(_nameController.text.trim());
        }

        // Уведомление о регистрации
        NotificationService.showInstantNotification(
          title: 'Добро пожаловать! 🎉',
          body: 'Ваш профиль "${_nameController.text}" успешно создан.',
        );
      }

      if (mounted) {
        widget.onAuthSuccess();
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Произошла ошибка';
      if (e.code == 'user-not-found') message = 'Пользователь не найден';
      else if (e.code == 'wrong-password') message = 'Неверный пароль';
      else if (e.code == 'email-already-in-use') message = 'Email уже используется';
      else if (e.code == 'weak-password') message = 'Слишком слабый пароль';
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    _isLogin ? 'С возвращением' : 'Создать аккаунт',
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLogin 
                        ? 'Войдите в свой профиль' 
                        : 'Заполните данные для регистрации',
                    style: const TextStyle(color: AppColors.muted, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  if (!_isLogin) ...[
                    _buildTextField(
                      controller: _nameController,
                      label: 'Имя',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                  ],
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Пароль',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: AppColors.bg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: AppColors.bg)
                          : Text(
                              _isLogin ? 'Войти' : 'Зарегистрироваться',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin 
                            ? 'Нет аккаунта? Зарегистрироваться' 
                            : 'Уже есть аккаунт? Войти',
                        style: const TextStyle(color: AppColors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.text),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.muted),
        prefixIcon: Icon(icon, color: AppColors.muted),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.green, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, заполните поле';
        }
        if (label == 'Пароль' && value.length < 6) {
          return 'Минимум 6 символов';
        }
        return null;
      },
    );
  }
}
