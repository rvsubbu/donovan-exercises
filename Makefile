# Go Programming Language Study - Makefile
# Based on "The Go Programming Language" by Donovan & Kernighan

# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GOMOD=$(GOCMD) mod
GOFMT=gofmt
GOVET=$(GOCMD) vet

# Directories
CHAPTERS := chapter01 chapter02 chapter03 chapter04 chapter05 chapter06 chapter07 chapter08 chapter09 chapter10 chapter11 chapter12 chapter13

# Build flags
BUILD_FLAGS=-v
TEST_FLAGS=-v -race
BENCH_FLAGS=-benchmem

# Linting tools
GOLANGCI_LINT=golangci-lint
STATICCHECK=staticcheck
GOSEC=gosec
GOVULNCHECK=govulncheck

.PHONY: all build test clean fmt vet lint security test-coverage benchmark help setup verify-exercises

# Default target
all: build test lint

help: ## Display this help message
	@echo "Go Programming Language Study - Makefile"
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Setup development environment
setup: ## Install required tools and dependencies
	@echo "Setting up development environment..."
	$(GOGET) -u github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	$(GOGET) -u honnef.co/go/tools/cmd/staticcheck@latest
	$(GOGET) -u github.com/securecodewarrior/gosec/v2/cmd/gosec@latest
	$(GOGET) -u golang.org/x/vuln/cmd/govulncheck@latest
	$(GOGET) -u golang.org/x/tools/cmd/goimports@latest
	@echo "Development environment setup complete!"

# Build all chapters
build: ## Build all chapter exercises
	@echo "Building all chapters..."
	@for chapter in $(CHAPTERS); do \
		if [ -d $$chapter ]; then \
			echo "Building $$chapter..."; \
			cd $$chapter && $(GOBUILD) $(BUILD_FLAGS) ./... && cd ..; \
		fi; \
	done
	@echo "Build complete!"

# Build specific chapter
build-chapter: ## Build specific chapter (usage: make build-chapter CHAPTER=01)
	@if [ -z "$(CHAPTER)" ]; then \
		echo "Please specify CHAPTER variable (e.g., make build-chapter CHAPTER=01)"; \
		exit 1; \
	fi
	@chapter_dir="chapter$(shell printf "%02d" $(CHAPTER))"; \
	if [ -d $$chapter_dir ]; then \
		echo "Building $$chapter_dir..."; \
		cd $$chapter_dir && $(GOBUILD) $(BUILD_FLAGS) ./...; \
	else \
		echo "Chapter directory $$chapter_dir not found"; \
		exit 1; \
	fi

# Test all chapters
test: ## Run tests for all chapters
	@echo "Running tests for all chapters..."
	@for chapter in $(CHAPTERS); do \
		if [ -d $$chapter ]; then \
			echo "Testing $$chapter..."; \
			cd $$chapter && $(GOTEST) $(TEST_FLAGS) ./... && cd ..; \
		fi; \
	done
	@echo "All tests completed!"

# Test specific chapter
test-chapter: ## Test specific chapter (usage: make test-chapter CHAPTER=01)
	@if [ -z "$(CHAPTER)" ]; then \
		echo "Please specify CHAPTER variable (e.g., make test-chapter CHAPTER=01)"; \
		exit 1; \
	fi
	@chapter_dir="chapter$(shell printf "%02d" $(CHAPTER))"; \
	if [ -d $$chapter_dir ]; then \
		echo "Testing $$chapter_dir..."; \
		cd $$chapter_dir && $(GOTEST) $(TEST_FLAGS) ./...; \
	else \
		echo "Chapter directory $$chapter_dir not found"; \
		exit 1; \
	fi

# Test coverage
test-coverage: ## Run tests with coverage analysis
	@echo "Running tests with coverage analysis..."
	@mkdir -p coverage
	@for chapter in $(CHAPTERS); do \
		if [ -d $$chapter ]; then \
			echo "Coverage analysis for $$chapter..."; \
			cd $$chapter && \
			$(GOTEST) $(TEST_FLAGS) -coverprofile=../coverage/$$chapter.out ./... && \
			cd ..; \
		fi; \
	done
	@echo "Generating combined coverage report..."
	@echo "mode: atomic" > coverage/coverage.out
	@for chapter in $(CHAPTERS); do \
		if [ -f coverage/$$chapter.out ]; then \
			tail -n +2 coverage/$$chapter.out >> coverage/coverage.out; \
		fi; \
	done
	@$(GOCMD) tool cover -html=coverage/coverage.out -o coverage/coverage.html
	@$(GOCMD) tool cover -func=coverage/coverage.out | grep total:
	@echo "Coverage report generated in coverage/coverage.html"

