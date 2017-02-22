// Layout User Options
class UserConfig {
	</ label="Primary Color",
		help="Select a color scheme.",
		options="blue, blue_green, green, yellow_green, yellow, yellow_orange, orange, red_orange, red, red_violet, violet, blue_violet",
		order=1 />
	primaryColor="red";
	
	</ label="Artwork",
		help="Select an artwork type to display for game.",
		order=2 />
	artwork="wheel";
	
	</ label="Enable CRT Shader",
		help="Snap is simulated to look like it is beind displayed on a crt.",
		options="Yes, No",
		order=3 />
	enableShader="Yes";
	
	</ label="CRT Shader Resolution",
		help="Select CRT resolution.",
		options="640x480, 320x240",
		order=4 />
	shaderResolution="320x240";
}
local config = fe.get_config();

// Percentages of A Value
function percentage(percent, value) {
	if (percent == 0) return 0;
	return (percent / 100.0) * value.tofloat();
}

// Convert Yes and No to True and False
function yesNo(x) {
	x = x.tolower();
	if (x == "yes") return true;
	return false;
}

// Seperate X and Y Resolutions
function splitRes(var, type) {
	local s = split(var, "x");
	if (type == "width") return s[0].tointeger();
	if (type == "height") return s[1].tointeger();
}

// Set Properties On An Object
function setProperties(target, properties) {
	foreach(key, value in properties) {
		try {
			target[key] = value;
		}
		catch(e) {
			"error setting property: " + key;
		}
	}
}

// Colors
local colors = {
	black = { r = 0, g = 0, b = 0 },
	white = { r = 255, g = 255, b = 255 },
	grey = { r = 120, g = 120, b = 120 },
	
	primary = config["primaryColor"],
	
	blue = { r = 0, g = 88, b = 209 },
	blue_green = { r = 0, g = 159, b = 209 },
	green = { r = 2, g = 209, b = 77 },
	yellow_green = { r = 177, g = 235, b = 0 },
	yellow = { r = 255, g = 254, b = 0 },
	yellow_orange = { r = 255, g = 203, b = 0 },
	orange = { r = 255, g = 152, b = 0 },
	red_orange = { r = 255, g = 101, b = 0 },
	red = { r = 255, g = 0, b = 1 },
	red_violet = { r = 221, g = 0, b = 131 },
	violet = { r = 138, g = 0, b = 209 },
	blue_violet = { r = 34, g = 0, b = 209 },
}

// Return Favorite String If Game Is Favorite
function favoriteString() {
	if (fe.game_info(Info.Favourite) == "1") return "";
	return "";
}

// Declare Shader
local shader = fe.add_shader(Shader.VertexAndFragment, "CRT-lottes.vsh", "CRT-lottes_rgb32_dir.fsh");
	// CURVATURE
	// 0 = Flat
	// 1.0 = Curved
	shader.set_param("CURVATURE", 0);
	// APERATURE_TYPE
	// 0 = VGA style shadow mask.
	// 1.0 = Very compressed TV style shadow mask.
	// 2.0 = Aperture-grille.
	shader.set_param("aperature_type", 2.0);
	shader.set_param("distortion", 0.1);
	// Size of corners
	shader.set_param("cornersize", 0.038);
	// Smoothing corners (100-1000)
	shader.set_param("cornersmooth", 400.0);
	// Hardness of Scanline -8.0 = soft -16.0 = medium
	shader.set_param("hardScan", -10.0);
	// Hardness of pixels in scanline -2.0 = soft, -4.0 = hard
	shader.set_param("hardPix", -2.3);
	//Sets how dark a "dark subpixel" is in the aperture pattern.
	shader.set_param("maskDark", 0.4);
	//Sets how dark a "bright subpixel" is in the aperture pattern
	shader.set_param("maskLight", 1.3);
	// 1.0 is normal saturation. Increase as needed.
	shader.set_param("saturation", 1..25);
	//0.0 is 0.0 degrees of Tint. Adjust as needed.
	shader.set_param("tint", 0.1);
	//Drops the final color value by this amount if GAMMA_CONTRAST_BOOST is defined
	shader.set_param("blackClip", 0.08);
	//Multiplies the color settings by this amount if GAMMA_CONTRAST_BOOST is defined
	shader.set_param("brightMult", 1.25);

	// Standard Shader stuff. Can probably send image.width to shader
	shader.set_param("color_texture_sz", splitRes(config["shaderResolution"], "width"), splitRes(config["shaderResolution"], "height"));
	shader.set_param("color_texture_pow2_sz", splitRes(config["shaderResolution"], "width"), splitRes(config["shaderResolution"], "height"));
	shader.set_texture_param("mpass_texture");

// Layout Constants
local flw = fe.layout.width;
local flh = fe.layout.height;
fe.layout.font = "Alégre Sans Bold NC";

