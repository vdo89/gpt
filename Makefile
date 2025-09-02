PY=python
ANSIBLE=ansible-playbook -i ansible/inventory/agent.example.yaml -e @vars.local.yml

deps:
	$(PY) -m pip install -U pip ansible-core ansible-lint yamllint
	ansible-galaxy collection install -r requirements.yml

lint:
	ansible-lint
	yamllint .

provision:
	$(ANSIBLE) ansible/playbooks/os-provision.yaml

deploy:
	$(ANSIBLE) ansible/playbooks/os-deploy.yaml

destroy:
	$(ANSIBLE) ansible/playbooks/os-destroy.yaml

mirror:
	$(ANSIBLE) ansible/playbooks/os-mirror.yaml
