abstract class IStorageService {
  Future<List<String>> uploadFiles(List<String> filesPaths);
  Future<String> uploadFile(String path, String? fileName);
  Future<void> deleteFile(String fileId);
}
