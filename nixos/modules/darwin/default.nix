_: {
  system.defaults = {
    finder = {
      AppleShowAllFiles = false; # Show all files
      AppleShowAllExtensions = true; # Show all file extensions
      FXEnableExtensionChangeWarning = false; # Disable Warning for changing extension
      FXPreferredViewStyle = "clmv"; # Change the default finder view. “icnv” = Icon view
      ShowPathbar = true; # Show full path at bottom
      CreateDesktop = false;
    };
    menuExtraClock = {
      Show24Hour = true; # Use 24 hour clock
      ShowSeconds = true; # Show Seconds
    };
    dock = {
      autohide = true;
      magnification = false;
      orientation = "bottom";
      show-recents = false; # Show Recently Open
      showhidden = true;
      tilesize = 48;

      # Disable all Corners, 1 = Disabled
      # Top Left
      wvous-tl-corner = 1;
      # Top Right
      wvous-tr-corner = 1;
      # Bottom Left
      wvous-bl-corner = 1;
      # Bottom Right
      wvous-br-corner = 1;
    };
  };
}