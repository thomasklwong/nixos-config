
# Gemini CLI Guide for Managing this macOS Configuration

This guide provides instructions on how to use the Gemini CLI to effectively manage this macOS configuration. The primary goal is to use Nix for as much as possible, but fall back to `nix-homebrew` when necessary.

## Understanding the Configuration

This repository uses Nix Flakes to manage the macOS configuration. The main entry point is `flake.nix`.

### Exploring the configuration

To understand which packages are installed, you can inspect the relevant files in the `modules/darwin` and `modules/shared` directories.

*   **Nix Packages (macOS specific):** `modules/darwin/packages.nix`
*   **Nix Packages (Shared):** `modules/shared/packages.nix`
*   **Homebrew Brews:** `modules/darwin/brews.nix`
*   **Homebrew Casks:** `modules/darwin/casks.nix`

**Example: Find packages for macOS**

To see the packages installed via Nix, you can read the `modules/darwin/packages.nix` and `modules/shared/packages.nix` files:

```bash
read_file modules/darwin/packages.nix
read_file modules/shared/packages.nix
```

To see the Homebrew packages (casks and brews), you can read the `modules/darwin/casks.nix` and `modules/darwin/brews.nix` files:

```bash
read_file modules/darwin/casks.nix
read_file modules/darwin/brews.nix
```

### Searching for a specific package

To find where a specific package is defined, you can use `search_file_content`.

**Example: Find where the "git" package is defined**

```bash
search_file_content "git"
```

## Making Changes

### Package Management Strategy

This repository uses the following strategy for managing packages to ensure the best available version of a package is used, while also giving the user full control over the final decision.

1.  **GUI Applications:** For GUI applications, the preferred method is to use Homebrew Casks. These are managed in `modules/darwin/casks.nix`. If an application is only available on the Mac App Store, `mas` can be used as a fallback, which is managed declaratively through `nix-darwin` in the `modules/darwin/home-manager.nix` file.

2.  **CLI Tools & Libraries:** If the package is a command-line tool or a library, the following steps should be taken:
    a. **Check availability:** Check if the package is available in both Nixpkgs and Homebrew.
    b. **Compare versions:** If the package is available in both, compare the versions to see which one is more up-to-date.
    c. **User confirmation:** Present the options and ask for user confirmation before making any changes.
    d. **Use available:** If the package is only available in one system, use that one.

### Adding a new package

When adding a new package, follow the **Package Management Strategy** outlined above. Gemini will help with this process by searching for the package in both Nixpkgs and Homebrew, comparing the versions, and asking for confirmation.

### Modifying configurations

Configurations for different tools are located in the `modules/shared/config` and `modules/darwin/config` directories. To modify a configuration, read the file and then use `replace` to apply your changes.

**Example: Modify the `p10k.zsh` configuration**

1.  **Read the file:**
    ```bash
    read_file modules/shared/config/p10k.zsh
    ```

2.  **Apply changes:** Use `replace` to modify the configuration.

## Updating the System

To keep the system up-to-date, run the following command:

```bash
nix flake update
```

This will fetch the latest versions of all the inputs defined in the `flake.nix` file and update the `flake.lock` file.

## Applying Changes

After updating the flake or making changes to the configuration, the new configuration needs to be built and applied. This is done by running the following command in a terminal:

```bash
sudo nix run .#build-switch
```

This command will build and activate the new configuration for the macOS system. It requires `sudo` because it modifies system-level files.

## Eventual Removal of NixOS

This repository currently contains configurations for NixOS. However, the long-term goal is to remove the NixOS parts and focus exclusively on macOS.

## Managing Secrets (Agenix - Currently Disabled)

This repository uses `agenix` to manage secrets. The secrets are encrypted and stored in the repository, and they are decrypted at build time. The encrypted files are located in the `modules/shared/secrets` and `modules/darwin/secrets` directories.

**Note:** `agenix` is not currently in use. The following documentation is kept for future reference.

To edit a secret, you need to use the `agenix` command-line tool.

**Example: Edit a secret**

1.  **Open the secret for editing:**
    ```bash
    agenix -e modules/shared/secrets/some-secret.age
    ```
    This will open the decrypted file in your `$EDITOR`.

2.  **Save and encrypt:** After making your changes, save the file and close the editor. `agenix` will automatically re-encrypt the file.

3.  **Apply the changes:** Rebuild and apply the configuration for the changes to take effect.

For more information about `agenix`, refer to its documentation.
