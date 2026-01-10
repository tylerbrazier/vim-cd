# vim-cd

Type `cd` to change to recent directories.

The mapping starts `:ChDir` which works like `:lcd`
but with completion that shows directories in most recently used order.

History is persisted to a local file. Use `:ChHist` to edit it.
The plugin will reload the history when you write to the file,
so you can use this for cleanup.

## TODO

- completion should include local dirs too (not just history)
- allow disabling dirs from history e.g. use `0` for the timestamp
- write to history (actually merge) when going to a new dir instead of on exit
