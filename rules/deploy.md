# Deploys and infrastructure

- **Pin images by tag plus digest:** `image: org/app:1.4.2@sha256:<digest>`. The tag says what
  it is; the digest guarantees it.
- **One release path:** git tag, then CI builds and pushes the image, then the digest is pinned
  in the compose file, then the host pulls it. Never build a release image on a laptop or on
  the server.
- **Deploy, then hash-compare.** After copying files to a host, compare a hash of each
  deployed file with the repo copy (`sha256sum` on both sides). Before a full-directory sync,
  confirm the host has not diverged from the repo.
- **Never overwrite runtime state.** A host's `.env`, caches and data directories live only on
  the host. Exclude them from every sync.
- **The repo is the source of truth.** Change the repo first, commit, then deploy from it.
  Never hand-edit a host and leave the repo behind.
- **Respect rollout order and maintenance windows.** Don't enable automatic merges or applies
  before their prerequisites (tests, monitoring, rollback) are in place.
- **Read-only first.** Discover the live state before changing it, and record what you found.
