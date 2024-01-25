# Define space for new EMMC partitions
disk_boot_start_mb=1 \
disk_boot_end_mb=512 \
disk_root_start_mb=$(($disk_boot_end_mb + 1)) \
disk_root_end_mb=100%

# Make partition table
sudo parted -s /dev/vda mklabel gpt

# Make root
sudo parted -s /dev/vda mkpart primary ext4 ${disk_root_start_mb}MiB ${disk_root_end_mb}
disk_root_partition=/dev/vda1

# Make boot
sudo parted -s /dev/vda mkpart primary fat32 ${disk_boot_start_mb}MiB ${disk_boot_end_mb}
disk_boot_partition=/dev/vda2
sudo parted /dev/vda set 2 boot on
sudo mkfs.fat -F 32 -n boot $disk_boot_partition

zfs_pool="rootpool"

# Make ZFS pool
sudo zpool create -f $zfs_pool $disk_root_partition

# Make ZFS datasets
zfs_pool_root="$zfs_pool/root" \
zfs_pool_nix="$zfs_pool/nix" \
zfs_pool_home="$zfs_pool/home"

sudo zfs create -o mountpoint=legacy $zfs_pool_root
sudo zfs create -o mountpoint=legacy $zfs_pool_nix
sudo zfs create -o mountpoint=legacy $zfs_pool_home

# Mount ZFS datasets
sudo mkdir -p /mnt
sudo mount -t zfs $zfs_pool_root /mnt

sudo mkdir -p /mnt/nix
sudo mount -t zfs $zfs_pool_nix /mnt/nix
sudo mkdir -p /mnt/home
sudo mount -t zfs $zfs_pool_home /mnt/home

# Mount boot partition
sudo mkdir -p /mnt/boot
sudo mount $disk_boot_partition /mnt/boot

# Mount data partition
sudo mkdir -p /mnt/home
sudo mount $disk_root_partition /mnt/home

# Download the flake
mkdir -p /mnt/etc/nixos
sudo curl -o /mnt/etc/nixos/flake.nix https://raw.githubusercontent.com/arduano/test-vm-nix/master/_remote_flake.nix

# Install nixos
sudo nixos-install --root /mnt --flake /mnt/etc/nixos#dev-vm
