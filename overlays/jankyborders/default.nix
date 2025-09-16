{ jankyborders-src, ... }:
final: prev: {
  jankyborders = prev.jankyborders.overrideAttrs (_old: {
    src = jankyborders-src;
    version = "head";
    buildInputs = [ prev.apple-sdk_15 ];
  });
}
