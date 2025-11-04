#!/bin/bash
# ===========================================================
# LOG ARCHIVE TOOL – Compress & Clean Old Logs
# Author: Linet
# Usage: ./log-archive.sh /var/log
# Features:
#   • Takes any log directory
#   • Creates timestamped .tar.gz archives
#   • Stores archives in ./archives/ (auto-created)
#   • Logs every run to archive.log
#   • Safe: skips if no .log files are found
# ===========================================================

set -euo pipefail  # Safety first!

# ---------- CONFIG ----------
ARCHIVE_DIR="./archives"
LOG_FILE="$ARCHIVE_DIR/archive.log"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# ---------- HELP ----------
show_help() {
    cat << EOF
Usage: $(basename "$0") <log-directory>

Example:
    $(basename "$0") /var/log
    $(basename "$0") /home/user/myapp/logs

Archives all .log files in <log-directory> into:
    $ARCHIVE_DIR/logs_archive_YYYYMMDD_HHMMSS.tar.gz

Logs every run to: $LOG_FILE
EOF
    exit 0
}

# ---------- VALIDATE INPUT ----------
if [[ $# -ne 1 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    show_help
fi

LOG_DIR="$1"

if [[ ! -d "$LOG_DIR" ]]; then
    echo "Error: Directory '$LOG_DIR' not found!"
    exit 1
fi

# Check for .log files safely
if ! compgen -G "$LOG_DIR/*.log" > /dev/null; then
    echo "No .log files found in '$LOG_DIR'. Skipping."
    exit 0
fi

# ---------- SETUP ARCHIVE DIR ----------
mkdir -p "$ARCHIVE_DIR"

# ---------- CREATE ARCHIVE ----------
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="$ARCHIVE_DIR/$ARCHIVE_NAME"

echo "Archiving logs from: $LOG_DIR"
echo "Creating archive: $ARCHIVE_NAME"

# Only include .log files to avoid unnecessary files
tar -czf "$ARCHIVE_PATH" -C "$LOG_DIR" $(find . -maxdepth 1 -type f -name "*.log") 2>/dev/null || {
    echo "Failed to create archive!"
    exit 1
}

# ---------- LOG THE EVENT ----------
ARCHIVE_SIZE=$(du -h "$ARCHIVE_PATH" | cut -f1)
printf "[%s] Archived %s → %s\n" "$(date)" "$ARCHIVE_SIZE" "$ARCHIVE_NAME" >> "$LOG_FILE"

# ---------- SUCCESS MESSAGE ----------
echo "SUCCESS!"
echo "Archive saved to: $ARCHIVE_PATH"
echo "Size: $ARCHIVE_SIZE"
echo "All runs logged to: $LOG_FILE"

# ---------- OPTIONAL CLEANUP ----------
# Uncomment below lines to delete original logs after archiving
# read -p "Clean original logs after archiving? (y/N): " choice
# if [[ "$choice" =~ ^[Yy]$ ]]; then
#     find "$LOG_DIR" -name "*.log" -delete
#     echo "Original logs deleted."
# fi

exit 0
