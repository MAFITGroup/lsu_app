import 'dart:convert';

import 'package:http/http.dart' as http;

class EnvioMail {
/*
Config para cuenta testing
 */
/*
  Future enviarMail(
      String nombreUsuario, String correoUsuario, String tipo) async {
    final serviceId = 'service_gk0ztah';
    final templateId = 'template_4fz08cw';
    final userId = 'user_Jejg0nf4RdiigOuqP4tsd';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'nombre_usuario': nombreUsuario,
            'tipo': tipo,
            'mail_usuario': correoUsuario,
          }
        }));
  }

 */

  /*
  Config cuenta prod
   */
  Future enviarMail(String nombreUsuario, String correoUsuario,
      String estadoSolicitud) async {
    final serviceId = 'service_u2c0omv';
    final templateId = 'template_n0zyfki';
    final userId = 'user_3AeyYnd4DEkwW8tRldLMn';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'nombre_usuario': nombreUsuario,
            'tipo': estadoSolicitud,
            'mail_usuario': correoUsuario,
          }
        }));
  }
}
