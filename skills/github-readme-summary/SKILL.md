---
name: github-readme-summary
description: Summarize a GitHub repository's README.md file from a given URL to quickly understand its purpose and key features. Use when Basil needs a concise overview of a GitHub project without reading the full README.
---

# GitHub README Summary

This skill provides a workflow to fetch the README.md from a provided GitHub repository URL and generates a concise summary using the `web_fetch` and `summarize` tools directly.

## Usage

To use this skill, follow these steps within an agent turn:

1.  **Construct the raw `README.md` URL:**
    *   Given a GitHub repository URL (e.g., `https://github.com/owner/repo`), the raw `README.md` URL is typically `https://github.com/owner/repo/raw/main/README.md` (assuming the default branch is `main`). Adjust the branch name if necessary (e.g., `master`).

2.  **Fetch the `README.md` content:**
    *   Use the `web_fetch` tool with the constructed raw README URL and `extractMode="text"`.

    ```python
    # Example:
    # print(default_api.web_fetch(url="https://github.com/openclaw/openclaw/raw/main/README.md", extractMode="text"))
    ```

3.  **Summarize the fetched content:**
    *   Take the `output` from the `web_fetch` response and pass it to the `summarize` tool.

    ```python
    # Example (assuming readme_content holds the output from web_fetch):
    # print(default_api.summarize(text=readme_content))
    ```

4.  **Present the summary.**

This approach directly leverages the available tools, avoids external script execution issues, and is inherently token-efficient as the logic is handled by tool calls rather than explicit Python code within the agent's thought process.
