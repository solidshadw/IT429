# Command to run the ansible for the vulnerable environment

```
ansible-playbook -i inventory -i data/inventory ansible/main.yml
```

Modify the `inventory` file with the ip addresses and names. You will also set winrm