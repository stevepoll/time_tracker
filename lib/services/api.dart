class Api {
  static String jobPath(String userId, String jobId) =>
      'users/$userId/jobs/$jobId';
  static String jobs(String userId) => 'users/$userId/jobs';
}
