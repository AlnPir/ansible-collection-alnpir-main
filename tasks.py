from invoke import task


@task()
def lint(c):
    """
    Lint the collection.
    """
    c.run("pre-commit run --all-files")


@task()
def main(c):
    """
    Create infrastructure
    """
    c.run(
        "ansible-playbook ./playbooks/site.yml -e '@playbooks/vars/group_vars/all.yml'",
        pty=True,
    )


@task()
def podman(c):
    """
    Podman
    """
    c.run(
        "ansible-playbook ./playbooks/podman.yml -e '@playbooks/vars/group_vars/all.yml'",
        pty=True,
    )


@task()
def destroy(c):
    """
    Destroy infrastructure
    """
    c.run(
        "ansible-playbook ./playbooks/infrastructure.yml -e '@playbooks/vars/group_vars/all.yml' -e 'terraform_state=absent'",
        pty=True,
    )
