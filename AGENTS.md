# Agent instructions

- Stay within the VS Code sandbox. Do not request unsandboxed execution or elevated permissions; if a required action cannot run sandboxed, explain the blocker to the user.
- Prefer workspace-local tools and non-interactive commands that run without permission prompts. Use sandbox-compatible alternatives when available.
- Do not bypass sandbox restrictions or change permissions to work around them.

## Known pitfalls

- Before ending a session that worked a BMad story, reconcile its ticket and dependent gates: when acceptance and verification are complete, mark it `done` with `tickets.py mark`; otherwise record its actual unfinished state. Update any cross-tree manual gate the result satisfies, verify with `tickets.py find` or `status`, and include those state changes with the story work.
- Before ending a session that changed repository files, commit the completed task's files with a focused message unless the user explicitly says not to commit. Never include unrelated pre-existing or concurrent changes; report any task files intentionally left uncommitted.