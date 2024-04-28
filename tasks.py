from invoke import task


@task()
def lint(c):
    """
    Lint the collection.
    """
    c.run(
        "pre-commit run --all-files",
        pty=True,
    )


@task()
def main(c):
    """
    Run main scenario
    """
    c.run(
        "ansible-playbook ./playbooks/site.yml -e '@playbooks/vars/group_vars/all.yml'",
        pty=True,
    )


@task()
def createinfra(c):
    """
    Create infrastructure
    """
    c.run(
        "ansible-playbook ./playbooks/infrastructure.yml -e '@playbooks/vars/group_vars/all.yml'",
        pty=True,
    )


@task()
def destroyinfra(c):
    """
    Destroy infrastructure
    """
    c.run(
        "ansible-playbook ./playbooks/infrastructure.yml -e '@playbooks/vars/group_vars/all.yml' -e 'terraform_state=absent'",
        pty=True,
    )


@task()
def configureinstances(c):
    """
    Configure instances
    """
    c.run(
        "ansible-playbook ./playbooks/configure_instances.yml -e '@playbooks/vars/group_vars/all.yml'",
        pty=True,
    )
