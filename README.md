# HTTP 403 Bypass Script

## Overview

This script, named `403-Bypass`, is designed to help bypass HTTP 403 Forbidden responses by attempting various URL and header manipulation techniques.

## Usage

To use the script, run the following command:

```bash
./403-bypass.sh [URL] [path]
```

- `[URL]`: The target URL you want to test.
- `[path]`: The specific path on the target URL you want to bypass.

## Features

### Bypass Methods

The script attempts various URL manipulation techniques to bypass 403 Forbidden responses:

- Basic request to the target path.
- URL encoding and path traversal techniques.
- Adding special characters and extensions to the path.

### Header Bypass Methods

The script also tries different HTTP headers that might trick the server into allowing access:

- `X-Original-URL`
- `X-Custom-IP-Authorization`
- `X-Forwarded-For`
- `X-Forwarded-Host`
- `X-Host`
- `X-rewrite-url`

### Method Bypass

The script uses different HTTP methods to bypass restrictions:

- `POST` with a `Content-Length` of 0.
- `TRACE` method.

### Wayback Machine Lookup

The script checks the Wayback Machine for archived versions of the target URL, which might provide accessible versions of the content.

## Output

The script provides detailed output for each request, including:

- Timestamp of the request.
- URL and headers used.
- HTTP status code (color-coded).
- Size of the response in bytes.

## Example

```bash
./403-bypass.sh https://example.com secret-path
```

This command will attempt to bypass 403 Forbidden responses for the path `secret-path` on `https://example.com`.

## Requirements

- `curl`: Used for making HTTP requests.
- `jq`: Used for parsing JSON responses from the Wayback Machine.
- `figlet`: Used for displaying the script name in a stylized manner.