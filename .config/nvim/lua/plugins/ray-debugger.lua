-- Ray distributed debugger (ray-debugger.nvim).
-- Backed by nvim-dap. LazyVim's `lazyvim.plugins.extras.dap.core` is already
-- enabled in lazyvim.json, so nvim-dap and its keymaps are available.
return {
  {
    "2ToTheNthPower/open-ray-debugger",
    name = "ray-debugger.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    -- `keys` makes lazy.nvim lazy-load the plugin; `cmd` makes :RayDebug* load it too.
    cmd = { "RayDebug", "RayDebugAttach", "RayDebugPostMortem", "RayDebugWatch", "RayDebugRefresh" },
    -- Chosen to not clash with LazyVim's DAP keys (<leader>dr is "Toggle REPL").
    keys = {
      { "<leader>dR", function() require("ray-debugger").pick() end, desc = "Ray: Attach to paused task" },
      { "<leader>dW", function() require("ray-debugger").watch() end, desc = "Ray: Toggle watch" },
    },
    opts = {
      dashboard_url = "http://127.0.0.1:8265",
    },
  },
}
