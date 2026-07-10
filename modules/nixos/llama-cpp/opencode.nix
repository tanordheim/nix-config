{ config, ... }:
{
  imports = [ ../../common/opencode ];

  home-manager.sharedModules = [
    {
      opencode.providers.llamacpp = {
        npm = "@ai-sdk/openai-compatible";
        name = "llama.cpp (harahorn)";
        options.baseURL = "http://127.0.0.1:${toString config.services.llama-cpp.settings.port}/v1";
        models.qwen3-coder-30b.name = "Qwen3-Coder-30B-A3B (local)";
      };
    }
  ];
}
