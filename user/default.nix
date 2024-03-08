{ user, ... }:
{
  users.users.${user} = {
    description = "Treelar";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "dialout" ];
  };
}