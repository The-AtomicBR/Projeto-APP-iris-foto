import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';

class IrisIA {
  static final Logger _logger = Logger();

  /// Analisa a imagem e retorna uma lista de alertas
  static Future<List<String>> analisarImagem(File imageFile) async {
    final List<String> feedback = [];

    try {
      // Lê bytes da imagem
      Uint8List bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        _logger.e('Falha ao decodificar imagem');
        feedback.add('Erro ao processar a imagem.');
        return feedback;
      }

      // Análise de brilho médio
      double brightness = _calcularBrilhoMedio(image);
      if (brightness < 50) {
        feedback.add('📸 Foto muito escura');
      }

      // Simulação de detecção de borrado (análise de variação de pixels)
      double blurValue = _calcularNitidez(image);
      if (blurValue < 20) {
        feedback.add('📸 Foto muito borrada');
      }

      // Podemos simular que a imagem está “muito longe” se a imagem for muito pequena
      if (image.width < 200 || image.height < 200) {
        feedback.add('📸 Foto muito distante');
      }

    } catch (e) {
      _logger.e('Erro ao analisar imagem: $e');
      feedback.add('Erro inesperado durante a análise.');
    }

    return feedback;
  }

 static double _calcularBrilhoMedio(img.Image image) {
  double totalBrightness = 0;
  int count = 0;

  for (int y = 0; y < image.height; y += 10) {
    for (int x = 0; x < image.width; x += 10) {
      final pixel = image.getPixel(x, y);
      final r = pixel.r;
      final g = pixel.g;
      final b = pixel.b;
      totalBrightness += (r + g + b) / 3;
      count++;
    }
  }

  return totalBrightness / count;
}


  static double _calcularNitidez(img.Image image) {
    // Essa função é simplificada — só compara pixels vizinhos
    double diff = 0;
    int count = 0;

    for (int y = 1; y < image.height; y += 10) {
      for (int x = 1; x < image.width; x += 10) {
        final curr = img.getLuminance(image.getPixel(x, y));
        final prev = img.getLuminance(image.getPixel(x - 1, y));
        diff += (curr - prev).abs();
        count++;
      }
    }

    return diff / count;
  }
}
