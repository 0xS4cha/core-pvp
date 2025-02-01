
local function shiftCoronaDesc()
    BeginScaleformMovieMethodOnFrontendHeader("SHIFT_CORONA_DESC");
    ScaleformMovieMethodAddParamBool(true);
    ScaleformMovieMethodAddParamBool(true);
    EndScaleformMovieMethod();

    BeginScaleformMovieMethodOnFrontendHeader("SET_HEADER_TITLE");
    ScaleformMovieMethodAddParamTextureNameString("");
    ScaleformMovieMethodAddParamBool(true);
    EndScaleformMovieMethod();

    PushScaleformMovieFunctionParameterString("");
    ScaleformMovieMethodAddParamBool(true);
    EndScaleformMovieMethod();

    BeginScaleformMovieMethodOnFrontend("SET_HEADING_DETAILS");
    ScaleformMovieMethodAddParamTextureNameString("");
    ScaleformMovieMethodAddParamTextureNameString("");
    ScaleformMovieMethodAddParamTextureNameString("");
    ScaleformMovieMethodAddParamBool(false);
    EndScaleformMovieMethod();
end
local TEXTURE_DICT = "logo_nobackground";
local TEXTURE_FILE = "core_ui";
local Width = '152';
local Height = '52';
local function setLogoMap()
    RequestStreamedTextureDict(TEXTURE_FILE, true);
    while (not HasStreamedTextureDictLoaded(TEXTURE_FILE)) do
        Wait(0);
    end

    BeginScaleformMovieMethodOnFrontendHeader("SET_HEADER_TITLE");
    AddTextEntry("FE_THDR_GTAO","<img src='img://"..TEXTURE_FILE.."/"..TEXTURE_DICT.."' width="..Width.." height="..Height.." />");
    ScaleformMovieMethodAddParamTextureNameString("FE_THDR_GTAO");
    ScaleformMovieMethodAddParamBool(false);
    ScaleformMovieMethodAddParamTextureNameString("");
    ScaleformMovieMethodAddParamBool(false);
    ScaleformMovieMethodAddParamBool(true);
    EndScaleformMovieMethod();

    shiftCoronaDesc();
end
CreateThread(function()
    ReplaceHudColourWithRgba(116, _CONFIG.RGBA.LINE.RED, _CONFIG.RGBA.LINE.GREEN, _CONFIG.RGBA.LINE.BLUE, _CONFIG.RGBA.LINE.ALPHA)
    ReplaceHudColourWithRgba(117, _CONFIG.RGBA.STYLE.RED, _CONFIG.RGBA.STYLE.GREEN, _CONFIG.RGBA.STYLE.BLUE, _CONFIG.RGBA.STYLE.ALPHA)
    ReplaceHudColourWithRgba(142, _CONFIG.RGBA.WAYPOINT.RED, _CONFIG.RGBA.WAYPOINT.GREEN, _CONFIG.RGBA.WAYPOINT.BLUE, 0)

    ReplaceHudColourWithRgba(117, _CONFIG.RGBA.WAYPOINT.RED, _CONFIG.RGBA.WAYPOINT.GREEN, _CONFIG.RGBA.WAYPOINT.BLUE, 100)
    setLogoMap()

    
end)

