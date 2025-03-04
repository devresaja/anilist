import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui' as ui;

class CachedImage extends StatefulWidget {
  final String? imageUrl;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isRounded;
  final bool isCircle;
  final double? width;
  final double? height;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isRounded = false,
    this.isCircle = false,
    this.width,
    this.height,
  });

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  Uint8List? _cachedImage;
  bool _isEmpty = false;
  final Dio _dio = Dio();
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    _cancelToken?.cancel('Widget disposed');
    _dio.close();
    super.dispose();
  }

  void _getData() {
    if (widget.imageUrl != null) {
      _loadImage(widget.imageUrl!);
    } else {
      setState(() {
        _isEmpty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _getBorderRadius(),
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: _buildChild(),
      ),
    );
  }

  BorderRadius _getBorderRadius() {
    if (widget.borderRadius != null) return widget.borderRadius!;
    if (widget.isRounded) return const BorderRadius.all(Radius.circular(12));
    if (widget.isCircle) return const BorderRadius.all(Radius.circular(300));
    return BorderRadius.zero;
  }

  Widget _buildChild() {
    if (_isEmpty) {
      return _buildEmptyWidget();
    }
    if (_cachedImage != null) {
      return _buildImage();
    }
    return _buildPlaceholder();
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Icon(
        Icons.broken_image,
        color: Colors.grey,
        size: 50,
      ),
    );
  }

  Widget _buildImage() {
    return Image.memory(
      _cachedImage!,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
    );
  }

  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Container(
        color: Colors.white,
        height: widget.height,
        width: widget.width,
      ),
    );
  }

  Future<void> _loadImage(String url) async {
    try {
      _cancelToken = CancelToken();
      final filePath = await _getCachedFilePath(url);
      final file = File(filePath);

      if (await file.exists()) {
        await _loadFromCache(file);
      } else {
        await _downloadAndCacheImage(url, file);
      }
    } on DioException catch (e) {
      if (e.type != DioExceptionType.cancel) {
        _handleError('Dio error: ${e.message}');
      }
    } catch (e) {
      _handleError('Error loading image: $e');
    }
  }

  Future<String> _getCachedFilePath(String url) async {
    final cacheDir = await getTemporaryDirectory();
    return '${cacheDir.path}/${_generateFileName(url)}';
  }

  Future<void> _loadFromCache(File file) async {
    final bytes = await file.readAsBytes();
    if (await _isValidImage(bytes)) {
      if (mounted) {
        setState(() {
          _cachedImage = bytes;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isEmpty = true;
        });
      }
    }
  }

  Future<void> _downloadAndCacheImage(String url, File file) async {
    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
      cancelToken: _cancelToken,
    );
    if (response.statusCode == 200 && mounted) {
      final bytes = Uint8List.fromList(response.data!);
      if (await _isValidImage(bytes)) {
        await file.writeAsBytes(bytes);
        if (mounted) {
          setState(() {
            _cachedImage = bytes;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isEmpty = true;
          });
        }
      }
    }
  }

  void _handleError(String message) {
    debugPrint(message);
    if (mounted) {
      setState(() {
        _isEmpty = true;
      });
    }
  }

  Future<bool> _isValidImage(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      await codec.getNextFrame();
      return true;
    } catch (e) {
      debugPrint('Invalid image: $e');
      return false;
    }
  }

  String _generateFileName(String url) {
    return Uri.parse(url).pathSegments.last;
  }
}
