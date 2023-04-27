import 'package:redis/redis.dart';

class LoggingService {
  Future<Command> connectToRedis() async {
    final connection = await RedisConnection();
    return connection.connect("localhost", 6379);
  }

  Future<void> logToRedis(String logMessage) async {
    final command = await connectToRedis();

// Store the log message in a Redis list named 'client-logs'
    await command.send_object(['LPUSH', 'client-logs', logMessage]);

// Close the Redis connection
    command.pipe_end();
  }
}
