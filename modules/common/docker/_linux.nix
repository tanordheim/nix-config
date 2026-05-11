{
  virtualisation.docker.enable = true;

  networking.firewall.extraCommands = ''
    iptables -I nixos-fw 1 -i docker0 -j nixos-fw-accept
    iptables -I nixos-fw 1 -i br+ -j nixos-fw-accept
  '';
  networking.firewall.extraStopCommands = ''
    iptables -D nixos-fw -i docker0 -j nixos-fw-accept 2>/dev/null || true
    iptables -D nixos-fw -i br+ -j nixos-fw-accept 2>/dev/null || true
  '';
}
