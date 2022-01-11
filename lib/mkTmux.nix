mkTmux: { pkgs, ...}: pkgs.stdenv.mkDerivation {
  name = "tmux";
  version = "3.2a";

  outputs = [ "out" ];

  src = pkgs.fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = "3.2a";
    sha256 = "CWDT0F0jOADBHftp6JhAJT80BDJnaRVrH1T/Mx31gwQ=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
    autoreconfHook
    bison
  ];

  buildInputs = with pkgs; [
    ncurses
    libevent
  ];

  configureFlags = [
    "--sysconfdir=/etc/"
    "--localstatedir=/var"
  ];

  enableParallelBuilding = true;

  postInstall = "";

  patches = [
    (pkgs.fetchpatch {
      url = "https://github.com/tmux/tmux/commit/d0a2683120ec5a33163a14b0e1b39d208745968f.patch";
      sha256 = "070knpncxfxi6k4q64jwi14ns5vm3606cf402h1c11cwnaa84n1g";
    })
  ];
}
