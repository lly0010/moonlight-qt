# Patches

## moonlight-common-c-custom-ports.patch

This patch adds support for client-side **streaming port overrides** to the
`moonlight-common-c` submodule. It is required for the "Use custom ports"
feature in the Add PC dialog to be able to override the RTSP, video, audio and
control ports (the HTTP and HTTPS ports are handled entirely in the Qt app and
do not need this patch).

### Why a patch instead of a submodule commit?

`moonlight-common-c` is a git submodule pointing at the upstream
`moonlight-stream/moonlight-common-c` repository. Committing local changes to
the submodule and updating the gitlink in this repository would point at a
commit that does not exist on the upstream remote, which breaks
`git submodule update` on a fresh clone. To keep clean clones working, the
changes are tracked here as a patch and applied to the checked-out submodule
instead.

If you maintain your own fork of `moonlight-common-c`, you can instead commit
these changes there and update the submodule URL in `.gitmodules`.

### What it changes

* `src/Limelight.h` — adds `rtspPortOverride`, `videoPortOverride`,
  `audioPortOverride` and `controlPortOverride` fields to `SERVER_INFORMATION`.
* `src/Connection.c` / `src/Limelight-internal.h` — stores the overrides and
  applies the RTSP port override.
* `src/RtspConnection.c` — applies the video/audio/control port overrides,
  taking precedence over the ports negotiated via RTSP SETUP.

A non-zero override value is used in place of the default/negotiated port; a
value of 0 preserves the original behavior.

### Applying the patch

From the repository root:

```sh
./scripts/apply-common-c-patch.sh
```

or manually:

```sh
git -C moonlight-common-c/moonlight-common-c apply ../../patches/moonlight-common-c-custom-ports.patch
```

The script is idempotent: it skips applying if the patch is already present.
