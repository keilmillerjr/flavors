// --------------------
// Load Modules
// --------------------
if (fe.load_module("Debug")) log <- Log();
fe.load_module("shader");
fe.load_module("helpers");
fe.load_module("fade");

// --------------------
// Layout User Options
// --------------------
class UserConfig {
	</ label="Primary Color",
		help="Select a color scheme.",
		options="blue, blue_green, green, yellow_green, yellow, yellow_orange, orange, red_orange, red, red_violet, violet, blue_violet",
		order=1 />
	primaryColor="red";

	</ label="Breadcrumbs",
		help="Magic tokens to display as breadcrumbs.",
		order=2 />
	breadcrumbs="[DisplayName] > [FilterName] > [Title]";
	
	</ label="Enable Marquee",
		help="Enable use of marquee.",
		options="Yes, No",
		order=3 />
	enableMarquee="No";
	
	</ label="Enable Artwork",
		help="Enable use of artwork.",
		options="Yes, No",
		order=4 />
	enableArtwork="Yes";
	
	</ label="Artwork Type",
		help="Select an artwork type to display.",
		order=5 />
	artworkType="wheel";
	
	</ label="Enable CRT Shader on Background",
		help="Snap and Artwork is simulated to look like it is being displayed on a crt.",
		options="Yes, No",
		order=6 />
	enableBackgroundShader="Yes";
	
	</ label="Enable CRT Shader on Marquee",
		help="Marquee is simulated to look like it is being displayed on a crt.",
		options="Yes, No",
		order=7 />
	enableMarqueeShader="No";
	
	</ label="CRT Shader Resolution",
		help="Select CRT resolution.",
		options="640x480, 320x240",
		order=8 />
	shaderResolution="320x240";
}
local config = fe.get_config();

// --------------------
// Layout Constants
// --------------------
local flw = fe.layout.width;
local flh = fe.layout.height;
fe.layout.font = "Alégre Sans Bold NC";

// --------------------
// Colors
// --------------------
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

// --------------------
// Settings
// --------------------
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
		y = percentage(52, flh),
		width = percentage(36, flw),
		height = percentage(29, flh),
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
	headerAlt = {
		height = percentage(42, flh),
	},
	marquee = {
		x = 0,
		y = percentage(2, flh),
		width = flw,
		height = percentage(38, flh),
	},
	gradientTop = {
		x = 0,
		y = percentage(2, flh),
		width = flw,
		height = percentage(10, flh),
	},
	gradientTopAlt = {
		y = percentage(42, flh),
	},
	gradientBottom = {
		x = 0,
		y = percentage(83, flh),
		width = flw,
		height = percentage(17, flh),
	},
	breadcrumbs = {
		x = 0,
		y = percentage(3, flh),
		width = percentage(80, flw),
		height = percentage(8, flh),
		red = colors.white.r, green = colors.white.g, blue = colors.white.b,
		align = Align.Left,
	},
	breadcrumbsAlt = {
		y = percentage(43, flh),
	},
	count = {
		x = percentage(80, flw),
		y = percentage(3, flh),
		width = percentage(20, flw),
		height = percentage(8, flh),
		red = colors.white.r, green = colors.white.g, blue = colors.white.b,
		align = Align.Right,
	},
	countAlt = {
		y = percentage(43, flh),
	},
	published = {
		x = 0,
		y = percentage(82, flh),
		width = percentage(50, flw),
		height = percentage(8, flh),
		red = colors[colors.primary].r, green = colors[colors.primary].g, blue = colors[colors.primary].b,
		align = Align.Left,
	},
	favorite = {
		x = percentage(50, flw),
		y = percentage(82, flh),
		width = percentage(50, flw),
		height = percentage(8, flh),
		red = colors.yellow.r, green = colors.yellow.g, blue = colors.yellow.b,
		align = Align.Right,
		font = "FontAwesome",
	},
	divider = {
		x = percentage(1, flw),
		y = percentage(90.375, flh),
		width = percentage(98, flw),
		height = percentage(0.25, flh),
		red = colors[colors.primary].r, green = colors[colors.primary].g, blue = colors[colors.primary].b,
	},
	category = {
		x = 0,
		y = percentage(91, flh),
		width = percentage(50, flw),
		height = percentage(8, flh),
		red = colors.white.r, green = colors.white.g, blue = colors.white.b,
		align = Align.Left,
	},
	playTime = {
		x = percentage(50, flw),
		y = percentage(91, flh),
		width = percentage(50, flw),
		height = percentage(8, flh),
		red = colors.grey.r, green = colors.grey.g, blue = colors.grey.b,
		align = Align.Right,
	},
}

// --------------------
// Magic Functions
// --------------------
function favoriteString() {
	return fe.game_info(Info.Favourite) == "1" ? "" : "";
}

// --------------------
// Layout
// --------------------
local background = fe.add_surface(settings.background.width, settings.background.height);
	setProperties(background, settings.background);

local snap = FadeArt("snap", -1, -1, 1, 1, background);
	setProperties(snap, settings.snap);

if (toBool(config["enableArtwork"])) {
	local artwork = FadeArt(config["artworkType"], -1, -1, 1, 1, background);
		setProperties(artwork, settings.artwork);
}

local shade = background.add_image("white.png", -1, -1, 1, 1);
	setProperties(shade, settings.shade);

local header = fe.add_image("white.png", -1, -1, 1, 1);
	setProperties(header, settings.header);
	if (toBool(config["enableMarquee"])) setProperties(header, settings.headerAlt);

local marquee = null;
if (toBool(config["enableMarquee"])) {
	marquee = fe.add_artwork("marquee", -1, -1, 1, 1);
		setProperties(marquee, settings.marquee);
}

local gradientTop = fe.add_image("gradient-top.png", -1, -1, 1, 1);
	setProperties(gradientTop, settings.gradientTop);
	if (toBool(config["enableMarquee"])) setProperties(gradientTop, settings.gradientTopAlt);

local gradientBottom = fe.add_image("gradient-bottom.png", -1, -1, 1, 1);
	setProperties(gradientBottom, settings.gradientBottom);

local breadcrumbs = fe.add_text(config["breadcrumbs"], -1, -1, 1, 1);
	setProperties(breadcrumbs, settings.breadcrumbs);
	if (toBool(config["enableMarquee"])) setProperties(breadcrumbs, settings.breadcrumbsAlt);

local count = fe.add_text("[ListEntry] of [ListSize]", -1, -1, 1, 1);
	setProperties(count, settings.count);
	if (toBool(config["enableMarquee"])) setProperties(count, settings.countAlt);

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

// --------------------
// Enable Shaders
// --------------------
if (fe.load_module("shader")) {
	if (isLayoutVertical()) {
		config["shaderResolution"] = reverseRes(config["shaderResolution"]);
	}
	if (toBool(config["enableBackgroundShader"])) {
		local backgroundShader = CrtLottes(splitRes(config["shaderResolution"], "width"), splitRes(config["shaderResolution"], "height"));
		background.shader = backgroundShader.shader;
	}
	
	if (toBool(config["enableMarqueeShader"])) {
		local marqueeShader = CrtLottes(splitRes(config["shaderResolution"], "width"), settings.marquee.height);
		marquee.shader = marqueeShader.shader;
	}
}

