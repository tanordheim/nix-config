{ pkgs, ... }:
{
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp.override { vulkanSupport = true; };
    settings = {
      hf-repo = "unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q4_K_M";
      alias = "qwen3-coder-30b";
      jinja = true;
      n-gpu-layers = 999;
      n-cpu-moe = 24;
      flash-attn = "on";
      ctx-size = 65536;
      cache-type-k = "q8_0";
      cache-type-v = "q8_0";
      temp = "0.7";
      top-p = "0.8";
      top-k = 20;
      repeat-penalty = "1.05";
    };
  };

  systemd.services.llama-cpp.environment.XDG_CACHE_HOME = "/var/cache/llama-cpp";
}
