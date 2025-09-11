# Modular Make - Advanced Makefile System

A comprehensive, modular Makefile system designed to simplify and standardize build automation across projects. This repository provides a reusable framework with color-coded output, automatic target discovery, dependency management, and built-in help system.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#-getting-started)
- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Help System](#help-system)
- [Dependency Management](#dependency-management)
- [System Utilities](#system-utilities)
- [Color System](#color-system)
- [Project Structure](#project-structure)
- [Customization](#customization)

## Overview

This Makefile system provides a scalable, maintainable approach to project automation. It automatically discovers and integrates Makefiles from subdirectories, provides comprehensive help documentation, and includes utilities for dependency checking and conflict detection.

### Key Benefits

- **Modular Design**: Separate Makefiles for different concerns (docker, deploy, test, docs, etc.)
- **Auto-discovery**: Automatically finds and includes subdirectory Makefiles
- **Rich Help System**: Self-documenting with examples and categorized targets
- **Dependency Management**: Track and verify required tools
- **Beautiful Output**: Color-coded messages for better readability
- **Conflict Detection**: Identifies duplicate target names across modules

## Features

- 🎨 **Color-coded output** for better readability
- 📚 **Self-documenting** targets with inline help
- 🔍 **Automatic subdirectory discovery** and inclusion
- 🏷️ **Target categorization** with section headers
- 📋 **Multiple help levels** (quick help, full help with examples)
- 🔧 **Dependency checking** system
- 🚦 **Conflict detection** for target names
- 📊 **System information** and statistics
- 🏗️ **Modular architecture** for easy extension

## 🚀 Getting Started

### Quick Setup (< 2 minutes)

1. **Clone this repository**:
   ```bash
   git clone https://github.com/theburrowhub/modular-make.git /tmp/modular-make
   ```

2. **Copy to your project**:
   ```bash
   cd your-project
   cp -r /tmp/modular-make/.make .
   cp /tmp/modular-make/Makefile .
   ```

3. **Test it works**:
   ```bash
   make        # Shows quick help
   make help   # Shows full documentation
   ```

That's it! You now have a fully functional Makefile system.

### Optional: Add Example Modules

Want to see examples in action? Copy some sample modules:

```bash
# Copy example modules (adjust as needed)
cp -r /tmp/modular-make/docker .
cp -r /tmp/modular-make/test .
```

Then try:
```bash
make list-all    # See all available targets
make build       # Run Docker build (if docker module copied)
make test        # Run tests (if test module copied)
```

### Create Your Own Targets

Add your own targets to the main `Makefile` or create a new module:

```makefile
# Example: Add to your main Makefile or create a new module like 'myapp/Makefile'
# Remember to include colors for pretty output
-include .make/colors.mk  # or ../.make/colors.mk for subdirectories

##@ My Application Targets

start: ##! Start the application (shown in main help)
	@echo "$(BLUE)🚀 Starting application...$(NC)"
	@echo "[Your start command here]"
	@echo "$(GREEN)✅ Application started!$(NC)"

stop: ## Stop the application (only in 'make list-all')
	@echo "$(YELLOW)⏹ Stopping application...$(NC)"
	@echo "[Your stop command here]"

restart: ## Restart the application
	@$(MAKE) stop
	@$(MAKE) start

##? Examples:
# make start                    # Start with defaults
# make start PORT=3000          # Start on specific port
# make restart                  # Stop and start again
```

Now try:
```bash
make           # Your 'start' target appears in quick help!
make help      # Shows your examples
make start     # Runs your new target
```

### Next Steps

- **Check dependencies**: `make check-deps` to see what tools you need
- **Explore utilities**: `make utils` to see system management commands  
- **Read full docs**: Continue reading below for detailed explanations

---

## Installation

### Quick Install in Your Project

1. **Clone or download** this repository:
   ```bash
   git clone https://github.com/theburrowhub/modular-make.git
   cd modular-make
   ```

2. **Copy the system files** to your project:
   ```bash
   # Copy the main Makefile (adjust as needed for your project)
   cp Makefile /path/to/your/project/
   
   # Copy the hidden .make directory with system files
   cp -r .make /path/to/your/project/
   
   # Optionally, copy example subdirectory Makefiles
   cp -r docker /path/to/your/project/
   cp -r deploy /path/to/your/project/
   cp -r test /path/to/your/project/
   cp -r doc /path/to/your/project/
   ```

3. **Initialize dependencies** (optional):
   ```bash
   cd /path/to/your/project
   make deps-init
   ```

4. **Verify installation**:
   ```bash
   make info
   ```

### Alternative: Use as a Git Submodule

```bash
cd /path/to/your/project
git submodule add https://github.com/theburrowhub/modular-make.git .make-system
ln -s .make-system/Makefile Makefile
ln -s .make-system/.make .make
```

## Basic Usage

### Quick Start

```bash
# Show quick help (default target)
make

# Show full help with examples
make help

# List all available targets
make list-all

# Check dependencies
make check-deps
```

## Help System

The Makefile system provides multiple levels of help:

### 1. Quick Help (Default)
```bash
make
# or
make quick
```
Shows only the most important targets marked with `##!` and basic usage information.

### 2. Full Help with Examples
```bash
make help
```
Displays all targets, examples, and comprehensive documentation.

### 3. List All Targets
```bash
make list-all
```
Shows every available target from all Makefiles.

### 4. System Utilities
```bash
make utils
```
Displays all system maintenance and utility targets.

### Target Documentation Conventions

- `##` - Regular target documentation
- `##!` - Important target (shown in main help)
- `##@` - Section header
- `##?` - Example section marker

Example in your Makefile:
```makefile
##@ Build Operations

build: ##! Build the application
	@echo "Building..."

test: ## Run tests
	@echo "Testing..."

##? Examples:
# make build
# make test VERBOSE=true
```

## Dependency Management

The system includes a comprehensive dependency checking mechanism.

### Check Dependencies
```bash
# Check all required and recommended tools
make check-deps
```

### Configure Dependencies

1. **Initialize dependency file**:
   ```bash
   make deps-init
   ```

2. **Edit dependencies**:
   ```bash
   make deps-edit
   ```

3. **View current configuration**:
   ```bash
   make deps-show
   ```

### Dependency File Format

The `.make-deps` file uses a simple format:
```
command:description:level
```

Where `level` can be:
- `required` - Must be installed for the system to work
- `recommended` - Should be installed for full functionality
- `optional` - Nice to have, but not necessary

Example `.make-deps`:
```
make:GNU Make build tool:required
docker:Docker container runtime:required
kubectl:Kubernetes CLI:recommended
aws:AWS CLI:optional
```

## System Utilities

The Makefile system includes numerous utilities for maintenance and inspection:

### Information & Discovery
```bash
# Show system information and statistics
make info

# List all subdirectories with Makefiles
make list-subdirs

# List only marked (important) targets
make list-marked

# Show target dependency graph
make graph
```

### Validation & Maintenance
```bash
# Check for target name conflicts
make check-conflicts

# Validate syntax of all Makefiles
make validate-makefiles
```

### Examples
```bash
$ make info
Makefile System Information

Configuration:
  Main Makefile: Makefile
  Subdirectories: deploy doc docker test
  Total Makefiles: 5

Statistics:
  Total targets in main: 3
  Total targets in deploy: 6
  Total targets in doc: 3
  Total targets in docker: 4
  Total targets in test: 5
  Total marked targets: 8
```

## Color System

The system uses ANSI color codes for better readability. All colors are centralized in `.make/colors.mk`.

### Available Colors

Basic colors:
- `$(BLACK)`, `$(RED)`, `$(GREEN)`, `$(YELLOW)`
- `$(BLUE)`, `$(MAGENTA)`, `$(CYAN)`, `$(WHITE)`

Bold variants:
- `$(BOLD_RED)`, `$(BOLD_GREEN)`, etc.

Semantic aliases:
- `$(COLOR_SUCCESS)` - Green for success messages
- `$(COLOR_ERROR)` - Red for errors
- `$(COLOR_WARNING)` - Yellow for warnings
- `$(COLOR_INFO)` - Cyan for information
- `$(NC)` - Reset color

### Using Colors in Your Makefiles

1. **Include the color definitions**:
   ```makefile
   # In main Makefile
   -include .make/colors.mk
   
   # In subdirectory Makefiles
   -include ../.make/colors.mk
   ```

2. **Use in your targets**:
   ```makefile
   deploy:
   	@echo "$(BLUE)🚀 Deploying application...$(NC)"
   	@# deployment commands
   	@echo "$(GREEN)✅ Deployment successful!$(NC)"
   ```

3. **Error handling example**:
   ```makefile
   validate:
   	@if [ ! -f config.yaml ]; then \
   		echo "$(RED)❌ Error: config.yaml not found$(NC)"; \
   		exit 1; \
   	fi
   	@echo "$(GREEN)✓ Configuration valid$(NC)"
   ```

## Example of Project Structure

```
your-project/
├── Makefile                 # Main orchestration Makefile
├── .make/                   # Hidden system directory
│   ├── colors.mk           # Centralized color definitions
│   ├── internal.mk         # System utilities and tools
│   ├── .make-deps          # Dependency configuration
│   └── .make-deps.example  # Example dependency template
├── docker/
│   └── Makefile            # Docker-specific targets
├── deploy/
│   └── Makefile            # Deployment targets
├── test/
│   └── Makefile            # Testing targets
└── doc/
    └── Makefile            # Documentation targets
```

### How It Works

1. **Main Makefile** automatically discovers subdirectories with Makefiles
2. **Subdirectory Makefiles** are included and their targets become available
3. **Color definitions** are shared across all Makefiles
4. **System utilities** provide maintenance and inspection capabilities
5. **Help system** automatically extracts documentation from comments

## Customization

### Adding New Subdirectories

Simply create a new directory with a Makefile:

```bash
mkdir mymodule
cat > mymodule/Makefile << 'EOF'
# Include colors
-include ../.make/colors.mk

##@ My Module

my-target: ##! Important target for my module
	@echo "$(GREEN)Running my target...$(NC)"

my-helper: ## Helper target
	@echo "Helping..."

##? Examples:
# make my-target
# make my-helper OPTION=value
EOF
```

The targets will be automatically discovered and included.

### Customizing the Main Makefile

Modify the main `Makefile` to:
- Change the default target (`.DEFAULT_GOAL`)
- Add project-specific targets
- Modify or remove the `all` and `clean-all` orchestration
- Adjust subdirectory discovery patterns

### Creating Project-Specific Dependencies

1. Copy the example file:
   ```bash
   cp .make/.make-deps.example .make-deps
   ```

2. Edit to match your project needs:
   ```bash
   make deps-edit
   ```

3. Add to your CI/CD pipeline:
   ```yaml
   - name: Check dependencies
     run: make check-deps
   ```

## Tips and Best Practices

1. **Use semantic colors** - `$(COLOR_SUCCESS)` instead of `$(GREEN)` for consistency
2. **Mark important targets** with `##!` to show them in quick help
3. **Group related targets** with `##@` section headers
4. **Provide examples** using `##?` markers
5. **Check for conflicts** regularly with `make check-conflicts`
6. **Document variables** in comments near their definition
7. **Use `.PHONY`** for all non-file targets
8. **Leverage parallel execution** with `make -j` when possible

## Troubleshooting

### Common Issues

**Colors not showing:**
- Ensure your terminal supports ANSI colors
- Check that `.make/colors.mk` is properly included

**Targets not found:**
- Verify subdirectory has a valid Makefile
- Check that the main Makefile includes `.make/internal.mk`
- Run `make validate-makefiles` to check syntax

**Dependency check fails:**
- Run `make deps-show` to see current configuration
- Use `make deps-edit` to update requirements
- Ensure `.make-deps` file exists

## Contributing

Contributions are welcome! Please ensure:
- New targets are properly documented
- Colors are used consistently
- Examples are provided for complex operations
- Conflicts are checked before submitting

## License

This Makefile system is provided as-is for use in your projects. Feel free to modify and distribute as needed.

---

**Quick Commands Reference:**
```bash
make              # Quick help
make help         # Full help
make check-deps   # Check dependencies
make utils        # Show utilities
make info         # System information
```
