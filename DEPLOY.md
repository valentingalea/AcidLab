# VPS Deployment Runbook

How to recreate the public AcidLab deployment on a fresh VPS. Follow top to bottom — each step assumes the previous ones succeeded.

Target setup: a public subdomain (`acidlab.duckdns.org`) proxying to a localhost-bound Python server serving `/`, `/index.html`, and the `/lessons/*` subpages.

> **If you already deployed another site on this VPS** (e.g. GolfWar, Puckline, Mudline), the Caddy install / DuckDNS / firewall steps (sections 1–5) are already done. Skip ahead to section **3a** to add AcidLab as another site to the existing Caddyfile, then start the AcidLab origin on its own port.

---

## 0. Prerequisites

- A VPS running **Debian 12 / Ubuntu 22.04+** (adjust package names for other distros)
- Root access (all commands assume root; prefix with `sudo` if not root)
- A **public IPv4 address** — record it now:
  ```
  curl -4 -s ifconfig.me
  ```
- **SSH access** — confirm the sshd port before touching the firewall:
  ```
  ss -tlnp | grep sshd
  ```
- **Git** installed and repo cloned:
  ```
  apt-get install -y git
  git clone <repo-url> /usr/games/AcidLab
  ```
- **Python 3** (pre-installed on most modern distros):
  ```
  python3 --version
  ```

---

## 1. DuckDNS subdomain

If you don't own a domain, DuckDNS gives you a free `*.duckdns.org` subdomain that plays nicely with Let's Encrypt.

1. Go to https://www.duckdns.org and sign in (GitHub/Google/etc., no email required).
2. Claim a subdomain, e.g. `acidlab.duckdns.org`.
3. **Set the IP field to the VPS's public IPv4**, not your home IP. (DuckDNS auto-fills with the IP of the browser you're signing in from — if you're on your laptop, that's wrong. Paste the VPS IP explicitly.)
4. Click **update ip**.

Verify from the VPS (wait up to 60s for propagation):
```
getent ahosts acidlab.duckdns.org
```
The first column must match the VPS public IPv4. If not, fix it before proceeding — Let's Encrypt will refuse to issue a cert.

**If you have your own domain** instead: set an A record pointing the domain at the VPS IP, substitute it anywhere this runbook says `acidlab.duckdns.org`.

---

## 2. Install Caddy

