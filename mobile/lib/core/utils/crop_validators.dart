class CropValidators {
  static String? cropType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please choose a crop';
    }
    return null;
  }

  static String? batchId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Batch ID';
    }
    return null;
  }

  static String? location(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Location';
    }
    return null;
  }
}
