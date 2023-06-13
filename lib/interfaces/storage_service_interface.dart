abstract class IStorageService {
  Future<String> uploadFile(String path, String? fileName);
  Future<void> deleteFile(String fileId);
}
