#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright: (c) 2024, Alan PIERRE <alan.pierre@proton.me>
# MIT License
DOCUMENTATION = """
---
module: dummy
short_description: This is a dummy module
version_added: "1.0.0"
description: This module greet the user, with different return state.
options:
    name:
        description: This is the message to send to the dummy module.
        required: true
        type: str
    changed:
        description: Control if the result of this module is changed or not.
        required: false
        type: bool
    failed:
        description: Control if the result of this module is failed or not.
        required: false
        type: bool
author:
    - Alan PIERRE (@alnpir)
"""

EXAMPLES = r"""
# Pass a message
- name: Test with a message
  dummy:
    name: John Doe

# Pass in a message with changed state
- name: Test with a message and changed output
  dummy:
    name: John Doe
    changed: true

# Pass in a message and failed state
- name: Test failure of the module
  dummy:
    name: John Doe
    changed: true
"""

RETURN = r"""
inputed_name:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'John Doe'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'Hi John Doe !'
"""

from ansible.module_utils.basic import AnsibleModule  # noqa: E402


def run_module():
    module_args = dict(
        name=dict(type="str", required=True),
        changed=dict(type="bool", required=False, default=False),
        failed=dict(type="bool", required=False, default=False),
    )

    result = dict(changed=False, inputed_name="", message="")

    module = AnsibleModule(argument_spec=module_args, supports_check_mode=True)

    if module.check_mode:
        module.exit_json(**result)

    result["inputed_name"] = module.params["name"]
    result["message"] = f"Hi {result["inputed_name"]} !"

    if module.params["changed"]:
        result["changed"] = True

    if module.params["failed"]:
        module.fail_json(msg="You requested this to fail", **result)

    module.exit_json(**result)


def main():
    run_module()


if __name__ == "__main__":
    main()
