# Automates installation of this repository into the host's `@local`
# namespace so `#import "@local/<name>:<version>"` and
# `typst init @local/<name>:<version>` can resolve anywhere on the machine.
#
# The repo layout mirrors the namespace layout exactly, <name>/<version>/typst.toml.

default: link

# Typst default `@local` packages directory. Override with `just dest_root=… link`.
dest_root := if os() == "macos" { home_directory() / "Library/Application Support/typst/packages/local" } else if os() == "windows" { env('APPDATA', home_directory() / "AppData/Roaming") / "typst/packages/local" } else { env('XDG_DATA_HOME', home_directory() / ".local/share") / "typst/packages/local" }

repo_root := justfile_directory()

# Symlink every package into the namespace.
link:
    @for manifest in {{ quote(repo_root) }}/*/*/typst.toml; do \
        [ -e "$manifest" ] || continue; \
        version_dir=$(dirname "$manifest"); \
        name=$(basename "$(dirname "$version_dir")"); \
        version=$(basename "$version_dir"); \
        dest="{{ dest_root }}/$name/$version"; \
        mkdir -p "$(dirname "$dest")"; \
        ln -sfn "$version_dir" "$dest"; \
        echo "linked $name:$version"; \
    done
    @echo "namespace: {{ dest_root }}"

# Remove this repo's links from the namespace.
uninstall:
    @for manifest in {{ quote(repo_root) }}/*/*/typst.toml; do \
        [ -e "$manifest" ] || continue; \
        version_dir=$(dirname "$manifest"); \
        name=$(basename "$(dirname "$version_dir")"); \
        version=$(basename "$version_dir"); \
        dest="{{ dest_root }}/$name/$version"; \
        [ -L "$dest" ] || continue; \
        rm "$dest"; \
        echo "removed $name:$version"; \
        rmdir "{{ dest_root }}/$name" 2>/dev/null || true; \
    done

# Dev: regenerate the `typst init` scaffolding of every package that ships one.
templates:
    @for jf in {{ quote(repo_root) }}/*/*/justfile; do \
        [ -e "$jf" ] || continue; \
        d=$(dirname "$jf"); \
        {{ just_executable() }} --justfile "$jf" --working-directory "$d" --show template >/dev/null 2>&1 || continue; \
        {{ just_executable() }} --justfile "$jf" --working-directory "$d" template; \
    done
