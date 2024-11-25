ENV_NAME ?= default_env

init:
	@apt update
	@apt install -y unzip

clean-envs:
	@find envs/* -mindepth 1 -maxdepth 1 -not -name "example" -exec rm -rf {} +
	
create-vm-env:
ifeq ($(ENV_NAME), default_env)
	@echo "Error: ENV_NAME is not set. Please specify a ENV_NAME">&2
	@exit 1
endif
	cp -r envs/vm-example envs/$(ENV_NAME)

create-lxc-env:
ifeq ($(ENV_NAME), default_env)
	@echo "Error: ENV_NAME is not set. Please specify a ENV_NAME">&2
	@exit 1
endif
	cp -r envs/lxc-example envs/$(ENV_NAME)

copy-provider:
	@cp modules/proxmox_vm/provider.tf.example modules/proxmox_vm/provider.tf
	
install-tfenv:
	@echo "Installing tfenv..."
	@echo 'export PATH=$$PATH:$$HOME/.tfenv/bin' >> $(HOME)/.bashrc
	@echo "alias tf=terraform" >> $(HOME)/.bashrc
	@mkdir -p $$HOME/.tfenv
	@git clone https://github.com/tfutils/tfenv.git $$HOME/.tfenv || echo "tfenv already installed"
	@$$HOME/.tfenv/bin/tfenv install 1.9.8
	@echo "tfenv and Terraform installed successfully. Use 'tf --version' after sourcing .bashrc."
	@echo "Please run 'source $(HOME)/.bashrc' to reload the shell environment."
	@$$HOME/.tfenv/bin/tfenv use 1.9.8
	@$$HOME/.tfenv/bin/tfenv list
