## Flyawesome
Just one them for awesomewm inspired adi1090x's polybar themes and manilarome's the-glorious-files.

## Install
### Required dependencies
+ [picom-git](https://github.com/yshui/picom): A lightweight compositor for X11 
+ [rofi-git](https://github.com/davatorium/rofi): A window switcher, application launcher and dmenu replacement 
+ [awesome-git](https://github.com/awesomeWM/awesome): awesome window manager
+ [feh](https://feh.finalrewind.org/): a fast and light image viewer,used to set wallpaper here
+ [DBus](https://www.freedesktop.org/wiki/Software/dbus/): D-Bus is a message bus system, a simple way for applications to talk to one another.Installed automatically on many distros.
+ [GeoClue2](https://gitlab.freedesktop.org/geoclue/geoclue/-/wikis/home): A DBus service that provides geo location info
+ [redshift](https://github.com/jonls/redshift): To save your eyes
### Fonts
+ [Alarm Clock](https://www.dafont.com/alarm-clock.font)
+ [Apple's developer font](https://developer.apple.com/fonts/)

### Icon theme
+ [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
### Place config files
#### clone the repo
`git clone --depth=1 https://github.com/RMTT/flyawesome.git`
#### move files
`cp -r flyawesome ~/.config/awesome`
`cp -r flyawesome/example ~/.config/flyawesome`

## Update
Just pull from this repo, and see changes of config file

## Configuration
The most configuration items are placed in the `flyawesome/config.lua`,you should 
move it to default `$XDG_CONFIG_HOME`(`$HOME/.config`).

### Modules
#### Wallpaper
> Wallpaper in this theme, named 24 hours wallpaper, inspired by 
>[24 hours wallpaper](https://github.com/t1m0thyj/WinDynamicDesktop),
>will changed wallpaper by your location time.

The configuration for wallpaper, you can find it on the end of `config.lua`,is
 a lua table:
 ```lua
    wallpaper = {
        mode = "auto",
        timezone = 8,
        latitude = 0,
        longitude = 0,
        theme = "YourName"
    }
 ```
+ mode: "auto" or "manual", if "auto", it will use GeoClue2 service to get geoinfo, if "manual", you need fill the 
`latitude` and `longitude` filed.
+ timezone: the hours different to UTC, for example, if you are in `UTF-7`,just using -7 to this filed.

For more information, see [wiki](https://github.com/RMTT/flyawesome/wiki/Wallpaper-themes)
## Features
+ Dropdown terminal
+ 24 hours wallpaper

## Todo
- [ ] lockscreen module
- [ ] power manager module and widget
- [ ] sound volume control
- [ ] brightness control
- [ ] notification beautify

## Other Apps for you making a great experience on Linux
+ Flameshot : A very good screenshot software.
+ Master PDF Editor : PDF Viewer and Editor, also can annotate pdf and so on.
+ XMind : Making mindmaps on Linux, when you see papers or studying :)
+ Thunderbird : Email and RSS client
+ Dolphin : File Manager
+ Alacritty: A good terminal
+ Qt5ct and Kvantum Manager : Manage qt5 themes
+ lxappearance : Manage gtk themes
> If you are using Arch Linux, you can find all on AUR or Official repo :)
### Current preview
![preview](https://i.imgur.com/TAvg49h.png)

