# BuildKit frontend for Gosh

## Architecture

```mermaid
flowchart BT
    target["
        arbitrary target image
        e.g. ubuntu, nginx, etc
        <b>(no internet)</b>
    "]
    subgraph gosh_team[Gosh]
        G[(GOSH)]
        frontend["
            buildkit frontend
            <b>buildkit-gosh</b>
        "]
    end

    subgraph docker_team[Docker]
        buildkit["buildkit"]
        reg["docker registry"]
    end

    buildkit --> reg
    frontend --> reg
    buildkit <==> target
    buildkit <--> |LLB|frontend

    frontend<-->|"
        sign
        mount
    "| G

```
