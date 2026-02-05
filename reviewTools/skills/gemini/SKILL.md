---
name: gemini
description: Use when the user asks to run Gemini CLI (gemini, gemini -p) or references Google Gemini for AI assistance, code analysis, generation, debugging, or interactive terminal workflows
---

# Gemini Skill Guide

## When to use this skill

- When the user explicitly asks to run Gemini CLI (e.g., "use gemini to...", "run gemini...", "gemini -p...")
- When the user references Google Gemini or the Gemini CLI tool by name
- When the user wants to leverage Gemini for code analysis, generation, or debugging tasks
- When the user mentions interactive Gemini sessions or Gemini chat mode
- When the user requests non-interactive Gemini workflows with structured output

## Running a Task
1. Ask the user (via `AskUserQuestion`) which model to run (`gemini-3-pro-preview`,`gemini-2.5-pro`, `gemini-2.5-flash`, or other available models) in a single prompt.
2. Determine if the task requires interactive mode (default) or non-interactive mode (for scripting/automation).
3. Assemble the command with the appropriate options:
   - `-m, --model <MODEL>` - Specify the model to use
   - `-p, --prompt <PROMPT>` - For non-interactive mode
   - `--include-directories <DIRS>` - Include additional directories in context
   - `--output-format <FORMAT>` - Choose output format: `text`, `json`, or `stream-json`
   - `--config <KEY=VALUE>` - Set configuration options
4. For interactive sessions, use `gemini` to start an interactive chat session
5. For automated workflows or scripts, use `gemini -p "your prompt here"` with optional `--output-format json` for structured output
6. Run the command and capture the output, summarizing the outcome for the user
7. **After Gemini completes**, inform the user about available next steps, including continuing the conversation or switching modes

### Quick Reference
| Use case | Command format | Key flags |
| --- | --- | --- |
| Interactive chat in current directory | `gemini` | Default interactive mode |
| Interactive with specific model | `gemini -m gemini-2.5-flash` | `-m <model>` |
| Include multiple directories | `gemini --include-directories ../lib,../docs` | `--include-directories <dirs>` |
| Non-interactive with text output | `gemini -p "prompt"` | `-p <prompt>` |
| Scripting with JSON output | `gemini -p "prompt" --output-format json` | `--output-format json` |
| Streaming events for monitoring | `gemini -p "prompt" --output-format stream-json` | `--output-format stream-json` |

## Following Up
- After every `gemini` command, immediately use `AskUserQuestion` to confirm next steps, collect clarifications, or decide whether to continue with follow-up prompts
- For interactive sessions, inform the user they can continue the conversation with additional prompts
- Restate the chosen model and mode when proposing follow-up actions

## Built-in Tools
Gemini CLI comes with powerful built-in tools that can be used during sessions:
- **File System Operations**: Read, write, and manage files
- **Shell Commands**: Execute terminal commands
- **Web Fetch & Search**: Fetch web content and perform Google Search grounding
- **MCP Server Integration**: Extend capabilities with Model Context Protocol servers

## Context Files (GEMINI.md)
Inform users that they can create a `GEMINI.md` file in their project root to provide persistent context and instructions that will be automatically loaded in every session.

## Authentication
Gemini CLI supports multiple authentication methods:
- **Login with Google** (OAuth): 60 requests/min, 1,000 requests/day (free tier)
- **Gemini API Key**: 100 requests/day with Gemini 2.5 Pro (free tier)
- **Vertex AI**: Enterprise features with Google Cloud integration

Before running Gemini commands, ensure the user is authenticated. Common environment variables:
- `GEMINI_API_KEY` - For API key authentication
- `GOOGLE_API_KEY` - For Vertex AI authentication
- `GOOGLE_CLOUD_PROJECT` - For Google Cloud project
- `GOOGLE_GENAI_USE_VERTEXAI` - Set to true for Vertex AI

## Error Handling
- Stop and report failures whenever a `gemini` command exits non-zero; request direction before retrying
- If authentication fails, guide the user through the authentication process
- When output includes warnings or errors, summarize them and ask how to proceed using `AskUserQuestion`
- For MCP server errors, check the MCP configuration in `~/.gemini/settings.json`
