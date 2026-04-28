vim.opt.autoread = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.nu = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.ai = true
vim.opt.si = true
vim.opt.foldenable = false
vim.opt.linebreak = false
vim.opt.breakindent = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = false
vim.g.mapleader = " "
vim.opt.completeopt = "menuone,noinsert,noselect"
-- Avoid showing extra messages when using completion
vim.opt.signcolumn= "yes"
vim.opt.updatetime = 50
vim.opt.background = "dark"
vim.opt.statusline = "%f [byte:%o] %l,%c"

vim.keymap.set('n', 'g[', ':lprev<CR>', {})
vim.keymap.set('n', 'g]', ':lnext<CR>', {})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local has_lazy = vim.loop.fs_stat(lazypath)
if not has_lazy then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_method = 'latexrun'

require("lazy").setup({
  { "ellisonleao/gruvbox.nvim" },

  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-vsnip" },
  { "hrsh7th/vim-vsnip" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },

  { "nvim-telescope/telescope.nvim", dependencies = {
      { "nvim-lua/popup.nvim", lazy = false },
      { "nvim-lua/plenary.nvim", lazy = false },
    }
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
  -- { "ziglang/zig.vim" },
  { "lewis6991/gitsigns.nvim", config = function() require("gitsigns").setup() end },
  { "f-person/git-blame.nvim" },
  {
    "folke/trouble.nvim",
    opts = { auto_close = true },
  },
})

vim.cmd([[colorscheme gruvbox]])

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("zls", {
  capabilities = capabilities,
  -- uncomment only if zls is not on PATH:
  -- cmd = { "/absolute/path/to/zls" },
  settings = {
    zls = {
      -- uncomment only if zig is not on PATH:
      -- zig_exe_path = "/absolute/path/to/zig",
    },
  },
})

vim.lsp.config("clangd", {
    capabilities = capabilities,
})

vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            check = {
                allTargets = false,
            },
        },
    },
})

vim.lsp.config("ols", {
  capabilities = capabilities,
})

vim.lsp.enable("zls")
vim.lsp.enable("clangd")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("ols")

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "path" },
    { name = "buffer" },
  },
})

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

