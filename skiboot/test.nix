{ pkgs, skiboot }: {
  name = "skiboot";
  hostPkgs = pkgs;
  defaults.documentation.enable = pkgs.lib.mkDefault false;

  nodes.machine =
    { pkgs, ... }:

    {
      environment.systemPackages = with pkgs; [
        skiboot
        qemu
      ];

      virtualisation.memorySize = 1536;
    };

  testScript = ''
    hw = "Hello World!"
    assert hw in machine.succeed("qemu-system-ppc64 -M powernv8 -cpu power8 -nographic -bios ${skiboot}/skiboot.lid -kernel ${skiboot.test}/hello_kernel")
  '';
}
