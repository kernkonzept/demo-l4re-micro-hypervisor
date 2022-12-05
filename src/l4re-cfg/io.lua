local Res = Io.Res
local Hw = Io.Hw

local add_children = Io.Dt.add_children

add_children(Io.system_bus(), function()
  uart1 = Hw.Device(function()
    Property.hid = "AMBA PL011";
    compatible = {"arm,pl011","arm,primecell"};
    Resource.irq0 = Res.irq(32 + 6, Io.Resource.Irq_type_level_high);
    Resource.regs = Res.mmio(0x9c0a0000, 0x9c0affff);
  end);
end)

Io.add_vbusses
{ 
  linux_vm = Io.Vi.System_bus(function()
    uart1 = wrap(Io.system_bus().uart1);
  end);
}
