# Компания ЧичаСофт

## Windows icon resource troubleshooting

If `rsrc` fails in CI with `bad magic number`, your `*.ico` file is most likely not a valid ICO container.

Use the helper script below in GitHub Actions (PowerShell) to validate the ICO header before running `rsrc`:

```powershell
pwsh -File scripts/generate-windows-icon.ps1 \
  -IconPath "public_html/images/app-icon.ico" \
  -OutputPath "zz_chicha_icon_windows_amd64.syso"
```

The script installs `github.com/akavel/rsrc`, verifies that the icon starts with `00 00 01 00`, and then generates the `.syso` file.
