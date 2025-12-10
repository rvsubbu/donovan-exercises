# The Go Programming Language - Study Repository

> **Mastering Go fundamentals through systematic practice**  
> *Working through "The Go Programming Language" by Alan Donovan and Brian Kernighan*

## 🎯 Objective

This repository contains my systematic study of Go programming fundamentals, working through exercises and examples from Donovan & Kernighan's "The Go Programming Language" (the definitive Go reference). The goal is to ensure comprehensive understanding of Go's core concepts, idioms, and best practices for experienced developers.

## 📖 About the Book

"The Go Programming Language" is the authoritative resource for learning Go, written by Alan Donovan and Brian Kernighan. This study covers:

- **Language Fundamentals**: Syntax, types, control flow
- **Program Structure**: Packages, functions, variables, scope
- **Data Types**: Basic types, composite types, constants
- **Functions & Methods**: First-class functions, methods, interfaces
- **Concurrency**: Goroutines, channels, select statements
- **Packages & Tooling**: Standard library, testing, profiling
- **Reflection & Low-level Programming**: Unsafe operations, CGO

## 🏗 Project Structure

```
.
├── README.md                    # This file
├── donovan_go_programming_language.pdf
├── chapter01/                   # Tutorial: Hello, World
│   └── EXERCISES.md            # Chapter 1 exercises
├── chapter02/                   # Program Structure
│   └── EXERCISES.md            # Chapter 2 exercises
├── chapter03/                   # Basic Data Types
│   └── EXERCISES.md            # Chapter 3 exercises
├── chapter04/                   # Composite Types
│   └── EXERCISES.md            # Chapter 4 exercises
├── chapter05/                   # Functions
│   └── EXERCISES.md            # Chapter 5 exercises
├── chapter06/                   # Methods
│   └── EXERCISES.md            # Chapter 6 exercises
├── chapter07/                   # Interfaces
│   └── EXERCISES.md            # Chapter 7 exercises
├── chapter08/                   # Goroutines and Channels
│   └── EXERCISES.md            # Chapter 8 exercises
├── chapter09/                   # Concurrency with Shared Variables
│   └── EXERCISES.md            # Chapter 9 exercises
├── chapter10/                   # Packages and the Go Tool
│   └── EXERCISES.md            # Chapter 10 exercises
├── chapter11/                   # Testing
│   └── EXERCISES.md            # Chapter 11 exercises
├── chapter12/                   # Reflection
│   └── EXERCISES.md            # Chapter 12 exercises
├── chapter13/                   # Low-Level Programming
│   └── EXERCISES.md            # Chapter 13 exercises
├── Makefile                     # Build automation
└── docs/                        # Documentation and notes
```

## 🚀 Quick Start

### Prerequisites

- **Go 1.21+** (latest stable recommended)
- **Make** (for build automation)
- **Git** (for version control)

### Setup

```bash
# Clone the repository
git clone <repository-url>
cd donovan

# Verify Go installation
go version

# Run all tests
make test

# Build all chapters
make build

# Run static analysis
make lint
```

## 🔧 Development Workflow

### Building

```bash
# Build all chapters
make build

# Build specific chapter
make build-chapter CHAPTER=01

# Clean build artifacts
make clean
```

### Testing

```bash
# Run all tests
make test

# Run tests with coverage
make test-coverage

# Run specific chapter tests
make test-chapter CHAPTER=01

# Run benchmarks
make benchmark
```

## 📋 Learning Progress

### Completion Status

- [ ] **Chapter 1**: Tutorial
- [ ] **Chapter 2**: Program Structure  
- [ ] **Chapter 3**: Basic Data Types
- [ ] **Chapter 4**: Composite Types
- [ ] **Chapter 5**: Functions
- [ ] **Chapter 6**: Methods
- [ ] **Chapter 7**: Interfaces
- [ ] **Chapter 8**: Goroutines and Channels
- [ ] **Chapter 9**: Concurrency with Shared Variables
- [ ] **Chapter 10**: Packages and the Go Tool
- [ ] **Chapter 11**: Testing
- [ ] **Chapter 12**: Reflection
- [ ] **Chapter 13**: Low-Level Programming

