# TLP

TLP config cannot be managed via stow as it lives in `/etc`. Deploy manually:

```bash
sudo cp ~/dotfiles/tlp/etc/tlp.d/99-custom.conf /etc/tlp.d/
sudo tlp start
```
