# log-archive-tool-clogger
A simple yet powerful **Bash script** for compressing and managing log files.  
It’s designed to help DevOps and system admins automate log archival tasks safely and efficiently.

---

## 🚀 Features
- Archives all `.log` files in a given directory
- Creates timestamped `.tar.gz` files for easy tracking
- Automatically stores archives in `./archives/`
- Logs every run in `archive.log`
- Optional cleanup step to delete original logs after archiving
- Works on any Linux system with built-in tools (no dependencies)

---

## 🧠 Usage

### Run the script:
```bash
./log-archive.sh <log-directory>
```

https://roadmap.sh/projects/log-archive-tool
