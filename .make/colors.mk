# Centralized Color Definitions for Makefile System
# This file is automatically included by all Makefiles
# All color codes are ANSI escape sequences

# Basic Colors
BLACK   := \033[0;30m
RED     := \033[0;31m
GREEN   := \033[0;32m
YELLOW  := \033[0;33m
BLUE    := \033[0;34m
MAGENTA := \033[0;35m
CYAN    := \033[0;36m
WHITE   := \033[0;37m

# Bold Colors
BOLD_BLACK   := \033[1;30m
BOLD_RED     := \033[1;31m
BOLD_GREEN   := \033[1;32m
BOLD_YELLOW  := \033[1;33m
BOLD_BLUE    := \033[1;34m
BOLD_MAGENTA := \033[1;35m
BOLD_CYAN    := \033[1;36m
BOLD_WHITE   := \033[1;37m

# Reset Color
NC := \033[0m  # No Color / Reset

# Semantic Color Aliases (for consistent messaging)
COLOR_SUCCESS := $(GREEN)
COLOR_ERROR   := $(RED)
COLOR_WARNING := $(YELLOW)
COLOR_INFO    := $(CYAN)
COLOR_HEADER  := $(BLUE)
COLOR_SECTION := $(YELLOW)
COLOR_TARGET  := $(GREEN)
COLOR_RESET   := $(NC)
