{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  config = {
    programs.waybar.settings.mainBar = {
      modules-right = ["group/connection"];
      "group/connection" = {
        orientation = "inherit";
        modules = [
          "group/network"
          "group/bluetooth"
        ];
      };
      "group/network" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = true;
        };
        modules = ["network" "network#speed"];
      };
      network = {
        format = "{icon}";
        format-icons = {
          wifi = ["󰤨"];
          ethernet = ["󰈀"];
          disconnected = ["󰖪"];
        };
        format-wifi = "󱑲";
        format-ethernet = "󰈀";
        format-disconnected = "󰖪";
        format-linked = "󰈁";
        tooltip = false;
        on-click = "killall rofi || ${getExe pkgs.networkmanager_dmenu}";
      };
      "network#speed" = {
        format = " {bandwidthDownBits} ";
        rotate = 90;
        interval = 5;
        tooltip-format = "{ipaddr}";
        tooltip-format-wifi = ''
          {essid} ({signalStrength}%) 󰤨
          {ipaddr} | {frequency} MHz{icon} '';
        tooltip-format-ethernet = ''
          {ifname} 󰈀
          {ipaddr} | {frequency} MHz{icon} '';
        tooltip-format-disconnected = "Not Connected to any type of Network";
        tooltip = true;
        on-click = "killall rofi || ${getExe pkgs.networkmanager_dmenu}";
      };

      bluetooth = {
        format-on = "";
        format-off = "󰂲";
        format-disabled = "";
        format-connected = "<b></b>";
        tooltip-format = ''
          {controller_alias}	{controller_address}

          {num_connections} connected'';
        tooltip-format-connected = ''
          {controller_alias}	{controller_address}

          {num_connections} connected

          {device_enumerate}'';
        tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
        tooltip-format-enumerate-connected-battery = "{device_alias}	{device_address}	{device_battery_percentage}%";
        on-click = "${getExe pkgs.rofi-bluetooth} -theme bluetooth.rasi -i";
      };
      "group/bluetooth" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = true;
        };
        modules = ["bluetooth" "bluetooth#status"];
      };
      "bluetooth#status" = {
        format-on = "";
        format-off = "";
        format-disabled = "";
        format-connected = "<b>{num_connections}</b>";
        format-connected-battery = "<small><b>{device_battery_percentage}%</b></small>";
        tooltip-format = ''
          {controller_alias}	{controller_address}

          {num_connections} connected'';
        tooltip-format-connected = ''
          {controller_alias}	{controller_address}

          {num_connections} connected

          {device_enumerate}'';
        tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
        tooltip-format-enumerate-connected-battery = "{device_alias}	{device_address}	{device_battery_percentage}%";
        on-click = "${getExe pkgs.rofi-bluetooth} -theme bluetooth.rasi -i";
      };
    };
  };
}
