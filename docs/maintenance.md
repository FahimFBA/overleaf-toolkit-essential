# Overleaf Toolkit Essential – Maintenance and Troubleshooting Guide

This document provides detailed instructions for maintaining, troubleshooting, and customizing **Overleaf Toolkit Essential**.

It is intended for system administrators, developers, and researchers running local Overleaf instances using Docker.

---

## 1. Overview

The toolkit is designed to minimize manual maintenance by automating common tasks such as:
- Installing required LaTeX packages
- Keeping TeX Live up to date
- Running periodic updates using cron
- Preserving configuration consistency through the `.env` file

!!! note
    Most maintenance is automated through scheduled cron jobs.  
    Manual intervention is rarely required unless updates fail or configuration changes.

---

## 2. Routine Maintenance

### 2.1 Manual Package Updates

You can trigger an on-demand update at any time:

```bash
./scripts/update-all-packages.sh
````

This script:

* Updates TeX Live itself (`tlmgr update --self`)
* Updates all installed LaTeX packages
* Cleans up obsolete packages if necessary

!!! tip
Run this manually if you notice missing packages or after updating the Overleaf container.

---

### 2.2 Verifying Package Installation

To ensure that all required LaTeX packages are installed:

```bash
./scripts/install-latex-packages.sh
```

This command:

* Checks the container for missing packages
* Installs only those not already present
* Logs results for review

!!! note
The script is **idempotent** — running it multiple times causes no harm.

---

### 2.3 Updating the Toolkit Scripts

If you’ve cloned this repository, you can pull new versions of the scripts at any time:

```bash
git pull origin main
```

Then reapply cron (to ensure the latest script paths are registered):

```bash
./scripts/setup-weekly-cron.sh
```

---

## 3. Scheduled Maintenance (Cron)

### 3.1 Viewing Existing Cron Jobs

```bash
crontab -l
```

Expected output (example):

```bash
0 4 * * 1 /home/fahim/tmp-overleaf/overleaf-toolkit-essential/scripts/install-latex-packages.sh >> /home/fahim/tmp-overleaf/overleaf-toolkit-essential/latex-update.log 2>&1
```

### 3.2 Removing or Editing Cron Jobs

To edit your cron schedule:

```bash
crontab -e
```

To remove all cron jobs for the current user:

```bash
crontab -r
```

!!! warning
Removing all cron jobs will disable automatic updates.
Re-run `setup-weekly-cron.sh` to restore automation.

---

## 4. Log Management

### 4.1 Log File Location

Logs are written to the path defined in `.env`:

```bash
LOG_FILE=/path/to/latex-update.log
```

Example:

```bash
/home/fahim/tmp-overleaf/overleaf-toolkit-essential/latex-update.log
```

### 4.2 Viewing Logs

To view the most recent updates:

```bash
tail -n 50 /path/to/latex-update.log
```

Or to monitor logs live:

```bash
tail -f /path/to/latex-update.log
```

### 4.3 Cleaning Old Logs

If your logs become large, truncate them safely:

```bash
> /path/to/latex-update.log
```

!!! note
Logs are never rotated automatically to prevent losing diagnostic history.
You can add log rotation manually via `logrotate` if desired.

---

## 5. Common Issues and Fixes

### 5.1 Missing `tlmgr`

**Symptoms:**

```bash
bash: tlmgr: command not found
```

**Cause:**
TeX Live is not installed inside the Overleaf container or is located at a non-standard path.

**Fix:**

1. Enter your container:

   ```bash
   docker exec -it sharelatex bash
   ```
2. Confirm `tlmgr` exists:

   ```bash
   which tlmgr
   ```
3. If not found, reinstall TeX Live using the container’s package manager or image update.

---

### 5.2 Permission Errors

**Symptoms:**

```bash
tlmgr: cannot write to /usr/local/texlive/...
```

**Cause:**
File system permissions inside the container prevent `tlmgr` from updating packages.

**Fix:**

```bash
docker exec -it --user root sharelatex tlmgr update --self --all
```

!!! tip
You can add `--user root` to any of the toolkit scripts temporarily for debugging,
though it is not recommended for regular use.

---

### 5.3 Cron Job Does Not Run

**Check:**

```bash
systemctl status cron
```

If the cron service is inactive, start it:

```bash
sudo systemctl enable cron
sudo systemctl start cron
```

!!! note
On WSL or macOS, cron may need to be launched manually since it doesn’t run persistently by default.

---

### 5.4 Packages Still Missing After Update

**Possible causes:**

1. The package name is incorrect or misspelled in the installer script.
2. The package is part of a bundle (e.g., `algorithmicx` may require `algorithms`).

**Fix:**

* Verify the package name with:

  ```bash
  docker exec -it sharelatex tlmgr search --global --file algorithmic.sty
  ```
* Add the correct name to `ALL_PACKAGES` in `install-latex-packages.sh`.

---

## 6. Customization

### 6.1 Adding New Packages

Edit `scripts/install-latex-packages.sh` and append new packages to the list:

```bash
ALL_PACKAGES=(
  amsmath
  amsfonts
  algorithmicx
  pgfplots
  newpackage
)
```

Run the script again:

```bash
./scripts/install-latex-packages.sh
```

---

### 6.2 Changing Update Schedule

Edit `scripts/setup-weekly-cron.sh` and modify the cron expression:

Example — Run every day at 2 AM:

```bash
CRON_EXPR="0 2 * * *"
```

Then re-run:

```bash
./scripts/setup-weekly-cron.sh
```

---

## 7. Backup and Recovery

### 7.1 Backing Up Configuration

Before making any changes, back up:

```bash
.env
scripts/
```

### 7.2 Restoring Defaults

If something breaks:

```bash
git restore scripts/
cp .env.example .env
```

Then re-run:

```bash
./scripts/setup-weekly-cron.sh
```

---

## 8. Validation Checklist

| Check                       | Command                                  | Expected Result               |
| --------------------------- | ---------------------------------------- | ----------------------------- |
| Verify container is running | `docker ps`                              | Container `sharelatex` listed |
| Verify `tlmgr` availability | `docker exec -it sharelatex which tlmgr` | Returns a valid path          |
| Verify scheduled job        | `crontab -l`                             | Cron line exists              |
| Verify log updates weekly   | `ls -lh latex-update.log`                | Recent timestamp              |
| Verify environment file     | `cat .env`                               | Correct variable values       |

---

## 9. Advanced Tips

* Combine `update-all-packages.sh` with your CI/CD pipeline to ensure consistent builds.
* Add Slack or email alerts by appending notification commands at the end of your cron job.
* Use Docker volume mounts for persistent TeX Live installations.

!!! tip
You can test automation manually by simulating a cron run:

````
```bash
bash -x ./scripts/install-latex-packages.sh
```
````

---

## 10. Summary

Regular maintenance is minimal with **Overleaf Toolkit Essential**.
By ensuring that:

* Cron is active
* `.env` is correctly configured
* `tlmgr` is accessible

...the system will keep your LaTeX environment stable, up to date, and ready for production workloads.

!!! note
Most users only need to review logs occasionally.
The toolkit is fully automated once configured correctly.