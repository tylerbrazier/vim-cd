# vim-cd

Type `cd` to change to recent directories. History is persisted when vim exits.

The mapping starts `:Cd` which works like `:lcd` but with completion that:

- shows directories in most recently used order
- filters matches anywhere in the name (not just the beginning)

I use this with [vim-forgit](https://github.com/tylerbrazier/vim-forgit)
to switch between projects fast.

## TODO

- can `*` be used as part of the mapping instead of manual filtering?
- completion should include local dirs too (not just history)
- some way to manually cleanup history (edit the file?) and reload/persist
