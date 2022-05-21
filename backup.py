import os
import shutil
from pathlib import Path
from typing import Set


def get_dotfiles(path: str) -> Set[Path]:
    targets = Path(path).rglob('*')
    return set(target.relative_to(path) for target in targets if target.is_file() and target.parts[0] != '.git')


home = os.getenv('HOME')

cur_dotfiles = get_dotfiles(f'{home}/.config')
git_dotfiles = get_dotfiles('.config')

dotfiles = cur_dotfiles.intersection(git_dotfiles)

for dotfile in dotfiles:
    shutil.copy(f'{home}/.config/{dotfile}', f'.config/{dotfile}')

print(f'copied {len(dotfiles)} files.')
