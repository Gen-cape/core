{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
  libsecret,
  amneziawg-go,
  openvpn,
  wireguard-tools,
  libssh,
  openssl,
  tun2socks,
  v2ray-rules-dat,
  runtimeShell,
  callPackage,
  nix-update-script,
}:
let
  # The 5.0.1.5 Linux release explicitly requires this AWG 3.1 backend.
  amneziawg-go-pinned = amneziawg-go.overrideAttrs (finalAttrs: _: {
    version = "3.1.20260814";

    src = fetchFromGitHub {
      owner = "amnezia-vpn";
      repo = "amneziawg-go";
      tag = "v${finalAttrs.version}";
      hash = "sha256-HMmbKd1wYzotB+GAZ8GulyJmX7+XUnXOEerab0OCPO8=";
    };

    vendorHash = "sha256-Y2dCwlKMVLrkzDcNKyCPxFJwMbCA2mQKkakvzwbamCY=";
  });

  tun2socks-pinned = tun2socks.overrideAttrs (finalAttrs: _: {
    version = "2.6.0";

    src = fetchFromGitHub {
      owner = "xjasonlyu";
      repo = "tun2socks";
      tag = "v${finalAttrs.version}";
      hash = "sha256-ec4M107BE6MCnW/uz9S83JYJtY9tsQQXDFL98h951DA=";
    };

    vendorHash = "sha256-YAAdyV2p/Ci9RzgVWYXBwR/ctERSQ8SPK7AbwRuUJiI=";

    ldflags = [
      "-w"
      "-s"
      "-X github.com/xjasonlyu/tun2socks/v2/internal/version.Version=v${finalAttrs.version}"
      "-X github.com/xjasonlyu/tun2socks/v2/internal/version.GitCommit=v${finalAttrs.version}"
    ];
  });

  amnezia-xray = callPackage ./xray-lib.nix { };

  dev-agw-public-key = lib.replaceStrings [ "\n" ] [ "\\n" ] (builtins.readFile ./dev_agw_public_key);
  dev-agw-endpoint = "http://gw.dev.amzsvc.com:80/";
  dev-s3-endpoint = "https://s3.eu-north-1.amazonaws.com/amnezia-dev/";

  prod-agw-public-key = lib.replaceStrings [ "\n" ] [ "\\n" ] (
    builtins.readFile ./prod_agw_public_key
  );
  prod-s3-endpoint = lib.concatStringsSep ", " [
    "https://s3.eu-north-1.amazonaws.com/amnezia/"
    "https://storage.googleapis.com/lambda-list/"
    "https://amnzstrg01.blob.core.windows.net/lambda-list/"
    "https://objectstorage.eu-zurich-1.oraclecloud.com/n/zrhfyaq6qxvh/b/lambda-list/o/"
  ];
  fallback-s3-endpoint = lib.concatStringsSep ", " [
    "https://storage.mwsapis.ru/lambda-list/"
    "https://46.8.209.252/lambda-list/"
  ];
  free-v2-endpoint = "13.248.139.44";
  prem-v1-endpoint = "52.223.54.40";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "amnezia-vpn";
  version = "5.0.1.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amnezia-client";
    tag = finalAttrs.version;
    hash = "sha256-pSuKAv/Vy4k9kCotIzN1g5NbnyUG/6hDeuQQcGOt5Ow=";
    fetchSubmodules = true;
    postCheckout = ''
      git -C "$out" rev-parse --short HEAD > "$out/.git-revision"
      git -C "$out" show -s --format=%ct HEAD > "$out/.source-date-epoch"
    '';
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${CMAKE_SOURCE_DIR}/cmake/recipes_bootstrap.cmake" "" \
      --replace-fail "\''${CMAKE_SOURCE_DIR}/cmake/conan_provider.cmake" ""

    substituteInPlace client/CMakeLists.txt \
      --replace-fail 'git rev-parse --short HEAD' '"''${CMAKE_COMMAND}" -E cat "''${CMAKE_SOURCE_DIR}/.git-revision"'

    substituteInPlace client/core/utils/utilities.cpp \
      --replace-fail 'Utils::executable("openvpn", true)' 'Utils::executable("${openvpn}/bin/openvpn", false)' \
      --replace-fail 'Utils::usrExecutable("wg-quick")' 'Utils::executable("${wireguard-tools}/bin/wg-quick", false)' \
      --replace-fail 'Utils::executable("tun2socks", true)' 'Utils::executable("${tun2socks-pinned}/bin/tun2socks", false)'

    substituteInPlace client/platforms/linux/daemon/wireguardutilslinux.cpp \
      --replace-fail 'QDir appPath(QCoreApplication::applicationDirPath());' "" \
      --replace-fail 'appPath.filePath("amneziawg-go")' 'QString::fromUtf8("${amneziawg-go-pinned}/bin/amneziawg-go")'

    substituteInPlace client/mozilla/localsocketcontroller.cpp \
      --replace-fail $'  json.insert("deviceIpv4Address", wgConfig.value(amnezia::configKey::clientIp));\n  m_deviceIpv4 = wgConfig.value(amnezia::configKey::clientIp).toString();' $'  const QString clientIp = wgConfig.value(amnezia::configKey::clientIp).toString();\n  json.insert("deviceIpv4Address", clientIp.section(\',\', 0, 0).trimmed());\n  m_deviceIpv4 = clientIp.section(\',\', 0, 0).trimmed();'

    substituteInPlace client/cmake/3rdparty.cmake \
      --replace-fail 'list(APPEND LIBS ssh::ssh)' 'list(APPEND LIBS ssh)'

    substituteInPlace client/core/configurators/openVpnConfigurator.cpp \
      --replace-fail '.arg(qApp->applicationDirPath()))' ".arg(\"$out/libexec\"))"

    substituteInPlace client/platforms/linux/daemon/linuxfirewall.cpp \
      --replace-fail 'QStringLiteral("/bin/bash")' 'QStringLiteral("${runtimeShell}")'

    substituteInPlace client/ui/utils/qAutoStart.cpp \
      --replace-fail '/usr/share/pixmaps/AmneziaVPN.png' 'AmneziaVPN' \
      --replace-fail '"Exec=" << appPath()' '"Exec=AmneziaVPN --autostart"'

    substituteInPlace client/ui/utils/systemTrayNotificationHandler.cpp \
      --replace-fail 'm_systemTrayIcon.show();' "" \
      --replace-fail 'setTrayState(Vpn::ConnectionState::Disconnected);' $'setTrayState(Vpn::ConnectionState::Disconnected);\n    m_systemTrayIcon.show();'

    substituteInPlace client/main.cpp \
      --replace-fail '#include "version.h"' $'#include "version.h"\n#include <QIcon>' \
      --replace-fail 'app.setApplicationDisplayName(APPLICATION_NAME);' $'app.setApplicationDisplayName(APPLICATION_NAME);\n    app.setWindowIcon(QIcon::fromTheme("AmneziaVPN"));'

    substituteInPlace service/server/xray.cpp \
      --replace-fail 'qDebug() << "Xray::startXray()";' $'qDebug() << "Xray::startXray()";\n    qputenv("XRAY_LOCATION_ASSET", QByteArrayLiteral("${v2ray-rules-dat}/share/v2ray"));'

    substituteInPlace service/server/CMakeLists.txt \
      --replace-fail 'find_package(amnezia-xray-bindings REQUIRED)' 'target_include_directories(''${PROJECT} PRIVATE "${amnezia-xray}/include")' \
      --replace-fail 'amnezia::xray-bindings' '"${amnezia-xray}/lib/libamnezia_xray.a"' \
      --replace-fail $'    find_package(awg-go REQUIRED)\n    list(APPEND CONAN_EXECS $<TARGET_FILE:amnezia::awg-go>)\n' "" \
      --replace-fail $'find_package(openvpn REQUIRED)\nlist(APPEND CONAN_EXECS $<TARGET_FILE:openvpn::openvpn>)\n\nfind_package(tun2socks REQUIRED)\nlist(APPEND CONAN_EXECS $<TARGET_FILE:xjasonlyu::tun2socks>)\n\nfind_package(v2ray-rules-dat REQUIRED)\nlist(APPEND CONAN_BINS ''${GEOSITE_DAT_PATH} ''${GEOIP_DAT_PATH})\n' "" \
      --replace-fail $'add_custom_command(TARGET ''${PROJECT} POST_BUILD\n    COMMAND ''${CMAKE_COMMAND} -E copy_if_different\n        ''${CONAN_EXECS} ''${CONAN_BINS}\n        "$<TARGET_FILE_DIR:''${PROJECT}>"\n)\n' "" \
      --replace-fail $'if(LINUX)\n    file(GENERATE OUTPUT ''${CMAKE_CURRENT_BINARY_DIR}/set_openvpn_rpath.cmake' $'if(FALSE)\n    file(GENERATE OUTPUT ''${CMAKE_CURRENT_BINARY_DIR}/set_openvpn_rpath.cmake' \
      --replace-fail $'if(LINUX)\n    install(IMPORTED_RUNTIME_ARTIFACTS openvpn::openvpn' $'if(FALSE)\n    install(IMPORTED_RUNTIME_ARTIFACTS openvpn::openvpn'

    substituteInPlace deploy/data/linux/AmneziaVPN.desktop \
      --replace-fail 'Icon=/usr/share/pixmaps/AmneziaVPN.png' 'Icon=AmneziaVPN'
    substituteInPlace deploy/data/linux/AmneziaVPN.service \
      --replace-fail 'ExecStart=/opt/AmneziaVPN/bin/AmneziaVPN-service' "ExecStart=$out/bin/AmneziaVPN-service"
    substituteInPlace deploy/data/linux/update-resolv-conf.sh \
      --replace-fail '#!/usr/bin/env bash' '#!${runtimeShell}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtremoteobjects
    kdePackages.qtsvg
    libsecret
    libssh
    openssl
  ];

  preConfigure = ''
    export SOURCE_DATE_EPOCH="$(< .source-date-epoch)"
    export DEV_AGW_PUBLIC_KEY="${dev-agw-public-key}"
    export DEV_AGW_ENDPOINT="${dev-agw-endpoint}"
    export DEV_S3_ENDPOINT="${dev-s3-endpoint}"
    export PROD_AGW_PUBLIC_KEY="${prod-agw-public-key}"
    export PROD_S3_ENDPOINT="${prod-s3-endpoint}"
    export FALLBACK_S3_ENDPOINT="${fallback-s3-endpoint}"
    export FREE_V2_ENDPOINT="${free-v2-endpoint}"
    export PREM_V1_ENDPOINT="${prem-v1-endpoint}"
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 client/AmneziaVPN service/server/AmneziaVPN-service -t $out/bin/
    install -Dm555 ../deploy/data/linux/update-resolv-conf.sh -t $out/libexec/
    install -Dm444 ../deploy/data/linux/AmneziaVPN.desktop -t $out/share/applications/
    install -Dm444 ../deploy/data/linux/AmneziaVPN.png -t $out/share/icons/hicolor/512x512/apps/
    install -Dm444 ../deploy/data/linux/AmneziaVPN.service -t $out/lib/systemd/system/
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Amnezia VPN Client";
    downloadPage = "https://amnezia.org/en/downloads";
    homepage = "https://github.com/amnezia-vpn/amnezia-client";
    license = lib.licenses.gpl3Only;
    mainProgram = "AmneziaVPN";
    platforms = lib.platforms.linux;
  };
})
