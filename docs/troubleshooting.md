# Overleaf Toolkit Essential – Troubleshooting Guide

This guide provides detailed instructions for diagnosing and resolving issues encountered while running **Overleaf Toolkit Essential**.

It covers problems related to Docker containers, LaTeX packages, `tlmgr`, cron jobs, and environment configuration.

---

## 1. Overview

The toolkit automates local Overleaf maintenance, but issues can arise from:

- Incorrect container configuration  
- Missing or outdated TeX Live installations  
- Broken package repositories  
- Misconfigured `.env` variables  
- Docker permission or network errors

!!! note
    Troubleshooting is easier when you enable detailed logging.  
    Use `bash -x ./scripts/install-latex-packages.sh` for verbose mode.

---

## 2. Common Error Categories

| Category | Symptom | Root Cause |
|-----------|----------|------------|
| Docker Container | `Error: Container not found` | Wrong `CONTAINER_NAME` or container not running |
| TeX Live Manager | `tlmgr: command not found` | TeX Live missing or not in PATH |
| Permissions | `cannot write to /usr/local/texlive/...` | Non-root access issue inside container |
| Network | `Cannot connect to CTAN mirror` | Firewall or DNS issue |
| Cron | No automatic updates | Cron service inactive or job misconfigured |

---

## 3. Environment Configuration Errors

### 3.1 Missing or Incorrect `.env`

**Symptom:**

