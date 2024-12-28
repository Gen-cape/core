{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "yeet-mouse";
  version = "unstable-2024-08-29";

  src = fetchFromGitHub {
    owner = "AndyFilter";
    repo = "YeetMouse";
    rev = "78e8514e00046bf15c49e5331b5f84c07f8388d9";
    hash = "sha256-JvHlDzQW64gZ2/qFUhZ5QfKja76acl0cKTIYP/TlbcM=";
  };

  meta = {
    description = "A fork of a fork of the Linux mouse driver with acceleration. Now with GUI and some other improvements";
    homepage = "https://github.com/AndyFilter/YeetMouse";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "yeet-mouse";
    platforms = lib.platforms.all;
  };
}
