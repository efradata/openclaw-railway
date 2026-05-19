# OpenClaw on Railway

Minimal Railway deployment for OpenClaw using a custom Dockerfile and startup script.

## Railway setup

### 1. Connect the GitHub repository

Create a Railway service from this repository.

Railway should build the service using the `Dockerfile`.

### 2. Add a persistent volume

Add a Railway volume mounted at:

```bash
/data
````

This is required so OpenClaw keeps its configuration, workspace, sessions, and paired devices after redeploys.

### 3. Add Railway variables

Create the following variables in Railway:

```bash
OPENCLAW_STATE_DIR=/data
OPENCLAW_WORKSPACE_DIR=/data/workspace
PORT=8080
OPENCLAW_GATEWAY_TOKEN=<your-fixed-secure-token>
```

Important: use a fixed secure value for `OPENCLAW_GATEWAY_TOKEN`.

Do not leave it as:

```bash
${{secret()}}
```

if Railway regenerates it, because the token used in the OpenClaw UI may stop working after redeploys.

### 4. Open the Control UI

Open your Railway URL:

```text
https://your-service.up.railway.app/openclaw
```

When the UI asks for:

```text
Gateway Token
```

paste the value of:

```bash
OPENCLAW_GATEWAY_TOKEN
```

The password field can stay empty.

### 5. Approve the browser/device

OpenClaw may show:

```text
Device pairing required
```

The UI will show a command with a `requestId`, for example:

```bash
openclaw devices approve ab63c9a9-ef22-4aba-a9b3-0a2ba4432b87
```

Copy that command.

Then open Railway Shell / SSH:

```text
Railway → Service → Right click → Copy SSH Command
```

Run the approval command there:

```bash
openclaw devices approve <requestId>
```

After approval, reload the OpenClaw UI.

This pairing should persist because the `/data` volume is mounted.

## Notes

* `RAILWAY_PUBLIC_DOMAIN` is provided automatically by Railway.
* The startup script uses that domain to configure the allowed browser origin.
* Do not use wildcard origins like `*`.
* Keep secrets only in Railway variables, not in GitHub.
* If the UI says the origin is not allowed, check the Railway logs and confirm the startup script configured the Railway public domain.

---
E.