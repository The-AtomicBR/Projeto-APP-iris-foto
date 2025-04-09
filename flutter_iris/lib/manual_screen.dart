import 'package:flutter/material.dart';

class ManualScreen extends StatelessWidget {
  const ManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📸 Passo a Passo para Capturar a Íris")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📌 Guia Completo para Captura e Envio da Foto da Íris',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                '✅ Preparação Antes da Foto\n✔️ Iluminação adequada\n✔️ Câmera limpa\n✔️ Ajuda de outra pessoa\n✔️ Câmera traseira',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '📸 Passo a Passo:\n1️⃣ Clique em "Tirar Foto da Íris"\n2️⃣ Posicione a câmera corretamente\n3️⃣ Olhe diretamente para a câmera\n4️⃣ Centralize a íris\n5️⃣ Evite o flash\n6️⃣ Ajuste o foco\n7️⃣ Tire foto do olho direito\n8️⃣ Depois do esquerdo',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navega para a tela da câmera
                  Navigator.pushNamed(context, '/camera');
                },
                child: const Text("Próximo"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
































