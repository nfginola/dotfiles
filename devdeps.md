# Development Dependencies

Snapshot between each stage.

`base-devel` covers `gcc`, `g++`, `make`, `binutils`, etc.

## Stage 1 - Core dev

```bash
sudo pacman -S cmake clang gdb llvm valgrind strace uv
yay -S flamegraph
```

| Package | Purpose |
| ------- | ------- |
| `cmake` | Build system for C/C++ projects |
| `clang` | Alternative compiler + `clangd` LSP for editor integration |
| `gdb` | Debugger |
| `llvm` | LLVM toolchain: building compilers from source |
| `valgrind` | Memory leak and error detection |
| `strace` | Syscall tracing |
| `uv` | Python: manages its own Python versions, no system Python needed |
| `flamegraph` | CPU profiling flamegraphs |

## Stage 2 - Odin

```bash
sudo pacman -S odin odinfmt ols
```

| Package | Purpose |
| ------- | ------- |
| `odin` | Odin compiler |
| `odinfmt` | Source code formatter |
| `ols` | Language server for editor integration |

## Stage 3 - OS Development

Only needed for bare-metal / kernel work. Snapshot before installing.

```bash
sudo pacman -S qemu-full
yay -S i386-elf-gcc
```

| Package | Purpose |
| ------- | ------- |
| `qemu-full` | Virtualization — pulls in `edk2-ovmf`, `vde2`, `virtiofsd`, and all QEMU components as dependencies |
| `i386-elf-gcc` | Cross-compiler for i386 — pulls in `i386-elf-binutils` as a dependency |

