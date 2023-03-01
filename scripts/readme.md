(note that there are two mechanical requirements to enable shell script execution.)

The script must be “executable”.
The script must be “findable” for execution.

```
$ sudo chmod +x /home/builddockerimage.sh
```

OR

```
$ sudo chmod 0755 /home/builddockerimage.sh
```
2. Run the Shell Script
Now the Run the shell script using below command

bash builddockerimage.sh