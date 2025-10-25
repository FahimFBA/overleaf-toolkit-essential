# Overleaf Toolkit Essential

A lightweight automation toolkit for managing and enhancing **local Overleaf installations**.  
It automates LaTeX package installation, updates TeX Live automatically, and keeps your environment consistent with Overleaf’s cloud setup.

---

## 🎥 Setup Video Guide

📺 **[Watch the full setup tutorial on YouTube](https://youtu.be/jDy9rdgSoHs)**

This walkthrough covers:

- Cloning and configuring the toolkit
- Installing and verifying LaTeX packages
- Troubleshooting common issues

---

## ⚙️ Overview

**Overleaf Toolkit Essential** is ideal for developers and researchers using the `sharelatex/sharelatex` Docker image.  
It ensures your local Overleaf setup stays up-to-date with minimal maintenance.

### Key Features

- Environment-driven configuration via `.env`
- Smart package installation (only missing packages)
- Weekly cron-based updates for TeX Live
- Non-destructive and idempotent scripts
- Works on Linux, macOS, and WSL2

---

## 🚀 Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/FahimFBA/overleaf-toolkit-essential.git
cd overleaf-toolkit-essential
````

### 2. Copy and configure environment

```bash
cp .env.example .env
```

Edit `.env` with your system paths (example):

```bash
CONTAINER_NAME=sharelatex
PROJECT_DIR=$HOME/tmp-overleaf/overleaf-toolkit-essential
LOG_FILE=$PROJECT_DIR/latex-update.log
INSTALL_SCRIPT=$PROJECT_DIR/scripts/install-latex-packages.sh
```

> **Note:** Use absolute paths.
> On WSL2, ensure it points to your Linux filesystem (e.g., `/home/fahim/tmp-overleaf/...`).

### 3. Make scripts executable

```bash
chmod +x scripts/*.sh
```

### 4. Install LaTeX packages

```bash
./scripts/install-latex-packages.sh
```

### 5. Enable weekly auto-update

```bash
./scripts/setup-weekly-cron.sh
```

This runs every **Monday at 4:00 AM** and logs results to `latex-update.log`.

---

## 🧩 Configuration

All settings are managed via `.env`:

| Variable         | Description               | Example                                                                                 |
| ---------------- | ------------------------- | --------------------------------------------------------------------------------------- |
| `CONTAINER_NAME` | Overleaf container name   | `sharelatex`                                                                            |
| `PROJECT_DIR`    | Toolkit directory on host | `/home/fahim/tmp-overleaf/overleaf-toolkit-essential`                                   |
| `LOG_FILE`       | Log file path             | `/home/fahim/tmp-overleaf/overleaf-toolkit-essential/latex-update.log`                  |
| `INSTALL_SCRIPT` | Path to installer script  | `/home/fahim/tmp-overleaf/overleaf-toolkit-essential/scripts/install-latex-packages.sh` |

---

## 📦 Installed Packages

By default, the toolkit installs these essential LaTeX packages:

```
amsmath, amsfonts, amssymb, mathtools, siunitx,
xcolor, graphicx, float, geometry, fancyhdr, caption, subcaption,
listings, algorithm, algorithmic, algorithm2e, tikz, pgfplots,
hyperref, booktabs, multirow, array, longtable, tabularx, lipsum
```

You can add more in `scripts/install-latex-packages.sh`.

---

## 🕒 Weekly Auto-Update

The scheduled cron job runs automatically:

```
0 4 * * 1 /path/to/install-latex-packages.sh >> /path/to/latex-update.log 2>&1
```

To view or edit your cron jobs:

```bash
crontab -l
crontab -e
```

---

## 🧰 Requirements

* Docker (running `sharelatex/sharelatex`)
* Access to `tlmgr` inside the container
* Linux, macOS, or WSL2 host
* Cron service enabled on host

> **Tip:** Tested on Ubuntu 24.04 and WSL2 environments.

---

## 🤝 Contributing

Contributions are welcome!
You can help by:

* Adding more LaTeX packages
* Improving automation or cross-platform support
* Enhancing installation or troubleshooting scripts

### To contribute:

1. Fork this repository
2. Create a feature branch (`feature/your-update`)
3. Commit your changes
4. Submit a pull request with a clear description

---

## 🧾 License

This project is licensed under the [MIT License](LICENSE).
You’re free to use, modify, and distribute it under open-source terms.

---

## 👤 Author

**Md. Fahim Bin Amin**
[GitHub Profile](https://github.com/FahimFBA) • [LinkedIn](https://www.linkedin.com/in/fahimfba/)

> This is an independent open-source project, not affiliated with Overleaf Ltd.

---

⭐ **If you find this project helpful, please star it on GitHub!**