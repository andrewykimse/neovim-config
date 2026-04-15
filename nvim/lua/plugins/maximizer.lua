return {
  'declancm/maximize.nvim',
  keys = {
    {
      '<leader>m',
      function()
        require('maximize').toggle()
      end,
      desc = 'Toggle Maximize',
    },
  },
  opts = {},
}
