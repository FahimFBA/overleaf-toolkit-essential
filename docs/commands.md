# Command Reference

This page provides a concise list of commonly used commands for **Overleaf Toolkit Essential**.  
Use this as a quick reference when maintaining or debugging your Overleaf environment.

---

## 1. System Overview

| Purpose | Command |
|----------|----------|
| List running containers | `docker ps` |
| Enter Overleaf container | `docker exec -it sharelatex bash` |
| Check TeX Live version | `docker exec sharelatex tlmgr --version` |
| Verify TeX Live path | `docker exec sharelatex which tlmgr` |
| Display Overleaf logs | `docker logs sharelatex --tail 50` |

!!! note
    Replace `sharelatex` with your actual container name if you use a different identifier.

---

## 2. Toolkit Initialization

| Purpose | Command |
|----------|----------|
| Clone repository | `git clone https://github.com/FahimFBA/overleaf-toolkit-essential.git` |
| Navigate to directory | `cd overleaf-toolkit-essential` |
| Copy environment template | `cp .env.example .env` |
| Edit configuration | `nano .env` or `code .env` |
| Make scripts executable | `chmod +x scripts/*.sh` |

---

## 3. LaTeX Package Management

| Purpose | Command |
|----------|----------|
| Install essential packages | `./scripts/install-latex-packages.sh` |
| Update all LaTeX packages | `./scripts/update-all-packages.sh` |
| Check for missing packages | `docker exec sharelatex kpsewhich algorithm.sty` |
| Search package by file | `docker exec sharelatex tlmgr search --file algorithm.sty` |
| Reinstall specific package | `docker exec sharelatex tlmgr install algorithms` |

!!! tip
    Both `install-latex-packages.sh` and `update-all-packages.sh` automatically source `.env`  
    and operate safely even if rerun multiple times.

---

## 4. Cron Job Automation

| Purpose | Command |
|----------|----------|
| Create weekly cron job | `./scripts/setup-weekly-cron.sh` |
| View existing jobs | `crontab -l` |
| Remove all cron jobs | `crontab -r` |
| Edit cron jobs manually | `crontab -e` |
| Check cron service status | `sudo systemctl status cron` |

Default cron schedule (in `setup-weekly-cron.sh`):

```bash
0 4 * * 1 /path/to/install-latex-packages.sh >> /path/to/latex-update.log 2>&1
````

!!! note
This schedule runs every **Monday at 4:00 AM** by default.

---

## 5. Log Management

| Purpose                 | Command                    |             |
| ----------------------- | -------------------------- | ----------- |
| View last 50 log lines  | `tail -n 50 $LOG_FILE`     |             |
| Monitor live log output | `tail -f $LOG_FILE`        |             |
| Clear log file safely   | `> $LOG_FILE`              |             |
| Check cron log (Linux)  | `grep CRON /var/log/syslog | tail -n 10` |

!!! tip
The default log file path is defined in `.env`:

````
```bash
LOG_FILE=/home/fahim/tmp-overleaf/overleaf-toolkit-essential/latex-update.log
```
````

---

## 6. Debugging and Diagnostics

| Purpose                        | Command                                            |
| ------------------------------ | -------------------------------------------------- |
| Run installer in debug mode    | `bash -x ./scripts/install-latex-packages.sh`      |
| Run update in debug mode       | `bash -x ./scripts/update-all-packages.sh`         |
| Check TeX Live repository      | `docker exec sharelatex tlmgr option repository`   |
| Test internet inside container | `docker exec sharelatex ping -c 3 mirror.ctan.org` |
| Verify LaTeX compilation       | `docker exec sharelatex pdflatex test.tex`         |

!!! warning
Debug mode prints every shell command and environment variable.
Use it only when troubleshooting — not for automated cron execution.

---

## 7. Environment Variables

| Variable         | Description                    | Example                                               |
| ---------------- | ------------------------------ | ----------------------------------------------------- |
| `CONTAINER_NAME` | Overleaf Docker container name | `sharelatex`                                          |
| `PROJECT_DIR`    | Toolkit base directory         | `/home/fahim/tmp-overleaf/overleaf-toolkit-essential` |
| `LOG_FILE`       | Log output file path           | `$PROJECT_DIR/latex-update.log`                       |
| `INSTALL_SCRIPT` | Path to installer script       | `$PROJECT_DIR/scripts/install-latex-packages.sh`      |

To apply changes, reload environment:

```bash
source scripts/load-env.sh
```

---

## 8. Maintenance and Updates

| Purpose                              | Command                                                            |
| ------------------------------------ | ------------------------------------------------------------------ |
| Update TeX Live infrastructure       | `docker exec sharelatex tlmgr update --self`                       |
| Update all packages                  | `docker exec sharelatex tlmgr update --all`                        |
| Verify installed packages            | `docker exec sharelatex tlmgr list --only-installed`               |
| Clean obsolete packages              | `docker exec sharelatex tlmgr clean --all`                         |
| Force reinstall missing dependencies | `docker exec sharelatex tlmgr update --reinstall-forcibly-removed` |

---

## 9. Backup and Recovery

| Purpose                         | Command                                                  |
| ------------------------------- | -------------------------------------------------------- |
| Backup `.env` file              | `cp .env .env.bak`                                       |
| Restore defaults                | `cp .env.example .env`                                   |
| Reset scripts to default        | `git restore scripts/`                                   |
| Rebuild TeX Live database       | `docker exec sharelatex mktexlsr`                        |
| Force TeX Live reinitialization | `docker exec --user root sharelatex tlmgr init-usertree` |

---

## 10. Validation Checklist

| Check             | Command                                        | Expected Result    |
| ----------------- | ---------------------------------------------- | ------------------ |
| Container running | `docker ps`                                    | Overleaf listed    |
| `tlmgr` exists    | `docker exec sharelatex which tlmgr`           | Valid path         |
| Package installed | `docker exec sharelatex kpsewhich amsmath.sty` | File path returned |
| Cron job active   | `crontab -l`                                   | Job listed         |
| Log file updating | `ls -lh latex-update.log`                      | Recent timestamp   |

---

## 11. Common Recovery Commands

If the system becomes unstable or packages fail repeatedly:

```bash
docker exec -it --user root sharelatex rm -rf /usr/local/texlive/*
docker exec -it --user root sharelatex tlmgr init-usertree
./scripts/install-latex-packages.sh
```

!!! warning
This resets the TeX Live installation inside your container.
Use only as a last resort when `tlmgr` becomes corrupted.

---

## 12. Useful Links

* [Overleaf Toolkit Essential Repository](https://github.com/FahimFBA/overleaf-toolkit-essential)
* [Maintenance Guide](maintenance.md)
* [Troubleshooting Guide](troubleshooting.md)
* [Architecture Overview](architecture.md)
* [TeX Live Documentation](https://tug.org/texlive/doc.html)

---

## 13. Summary

This page summarizes all essential commands for maintaining, updating, and debugging your Overleaf Toolkit installation.

For detailed explanations, refer to:

* `quick-start.md` — full setup guide
* `maintenance.md` — operational maintenance
* `troubleshooting.md` — debugging and recovery