# Makefile System Internal Files

This hidden directory contains all internal files for the Makefile system infrastructure.

## Contents

### Core System Files
- **colors.mk** - Centralized color definitions (ANSI escape codes) used across all Makefiles
- **internal.mk** - System utilities and control targets for managing the Makefile infrastructure

### Dependency Management
- **.make-deps** - Unified dependency and tools configuration with auto-install support
- **.make-deps.example** - Example dependency file template

## Dependency and Tools Management

The `.make-deps` file provides a unified system for managing both project dependencies and development tools.

### Configuration Format

Dependencies are defined in `.make-deps` with the following format:
```
command:::description:::level:::check_command:::install_command
```

Fields (separated by `:::` to avoid conflicts):
- **command**: The command/tool name
- **description**: Human-readable description
- **level**: `required`, `recommended`, or `optional`
- **check_command**: Command to verify installation (e.g., `tool --version`)
- **install_command**: Auto-installation command (leave empty for manual install)

### Example Entries

```bash
# Manual installation (no install command)
make:::GNU Make build tool:::required:::make --version:::

# Auto-installable tool
cherry-go:::Makefile system manager:::required:::cherry-go --version 2>/dev/null:::curl -sSL https://raw.githubusercontent.com/theburrowhub/cherry-go/main/install.sh | bash

# Package manager installation
jq:::JSON processor:::optional:::jq --version:::brew install jq
```

### Available Commands

#### Check Dependencies
```bash
make check-deps     # Show status of all dependencies
```
Shows:
- ✅ Installed tools with version info
- ✗ Missing required dependencies
- ○ Missing optional/recommended tools
- Installation instructions for auto-installable tools

#### Auto-Install Dependencies
```bash
make deps-update    # Install all missing auto-installable dependencies
```
Automatically installs all tools that have install commands defined.

#### Install Specific Tool
```bash
make deps-install TOOL=cherry-go   # Install a specific tool
```
Installs or updates a specific tool if it has an install command.

#### List All Dependencies
```bash
make deps-list      # Show all dependencies with their status
```
Displays all configured dependencies with their installation status and capability.

### Adding New Dependencies

1. Edit `.make/.make-deps`:
   ```bash
   make deps-edit
   ```

2. Add entry with appropriate format:
   ```
   tool_name:::Description:::level:::version_check:::install_command
   ```

3. Run `make deps-update` to install all new auto-installable tools

### Tips

- Tools with install commands can be automatically installed/updated
- Some tools may require PATH updates or shell restart after installation
- Use `make check-deps` regularly to ensure all required tools are available
- Required dependencies will cause `check-deps` to exit with error if missing
- The system respects existing installations and won't reinstall unless requested

## Usage

These files are automatically included by the main Makefile and should not be modified directly unless you're customizing the Makefile system itself.

### Color System
All Makefiles must include the color definitions:
- Main Makefile: `-include .make/colors.mk`
- Subdirectories: `-include ../.make/colors.mk`

### Utilities
System utilities are included via:
- Main Makefile: `-include .make/internal.mk`

## Note
This directory is hidden (starts with `.`) to keep the repository root clean and focused on project files rather than build system internals.
