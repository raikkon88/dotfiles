# Albert Vila's Dotfiles

This is a collection of dotfiles and scripts I use for customizing OS X/Linux to my liking and setting up the software development tools I use on a day-to-day basis. It can be cloned anywhere. It includes a setup script that creates the symlinks from your home directory to the cloned repository.

The setup script is smart enough to back up your existing dotfiles into a `~/.dotfiles_old/` directory if you already have any dotfiles.

I prefer `zsh` as my shell of choice. As such, the setup script will install `prezto` and `zsh`. If `zsh` is installed, and it is not already configured as the default shell, the setup script will execute a `chsh -s $(which zsh)` command. This changes the default shell to zsh, and takes effect as soon as a new zsh is spawned or on next login.

If you prefer `oh-my-zsh` over `prezto` just edit lib/zsh.sh and comment/uncomment the install function.

Recap
- Setup dotfiles (Note that the first time you ran the setup script it may throw some vim errors)
- Install osx dev packages (./install/osx) for brew/pip & atom
- Install prezto & zsh as shell (https://github.com/sorin-ionescu/prezto)
- Shell theme powerlevel9k (https://github.com/bhilburn/powerlevel9k)
![Theme](zsh/theme.png)
- Colors theme solarized (iterm2, vim, intellij)
- Fonts powerline

## Installation

```sh
$ git clone https://github.com/albert.vila/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ sh ./setup.sh
```

### issues
- Permission issues with homebrew under OS X El Capitan. Check /usr/local folder if it has de right permissions. Maybe you need to run
```sudo chown $(whoami):admin /usr/local && sudo chown -R $(whoami):admin /usr/local```

## Manual steps after first setup

### general
1. Open OSX mouse settings and select Natural scroll on trackpad
2. Open OSX keyboard settings and remove spotlight shortcut
3. Open Alfred and set spotlight shortcut, also select to be opened at login
4. Open spectacle and select to be opened at login

### iterm2
1. Open iTerm2's preferences (do this change for all needed profiles).
2. Go to colors, load presets and select Solarized Dark. Make sure that the minimum contrast slider is set to low
3. Click on text, make sure that "Draw bold text in bright colours" is disabled
4. Change the font to Meslo LG M Regular for Powerline, 12p
5. Go to Global Keys tab and change mapping for Ctrl+Tab / Ctrl+Shift+Tab to Next and Previous tab
6. Add two more mappings to jump at the beginning/end of line
```
    FOR  ACTION         SEND
    ⌘←  "HEX CODE"      0x01
    ⌘→  "HEX CODE"      0x05
```

### intellij
1. Clone git repository
```sh
$ git clone git@github.com:jkaving/intellij-colors-solarized.git
```
2. Go to `File | Import Settings...` and specify the `intellij-colors-solarized` directory
 Click `OK` in the dialog that appears.
3. Restart IntelliJ IDEA
4. Go to `Preferences | Editor | Colors & Fonts` and select one of the new color themes.

### unison
- Configure unison if you want bidirectional file sync ([link](https://www.cis.upenn.edu/~bcpierce/unison/))
- GUI interface ([link](http://www.cs.haifa.ac.il/~shuly/unison/))

## External links

iTerm and zsh tips
- <https://www.undefinednull.com/2015/07/31/iterm-tips-and-zsh-plugins-for-better-development-environment/>
- <https://github.com/robbyrussell/oh-my-zsh/wiki/Cheatsheet>

Tmux
- <http://mikebuss.com/2014/02/02/a-beautiful-productive-terminal-experience>
- <http://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/>
- <https://panovski.me/productivity-tools-tmux-and-zsh/>
- <https://danielmiessler.com/study/tmux/#gs.5DmuzbE>

- <https://gist.github.com/andreyvit/2921703> (tmux Cheatsheet)
- <https://tmuxcheatsheet.com/>

Tmuxinator
- <http://www.avitzurel.com/blog/2014/08/28/my-development-workflow-vim-tmux-terminal-awesomeness/>
- <https://github.com/tmuxinator/tmuxinator>

## Future ToDo
- Create a --force flag that removes the ~/.dotfiles and then continues with the setup
- Instead of zsh gradle plugin check and use https://github.com/gradle/gradle-completion
- Be able to install npm modules https://www.leeboonstra.com/developer/mac-osx-how-to-install-jshint-to-the-commandline-sublime-text-with-node/
