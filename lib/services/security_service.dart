class SecurityService {
  // Sanitize input to allow only mathematical characters, logic, and standard text.
  // Remove control characters or excessive length.
  String sanitizeInput(String input) {
    if (input.length > 1000) {
      input = input.substring(0, 1000);
    }
    // Remove non-printable chars (ASCII 0-31), except newline/return/tab if needed? 
    // Actually for calc input, we usually only want one line.
    return input.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
  }

  // Example privacy feature: obscure history entry if in "Private Mode"
  bool _privateMode = false;
  
  bool get isPrivateMode => _privateMode;
  
  void togglePrivateMode() {
    _privateMode = !_privateMode;
  }
  
  String maskData(String data) {
    if (_privateMode) return '******';
    return data;
  }
}
