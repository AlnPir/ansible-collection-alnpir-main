from invoke import task


@task()
def lint(c):
    """
    Lint the collection.
    """
    c.run("ansible-lint --exclude .venv")


@task()
def dummy(c):
    """
    Play dummy playbook
    """
    c.run("ansible-playbook ./playbooks/dummy.yml")


@task()
def molecule(c):
    """
    Run molecule test
    """
    c.run("cd extensions && molecule test")
