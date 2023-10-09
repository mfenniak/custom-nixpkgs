{ fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "alertmanager-mqtt-bridge";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "uhlig-it";
    repo = pname;
    rev = version;
    sha256 = "sha256-y3JNVKIEAzgiM+fJJnEakR+2+zxJQC3PLLTPvnHA9qQ=";
  };

  vendorHash = "sha256-+AUtNi+1AglgHmtF8QhL+W7smiQAz7QJ/GxoEsPKZS4=";
}
