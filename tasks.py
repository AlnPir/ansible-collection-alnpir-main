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
