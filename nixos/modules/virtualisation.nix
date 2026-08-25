{
  user,
  pkgs,
  ...
}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  users.users.${user} = {
    extraGroups = [ "libvirtd" ];
  };

  environment.systemPackages = [
    pkgs.qemu_kvm
  ];
}