# Benchmarks
benchmark: ## Run benchmarks for all chapters
	@echo "Running benchmarks..."
	@for chapter in $(CHAPTERS); do \
		if [ -d $$chapter ]; then \
			echo "Benchmarking $$chapter..."; \
			cd $$chapter && $(GOTEST) -bench=. $(BENCH_FLAGS) ./... && cd ..; \
		fi; \
	done

# Code formatting
fmt: ## Format code using gofmt
	@echo "Formatting code..."
	@$(GOFMT) -s -w .
	@goimports -w .
	@echo "Code formatting complete!"

# Code vetting
vet: ## Run go vet on all chapters
	@echo "Running go vet..."
	@for chapter in $(CHAPTERS); do \
		if [ -d $$chapter ]; then \
			echo "Vetting $$chapter..."; \
			cd $$chapter && $(GOVET) ./... && cd ..; \
		fi; \
	done
	@echo "Go vet completed!"

# Comprehensive linting
lint: ## Run comprehensive linting analysis
	@echo "Running comprehensive linting..."
	@if command -v $(GOLANGCI_LINT) >/dev/null 2>&1; then \
		$(GOLANGCI_LINT) run --enable=staticcheck,gosec,ineffassign,misspell,gocyclo,goconst,unconvert,gocritic,funlen,revive ./...; \
	else \
		echo "golangci-lint not found. Please run 'make setup' first."; \
		exit 1; \
	fi

# Security analysis
security: ## Run security analysis
	@echo "Running security analysis..."
	@if command -v $(GOSEC) >/dev/null 2>&1; then \
		$(GOSEC) ./...; \
	else \
		echo "gosec not found. Please run 'make setup' first."; \
		exit 1; \
	fi
	@if command -v $(GOVULNCHECK) >/dev/null 2>&1; then \
		$(GOVULNCHECK) ./...; \
	else \
		echo "govulncheck not found. Please run 'make setup' first."; \
		exit 1; \
	fi

# Pre-commit checks (comprehensive quality check)
pre-commit: fmt vet lint security test ## Run all pre-commit quality checks
	@echo "All pre-commit checks passed!"

# Module management
mod-tidy: ## Clean up and verify module dependencies
	@echo "Tidying module dependencies..."
	@$(GOMOD) tidy
	@$(GOMOD) verify
	@echo "Module dependencies updated!"

# Clean build artifacts
clean: ## Clean build artifacts and caches
	@echo "Cleaning build artifacts..."
	@$(GOCLEAN) ./...
	@rm -rf coverage/
	@find . -name "*.out" -type f -delete
	@find . -name "*.test" -type f -delete
	@echo "Clean completed!"

# Verify exercise structure
verify-exercises: ## Verify that all exercise files exist and are properly structured
	@echo "Verifying exercise structure..."
	@for chapter in $(CHAPTERS); do \
		exercise_file="$$chapter/EXERCISES.md"; \
		if [ ! -f $$exercise_file ]; then \
			echo "❌ Missing exercise file: $$exercise_file"; \
			exit 1; \
		else \
			echo "✅ Found exercise file: $$exercise_file"; \
		fi; \
	done
	@echo "All exercise files verified!"

# Generate exercise summary
exercise-summary: ## Generate a summary of all exercises
	@echo "# Exercise Summary" > EXERCISE_SUMMARY.md
	@echo "" >> EXERCISE_SUMMARY.md
	@echo "This document provides an overview of all exercises across all chapters of 'The Go Programming Language' study." >> EXERCISE_SUMMARY.md
	@echo "" >> EXERCISE_SUMMARY.md
	@for chapter in $(CHAPTERS); do \
		chapter_num=$$(echo $$chapter | sed 's/chapter0*//'); \
		exercise_file="$$chapter/EXERCISES.md"; \
		if [ -f $$exercise_file ]; then \
			echo "## Chapter $$chapter_num Exercises" >> EXERCISE_SUMMARY.md; \
			echo "" >> EXERCISE_SUMMARY.md; \
			grep "^## Exercise" $$exercise_file | sed 's/^## /- /' >> EXERCISE_SUMMARY.md; \
			echo "" >> EXERCISE_SUMMARY.md; \
		fi; \
	done
	@echo "Exercise summary generated in EXERCISE_SUMMARY.md"

