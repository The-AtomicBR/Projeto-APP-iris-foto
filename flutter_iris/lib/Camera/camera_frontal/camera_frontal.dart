import 'dart:io';
import '../iris_ia.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraFrontalScreen extends StatefulWidget {
  const CameraFrontalScreen({super.key});

  @override
  CameraFrontalScreenState createState() => CameraFrontalScreenState();
}

class CameraFrontalScreenState extends State<CameraFrontalScreen> {
  late List<CameraDescription> cameras;
  CameraController? controllerFront;
  final Logger logger = Logger();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      logger.i('Permissão de câmera concedida');
      await _initializeCamera();
    } else {
      logger.e('Permissão de câmera negada');
    }
  }

  Future<void> _initializeCamera() async {
    logger.i('Inicializando câmera frontal...');
    try {
      cameras = await availableCameras();

      if (cameras.length > 1) {
        controllerFront = CameraController(cameras[1], ResolutionPreset.high);
      } else {
        logger.e('Nenhuma câmera frontal disponível');
        return;
      }

      await controllerFront!.initialize();
      if (!mounted) return;
      setState(() {});
      logger.i('Câmera frontal inicializada');
    } catch (e) {
      logger.e('Erro ao inicializar a câmera frontal: $e');
    }
  }

  Future<void> _takePicture() async {
    if (controllerFront != null && controllerFront!.value.isInitialized) {
      try {
        final XFile file = await controllerFront!.takePicture();
        logger.i('Foto tirada da câmera frontal: ${file.path}');

        if (!mounted) return;

        setState(() {
          _imageFile = file;
        });

        // 🔍 Chama a IA para analisar a imagem
        final feedback = await IrisIA.analisarImagem(File(file.path));

        // 💬 Mostra o feedback ao usuário
        if (feedback.isNotEmpty) {
          for (var msg in feedback) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
          }
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Foto analisada com sucesso')),
          );
        }
      } catch (e) {
        logger.e('Erro ao tirar foto: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao tirar a foto')),
        );
      }
    } else {
      logger.e('Erro: A câmera não está inicializada corretamente');
    }
  }

  Future<void> _savePicture() async {
    if (_imageFile == null) return;

    try {
      final directory = await getExternalStorageDirectory();
      final String newPath = '${directory!.path}/foto_frontal_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File savedFile = await File(_imageFile!.path).copy(newPath);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto salva em: ${savedFile.path}')),
      );
      logger.i('Foto salva em: ${savedFile.path}');
    } catch (e) {
      logger.e('Erro ao salvar a foto: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar a foto')),
      );
    }
  }

  @override
  void dispose() {
    controllerFront?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Câmera Frontal')),
      body: Column(
        children: [
          Expanded(
            child: controllerFront != null && controllerFront!.value.isInitialized
                ? CameraPreview(controllerFront!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _takePicture,
                child: const Text('Tirar Foto'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _savePicture,
                child: const Text('Salvar Foto'),
              ),
            ],
          ),
          if (_imageFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(File(_imageFile!.path), height: 200, width: 200),
            ),
        ],
      ),
    );
  }
}
