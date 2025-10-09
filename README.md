# Core System API

This repository contains the TypeSpec API definitions for Core System.

> [Chinese Version](README.md)

## Prerequisites

Please install [Node.js](https://nodejs.org/) and [pnpm](https://pnpm.io/) first.

> pnpm Installation:
>
> ```bash
> npm install --global corepack@latest
> corepack enable pnpm
> ```

## Installation

```bash
pnpm i
```

## Build Commands

Compile the TypeSpec files after editing.

```bash
pnpm build
```

### Format Check

```bash
pnpm format
```

### Compilation

```bash
pnpm compile
```

### Cleanup

```bash
pnpm clean
```

## Output

The compilation process generates OpenAPI specification in the `tsp-output/schema/openapi.yaml` file. You can preview it using:

-   [Swagger UI](https://nycu-sdc.github.io/core-system-api/) - Just open the [swagger-ui.html](swagger-ui.html) file below.
-   [Prism](https://prismjs.com/) - For API documentation preview and testing. Run `pnpm start` and open <http://localhost:4010>.

## What is Yaak doing?

Currently Yaak does not fetch data from TypeSpec, please maintain it separately.
