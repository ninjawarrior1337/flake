{
  ...
}: {
  # Limine replaces systemd-boot on miku; systemd-boot is disabled in
  # configuration.nix so only one bootloader owns the ESP.
  boot.loader.limine = {
    enable = true;

    # Same window of generations the systemd-boot config used.
    maxGenerations = 3;

    # Sign the Limine binary with sbctl (keys already exist in
    # /var/lib/sbctl) and enroll the limine.conf BLAKE2B hash into it. This is
    # staged now; enforcement only begins once the firmware is in User Mode
    # with our keys enrolled and Secure Boot switched on.
    secureBoot.enable = true;

    # Styling mirrors treelar.xyz: Tailwind gray-900 background, white text,
    # #39f (treelar) blue and #e4007f (muse) pink accents.
    style = {
      # No wallpaper: the site is a flat dark surface, so let the terminal
      # background provide it.
      wallpapers = [];
      backdrop = "101828";

      interface = {
        branding = "Treelar";
        brandingColor = "3399FF";
        helpColor = "E4007F";
        helpColorBright = "3399FF";
      };

      graphicalTerminal = {
        # black, red, green, brown, blue, magenta, cyan, gray
        palette = "101828;E4007F;3399FF;E4007F;3399FF;E4007F;3399FF;667085";
        # dark gray, bright red, bright green, yellow, bright blue,
        # bright magenta, bright cyan, white
        brightPalette = "344054;FF5CA8;66B2FF;FFD166;66B2FF;FF5CA8;99CCFF;FFFFFF";
        foreground = "FFFFFF";
        # TTRRGGBB: fully opaque gray-900.
        background = "FF101828";
        brightForeground = "FFFFFF";
        brightBackground = "1D2939";
      };
    };

    # Windows lives on a separate disk (sde) but its Boot Manager is on this
    # machine's ESP (/dev/sdc1), so chainload it from the boot partition.
    extraEntries = ''
      /Windows
          protocol: efi_chainload
          path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
          comment: Windows Boot Manager
    '';
  };
}
