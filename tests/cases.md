# Contract Cases

| id | category | input | expected_output | expected_exit |
|---|---|---|---|---|
| C1 | happy | `./scripts/run.sh --mode brief` | contains `## Idea Summary` | 0 |
| C2 | happy | `./scripts/run.sh --mode detailed --format json` | contains `\"mode\":\"detailed\"` | 0 |
| C3 | edge | `./scripts/run.sh --topic "Custom Scope"` | contains `Custom Scope` | 0 |
| C4 | edge | `./scripts/run.sh --mode brief --context "x"` | contains `Context` section | 0 |
| C5 | error | `./scripts/run.sh --mode invalid` | contains `Invalid mode` | 2 |
| C6 | error | `./scripts/run.sh --format yaml` | contains `Invalid format` | 2 |
