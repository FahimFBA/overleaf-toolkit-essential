# Overleaf Toolkit Essential Documentation

Welcome to the official documentation for **Overleaf Toolkit Essential**,  
a lightweight automation suite for managing and maintaining **local Overleaf installations**.

This toolkit simplifies LaTeX environment management by automating package installation, updates, and maintenance inside your Overleaf Docker container.

---

## Overview

The toolkit provides a unified, environment-driven way to:

- Install all required LaTeX packages using `tlmgr` inside your Overleaf container.
- Keep your TeX Live environment updated automatically.
- Run weekly background updates using cron.
- Maintain a consistent, reproducible Overleaf environment across systems.

It’s fully **non-destructive**, **idempotent**, and **cross-platform** (Linux, macOS, and WSL).

---

## Documentation Index

| Section | Description |
|----------|-------------|
| [Quick Start](quick-start.md) | Step-by-step installation and setup guide. |
| [Maintenance Guide](maintenance.md) | How to maintain, troubleshoot, and customize your setup. |
| [Architecture](architecture.md) | Detailed technical design and Mermaid diagrams explaining how the toolkit works. |

!!! tip
    You can read these documents directly on GitHub — all diagrams and formatting render natively.

---

## Key Components

| Component | Purpose |
|------------|----------|
| `.env` | Defines all environment variables such as container name, project directory, and log file. |
| `scripts/install-latex-packages.sh` | Installs missing LaTeX packages inside the container. |
| `scripts/update-all-packages.sh` | Performs full TeX Live updates (`tlmgr update --self --all`). |
| `scripts/setup-weekly-cron.sh` | Registers a cron job to automate weekly updates. |
| `scripts/load-env.sh` | Loads `.env` configuration for all other scripts. |

---

## System Requirements

- Docker environment running `sharelatex/sharelatex`
- Access to `tlmgr` within the container
- Cron available on the host (for scheduled maintenance)
- Linux or macOS host, or WSL2 (for Windows users)

!!! note
    The toolkit assumes you already have a functional Overleaf instance.  
    It does not create or manage the Overleaf container itself.

---

## Project Goals

1. **Automation** – Eliminate manual package installation steps.  
2. **Consistency** – Ensure identical LaTeX environments across developer machines.  
3. **Portability** – Single configuration file (`.env`) for all environments.  
4. **Maintainability** – Clear modular structure and weekly automated updates.  
5. **Extensibility** – Easily extendable to new automation or monitoring tools.

---

## Example Workflow

```mermaid
flowchart LR
    A[Clone Repository] --> B[Copy .env.example to .env]
    B --> C[Run install-latex-packages.sh]
    C --> D[All LaTeX Packages Installed]
    D --> E[Run setup-weekly-cron.sh]
    E --> F[Cron executes weekly updates automatically]
````

!!! tip
Once configured, maintenance is fully automated — no need to manually install or update LaTeX packages.

---

## Contributing

Contributions are welcome.
You can help by:

* Suggesting additional package groups
* Enhancing automation scripts
* Adding cross-platform support

Please follow these steps to contribute:

1. Fork the repository
2. Create a new branch (`feature/new-enhancement`)
3. Commit and push your changes
4. Submit a pull request with a clear description

---

## License

This project is licensed under the [MIT License](https://github.com/FahimFBA/overleaf-toolkit-essential/blob/main/LICENSE).
You are free to use, modify, and distribute this toolkit under open-source terms.

---

## Author

Developed and maintained by [Md. Fahim Bin Amin](https://github.com/FahimFBA).
For updates or issues, visit the [GitHub repository](https://github.com/FahimFBA/overleaf-toolkit-essential).

!!! note
This project is an independent open-source utility and is **not affiliated with Overleaf Ltd**.

---

## Next Steps

1. Read the [Quick Start Guide](quick-start.md) to begin installation.
2. Follow the [Maintenance Guide](maintenance.md) for long-term use.
3. Explore the [Architecture Overview](architecture.md) for deeper technical understanding.