// Settings
local settings = {
	background = {
		x = 0,
		y = 0,
		width = flw,
		height = flh,
	},
	snap = {
		x = 0,
		y = 0,
		width = flw,
		height = flh,
	},
	artwork = {
		x = percentage(4, flw),
		y = percentage(54, flh),
		width = percentage(33, flw),
		height = percentage(33, flh),
		preserve_aspect_ratio = true,
	},
	shade = {
		x = 0,
		y = 0,
		width = flw,
		height = flh,
		red = colors.black.r, green = colors.black.g, blue = colors.black.b,
		alpha = percentage(25, 255),
	}
	header = {
		x = 0,
		y = 0,
		width = flw,
		height = percentage(2, flh),
		red = colors[colors.primary].r, green = colors[colors.primary].g, blue = colors[colors.primary].b,
	},
	gradientTop = {
		x = 0,
		y = percentage(2, flh),
		width = flw,
		height = percentage(4, flh),
	},
	gradientBottom = {
		x = 0,
		y = percentage(80, flh),
		width = flw,
		height = percentage(20, flh),
	},
	breadcrumbs = {
		x = 0,
		y = percentage(3, flh),
		width = percentage(80, flw),
		height = percentage(6, flh),
		red = colors.white.r, green = colors.white.g, blue = colors.white.b,
		align = Align.Left,
	},
	count = {
		x = percentage(80, flw),
		y = percentage(3, flh),
		width = percentage(20, flw),
		height = percentage(6, flh),
		red = colors.white.r, green = colors.white.g, blue = colors.white.b,
		align = Align.Right,
	},
	published = {
		x = 0,
		y = percentage(88, flh),
		width = percentage(50, flw),
		height = percentage(5, flh),
		red = colors[colors.primary].r, green = colors[colors.primary].g, blue = colors[colors.primary].b,
		align = Align.Left,
	},
	favorite = {
		x = percentage(50, flw),
		y = percentage(88, flh),
		width = percentage(50, flw),
		height = percentage(5, flh),
		red = colors.yellow.r, green = colors.yellow.g, blue = colors.yellow.b,
		align = Align.Right,
		font = "FontAwesome",
	},
	divider = {
		x = percentage(1, flw),
		y = percentage(93.375, flh),
		width = percentage(98, flw),
		height = percentage(0.25, flh),
		red = colors[colors.primary].r, green = colors[colors.primary].g, blue = colors[colors.primary].b,
	},
	category = {
		x = 0,
		y = percentage(94, flh),
		width = percentage(50, flw),
		height = percentage(5, flh),
		red = colors.white.r, green = colors.white.g, blue = colors.white.b,
		align = Align.Left,
	},
	playTime = {
		x = percentage(50, flw),
		y = percentage(94, flh),
		width = percentage(50, flw),
		height = percentage(5, flh),
		red = colors.grey.r, green = colors.grey.g, blue = colors.grey.b,
		align = Align.Right,
	},
}

// Load Debug Module
local log = null;
if (fe.load_module("Debug")) log = Log();

// Load Layout Required Modules
fe.load_module("fade"); 

// Leap over filters with a list size of zero
class Leap {
	exception = "";

	constructor(e="All") {
		exception = e;

		fe.add_transition_callback(this, "transitions");
	}

	function transitions(ttype, var, ttime) {
		if (ttype == Transition.StartLayout || Transition.ToNewSelection || Transition.ToNewList) logic();
	}

	function logic() {
		if ((fe.filters[fe.list.filter_index].name != exception) && (fe.list.size == 0)) {
			try { log.send("Skipping the " + fe.filters[fe.list.filter_index].name + " filter because the list size is " + fe.list.size + "."); } catch(e) {}
			fe.signal("next_filter");
		}
	}
}
local leap = Leap();

// Layout
local background = fe.add_surface(settings.background.width, settings.background.height);
	setProperties(background, settings.background);
	if (yesNo(config["enableShader"])) background.shader = shader;

local snap = FadeArt("snap", -1, -1, 1, 1, background);
	setProperties(snap, settings.snap);

local artwork = background.add_artwork(config["artwork"], -1, -1, 1, 1);
	setProperties(artwork, settings.artwork);

local shade = background.add_image("white.png", -1, -1, 1, 1);
	setProperties(shade, settings.shade);

local header = fe.add_image("white.png", -1, -1, 1, 1);
	setProperties(header, settings.header);

local gradientTop = fe.add_image("gradient-top.png", -1, -1, 1, 1);
	setProperties(gradientTop, settings.gradientTop);

local gradientBottom = fe.add_image("gradient-bottom.png", -1, -1, 1, 1);
	setProperties(gradientBottom, settings.gradientBottom);

local breadcrumbs = fe.add_text("[DisplayName] > [FilterName] > [Title]", -1, -1, 1, 1);
	setProperties(breadcrumbs, settings.breadcrumbs);

local count = fe.add_text("[ListEntry] of [ListSize]", -1, -1, 1, 1);
	setProperties(count, settings.count);

local published = fe.add_text("[Year] [Manufacturer]", -1, -1, 1, 1);
	setProperties(published, settings.published);

local favorite = fe.add_text("[!favoriteString]", -1, -1, 1, 1);
	setProperties(favorite, settings.favorite);

local divider = fe.add_image("white.png", -1, -1, 1, 1);
	setProperties(divider, settings.divider);

local category = fe.add_text("[Players]P [Category]", -1, -1, 1, 1);
	setProperties(category, settings.category);

local playTime = fe.add_text("Played For [PlayedTime]", -1, -1, 1, 1);
	setProperties(playTime, settings.playTime);
