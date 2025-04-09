import 'dart:io';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraTraseiraScreen extends StatefulWidget {
  const CameraTraseiraScreen({super.key});

  @override
  State<CameraTraseiraScreen> createState() => _CameraTraseiraScreenState();
}

class _CameraTraseiraScreenState extends State<CameraTraseiraScreen> {
  late List<CameraDescription> cameras;
  CameraController? controllerBack;
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
      await _initializeCameras();
    } else {
      logger.e('Permissão de câmera negada');
    }
  }

  Future<void> _initializeCameras() async {
    logger.i('Inicializando câmeras...');
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        controllerBack = CameraController(cameras[0], ResolutionPreset.high);
        await controllerBack!.initialize();
        logger.i('Câmera traseira pronta');
        setState(() {});
      } else {
        logger.e('Nenhuma câmera disponível');
      }
    } catch (e) {
      logger.e('Erro ao inicializar a câmera: $e');
    }
  }

  Future<void> _takePicture() async {
    if (controllerBack != null && controllerBack!.value.isInitialized) {
      try {
        final XFile file = await controllerBack!.takePicture();
        logger.i('Foto tirada: ${file.path}');
        setState(() {
          _imageFile = file;
        });
      } catch (e) {
        logger.e('Erro ao tirar foto: $e');
      }
    } else {
      logger.e('Erro: A câmera não está inicializada corretamente');
    }
  }

  Future<void> _savePicture() async {
    if (_imageFile == null) return;
    try {
      final directory = await getExternalStorageDirectory();
      final String newPath = '${directory!.path}/foto_iris_${DateTime.now().millisecondsSinceEpoch}.jpg';
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
    controllerBack?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Câmera Traseira')),
      body: Column(
        children: [
          Expanded(
            child: controllerBack != null && controllerBack!.value.isInitialized
                ? Center(child: CameraPreview(controllerBack!))
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
              if (_imageFile != null)
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
