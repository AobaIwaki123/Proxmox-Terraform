# Terraform inventory backup

Terraform state and the real `terraform.tfvars` contain infrastructure details and may contain secrets. The backup uses restic to encrypt the data before it reaches Google Cloud Storage.

## Scope

The daily backup includes:

- `~/proxmox-inventory`, including its Terraform state, local provider credentials, and real `terraform.tfvars`.
- `~/proxmox-terraform-migration-backup-20261123.tgz`, the one-time archive of the previous environment layout.

Terraform's `.terraform` provider cache is excluded because it can be recreated with `terraform init`.

The timer starts daily around 03:00 Japan time. It keeps 14 daily, 8 weekly, and 12 monthly snapshots. The service writes its result to the user's systemd journal.

## Install on terraform.vm

The service expects these files to exist with mode `0600` under `~/.config/restic/`:

- `gcs-key.json`: the dedicated GCS service-account key.
- `password`: the restic repository password, stored separately from this repository.

Install and enable the user timer:

```sh
mkdir -p ~/.config/systemd/user
cp backup/proxmox-inventory-backup.service backup/proxmox-inventory-backup.timer ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now proxmox-inventory-backup.timer
```

To run after logout and after reboot, enable lingering once as an administrator:

```sh
sudo loginctl enable-linger aoba
```

Run the service immediately and inspect its result:

```sh
systemctl --user start proxmox-inventory-backup.service
journalctl --user -u proxmox-inventory-backup.service
```

## Restore

On a replacement machine, install restic and the Google Cloud CLI, authenticate with an account that can access this bucket, then retrieve the repository password from Secret Manager:

```sh
gcloud auth application-default login
mkdir -p "$HOME/.config/restic"
umask 077
gcloud secrets versions access latest --secret=proxmox-restic-password --project=aoba-infra-backup-20261123 > "$HOME/.config/restic/password"
export GOOGLE_PROJECT_ID=aoba-infra-backup-20261123
export RESTIC_REPOSITORY=gs:aoba-infra-backup-20261123:/proxmox
export RESTIC_PASSWORD_FILE="$HOME/.config/restic/password"
restic snapshots
restic restore latest --target "$HOME/proxmox-restore"
```

The restic password is required to decrypt the backup. It is stored in Secret Manager so it can be retrieved if `terraform.vm` is lost. Access to the GCP account and project is therefore required for recovery.
