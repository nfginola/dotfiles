# Btrfs Snapshots & Copy-on-Write

- **COW**: writes go to new blocks, old blocks are preserved instead of overwritten
- **Snapshot**: a saved set of pointers to all blocks at a point in time
- **Shared data**: unchanged blocks between snapshots are one physical chunk pointed to by many snapshots
- **Real memory cost**: only the blocks that changed between snapshots, not the full snapshot size
- **`du` is not accurate**: reports every referenced block per snapshot
    - use `btrfs filesystem du` for btrfs-aware memory info
- **Performance**: indirection concerns? meh. Negligible on SSDs
