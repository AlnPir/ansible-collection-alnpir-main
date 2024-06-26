# Ansible Collection - alnpir.main

Documentation for the collection.

## Requirements

You need to run the following command in your terminal to configure the python venv and be able to run the playbooks:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -e .
ansible-galaxy install -r requirements.yml
```

## Contribute

First, run :

```bash
pip install -e .'[dev]'
pre-commit install
pre-commit run --all-files
```

You'll need to install `tflint` and `trivy`.

Then, use `invoke lint` to lint and format the collection.
