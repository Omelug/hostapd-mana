{
  description = "hostapd-mana — MANA/KARMA rogue AP";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation {
      pname = "hostapd-mana";
      version = self.shortRev or "dirty";

      src = self;

      nativeBuildInputs = [ pkgs.pkg-config ];
      buildInputs = [ pkgs.libnl pkgs.openssl ];

      configurePhase = ''
        cd hostapd
        cp defconfig .config
        substituteInPlace Makefile --replace /usr/local $out
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags libnl-3.0)"
      '';

      preInstall = "mkdir -p $out/bin";

      meta = {
        description = "Rogue AP with MANA/KARMA, WPE credential capture, EAP sycophant";
        license = pkgs.lib.licenses.bsd3;
        platforms = pkgs.lib.platforms.linux;
        mainProgram = "hostapd";
      };
    };
  };
}
