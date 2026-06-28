# Linux-Privilege-Escalation-Checker


🎯 Objective

To automate the enumeration of common privilege escalation vectors on a Linux system. Manual privilege escalation checks are time‑consuming and error‑prone; this tool consolidates dozens of manual commands into a single, structured report. It helps system administrators proactively close security gaps and helps penetration testers quickly identify the most promising attack paths during an engagement.
🧠 How It Works – Technical Overview

The tool (written in Bash and Python) performs a non‑intrusive, read‑only scan of the target system. It queries system files, process listings, scheduled tasks, and environment variables using native Linux utilities. All checks are performed with the permissions of the current user—simulating exactly what an attacker who has gained initial low‑privileged access would see.

Key areas of inspection include:
Check Area	What It Looks For	Why It Matters
Sudo Permissions	Any commands the user can run with sudo (especially if NOPASSWD is set).	A misconfigured sudoers entry can allow trivial privilege escalation (e.g., sudo vim, sudo apt).
SUID/SGID Binaries	Files with the setuid or setgid bit set (e.g., find, pkexec, exim).	These binaries run with elevated privileges; if they have known exploits, an attacker can instantly become root.
Writable System Files	Files in /etc (e.g., /etc/passwd, /etc/shadow, /etc/sudoers) that are writable by the current user.	Writing to /etc/passwd can create a backdoor root user; writing to /etc/sudoers can grant full sudo access.
Writable Directories in $PATH	Directories in the system PATH that the current user can write to.	An attacker can plant a malicious script (e.g., a fake ls) that executes with the privileges of the next user who runs that command.
Cron Jobs	Scheduled tasks (in /etc/cron*, user crontabs) and their associated scripts.	If a cron job runs a writable script or binary, an attacker can modify it to execute malicious code with root privileges.
Kernel Version	The uname -a output to check for vulnerable kernels.	Outdated kernels are often vulnerable to well‑known local privilege escalation exploits (e.g., Dirty Cow, OverlayFS).
Environment Variables	Sensitive variables like LD_PRELOAD, LD_LIBRARY_PATH, PYTHONPATH.	Misconfigured library paths can be abused to load malicious shared libraries into privileged processes.
Weak Password Files	World‑readable files with names containing passwd, secret, key, etc.	Hard‑coded credentials or sensitive keys stored in plaintext are a goldmine for attackers.
✨ Advanced Features (Real‑World Upgrade)
Feature	Implementation
Comprehensive Coverage	Executes 10+ distinct checks covering filesystem, process, network, and kernel vectors – far beyond a simple sudo -l.
Non‑Intrusive Scanning	Performs only read‑only operations; does not attempt to exploit any vulnerabilities (safe for production use).
Structured JSON/CSV Output	Outputs results in machine‑readable formats for easy integration with SIEMs or vulnerability management platforms.
Color‑Coded Terminal Output	Highlights high‑risk findings (e.g., SUID binaries, writable PATH dirs) in red for immediate attention.
Automated Reporting	Generates a timestamped report file that can be attached to tickets or shared with the security team.
Audit Trail	Logs the scan time, user, and system information for compliance and historical tracking.
🛠️ Tools & Technologies

    Bash – for fast, native system queries.

    Python 3 – for advanced parsing, logic, and structured output generation.

    Standard Linux Utilities – find, sudo, ls, env, uname, crontab, ps, netstat.

    JSON – for structured reporting.

🔬 Testing & Typical Findings

Scenario:
The tool is executed by a non‑privileged user (jenishkali) on a Kali Linux system that contains several common misconfigurations intentionally left unpatched for demonstration.

Typical Findings:

    SUID Binary: /usr/bin/passwd (normal), but also /usr/bin/pkexec and /usr/bin/exim (which may be vulnerable to known CVEs).

    Writable Directory in PATH: /home/jenishkali/.local/bin is writable and appears in the user's PATH.

    Sudo Misconfiguration: The user can run /usr/bin/apt without a password (NOPASSWD: /usr/bin/apt), which can be trivially exploited to gain root.

    Cron Job Script: A root cron job executes /opt/backup.sh, and that file is writable by the jenishkali user.

    Outdated Kernel: Linux version 5.10.0-kali7-amd64 is detected, which is vulnerable to multiple local privilege escalation exploits.

Outcome:

    The report clearly highlights each misconfiguration with a risk level.

    The system administrator can use this report to patch the kernel, remove the writable PATH, restrict sudo, and secure the cron script.

    The penetration tester can prioritise attacking the apt sudo entry to gain root immediately.

📁 Output Example (JSON Structure)

A typical report entry contains:

    Timestamp – Scan date and time.

    User – The user who ran the scan.

    Vulnerability – Description of the finding (e.g., Writable PATH dir: /home/user/bin).

    Risk Level – HIGH, MEDIUM, or LOW.

    Recommendation – Step‑by‑step remediation advice.

📝 Conclusion

The Linux Privilege Escalation Checker is an invaluable tool for both offensive and defensive security teams. It provides a complete, automated overview of the attack surface available to a low‑privileged user, drastically reducing the time required for manual enumeration. Its structured output allows for easy tracking of security improvements over time. During testing, the tool successfully identified multiple high‑risk misconfigurations, including a writable PATH directory and a NOPASSWD sudo entry, demonstrating its effectiveness in uncovering real‑world vulnerabilities that could otherwise lead to full system compromise.
