-- vim: syntax=lua
local L4 = require "L4";

local l = L4.Loader.new({
    mem = L4.Env.user_factory,
    log_fab = L4.default_loader:new_channel(),
  });



L4.default_loader:start(
  {
    base     = 0x200000,  -- Offset for l4re_kernel
    ldr_base = 0x200000,  -- Offset of uvmm
    log = L4.Env.log,
    caps = {
      cons = l.log_fab:svr(),
      jdb  = L4.Env.jdb,
    },
  }, "rom/cons -a");


local platform_ctl = l:new_channel();
local linux_vbus = l:new_channel()
l:startv(
  {
    base     = 0x800000,  -- Offset for l4re_kernel
    ldr_base = 0x800000,  -- Offset of uvmm
    caps = {
      sigma0        = L4.cast(L4.Proto.Factory, L4.Env.sigma0):create(L4.Proto.Sigma0);
      icu           = L4.Env.icu;
      iommu         = L4.Env.iommu;
      platform_ctl  = platform_ctl:svr(),
      jdb           = L4.Env.jdb,

      -- vbus capabilities
      linux_vm      = linux_vbus:svr(),
    };
    log = {"io", "r", "keep"};
  }, "rom/io", "-vvv", "rom/io.lua")


local mem_flags = L4.Mem_alloc_flags.Continuous
                  | L4.Mem_alloc_flags.Pinned
                  | L4.Mem_alloc_flags.Super_pages;

local ram_zephyr = L4.Env.user_factory:create(L4.Proto.Dataspace,
                                              2 * 1024 * 1024,
                                              mem_flags, 20, 0x02000000):m("rw");

l:startv(
  {
    base     = 0x400000,  -- Offset for l4re_kernel
    ldr_base = 0x400000,  -- Offset of uvmm
    log = { "zephyr", "normal" },
    --log = L4.Env.log,
    caps = {
      jdb = L4.Env.jdb,
      ram = ram_zephyr,
    },
  },
  "rom/uvmm", "-i", "-drom/virt-arm_r82-zephyr.dtb", "-krom/zephyr.elf",
  "-b0x02000000")


local ram_linux = L4.Env.user_factory:create(L4.Proto.Dataspace,
                                             128 * 1024 * 1024,
                                             mem_flags, 20, 0x02200000):m("rw");

l:startv(
  {
    base     = 0x600000,  -- Offset for l4re_kernel
    ldr_base = 0x600000,  -- Offset of uvmm
    log = { "linux", "normal" },
    --log = L4.Env.log,
    caps = {
      jdb = L4.Env.jdb,
      ram = ram_linux,
      vbus = linux_vbus,
    },
  },
  "rom/uvmm", "-i", "-b0x02200000",
  "-drom/virt-arm_r82-linux.dtb", "-krom/vmlinux", "-rrom/initramfs.cpio.gz",
  "-cconsole=ttyAMA0 earlyprintk=1 debug"
  )
