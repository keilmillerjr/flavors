# flavors layout for AttractMode front end

by [Keil Miller Jr](http://keilmillerjr.com)

![Image of layout](layout.png)

## DESCRIPTION:

flavors is a simple layout for the [AttractMode](http://attractmode.org) front end. It has 12 different user selectable "flavors". Layout looks nicely with both vertical and horizontal orientations. Any resolution qvga (240p) and upwards works well. Any lower resolution and text would be unreadable. Make sure the crt shader is not enabled if you are using this layout on a crt monitor.

## Paths

You may need to change file paths as necessary as each platform (windows, mac, linux) has a slightly different directory structure.

## Install Files

1. Copy layout files to `$HOME/.attract/layouts/flavors/`.
2. The [Debug module](https://github.com/keilmillerjr/debug-module) is optional. It is recommended for debugging.
3. The [Shader module](https://github.com/keilmillerjr/shader-module) is optional. It is required for you to install it if you intend to use crt shaders within the layout.
4. The [Helpers module](https://github.com/keilmillerjr/helpers-module) is REQUIRED for you to install. The layout will not work correctly without it.
5. The fade module is required. It is included with attractmode by default. No additional install is required.

## Usage

You can enable the flavors layout by running Attract Mode and pressing the tab key to enter the configure menu. Navigate to `Displays -> Display Name -> Layout`. Enable the layout and set your `Layout Options`. This layout is oriented towards the use of mame, and usage of catver.ini is currently required. This will soon change in a future commit.

## Notes

Inspiration for this theme came from the [unnamed theme](http://forum.attractmode.org/index.php?topic=1231.0) by [liquid8d](http://forum.attractmode.org/index.php?action=profile;u=4)

CRT-Lottes Shader by Timothy Lottes, converted to MAME and AttractMode FE by Luke-Nukem.
