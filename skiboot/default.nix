{ stdenv
, lib
, pkgsCross
, openssl
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skiboot";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "open-power";
    repo = "skiboot";
    rev = "v" + finalAttrs.version;
    hash = "sha256-G3NZDVGj/4Or3IgVazBYKZAQQaEr4MoMjytFBW/c774=";
  };

  outputs = [ "out" "test" ];
  postBuild = ''
    make test/hello_world/hello_kernel/hello_kernel
  '';
  postInstall = ''
    mkdir -p $test
    cp test/hello_world/hello_kernel/hello_kernel $test
  '';


  strictDeps = true;
  enableParallelBuilding = true;

  # openssl is used for signing during build time and also linked against
  nativeBuildInputs = [ pkgsCross.ppc64.buildPackages.gcc openssl ];
  buildInputs = [ openssl ];
  hardeningDisable = [ "format" ];

  prePatch = ''
    patchShebangs --build make_version.sh libstb/sign-with-local-keys.sh
  '';
  buildPhase = ''
    runHook preBuild

    export NIX_CFLAGS_COMPILE=$NIX_CFLAGS_COMPILE" -Wno-error"
    export CROSS=powerpc64-unknown-linux-gnuabielfv2-
    export SKIBOOT_VERSION=v${finalAttrs.version}
    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp skiboot.lid* $out

    runHook postInstall
  '';

  meta = {
    description = "OPAL boot and runtime firmware for POWER";
    homepage = "https://github.com/open-power/skiboot";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moody ];
    platforms = lib.platforms.all;
  };

})