Caddy is the reverse proxy. It handles TLS automatically (Let's Encrypt), path routing, and runs under systemd.

```
export DEBIAN_FRONTEND=noninteractive
apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
  | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
  > /etc/apt/sources.list.d/caddy-stable.list
apt-get update
apt-get install -y caddy
caddy version                 # verify install
systemctl is-enabled caddy    # should say "enabled"
```

The Caddy package ships a systemd unit that runs as user `caddy`, auto-starts on boot, and handles cert renewal.

---

## 3. Write the Caddyfile

Replace the default `/etc/caddy/Caddyfile` with the allowlist config below. **Change `acidlab.duckdns.org` to your subdomain.**

```
acidlab.duckdns.org {
	encode gzip zstd

	@allowed path / /index.html /lessons/*
	handle @allowed {
		reverse_proxy 127.0.0.1:8083
	}

	handle {
		respond 404
	}

	log {
		output file /var/log/caddy/acidlab-access.log
	}
}
```

What this does:
- TLS is implicit — Caddy fetches a Let's Encrypt cert on first request.
- `@allowed path` is a named matcher listing the only paths that get proxied through to Python: `/`, `/index.html`, and anything under `/lessons/` (each lesson is its own self-contained `lessons/<slug>/index.html`, linked from the root page).
- The catch-all `handle { respond 404 }` returns 404 for everything else — `.git/`, dotfiles, `start.sh`, `server.log`, `README.md` etc. never reach the origin.
- Every lesson page is fully self-contained (no external JS/CSS imports), so the origin only ever serves static HTML.
- Access log goes to `/var/log/caddy/acidlab-access.log`.

> **If a new lesson adds a local asset** (e.g. a shared stylesheet or a sample audio file outside `lessons/*`), add its path/prefix to the `@allowed path` line and `systemctl reload caddy`.

### 3a. Adding AcidLab alongside existing sites

If the Caddyfile already has other site blocks (e.g. GolfWar's `vinyltin.duckdns.org`, Puckline's `puckline.duckdns.org`, Mudline's `mudline.duckdns.org`), simply append the AcidLab block at the bottom — Caddy supports many independent virtual hosts in one file. Make sure each site uses a different `reverse_proxy` port and a different subdomain.

Validate the config:
```
caddy validate --config /etc/caddy/Caddyfile
```
Should print `Valid configuration`.

---

## 4. Create the Caddy log directory (don't skip this)

If Caddy tries to write to `/var/log/caddy/acidlab-access.log` before the directory exists, systemd creates the file as `root:root` and Caddy (running as user `caddy`) can't open it. Fix it preemptively:

```
mkdir -p /var/log/caddy
chown -R caddy:caddy /var/log/caddy
```

If you hit "permission denied" on a future Caddy start, the cure is the same `chown -R caddy:caddy /var/log/caddy/`.

> **Adding a new site to an already-running Caddy**: the same trap fires on the *new* log file. The first `systemctl reload caddy` after appending the AcidLab block fails because the log file doesn't exist yet — Caddy tries to open it, fails, and systemd creates an empty `acidlab-access.log` owned `root:root`. Every subsequent reload then also fails on the same file, and systemd's reload state gets stuck (`systemctl is-active caddy` reports `reloading` indefinitely, retrying every 90s). Fix:
> ```
> touch /var/log/caddy/acidlab-access.log
> chown caddy:caddy /var/log/caddy/acidlab-access.log
> caddy reload --config /etc/caddy/Caddyfile     # bypasses stuck systemd reload via admin API on :2019
> ```
> Then kill any orphaned `systemctl reload caddy` waiter processes (`ps -eo pid,cmd | grep 'systemctl reload caddy'`). `caddy reload` talks to the live process directly, so it works even when systemd thinks a reload is mid-flight.

---

## 5. Firewall (ufw)

Lock down the VPS to ports 22 (SSH), 80 (HTTP — Caddy needs it for the Let's Encrypt challenge and HTTP→HTTPS redirect), and 443 (HTTPS).

**Verify your SSH port matches the `ufw allow 22/tcp` line below, or you will lock yourself out.**

```
ufw allow 22/tcp     # adjust if sshd is on a different port
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 443/udp    # HTTP/3 (QUIC) — see note below; don't skip
ufw --force enable
ufw status
```

Port 8083 is intentionally **not** opened. Python is bound to `127.0.0.1` so nothing external could reach it anyway, but the firewall gives belt-and-suspenders.

> **Don't skip `443/udp`.** Caddy serves HTTP/3 and advertises it to every client via the `alt-svc: h3=":443"` response header, but HTTP/3 runs over **UDP** 443, not TCP. If only `443/tcp` is open, inbound QUIC packets are *silently dropped* — desktop browsers quietly fall back to HTTP/2 over TCP, but mobile browsers (Chrome/Safari) prefer QUIC and cache the `alt-svc` h3 promise for ~30 days, so they keep retrying UDP 443 and time out, then self-heal once they flag h3 "broken" and fall back, then relapse later. The symptom is **intermittent, mobile-only "can't connect" that comes and goes on its own** while the server is provably stable. Opening `443/udp` (v4 + v6) is the fix. (If you ever need UDP closed for policy reasons, the alternative is to disable HTTP/3 in Caddy with a global `servers { protocols h1 h2 }` block so it stops advertising h3.)

---

## 6. Bring it up

Start Caddy (fetches cert on first public request to a new hostname):
```
systemctl reload caddy        # if Caddy was already running for another site
# or
systemctl start caddy         # first time
systemctl is-active caddy     # should say "active"
```

Start the Python origin in the background:
```
cd /usr/games/AcidLab
./start.sh --background
```

`start.sh` binds Python to `127.0.0.1:8083`. **Never** change it back to `0.0.0.0` — that re-exposes the whole repo root including dotfiles and `.git/`, which credential scanners actively probe.

Confirm listeners:
```
ss -tlnp | grep -E ':80 |:443 |:8083 '
```
Expected: `caddy` on `:80` and `:443` (IPv4+IPv6), `python3` on `127.0.0.1:8083` only.

---

## 7. Verify from outside

From your laptop (or anywhere not localhost):

```
curl -sI https://acidlab.duckdns.org/                                          # expect 200
curl -sI https://acidlab.duckdns.org/index.html                                # expect 200
curl -sI https://acidlab.duckdns.org/lessons/00-oscillator/index.html          # expect 200
curl -sI https://acidlab.duckdns.org/.git/config                               # expect 404 at Caddy
curl -sI https://acidlab.duckdns.org/server.log                                # expect 404 at Caddy
curl -sI https://acidlab.duckdns.org/start.sh                                  # expect 404 at Caddy
curl -sI https://acidlab.duckdns.org/README.md                                 # expect 404 at Caddy
```

The first request to a new domain may take 5–15s while Caddy negotiates the Let's Encrypt cert. Subsequent requests are instant.

Open `https://acidlab.duckdns.org/` in a browser — should load the AcidLab lesson index with a valid TLS padlock, and each lesson card should link through to its own page.

---

## 8. Day-to-day operations

| Task | Command |
|---|---|
| Start Python origin | `cd /usr/games/AcidLab && ./start.sh --background` |
| Stop Python origin | `./kill.sh` |
| Reload Caddy after Caddyfile edit | `systemctl reload caddy` |
| Restart Caddy | `systemctl restart caddy` |
| Tail Caddy access log | `tail -f /var/log/caddy/acidlab-access.log` |
| Tail Caddy service log | `journalctl -u caddy -f` |
| Tail Python access log | `tail -f /usr/games/AcidLab/server.log` |
| Validate Caddyfile before reload | `caddy validate --config /etc/caddy/Caddyfile` |
| Pull updates and restart | `cd /usr/games/AcidLab && git pull && ./kill.sh && ./start.sh --background` |

---

## 9. Troubleshooting

**Caddy won't start, "permission denied" on access.log**
`chown -R caddy:caddy /var/log/caddy/`

**`systemctl is-active caddy` is stuck on `reloading`**
A failed reload (usually the access-log perms trap above when adding a new site) leaves systemd retrying every 90s, while the live Caddy process keeps serving the *old* config. Fix the underlying cause (e.g. `chown caddy:caddy /var/log/caddy/acidlab-access.log`), then push the new config straight to Caddy via its admin API: `caddy reload --config /etc/caddy/Caddyfile`. Afterwards, kill any stale `systemctl reload caddy` waiter processes (`pkill -f 'systemctl reload caddy'`).

**Let's Encrypt cert won't issue**
- `getent ahosts acidlab.duckdns.org` must return the VPS IPv4.
- Port 80 must be reachable from the internet (Let's Encrypt HTTP challenge). Check `ufw status` and that no upstream firewall/NAT is in the way.
- Check `journalctl -u caddy -n 50` for the specific ACME error.

**Root page loads but a lesson 404s**
The lesson path doesn't match the `@allowed path` matcher. New lessons live under `lessons/<slug>/index.html`, which the `/lessons/*` glob already covers — but a lesson added directly at the repo root would not be. Move it under `lessons/`, or extend the matcher.

**Port conflict — Caddy can't bind :80 or :443**
`ss -tlnp | grep -E ':80 |:443 '` — something else is already listening. Stop it or reassign.

**I accidentally bound Python to 0.0.0.0 again**
Revert `start.sh` to bind `'127.0.0.1'`, run `./kill.sh`, then `./start.sh --background`. Check `server.log` for any scanner hits that landed during the exposure window.
