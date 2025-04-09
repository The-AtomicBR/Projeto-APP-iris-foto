import 'dart:io';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../relatorio_final.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  CameraController? controller;
  final Logger logger = Logger();
  XFile? _leftEyeImage;
  XFile? _rightEyeImage;
  int _photoStep = 0; // 0 para olho esquerdo, 1 para olho direito
  int _cameraIndex = 0; // Índice da câmera ativa (0 = traseira, 1 = frontal)

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
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraIndex = _cameraIndex % cameras.length;
        controller = CameraController(cameras[_cameraIndex], ResolutionPreset.high);
        await controller!.initialize();
        setState(() {}); // Atualiza a UI
        logger.i('Câmera inicializada com sucesso');
      } else {
        logger.e('Nenhuma câmera disponível');
      }
    } catch (e) {
      logger.e('Erro ao inicializar a câmera: $e');
    }
  }

  Future<void> _toggleCamera() async {
    if (cameras.length > 1) {
      _cameraIndex = (_cameraIndex + 1) % cameras.length;
      await controller?.dispose();
      await _initializeCamera();
    } else {
      logger.w('Apenas uma câmera disponível');
    }
  }

  Future<void> _takePicture() async {
    if (controller != null && controller!.value.isInitialized) {
      try {
        final XFile file = await controller!.takePicture();
        logger.i('Foto tirada: ${file.path}');
        setState(() {
          if (_photoStep == 0) {
            _leftEyeImage = file;
          } else {
            _rightEyeImage = file;
          }
        });
        _showSaveDialog(file);
      } catch (e) {
        logger.e('Erro ao tirar foto: $e');
      }
    } else {
      logger.e('Erro: A câmera não está inicializada corretamente');
    }
  }

  void _showSaveDialog(XFile image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deseja salvar essa foto?'),
        content: Image.file(File(image.path), height: 200, width: 200),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _savePicture(image);
              Navigator.pop(context);
              setState(() {
                _photoStep = _photoStep == 0 ? 1 : 0;
              });
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _savePicture(XFile image) async {
    try {
      final directory = await getExternalStorageDirectory();
      final String newPath = '${directory!.path}/foto_iris_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File savedFile = await File(image.path).copy(newPath);
      logger.i('Foto salva em: ${savedFile.path}');
      setState(() {}); // Atualiza a UI para refletir a nova imagem
    } catch (e) {
      logger.e('Erro ao salvar a foto: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_photoStep == 0 ? 'FOTO DO OLHO ESQUERDO' : 'FOTO DO OLHO DIREITO')),
      body: Stack(
        children: [
          Positioned.fill(
            child: controller != null && controller!.value.isInitialized
                ? CameraPreview(controller!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: FloatingActionButton(
              onPressed: _toggleCamera,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.flip_camera_ios, size: 30),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton(
              onPressed: _takePicture,
              backgroundColor: Colors.red,
              child: const Icon(Icons.camera, size: 35),
            ),
          ),
          if (_leftEyeImage != null || _rightEyeImage != null)
            Positioned(
              top: 80,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_leftEyeImage != null)
                    Column(
                      children: [
                        const Text('Olho Esquerdo'),
                        Image.file(File(_leftEyeImage!.path), height: 100, width: 100),
                      ],
                    ),
                  if (_rightEyeImage != null)
                    Column(
                      children: [
                        const Text('Olho Direito'),
                        Image.file(File(_rightEyeImage!.path), height: 100, width: 100),
                      ],
                    ),
                ],
              ),
            ),
          if (_leftEyeImage != null && _rightEyeImage != null)
            Positioned(
              bottom: 100,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RelatorioFinal()),
                  );
                },
                child: const Text('Próximo'),
              ),
            ),
        ],
      ),
    );
  }
}
