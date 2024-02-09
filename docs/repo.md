## Adding New Repo / Pyright & Direnv
- check that pip and python are in shims
- `touch .envrc`
```
pyenv local 3.11.7
pip install --upgrade pip
pip install pip-tools
pip-sync requirements/requirements*.txt
# this could be a little different
```
- `direnv allow` as needed
- `touch pyrightconfig.json`
```
{
  "exclude": [ ".venv" ],
  "venvPath": ".",
  "venv": ".venv",
}
```
- set up venv , run the following:
    - `python3 -m venv .venv`
    - `source .venv/bin/activate`
- then to ignore these files in repos
- touch or open `.git/info/exclude` and add:
    - .venv/
    - pyrightconfig.json
    - .envrc
- cd out of directory, back in, so that everything installs
