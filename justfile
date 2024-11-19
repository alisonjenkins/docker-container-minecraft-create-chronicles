build tag:
    #!/usr/bin/env bash
    test -d rconc || git clone https://github.com/klemens/rconc.git
    cd rconc || exit 1

    cross build --target aarch64-unknown-linux-gnu --release &
    cross build --release &
    wait

    cp target/x86_64-unknown-linux-gnu/release/rconc ../rconc_amd64
    cp target/aarch64-unknown-linux-gnu/release/rconc ../rconc_arm64

    cd .. || exit 1

    docker buildx build \
      --push \
      --platform linux/arm64/v8,linux/amd64 \
      --tag 918821718107.dkr.ecr.eu-west-1.amazonaws.com/docker-minecraft-create-chronicles:{{tag}} \
      .

login:
    aws ecr get-login-password --region eu-west-1 --profile alisonRW-script | docker login --username AWS --password-stdin 918821718107.dkr.ecr.eu-west-1.amazonaws.com

# push tag:
#     #!/usr/bin/env bash
#     docker push 918821718107.dkr.ecr.eu-west-1.amazonaws.com/docker-minecraft-vanilla:{{tag}}

alias b := build
alias l := login
#alias p := push
