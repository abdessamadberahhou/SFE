class FileRequest
{
  String _IdFile;
  String _IdCourrier ;
  String _FILE ;
  String _FileName ;
  String _FileExtention ;
  FileRequest(this._IdFile, this._IdCourrier, this._FILE, this._FileName, this._FileExtention);

  String get FileExtention => _FileExtention;

  set FileExtention(String value) {
    _FileExtention = value;
  }

  String get FileName => _FileName;

  set FileName(String value) {
    _FileName = value;
  }

  String get FILE => _FILE;

  set FILE(String value) {
    _FILE = value;
  }

  String get IdCourrier => _IdCourrier;

  set IdCourrier(String value) {
    _IdCourrier = value;
  }

  String get IdFile => _IdFile;

  set IdFile(String value) {
    _IdFile = value;
  }
  @override
  String toString() {
    // TODO: implement toString
    return IdFile;
  }
}