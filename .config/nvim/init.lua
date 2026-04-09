vim.opt.hlsearch = false
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.autowrite = true

vim.pack.add({
	"https://github.com/fatih/vim-go",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/neovim/nvim-lspconfig",
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('gopls')
vim.lsp.enable('emmet_language_server')

vim.keymap.set("n","<leader>e", vim.diagnostic.open_float, {bufnr = bufnr})


require("mason").setup()

-- Define an autocommand group to prevent duplicate autocmds
vim.api.nvim_create_augroup("LspFormatting", { clear = true })

-- Create an autocommand that fires when an LSP client attaches to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspFormatting",
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Check if the client supports formatting and auto-formatting is desired
    if client and client.server_capabilities.documentFormattingProvider then
      -- Create another autocommand for BufWritePre (before saving)
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = "LspFormatting",
        buffer = bufnr,
        callback = function()
          -- Format the buffer using the attached LSP client
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"html", "css", "javascript", "yaml", "javascriptreact", "typescript", "typescriptreact"},
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