```bash
./scripts/load-env.sh: line 3: .env: No such file or directory
````

**Fix:**

1. Copy the example file:

   ```bash
   cp .env.example .env
   ```

2. Update your container name and project directory paths.

**Verification:**

```bash
source scripts/load-env.sh && env | grep PROJECT_DIR
```

!!! tip
Always use absolute paths in `.env`.
Relative paths can cause silent failures in cron jobs.

---

## 4. Docker-Related Issues

### 4.1 Container Not Found

**Error:**

```bash
Error response from daemon: No such container: sharelatex
```

**Fix:**

1. List active containers:

   ```bash
   docker ps
   ```
2. Start your Overleaf instance:

   ```bash
   docker start sharelatex
   ```

If you use Docker Compose:

```bash
docker compose up -d
```

---

### 4.2 Stale Containers or Volumes

Sometimes an older Overleaf instance remains from a previous setup.

**Fix:**

```bash
docker ps -a
docker stop old_sharelatex
docker rm old_sharelatex
```

To remove unused data:

```bash
docker system prune -f
```

!!! warning
This command permanently deletes stopped containers and unused volumes.
Use with caution.

---

### 4.3 Permission Denied Inside Container

**Error:**

```bash
tlmgr: cannot write to /usr/local/texlive/...
```

**Fix:**

Run the command as root within the container:

```bash
docker exec -it --user root sharelatex tlmgr update --self --all
```

If successful, re-run your normal maintenance scripts.

---

## 5. TeX Live (tlmgr) Issues

### 5.1 Broken Mirror or Timeout

**Error:**

```bash
tlmgr: package repository http://mirror.ctan.org/... not found
```

**Fix:**

Specify a known good mirror manually:

```bash
docker exec -it sharelatex tlmgr option repository https://mirror.ox.ac.uk/sites/ctan.org/systems/texlive/tlnet
```

Then retry installation:

```bash
docker exec -it sharelatex tlmgr update --self --all
```

---

### 5.2 tlmgr Self-Update Fails

**Error:**

```bash
tlmgr: package texlive.infra not updated
```

**Fix:**

Reinstall the TeX Live infrastructure:

```bash
docker exec -it sharelatex tlmgr update --self --reinstall-forcibly-removed
```

If that fails, remove the `texlive.infra` cache:

```bash
docker exec -it sharelatex rm -rf /usr/local/texlive/*/tlpkg/texlive.tlpdb.*
docker exec -it sharelatex tlmgr update --self
```

---

### 5.3 Package Not Found

**Error:**

```bash
tlmgr install: package 'algorithm' not present in repository
```

**Cause:** Package renamed or deprecated.

**Fix:**

Search for the correct name:

```bash
docker exec -it sharelatex tlmgr search --global --file algorithm.sty
```

Then install the correct package:

```bash
docker exec -it sharelatex tlmgr install algorithms
```

---

## 6. Cron-Related Issues

### 6.1 Cron Not Running

Check service status:

```bash
sudo systemctl status cron
```

Start if inactive:

```bash
sudo systemctl enable cron
sudo systemctl start cron
```

!!! note
On macOS or WSL, cron must be started manually:

````
```bash
sudo service cron start
```
````

---

### 6.2 Cron Job Missing or Invalid

List current jobs:

```bash
crontab -l
```

Recreate if missing:

```bash
./scripts/setup-weekly-cron.sh
```

To debug:

```bash
grep CRON /var/log/syslog | tail -n 20
```

---

## 7. LaTeX Compilation Issues

### 7.1 “File not found” During LaTeX Compile

**Example:**

```bash
! LaTeX Error: File `algorithm.sty` not found.
```

**Fix:**

1. Install missing package:

   ```bash
   ./scripts/install-latex-packages.sh
   ```
2. Verify installation inside container:

   ```bash
   docker exec -it sharelatex kpsewhich algorithm.sty
   ```

If the file still doesn’t exist, verify the correct package provides it:

```bash
docker exec -it sharelatex tlmgr search --file algorithm.sty
```

---

### 7.2 Missing Fonts or Symbols

**Symptoms:**

```bash
! Font T1/cmss/m/n/10 not found.
```

**Fix:**

Install font packages:

```bash
docker exec -it sharelatex tlmgr install cm-super ec lmodern
```

!!! tip
The `cm-super` and `lmodern` packages fix most missing font errors in Overleaf setups.

---

## 8. Network and Mirror Diagnostics

### 8.1 Check Internet Access Inside Container

```bash
docker exec -it sharelatex ping -c 3 mirror.ctan.org
```

If ping fails, verify your container’s network mode:

```bash
docker inspect sharelatex --format='{{.HostConfig.NetworkMode}}'
```

If isolated, reconnect to the default network:

```bash
docker network connect bridge sharelatex
```

---

### 8.2 Mirror Health Check

To verify that your mirror is reachable:

```bash
curl -I https://mirror.ox.ac.uk/sites/ctan.org/systems/texlive/tlnet
```

If it returns `200 OK`, the mirror is operational.

---

## 9. Advanced Diagnostics

### 9.1 Run Scripts in Debug Mode

Append `-x` for shell tracing:

```bash
bash -x ./scripts/install-latex-packages.sh
```

### 9.2 Manual Execution Inside Container

If you need to run commands directly:

```bash
docker exec -it sharelatex bash
tlmgr update --self --all
```

### 9.3 Check File Permissions

```bash
docker exec -it sharelatex ls -ld /usr/local/texlive
```

If permissions are too restrictive:

```bash
docker exec -it --user root sharelatex chmod -R a+w /usr/local/texlive
```

---

## 10. Recovery Procedures

### 10.1 Full TeX Live Rebuild (Last Resort)

If `tlmgr` becomes corrupted:

```bash
docker exec -it --user root sharelatex rm -rf /usr/local/texlive/*
docker exec -it --user root sharelatex tlmgr init-usertree
```

Then reinstall essential packages:

```bash
./scripts/install-latex-packages.sh
```

---

### 10.2 Reset Toolkit Configuration

If scripts or environment variables become inconsistent:

```bash
git restore scripts/
cp .env.example .env
```

Reapply automation:

```bash
./scripts/setup-weekly-cron.sh
```

---

## 11. Verification Checklist

| Check                | Command                                        | Expected Output           |
| -------------------- | ---------------------------------------------- | ------------------------- |
| Container status     | `docker ps`                                    | `sharelatex` listed       |
| TeX Live version     | `docker exec sharelatex tlmgr --version`       | Displays version          |
| Mirror access        | `docker exec sharelatex tlmgr update --list`   | List of available updates |
| Log update timestamp | `ls -lh latex-update.log`                      | Recent modification date  |
| Package check        | `docker exec sharelatex kpsewhich amsmath.sty` | Path returned             |

---

## 12. Summary

**Overleaf Toolkit Essential** is designed for high reliability and minimal manual intervention.
If issues arise, follow this diagnostic order:

1. Verify container accessibility
2. Confirm `tlmgr` availability
3. Check `.env` paths
4. Inspect cron and logs
5. Run installer in debug mode

!!! note
Once corrected, the toolkit resumes normal operation automatically without further configuration.

---

## 13. Additional Resources

* [TeX Live Documentation](https://tug.org/texlive/doc.html)
* [Overleaf Docker Image](https://hub.docker.com/r/sharelatex/sharelatex)
* [Cron Job Reference](https://crontab.guru/)
* [CTAN Mirrors List](https://ctan.org/mirrors)

---

## 14. Support and Contribution

If you encounter persistent or undocumented issues:

1. Open a GitHub issue in the repository:
   [https://github.com/FahimFBA/overleaf-toolkit-essential/issues](https://github.com/FahimFBA/overleaf-toolkit-essential/issues)
2. Include:

   * The output of `docker ps`
   * The last 20 lines of your log file
   * The contents of `.env` (with sensitive info removed)

!!! tip
The more information you include, the faster the issue can be diagnosed.