# Create new chapter structure
new-chapter: ## Create new chapter structure (usage: make new-chapter CHAPTER=14)
	@if [ -z "$(CHAPTER)" ]; then \
		echo "Please specify CHAPTER variable (e.g., make new-chapter CHAPTER=14)"; \
		exit 1; \
	fi
	@chapter_dir="chapter$(shell printf "%02d" $(CHAPTER))"; \
	mkdir -p $$chapter_dir; \
	echo "# Chapter $(CHAPTER): [Title] - Exercises" > $$chapter_dir/EXERCISES.md; \
	echo "" >> $$chapter_dir/EXERCISES.md; \
	echo "## Exercise $(CHAPTER).1: [Exercise Name] [DIFFICULTY]" >> $$chapter_dir/EXERCISES.md; \
	echo "**Difficulty**: [Easy/Medium/Hard/Expert]" >> $$chapter_dir/EXERCISES.md; \
	echo "**Topic**: [Topics covered]" >> $$chapter_dir/EXERCISES.md; \
	echo "" >> $$chapter_dir/EXERCISES.md; \
	echo "[Exercise description]" >> $$chapter_dir/EXERCISES.md; \
	echo "" >> $$chapter_dir/EXERCISES.md; \
	echo "**FAANG Interview Aspect**: [Interview relevance]" >> $$chapter_dir/EXERCISES.md; \
	mkdir -p $$chapter_dir/solutions; \
	echo "package main" > $$chapter_dir/solutions/solution_01.go; \
	echo "" >> $$chapter_dir/solutions/solution_01.go; \
	echo "// Solution for Exercise $(CHAPTER).1" >> $$chapter_dir/solutions/solution_01.go; \
	echo "func main() {" >> $$chapter_dir/solutions/solution_01.go; \
	echo "    // TODO: Implement solution" >> $$chapter_dir/solutions/solution_01.go; \
	echo "}" >> $$chapter_dir/solutions/solution_01.go; \
	echo "Created new chapter structure: $$chapter_dir"

# Development workflow helpers
dev-setup: setup mod-tidy ## Complete development setup
	@echo "Development setup complete!"

quick-check: fmt vet ## Quick code quality check (fast)
	@echo "Quick quality check passed!"

full-check: pre-commit ## Full comprehensive check (slow but thorough)
	@echo "Full quality check passed!"

# Progress tracking
progress: ## Show completion progress for exercises
	@echo "=== Exercise Completion Progress ==="
	@total_chapters=$$(echo $(CHAPTERS) | wc -w); \
	completed_chapters=0; \
	for chapter in $(CHAPTERS); do \
		if [ -f $$chapter/EXERCISES.md ]; then \
			completed_chapters=$$((completed_chapters + 1)); \
			echo "✅ $$chapter - Exercises available"; \
		else \
			echo "❌ $$chapter - No exercises found"; \
		fi; \
	done; \
	echo ""; \
	echo "Progress: $$completed_chapters/$$total_chapters chapters completed"; \
	percentage=$$((completed_chapters * 100 / total_chapters)); \
	echo "Completion: $$percentage%"

# Statistics
stats: ## Show project statistics
	@echo "=== Project Statistics ==="
	@echo "Total chapters: $$(echo $(CHAPTERS) | wc -w)"
	@echo "Total Go files: $$(find . -name "*.go" -type f | wc -l)"
	@echo "Total lines of code: $$(find . -name "*.go" -type f -exec wc -l {} + | tail -1 | awk '{print $$1}')"
	@echo "Total exercise files: $$(find . -name "EXERCISES.md" -type f | wc -l)"
	@echo "Repository size: $$(du -sh . | cut -f1)"

# Update README with exercise completion status
update-readme: ## Update README.md with current exercise completion status
	@echo "Updating README.md with exercise completion status..."
	@temp_file=$$(mktemp); \
	awk '/^### Completion Status/ {p=1} p && /^- \[ \]/ {gsub(/- \[ \]/, "- [x]"); print; next} p && /^- \[x\]/ {print; next} p && /^###/ && !/^### Completion Status/ {p=0} p || !p {print}' README.md > $$temp_file; \
	mv $$temp_file README.md
	@echo "README.md updated!"

# Docker support
docker-build: ## Build Docker image for development
	@echo "Building Docker image..."
	@docker build -t go-donovan-study .
	@echo "Docker image built: go-donovan-study"

docker-run: ## Run development environment in Docker
	@echo "Running Docker container..."
	@docker run -it --rm -v $$(pwd):/workspace go-donovan-study

# CI/CD helpers
ci-test: ## Run tests suitable for CI environment
	@echo "Running CI tests..."
	@$(GOTEST) -short -race -coverprofile=coverage.out ./...
	@$(GOCMD) tool cover -func=coverage.out

ci-lint: ## Run linting suitable for CI environment  
	@echo "Running CI linting..."
	@$(GOLANGCI_LINT) run --out-format=github-actions

# Documentation
docs: exercise-summary ## Generate all documentation
	@echo "Documentation generated!"

# Git hooks support
install-git-hooks: ## Install Git pre-commit hooks
	@echo "Installing Git pre-commit hooks..."
	@cp scripts/pre-commit .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "Git hooks installed!"

# Print variables for debugging
print-%: ## Print any Makefile variable (usage: make print-CHAPTERS)
	@echo $* = $($*)

# Special targets
.DEFAULT_GOAL := help