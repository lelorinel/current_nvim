return {
  {
    "milanglacier/minuet-ai.nvim",
    enabled = false,
    event = "InsertEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("minuet").setup {
        provider = "openai_fim_compatible",
        throttle = 1500,
        debounce = 500,
        provider_options = {
          openai_fim_compatible = {
            model = "qwen2.5-coder:1.5b",
            end_point = "http://localhost:11434/v1/completions",
            name = "ollama",
            api_key = "TERM", -- Ollama auth gerektirmez, var olan herhangi bir env var
            optional = {
              max_tokens = 256,
              top_p = 0.9,
            },
          },
        },
      }
    end,
  },
}
