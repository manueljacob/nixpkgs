{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

let
  vaultBashCompletions = fetchFromGitHub {
    owner = "iljaweis";
    repo = "vault-bash-completion";
    rev = "62c142e20929f930c893ebe3366350d735e81fbd";
    sha256 = "0nfv10ykjq9751ijdyq728gjlgldm1lxvrar8kf6nz6rdfnnl2n5";
  };
in buildGoPackage rec {
  name = "vault-${version}";
  version = "0.6.1";

  goPackagePath = "github.com/hashicorp/vault";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "06xf2dpn0q398qb6wbh9j1wjl5smqq9nrrn2039g48haqm8853jx";
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/hashicorp/vault/version.GitCommit=${version}
  '';

  postInstall = ''
    mkdir -p $bin/share/bash-completion/completions/ 
    cp ${vaultBashCompletions}/vault-bash-completion.sh $bin/share/bash-completion/completions/vault
  '';

  meta = with stdenv.lib; {
    homepage = https://www.vaultproject.io;
    description = "A tool for managing secrets";
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
