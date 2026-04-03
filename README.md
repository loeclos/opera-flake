# Opera Flakes

This repository provides **Nix Flake** packaging for the **Opera** and **Opera GX** browsers on Linux.

> **Note:** Opera is proprietary software. By using this flake, you agree to Opera's EULA.



## Usage

### 1. Try it instantly (without installation)

You can run the browsers directly using `nix run`:

```bash
# Run Opera Stable
nix run github:yisuidenghua/opera-flake#opera

# Run Opera GX
nix run github:yisuidenghua/opera-flake#opera-gx
```



## 2. Install via `nix profile`

To install the browser into your user profile:

```bash
nix profile install github:yisuidenghua/opera-flake#opera

nix profile install github:yisuidenghua/opera-flake#opera-gx
```



## 3.  Integrate into NixOS Configuration

Add the flake to your `inputs` and use the provided **overlay** for the cleanest integration.

**flake.nix:**

```Nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    opera-flake = {
      url = "github:yisuidenghua/opera-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, opera-flake, ... }: {
    nixosConfigurations.<your-hostname> = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        {
          nixpkgs.overlays = [ opera-flake.overlays.default ];
          # Required for proprietary software
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };
  };
}
```

**configuration.nix:**

```nix
{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.opera
    pkgs.opera-gx
  ];
}
```

## 4. Integrate into Home Manager

If you manage your packages via Home Manager:

**home.nix:**

Nix

```
{ pkgs, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  
  home.packages = [
    inputs.opera-flake.packages.${pkgs.system}.opera
    inputs.opera-flake.packages.${pkgs.system}.opera-gx
  ];
}
```

## Maintenance

This flake includes an `update.sh` script that automatically fetches the latest versions and SHA256 hashes directly from Opera's FTP servers.

## Disclaimer

This is a community-maintained project. Opera is a trademark of Opera Norway AS. The maintainer is not affiliated with Opera. 