# Atom

Backup packages
```bash
apm list --installed --bare > packages.list
```

Restore packages
```bash
apm install --packages-file packages.list
```
