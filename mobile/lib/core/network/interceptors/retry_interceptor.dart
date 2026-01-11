import 'package:dio/dio.dart';
import '../../utils/logger_service.dart';
import '../network_info.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final NetworkInfo networkInfo;
  final int maxRetries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    required this.networkInfo,
    this.maxRetries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ],
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      try {
        final retries = err.requestOptions.extra['retries'] as int? ?? 0;
        
        if (retries < maxRetries) {
          final delay = retryDelays.length > retries 
              ? retryDelays[retries] 
              : retryDelays.last;

          logger.warning(
            'Retrying request: ${err.requestOptions.path}',
            tag: 'RetryInterceptor',
            data: {'attempt': retries + 1, 'delay': delay.inSeconds},
          );

          await Future.delayed(delay);

          // Check connectivity before retrying if it was a connection error
          if (err.type == DioExceptionType.connectionError || 
              err.type == DioExceptionType.connectionTimeout) {
            final isConnected = await networkInfo.isConnected;
            if (!isConnected) {
              logger.warning('No internet connection, skipping retry', tag: 'RetryInterceptor');
              return super.onError(err, handler);
            }
          }

          final options = err.requestOptions;
          options.extra['retries'] = retries + 1;

          final response = await dio.fetch(options);
          return handler.resolve(response);
        }
      } catch (e) {
        logger.error('Retry failed', tag: 'RetryInterceptor', error: e);
        if (e is DioException) {
           return super.onError(e, handler);
        }
      }
    }
    
    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.type == DioExceptionType.badResponse &&
            err.response?.statusCode != null &&
            err.response!.statusCode! >= 500); // Server errors
  }
}
