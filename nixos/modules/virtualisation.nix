{
  user,
  pkgs,
  config,
  ...
}: {
  # vm-curator fixes

  systemd.tmpfiles.rules = let
    fw = "${config.virtualisation.libvirtd.qemu.package}/share/qemu";
  in [
    "L /run/libvirt/nix-ovmf/OVMF_CODE.fd - - - - ${fw}/edk2-x86_64-code.fd"
    "L /run/libvirt/nix-ovmf/OVMF_VARS.fd - - - - ${fw}/edk2-i386-vars.fd"
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  users.users.${user} = {
    extraGroups = ["libvirtd"];
  };

  environment.systemPackages = [
    pkgs.qemu_kvm
  ];
}
