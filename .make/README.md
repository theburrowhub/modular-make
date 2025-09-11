# Makefile System Internal Files

This hidden directory contains all internal files for the Makefile system infrastructure.

## Contents

### Core System Files
- **colors.mk** - Centralized color definitions (ANSI escape codes) used across all Makefiles
- **internal.mk** - System utilities and control targets for managing the Makefile infrastructure

### Dependency Management
- **.make-deps** - Project-specific dependency definitions
- **.make-deps.example** - Example dependency file template

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
