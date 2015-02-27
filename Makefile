default:
	@echo ""

install:
	vagrant destroy -f
	vagrant up
	rm -rf package.box
	vagrant package
	vagrant box add --name clastic-dev package.box --force
