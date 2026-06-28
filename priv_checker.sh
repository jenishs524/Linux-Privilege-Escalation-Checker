#!/bin/bash
# Linux Privilege Escalation Checker

echo "========================================="
echo "  LINUX PRIVILEGE ESCALATION CHECKER"
echo "========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. Current user
echo -e "${GREEN}[*] Current User:${NC}"
whoami
id
echo ""

# 2. Sudo permissions
echo -e "${GREEN}[*] Sudo Permissions:${NC}"
sudo -l 2>/dev/null
echo ""

# 3. SUID binaries (uncommon)
echo -e "${GREEN}[*] SUID Binaries (uncommon):${NC}"
find / -perm -4000 -type f 2>/dev/null | grep -v -E "(snap|docker|nvidia|lib)" | head -15
echo ""

# 4. Writable files in /etc
echo -e "${GREEN}[*] Writable files in /etc:${NC}"
find /etc -writable -type f 2>/dev/null | head -10
echo ""

# 5. Writable directories in PATH
echo -e "${GREEN}[*] Writable directories in PATH:${NC}"
echo $PATH | tr ':' '\n' | while read dir; do
    if [ -w "$dir" ]; then
        echo -e "${RED}[!] Writable: $dir${NC}"
    fi
done
echo ""

# 6. Cron jobs
echo -e "${GREEN}[*] Cron Jobs:${NC}"
ls -la /etc/cron* 2>/dev/null | head -10
echo ""

# 7. Kernel version
echo -e "${GREEN}[*] Kernel Version:${NC}"
uname -a
echo ""

# 8. Interesting environment variables
echo -e "${GREEN}[*] Interesting Environment Variables:${NC}"
env | grep -E "(PATH|LD_|PYTHONPATH|PERL5LIB)" 2>/dev/null
echo ""

# 9. Password files (weak)
echo -e "${GREEN}[*] Password/secret files (sample):${NC}"
find / -name "*.passwd" -o -name "*.secret" -o -name "*.key" 2>/dev/null | head -10
echo ""

echo "========================================="
echo "  CHECK COMPLETE"
echo "========================================="