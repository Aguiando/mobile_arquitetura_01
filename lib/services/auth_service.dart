import 'dart:convert';
import '../models/user.dart';
import 'http_helper.dart';
 
class AuthService {
  /// POST /auth/login
  Future<User> login({required String username, required String password}) async {
    final response = await HttpHelper.post(
      '/auth/login',
      body: {
        'username': username,
        'password': password,
        'expiresInMins': 60,
      },
    );
 
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return User.fromJson(json);
    } else if (response.statusCode == 400) {
      throw Exception('Usuário ou senha inválidos.');
    } else {
      throw Exception('Erro no servidor (${response.statusCode}).');
    }
  }
 
  /// GET /auth/me — retorna dados atualizados do usuário autenticado
  Future<User> getMe({required String token}) async {
    final response = await HttpHelper.get('/auth/me', token: token);
 
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      // /auth/me não devolve o token, então preservamos o token atual
      return User.fromJson({...json, 'accessToken': token});
    } else {
      throw Exception('Não foi possível obter os dados do perfil.');
    }
  }
}