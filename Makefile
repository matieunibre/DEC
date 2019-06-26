# All plugins are submodules. Run this to clone them into their respectful configs
r=$$(cat vim-plugins)

.PHONY: bootstrap
bootstrap:
	@echo "Making sure you have all of the dependancies..."
	sudo apt install vim terminator zsh python-pip
	pip install ranger-fm

	@echo "Removing submodules"
	rm -rf ./.vim/bundle/*
	@echo "Cloning all plugins into .vim......"
	for f in $r; do $$(cd ./.vim/bundle && git clone $$f); done
	exit

.PHONY: setup
setup:
	@echo "Copying new configuration...."
	@echo -n "This will replace your current configuration. Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	@echo "Proceeding....."
	@sleep 2
	rm -rf ~/.vimrc ~/.zshrc ~/.config/terminator ~/.vim
	cp -r .config/* ~/.config/
	cp -r .vim ~/
	cp .vimrc ~/
	cp .zshrc ~/

	@echo "Changing default shell to zsh..." 
	sudo chsh -s /bin/zsh 
	exec zsh
	exit

.PHONY: tools
tools:
	@echo "Collecting tools...."
	@echo "Installing htop....."
	git clone https://github.com/hishamhm/htop.git 
	cd htop && ./autogen.sh && ./configure && make

	@echo "Installing gotop....."
	git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop 
	/tmp/gotop/scripts/download.sh
	sudo mv gotop /usr/local/bin

	@echo "Installing nvtop....."
	sudo apt install cmake libncurses5-dev libncursesw5-dev git
	git clone https://github.com/Syllo/nvtop.git
	mkdir -p nvtop/build && cd nvtop/build && cmake .. -DNVML_RETRIEVE_HEADER_ONLINE=True && make && sudo make install

	@echo "Cleaning up...."
	rm -rf htop gotop nvtop

	@echo "Opening...."
	nohup terminator -x zsh -c 'echo "Hello world"; exec htop' &
	nohup terminator -x zsh -c 'echo "Hello world"; exec gotop' &
	nohup terminator -x zsh -c 'echo "Hello world"; exec nvtop' &
	exit