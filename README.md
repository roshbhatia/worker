# worker

Run commands in a reused tmux or WezTerm pane and keep their logs and exit codes.

```sh
go install github.com/roshbhatia/worker/cmd/...@latest
worker -w 120 -n tests 'go test ./...'
worker --status
agent-watch worker --no-follow
agent-watch worker --log tests
# Nix
nix run github:roshbhatia/worker -- --help
```

Run `worker` inside tmux or a native WezTerm pane. It needs the corresponding multiplexer, `git`, and `zsh` on PATH; the Nix package supplies them.
The caller owns the command string. Arguments after the options form one shell command.
Use `worker --help` and `agent-watch --help` for flags and cleanup commands.
A timeout returns 75. A blocked run returns 76 with `--wait-blocked`. A missing directory returns 78; a closed pane returns 129.

The viewer reads logs and the agent-state bus without starting panes or signaling producers.
Pane status uses the [agent-signals](https://github.com/roshbhatia/agent-signals) schema.
Status is optional: ordinary shell commands still return their recorded exit codes without an agent hook. When a run publishes state, `agent-state` on PATH clears its waiting status at exit.
Orc owns orchestration. This command owns only its worker pane, run records, and logs.
Existing XDG paths and `SYSINIT_WORKER_SESSION` remain compatible with sysinit.

```sh
nix develop -c go test ./...
nix build .#checks.aarch64-darwin.package
```

Extracted from [sysinit](https://github.com/roshbhatia/sysinit/tree/6b71b078a36964ab3610c24af7c76b179ce667e7/pkgs/utils/internal). MIT licensed.
