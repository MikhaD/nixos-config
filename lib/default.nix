{lib, ...}: rec {
  /**
  The same as lib.mkEnableOption, but defaults to true.
  */
  mkEnableOptionTrue = name:
    lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Whether to enable ${name}.";
    };

  /**
  Normalize a hex color string to the full 6- or 8-digit uppercase form with leading "#".
  Input string does not need leading "#", and can be in 3-, 4-, 6-, or 8-digit form.
  */
  normalizeHexColor = str: let
    hexChars = lib.stringToCharacters "0123456789ABCDEF";
    isValidHex = str: lib.elem (lib.stringLength str) [3 4 6 8] && (str |> lib.toUpper |> lib.stringToCharacters |> lib.all (c: lib.elem c hexChars));
    expandHex = s: s |> lib.stringToCharacters |> map (c: c + c) |> lib.concatStrings;
    s =
      if lib.substring 0 1 str == "#"
      then lib.substring 1 (lib.stringLength str) str
      else str;
    len = lib.stringLength s;
  in "#${lib.toUpper (
    if !(isValidHex s)
    then throw "Invalid hex color string: ${str}"
    else if len == 3 || len == 4
    then expandHex s
    else s
  )}";

  /**
  Convert a 6 digit hex color string prefixed with "#" to "R;G;B" format for bash.
  */
  hexToRGB = str: let
    hexFromSubstring = start: end: str: lib.substring start end str |> lib.trivial.fromHexString;
    hex = normalizeHexColor str;
    s = lib.substring 1 (lib.stringLength hex) hex;
    red = hexFromSubstring 0 2 s;
    green = hexFromSubstring 2 2 s;
    blue = hexFromSubstring 4 2 s;
  in "${toString red};${toString green};${toString blue}";

  /**
  Create a hex color option with normalization.
  */
  mkHexColorOption = default: description:
    lib.mkOption {
      type = lib.types.str;
      inherit default description;
      example = "#008080";
      apply = normalizeHexColor;
    };

  /**
  Create a bash color option that converts hex to "R;G;B".
  */
  mkBashColorOption = default: description: (mkHexColorOption default description) // {apply = hexToRGB;};
}
