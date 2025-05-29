# Core System API

This repository contains the TypeSpec API definitions for Core System.

## API Documentation

- [Swagger UI](https://nycu-sdc.github.io/core-system-api/index.html)
- [Redocly](https://nycu-sdc.github.io/core-system-api/redocly.html)

## Prerequisites

- Node.js and npm
- TypeSpec compiler (`@typespec/compiler`)

## Installation

```bash
# Install TypeSpec compiler globally
npm install -g @typespec/compiler

# Install project dependencies
tsp install
```

## Build Commands

The project includes a Makefile with the following commands:

### Format Check
```bash
make format
```

### Compilation
```bash
make compile
```

### Cleanup
```bash
make clean
```

### Full Build
```bash
make
```

## Output

The compilation process generates OpenAPI specification in the `tsp-output/schema/openapi.yaml` file.

## GitHub Actions

This project includes GitHub Actions workflow that:
1. Checks TypeSpec formatting
2. Compiles TypeSpec to OpenAPI
3. Generates and deploys Swagger UI documentation to GitHub Pages