local lsp_keymap_opts = {}
vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, lsp_keymap_opts)
vim.keymap.set('n', 'gD', function() vim.lsp.buf.implementation() end, lsp_keymap_opts)
vim.keymap.set('n', '<c-k>', function() vim.lsp.buf.signature_help() end, lsp_keymap_opts)
vim.keymap.set('n', '1gD', function() vim.lsp.buf.type_definition() end, lsp_keymap_opts)
vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, lsp_keymap_opts)
vim.keymap.set('n', 'g0', function() vim.lsp.buf.document_symbol() end, lsp_keymap_opts)
vim.keymap.set('n', 'gW', function() vim.lsp.buf.workspace_symbol() end, lsp_keymap_opts)
vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, lsp_keymap_opts)
vim.keymap.set('n', 'ge', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Next diagnostic' })
vim.keymap.set('n', 'ga', function() vim.lsp.buf.code_action() end, lsp_keymap_opts)
vim.keymap.set('n', 'gh', '<cmd>LspClangdSwitchSourceHeader<CR>', lsp_keymap_opts)

local telescope_builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>q', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>f', telescope_builtin.git_files, {})
vim.keymap.set('n', '<leader>g', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>r', telescope_builtin.resume, {})

local compile_job = nil
local cmake_compiler_cache = {}

local function shell_argv(command)
  local argv = { vim.o.shell }
  vim.list_extend(argv, vim.fn.split(vim.o.shellcmdflag))
  table.insert(argv, command)
  return argv
end

local function get_qflist_items()
  return vim.fn.getqflist({ items = 1 }).items
end

local function current_buffer_path(buffer)
  return vim.api.nvim_buf_get_name(buffer)
end

local function project_root(buffer)
  return vim.fs.root(current_buffer_path(buffer), { 'build.sh', 'CMakeLists.txt', '.git' })
end

local function buster_build_directory()
  return vim.env.BUSTER_BUILD_DIRECTORY or 'build'
end

local function cmake_cache_path(root)
  return root .. '/' .. buster_build_directory() .. '/CMakeCache.txt'
end

local function file_mtime_nanoseconds(path)
  local stat = vim.uv.fs_stat(path)
  if stat == nil or stat.mtime == nil then
    return nil
  end

  return stat.mtime.sec * 1000000000 + stat.mtime.nsec
end

local function cmake_cache_value(path, key)
  if vim.fn.filereadable(path) == 0 then
    return nil
  end

  for _, line in ipairs(vim.fn.readfile(path)) do
    local value = line:match("^" .. key .. ":[^=]+=(.*)$")
    if value ~= nil then
      return value
    end
  end

  return nil
end

local function compiler_from_cmake(buffer, root)
  if root == nil then
    return nil
  end

  local path = cmake_cache_path(root)
  local mtime = file_mtime_nanoseconds(path)
  if mtime == nil then
    return nil
  end

  local cached = cmake_compiler_cache[path]
  if cached ~= nil and cached.mtime == mtime then
    return cached.compiler
  end

  local keys = { 'CMAKE_C_COMPILER' }
  if vim.bo[buffer].filetype == 'cpp' then
    keys = { 'CMAKE_CXX_COMPILER', 'CMAKE_C_COMPILER' }
  end

  local compiler = nil
  for _, key in ipairs(keys) do
    local compiler_path = cmake_cache_value(path, key)
    if compiler_path ~= nil and compiler_path ~= '' then
      compiler = vim.fs.basename(compiler_path)
      break
    end
  end

  cmake_compiler_cache[path] = {
    mtime = mtime,
    compiler = compiler,
  }

  return compiler
end

local function set_cmake_compiler_options(buffer, root)
  local compiler = compiler_from_cmake(buffer, root)

  if compiler == 'tcc' then
    vim.bo[buffer].errorformat = table.concat({
      '%E%f:%l: error: %m',
      '%W%f:%l: warning: %m',
      '%I%f:%l: note: %m',
    }, ',')
  else
    vim.api.nvim_buf_call(buffer, function()
      vim.cmd('compiler gcc')
    end)
  end

  return compiler
end

local function current_errorformat()
  local local_efm = vim.bo.errorformat
  if local_efm ~= nil and local_efm ~= "" then
    return local_efm
  end
  return vim.o.errorformat
end

local function populate_qflist(title, output, efm, fallback_to_raw)
  local lines = vim.split(output or "", "\n", { plain = true, trimempty = true })
  vim.fn.setqflist({}, " ", { title = title, lines = lines, efm = efm })

  local items = get_qflist_items()
  if #items == 0 and fallback_to_raw and #lines > 0 then
    local raw_items = {}
    for _, line in ipairs(lines) do
      table.insert(raw_items, { text = line })
    end
    vim.fn.setqflist({}, " ", { title = title, items = raw_items })
    items = get_qflist_items()
  end

  return items
end

local function close_qflist_view()
  local ok, trouble = pcall(require, "trouble")
  if ok and trouble.is_open("qflist") then
    trouble.close("qflist")
  else
    vim.cmd("cclose")
  end
end

local function open_qflist_view()
  local ok, trouble = pcall(require, "trouble")
  if ok then
    trouble.open({ mode = "qflist", focus = false })
  else
    vim.cmd("cwindow")
  end
end

local function jump_to_first_valid_qf_item(items)
  local first_valid = nil
  for index, item in ipairs(items) do
    if item.valid == 1 then
      first_valid = first_valid or index
      if string.upper(item.type or "") == "E" then
        vim.cmd(("silent cc %d"):format(index))
        return true
      end
    end
  end
  if first_valid then
    vim.cmd(("silent cc %d"):format(first_valid))
    return true
  end
  return false
end

local function run_async_compile(command, title, options)
  options = options or {}

  if compile_job then
    vim.notify(("%s already running"):format(compile_job.title), vim.log.levels.WARN)
    return
  end

  vim.cmd("silent! wall")

  local efm = current_errorformat()
  vim.notify(("%s started"):format(title), vim.log.levels.INFO)
  local start_time = vim.uv.hrtime()
  compile_job = { title = title }

  vim.system(shell_argv(command .. " 2>&1"), { cwd = options.cwd, text = true }, function(obj)
    vim.schedule(function()
      compile_job = nil
      local elapsed_ms = (vim.uv.hrtime() - start_time) / 1000000
      local end_date = os.date("%H:%M:%S")

      local items = populate_qflist(title, obj.stdout or "", efm, obj.code ~= 0)

      if #items == 0 then
        close_qflist_view()
      else
        open_qflist_view()
        jump_to_first_valid_qf_item(items)
      end

      vim.notify(("%s finished (returned %d) in %.1f ms at %s"):format(title, obj.code, elapsed_ms, end_date), vim.log.levels.INFO)
    end)
  end)
end

vim.api.nvim_create_autocmd('QuickFixCmdPre', {
  pattern = 'make',
  callback = function() vim.cmd('silent! wall') end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function()
    vim.cmd('compiler cargo')
    vim.keymap.set('n', '<leader>c', function() run_async_compile('cargo check', 'cargo check') end,
      { buffer = true, desc = 'cargo check' })
    vim.keymap.set('n', '<leader>b', function() run_async_compile('cargo build', 'cargo build') end,
      { buffer = true, desc = 'cargo build' })
    vim.keymap.set('n', '<leader>r', '<cmd>silent make run<cr>',
      { buffer = true, desc = 'cargo run' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'zig',
  callback = function()
    vim.cmd('compiler zig')
    vim.keymap.set('n', '<leader>c', function() run_async_compile('zig build', 'zig build') end,
      { buffer = true, desc = 'zig build' })
    vim.keymap.set('n', '<leader>b', function() run_async_compile('zig build', 'zig build') end,
      { buffer = true, desc = 'zig build' })
    vim.keymap.set('n', '<leader>r', '<cmd>make run<cr>', { buffer = true, desc = 'zig run' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp' },
  callback = function(args)
    local root = project_root(args.buf)
    if root == nil then
      return
    end

    set_cmake_compiler_options(args.buf, root)
    vim.bo[args.buf].makeprg = './build.sh --quiet'

    vim.keymap.set('n', '<leader>c', function()
      run_async_compile('./build.sh --quiet', 'build.sh', { cwd = root })
    end, { buffer = args.buf, desc = 'build.sh --quiet' })

    vim.keymap.set('n', '<leader>b', function()
      run_async_compile('./build.sh --quiet', 'build.sh', { cwd = root })
    end, { buffer = args.buf, desc = 'build.sh --quiet' })
  end,
})
