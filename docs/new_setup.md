## For a Brand New Computer Setup!

### Applications

- Spotify
- Docker
- Gather
- Skitch
- Rectangle (use Spectacle settings)
- Chrome
- Firefox
    - Extensions
        - Bitwarden
        - uBlock Origin
        - Privacy Badger
    - Search
        - Change Default Search to DuckDuckGo
        - Disable all Search Suggestions and Address Bar - Firefox Suggest boxes
    - Privacy & Security
        - Website Privacy Preferences: Tell websites not to sell or share my data
        - Disable Ask to save Passwords
        - Disable autofill
        - Disable all Data Collection
        - Disable all Advertising Preferences
    - Theme: [Purple Night](https://addons.mozilla.org/en-US/firefox/addon/purple-night-theme/)

### Installs

- Brew
    - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Github SSH Key (R/W and signing - can use the same for both)
- `brew install tmux`
- `brew install neovim`
- `brew install pyenv`
    - `pyenv install XXXX`
    - `pyenv global XXXX`
    - `export PATH="$HOME/.pyenv/shims:$PATH"`
- `brew install ripgrep`
- `brew install go`
- [Lunarvim](https://www.lunarvim.org/docs/installation)
    - Install Nerd Font of choice for lunarvim (Bitstrom Wera is my current choice)
- Run this repo `script/setup`
- keyboard settings: CAPSLOCK -> CTRL mapping
- `brew install kubernetes-cli`
- `brew install kubectx`
