{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-cloud-logging
, google-cloud-testutils
, libcst
, mock
, proto-plus
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-error-reporting";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5482a7b05ac3be13a3d96db32d158cb4cebf0ac35c82c3a27ee2fd9aa0dcc25";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'google-cloud-logging>=1.14.0, <2.4' 'google-cloud-logging>=1.14.0'
  '';

  propagatedBuildInputs = [
    google-cloud-logging
    libcst
    proto-plus
  ];

  checkInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # require credentials
    "test_report_error_event"
    "test_report_exception"
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  meta = with lib; {
    description = "Stackdriver Error Reporting API client library";
    homepage = "https://github.com/googleapis/python-error-reporting";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
