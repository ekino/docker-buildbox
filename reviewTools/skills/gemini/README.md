
# Gemini Integration for Claude Code

## Purpose
Enable Claude Code to invoke the Gemini CLI for AI-powered assistance, code analysis, generation, debugging, and interactive terminal workflows using Google's Gemini models.

## Prerequisites
- `gemini` CLI installed and available on `PATH`
- Authentication configured (OAuth, API key, or Vertex AI)
- Confirm the installation by running `gemini --version`; resolve any errors before using the skill

## Installation

Download this repo and store the skill in ~/.claude/skills/gemini

```bash
git clone --depth 1 git@github.com:skills-directory/skill-gemini.git /tmp/skills-temp && \
mkdir -p ~/.claude/skills && \
cp -r /tmp/skills-temp/ ~/.claude/skills/gemini && \
rm -rf /tmp/skills-temp
```

## Authentication Setup

Before using this skill, you need to authenticate with one of these methods:

### Option 1: Login with Google (Recommended)
```bash
gemini
# Follow the browser authentication flow
```

### Option 2: Gemini API Key
```bash
# Get your key from https://aistudio.google.com/apikey
export GEMINI_API_KEY="YOUR_API_KEY"
```

### Option 3: Vertex AI (Enterprise)
```bash
export GOOGLE_API_KEY="YOUR_API_KEY"
export GOOGLE_GENAI_USE_VERTEXAI=true
export GOOGLE_CLOUD_PROJECT="YOUR_PROJECT_ID"
```

## Usage

### Example Workflow

**User prompt:**
```
Use gemini to create a Discord bot that answers questions using a FAQ.md file
```

**Claude Code response:**
Claude will activate the Gemini skill and:
1. Ask which model to use (`gemini-2.5-pro`, `gemini-2.5-flash`, etc.)
2. Select appropriate mode (interactive or non-interactive)
3. Run a command like:
```bash
gemini -m gemini-2.5-flash -p "Create a Discord bot that answers questions using a FAQ.md file"
```

**Result:**
Claude will display the Gemini output and ask if you'd like to continue with follow-up actions.

### Interactive Mode

For complex tasks that benefit from back-and-forth conversation:

**User prompt:**
```
Start an interactive gemini session to help me refactor this codebase
```

**Claude will run:**
```bash
gemini -m gemini-2.5-pro --include-directories ../lib,../docs
```

### Non-Interactive Mode (Scripting)

For automated workflows:

**User prompt:**
```
Use gemini in non-interactive mode to analyze the architecture and output as JSON
```

**Claude will run:**
```bash
gemini -p "Analyze the architecture of this codebase" --output-format json
```

### Key Features

**Built-in Tools:**
- File system operations (read, write, manage files)
- Shell command execution
- Web fetch and Google Search grounding
- MCP server integration for custom tools

**Context Files:**
Create a `GEMINI.md` file in your project root to provide persistent context that loads automatically in every session.

**Multiple Authentication Options:**
- Free tier with Google account: 60 requests/min, 1,000 requests/day
- API key: 100 requests/day with Gemini 2.5 Pro
- Vertex AI: Enterprise features with Google Cloud

**Powerful Models:**
- Gemini 2.5 Pro: 1M token context window
- Gemini 2.5 Flash: Fast and efficient
- Access to latest Google AI capabilities

### Detailed Instructions
See `SKILL.md` for complete operational instructions, CLI options, and workflow guidance.

## Additional Resources

- [Gemini CLI Documentation](https://geminicli.com/docs/)
- [GitHub Repository](https://github.com/google-gemini/gemini-cli)
- [Authentication Guide](https://github.com/google-gemini/gemini-cli/blob/main/docs/get-started/authentication.md)
- [MCP Server Integration](https://github.com/google-gemini/gemini-cli/blob/main/docs/tools/mcp-server.md)
