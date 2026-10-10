PROJECT_NAME := tsp-rubik-rs
PROGRAM_NAME := tsp-rubik-rs
DEPLOY_PATH := /mnt/SDCARD/Apps/RubikRS

# e.g. set the IP with `export IP=192.168.0.101`
IP := ${IP}
USN := root
PWD := tina

all: clean docker deploy

dist: clean docker zip

clean:
	rm dist -rf

docker:
	#docker run -d --name trimui-sdk -c 1024 -it --volume=/opt/TrimuiProjects/:/work/ --workdir=/work/ trimui-sdk
	docker exec trimui-sdk /bin/bash -c 'cd ${PROJECT_NAME} && make build'

build:
	rustup target add aarch64-unknown-linux-gnu
	CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER="aarch64-linux-gnu-g++" \
		CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_RUSTFLAGS="-C link-arg=--sysroot=${SYSROOT}" \
		cargo build --features raylib/nobuild --target=aarch64-unknown-linux-gnu --target-dir bin --bin ${PROJECT_NAME}

deploy:
	sshpass -p ${PWD} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${USN}@${IP} "rm ${DEPLOY_PATH}/${PROGRAM_NAME} -f"
	sshpass -p ${PWD} scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null bin/aarch64-unknown-linux-gnu/debug/${PROGRAM_NAME} ${USN}@${IP}:${DEPLOY_PATH}
	sshpass -p ${PWD} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${USN}@${IP} "chmod 777 ${DEPLOY_PATH}/${PROGRAM_NAME}"
	sshpass -p ${PWD} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${USN}@${IP} "if pgrep ${PROGRAM_NAME}; then pkill -f ${PROGRAM_NAME}; fi"
	sshpass -p ${PWD} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${USN}@${IP} "sh -c 'cd /tmp; LD_LIBRARY_PATH=${DEPLOY_PATH}:$LD_LIBRARY_PATH ${DEPLOY_PATH}/${PROGRAM_NAME}'" &

zip:
	cp res/* dist && cd dist && zip ${PROGRAM_NAME}.zip config.json icon.png launch.sh ${PROGRAM_NAME}

wasm:
	go mod tidy -modfile go.wasm.mod
	GOOS=js GOARCH=wasm go build -modfile go.wasm.mod -tags="wasm" -o ./docs/main.wasm tsp-rubik/src tsp-rubik/src