### Key Learning Objectives

- ✅ **Idiomatic Go**: Master Go idioms and conventions
- ✅ **Concurrency**: Deep understanding of goroutines and channels
- ✅ **Interface Design**: Effective use of Go's interface system
- ✅ **Testing**: Comprehensive testing strategies and benchmarking
- ✅ **Performance**: Memory management and optimization techniques
- ✅ **Standard Library**: Proficiency with core packages

## 🔧 Code Quality & Analysis

### Static Analysis Setup

```bash
# Install essential tools
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/vuln/cmd/govulncheck@latest
```

### Pre-commit Quality Checks

```bash
# All-in-one quality check
make pre-commit

# Individual checks
make fmt      # Format code
make vet      # Go vet analysis
make lint     # Comprehensive linting
make security # Security analysis
make test     # Run all tests
```

### Linting Configuration

The project uses `golangci-lint` with the following enabled linters:

| Linter | Purpose |
|--------|---------|
| `staticcheck` | Advanced static analysis |
| `gosec` | Security vulnerability detection |
| `gocritic` | Style and performance suggestions |
| `ineffassign` | Detect ineffective assignments |
| `gocyclo` | Cyclomatic complexity analysis |
| `revive` | Flexible Go linter |
| `misspell` | Spell checking |
| `unconvert` | Unnecessary type conversions |

### Quality Thresholds

- **Test Coverage**: >80% (aim for comprehensive coverage)
- **Cyclomatic Complexity**: <10 per function
- **Function Length**: <50 lines
- **Security Issues**: Zero tolerance
- **Go Vet Issues**: Zero tolerance

### Dependency Management

```bash
# Keep dependencies current
go mod tidy

# Verify module integrity
go mod verify

# Check for security vulnerabilities
govulncheck ./...
```

## 📚 Resources & References

### Primary Resources
- **Book**: [The Go Programming Language](https://www.gopl.io/) by Donovan & Kernighan
- **Go Documentation**: [golang.org/doc](https://golang.org/doc/)
- **Effective Go**: [golang.org/doc/effective_go](https://golang.org/doc/effective_go)
- **Go Blog**: [blog.golang.org](https://blog.golang.org/)

### Advanced Topics
- **Go Memory Model**: [golang.org/ref/mem](https://golang.org/ref/mem)
- **Go Specification**: [golang.org/ref/spec](https://golang.org/ref/spec)
- **Performance Profiling**: [golang.org/doc/diagnostics](https://golang.org/doc/diagnostics)

### Tools & Linting
- **golangci-lint**: [golangci-lint.run](https://golangci-lint.run/)
- **staticcheck**: [staticcheck.io](https://staticcheck.io/)
- **Go security checker**: [pkg.go.dev/golang.org/x/vuln/cmd/govulncheck](https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck)

## 🤝 Contributing

This is a personal study repository. However, improvements to the structure, additional exercises, or better explanations are welcome.

### Code Standards
- Follow standard Go conventions (`gofmt`, `go vet`)
- Write comprehensive tests for all exercises
- Include benchmarks for performance-critical code
- Document complex algorithms and design decisions
- Maintain high code coverage (>80%)

## 📄 License

This repository is for educational purposes. The exercises and examples are based on "The Go Programming Language" by Donovan & Kernighan. Please respect the book's copyright.

## 🎖 Acknowledgments

- **Alan Donovan** and **Brian Kernighan** for writing the definitive Go reference
- **The Go Team** at Google for creating such an elegant language
- **The Go Community** for maintaining excellent tooling and resources

---

*Last updated: December 2025*

## Instructions to Copilot
Generate exercises for each chapter. These exercises should be a text file, and I am going to test myself by filling each of them. If there are elementary exercises, tag them; I will probably skip them. I am looking for medium to hard level exercises. Ideally, these exercises should be at FAANG interview level.
