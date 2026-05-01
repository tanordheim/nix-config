{ ... }:
final: prev: {
  voxtype = prev.voxtype.overrideAttrs (old: {
    cargoBuildFeatures = (old.cargoBuildFeatures or [ ]) ++ [ "gpu-vulkan" ];

    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.shaderc ];

    buildInputs = (old.buildInputs or [ ]) ++ (with prev; [
      shaderc
      vulkan-headers
      vulkan-loader
    ]);
  });
}
