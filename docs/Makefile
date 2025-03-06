init:
	@apt update
	@apt install -y unzip

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
