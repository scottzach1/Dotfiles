-- C# via roslyn.nvim — drives the open-source Roslyn language server (not
-- OmniSharp). The server binary is installed as a dotnet global tool
-- (`roslyn-language-server`, see the Phase-2 install notes); this plugin just
-- wires it into the native LSP client and handles .sln/.csproj root detection.
return {
  'seblyng/roslyn.nvim',
  ft = 'cs',
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  opts = {
    -- roslyn.nvim finds `roslyn-language-server` on PATH automatically.
  },
}
