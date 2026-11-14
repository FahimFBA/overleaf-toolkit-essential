# Overleaf Toolkit Essential

[![Docs](https://github.com/FahimFBA/overleaf-toolkit-essential/actions/workflows/docs.yml/badge.svg)](https://github.com/FahimFBA/overleaf-toolkit-essential/actions/workflows/docs.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Automation scripts for self-hosted Overleaf. The toolkit installs commonly used LaTeX packages inside the `sharelatex/sharelatex` Docker container, keeps TeX Live up to date on a schedule, and brings a local installation closer to the package set available on Overleaf's cloud service.

**Documentation:** <https://fahimfba.github.io/overleaf-toolkit-essential>
**Video walkthrough:** [Setup tutorial on YouTube](https://youtu.be/jDy9rdgSoHs)

## Features

- Configuration through a single `.env` file
- Installs only the packages that are missing
- Scheduled TeX Live updates through cron, with a configurable schedule
- Idempotent scripts that are safe to run repeatedly
- Reports failed installs and exits with a non-zero status
- Runs on Linux, macOS, and Windows through WSL2

## Requirements

- Docker, with a running `sharelatex/sharelatex` container
- `tlmgr` available inside the container
- A Linux, macOS, or WSL2 host
- A running cron service on the host

Tested on Ubuntu 24.04, macOS, and Windows 11 (WSL2).

## Installation

Clone the repository and create your configuration file:

```bash
git clone https://github.com/FahimFBA/overleaf-toolkit-essential.git
cd overleaf-toolkit-essential
cp .env.example .env
```

Edit `.env` to match your environment (see [Configuration](#configuration)), then make the scripts executable:

```bash
chmod +x scripts/*.sh
```

## Usage

Install the default package set:

```bash
./scripts/install-latex-packages.sh
```

Update `tlmgr` and every installed TeX Live package:

```bash
./scripts/update-all-packages.sh
```

Schedule the installer to run automatically:

```bash
./scripts/setup-weekly-cron.sh
```

By default the job runs every Monday at 4:00 AM and appends output to the log file set in `.env`. Existing cron entries are preserved.

| Script                       | Purpose                                                   |
| ---------------------------- | --------------------------------------------------------- |
| `install-latex-packages.sh`  | Installs any missing packages from the default list       |
| `update-all-packages.sh`     | Runs `tlmgr update --self --all` inside the container     |
| `setup-weekly-cron.sh`       | Adds or replaces the scheduled cron job                   |
| `load-env.sh`                | Loads `.env`; sourced by the other scripts                |

## Configuration

All settings live in `.env`. Use absolute paths, because cron does not run from your project directory.

| Variable         | Description                                  | Default                                  |
| ---------------- | -------------------------------------------- | ---------------------------------------- |
| `CONTAINER_NAME` | Name of the running Overleaf container       | `sharelatex`                             |
| `PROJECT_DIR`    | Toolkit directory on the host                | Repository root                          |
| `LOG_FILE`       | File that receives output from scheduled runs | `$PROJECT_DIR/latex-update.log`          |
| `INSTALL_SCRIPT` | Path to the installer script run by cron     | `$PROJECT_DIR/scripts/install-latex-packages.sh` |
| `CRON_EXPR`      | Cron schedule (`min hour day month weekday`) | `0 4 * * 1`                              |

Example:

```bash
CONTAINER_NAME=sharelatex
PROJECT_DIR=$HOME/overleaf-toolkit-essential
LOG_FILE=$PROJECT_DIR/latex-update.log
INSTALL_SCRIPT=$PROJECT_DIR/scripts/install-latex-packages.sh
CRON_EXPR="0 4 * * 1"
```

On WSL2, point these paths at the Linux filesystem (for example `/home/youruser/...`), not at `/mnt/c/...`. After changing `CRON_EXPR`, run `./scripts/setup-weekly-cron.sh` again.

## Default packages

```
amsmath, amsfonts, mathtools, siunitx,
xcolor, graphics, float, geometry, fancyhdr, subfig, caption,
listings, algorithms, algorithm2e, pgf, pgfplots,
hyperref, booktabs, multirow, tools, lipsum
```

These are `tlmgr` package names, and each one provides several LaTeX packages:

| tlmgr package | Provides                              |
| ------------- | ------------------------------------- |
| `graphics`    | `graphicx`                            |
| `tools`       | `array`, `longtable`, `tabularx`      |
| `algorithms`  | `algorithm`, `algorithmic`            |
| `pgf`         | `tikz`                                |
| `amsfonts`    | `amssymb`                             |
| `caption`     | `subcaption`                          |

To add packages, edit the `ALL_PACKAGES` array in `scripts/install-latex-packages.sh`. Use `tlmgr search --global --file <name>.sty` inside the container to find the package that provides a file.

## Contributing

Contributions are welcome, including new packages, cross-platform fixes, and documentation improvements.

1. Fork the repository.
2. Create a branch (`feature/your-change`).
3. Commit your changes.
4. Open a pull request that describes what changed and why.

Notable changes are recorded in [CHANGELOG.md](CHANGELOG.md).

## License

Released under the [MIT License](LICENSE).

## Author

Md. Fahim Bin Amin ([GitHub](https://github.com/FahimFBA), [LinkedIn](https://www.linkedin.com/in/fahimfba/))

This is an independent project and is not affiliated with Overleaf Ltd.
