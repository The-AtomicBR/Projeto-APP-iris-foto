import 'package:flutter/material.dart';
import 'dart:io'; // Import necessário para fechar o app

class RelatorioFinal extends StatelessWidget {
  const RelatorioFinal({super.key});

  void _fecharAplicativo() {
    exit(0); // Fecha o aplicativo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CONSIDERAÇÕES FINAIS')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Suas fotos e seus dados foram encaminhados para a iridóloga Janete. '
              'Por favor, aguarde que, em até 1 semana, ela entrará em contato '
              'para dar andamento ao seu atendimento.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'CASO VOCÊ TENHA ENFRENTADO DIFICULDADES COM O APLICATIVO OU '
            'GOSTARIA DE RELATAR ALGUM BUG, MANDAR UM EMAIL PARA:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'DancingScript', // Opcional: simula letra de mão
            ),
          ),
          const Text(
            'developmentnecessary@gmail.com',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _fecharAplicativo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text(
              'Concluir',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
