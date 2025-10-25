# Quick Start Guide

This guide walks you through installing, configuring, and running **Overleaf Toolkit Essential** —  
a lightweight automation toolkit for managing LaTeX environments inside local Overleaf Docker containers.

---

## 1. Overview

The toolkit automates common LaTeX maintenance tasks such as:

- Installing and verifying required LaTeX packages  
- Keeping TeX Live up to date using `tlmgr`  
- Automating weekly updates via cron jobs  
- Maintaining consistent configuration through a single `.env` file

!!! note
    This toolkit is designed for users running Overleaf locally via Docker.  
    It does **not** modify Overleaf project data or web configurations.

---

## 2. Prerequisites

Before starting, make sure you have the following installed and running:

| Requirement | Description |
|--------------|-------------|
| **Docker** | Installed and running on your system |
| **Overleaf Container** | A running container, usually named `sharelatex` |
| **bash + cron** | Required for automation and scheduling |
| **Internet access** | Needed to download LaTeX packages via CTAN |

Verify your Overleaf container is active:

```bash
docker ps
````

You should see an entry similar to:

```bash
CONTAINER ID   IMAGE                        COMMAND          STATUS
ab12cd34ef56   sharelatex/sharelatex:5.5.4  "bash /start.sh" Up 2 hours
```

---

## 3. Clone the Repository

Clone the toolkit to your preferred directory:

```bash
git clone https://github.com/FahimFBA/overleaf-toolkit-essential.git
cd overleaf-toolkit-essential
```

This creates a local project directory containing all necessary scripts and configuration files.

---

## 4. Configure Environment Variables

Copy the provided example environment file and edit it according to your system paths:

```bash
cp .env.example .env
```

Open `.env` and update the variables:

```bash
CONTAINER_NAME=sharelatex
PROJECT_DIR=$HOME/tmp-overleaf/overleaf-toolkit-essential
LOG_FILE=$PROJECT_DIR/latex-update.log
INSTALL_SCRIPT=$PROJECT_DIR/scripts/install-latex-packages.sh
```

!!! tip
Always use **absolute paths** — relative paths can cause cron to fail silently.

---

## 5. Make Scripts Executable

Ensure all shell scripts are executable:

```bash
chmod +x scripts/*.sh
```

You only need to do this once after cloning.

---

## 6. Install Required LaTeX Packages

Run the main installer script:

```bash
./scripts/install-latex-packages.sh
```

This will:

1. Load configuration from `.env`
2. Check for missing LaTeX packages inside your container
3. Install only the ones not already present
4. Display progress and results in the terminal

!!! note
The installer is **idempotent** — you can safely run it multiple times.

---

## 7. Verify Installation

After installation, confirm that required packages exist inside your container:

```bash
docker exec -it sharelatex kpsewhich algorithm.sty
```

If the command returns a valid file path, the package is successfully installed.

---

## 8. Enable Automatic Weekly Updates

To automate weekly maintenance, set up the cron job:

```bash
./scripts/setup-weekly-cron.sh
```

This creates a job that runs every **Monday at 4:00 AM** and logs output to:

```bash
$PROJECT_DIR/latex-update.log
```

Check registered cron jobs:

```bash
crontab -l
```

Expected output:

```bash
0 4 * * 1 /home/fahim/tmp-overleaf/overleaf-toolkit-essential/scripts/install-latex-packages.sh >> /home/fahim/tmp-overleaf/overleaf-toolkit-essential/latex-update.log 2>&1
```

---

## 9. Perform a Full System Update (Optional)

You can manually update **all** LaTeX packages and TeX Live infrastructure:

```bash
./scripts/update-all-packages.sh
```

This command runs:

```bash
tlmgr update --self --all
```

inside your Overleaf container.

---

## 10. Check Logs

Review update activity and verify that jobs ran successfully:

```bash
tail -n 50 $LOG_FILE
```

Or monitor live output:

```bash
tail -f $LOG_FILE
```

!!! tip
Logs are never automatically deleted. You can safely clear them periodically if needed:

````
```bash
> $LOG_FILE
```
````

---

## 11. Run in Debug Mode (Optional)

To trace script execution for troubleshooting:

```bash
bash -x ./scripts/install-latex-packages.sh
```

This prints every command executed and is useful for diagnosing environment or Docker issues.

---

## 12. Cleanup and Best Practices

* Use one toolkit instance per Overleaf container
* Keep `.env` and `scripts/` under version control, but exclude logs and build artifacts
* Periodically check for toolkit updates:

  ```bash
  git pull origin main
  ```

---

## 13. Common Validation Commands

| Action                     | Command                                        |
| -------------------------- | ---------------------------------------------- |
| Verify running container   | `docker ps`                                    |
| Check package availability | `docker exec sharelatex kpsewhich amsmath.sty` |
| Update all packages        | `./scripts/update-all-packages.sh`             |
| View scheduled jobs        | `crontab -l`                                   |
| Check TeX Live version     | `docker exec sharelatex tlmgr --version`       |

---

## 14. Troubleshooting

If something doesn’t work as expected, refer to:

* [Maintenance Guide](maintenance.md)
* [Troubleshooting Guide](troubleshooting.md)

These documents cover debugging steps, `tlmgr` issues, network failures, and permission fixes.

---

## 15. Summary

You have now:

1. Cloned the toolkit
2. Configured environment variables
3. Installed LaTeX packages
4. Scheduled weekly updates

Your Overleaf container will now stay fully up to date with minimal manual maintenance.

!!! note
Once set up, the toolkit requires no further user interaction —
all updates occur automatically in the background.