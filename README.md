# evolve-apis

## Precautions for use

### permission
> You may need to add script execution permission to run on `linux`.

```shell
cd evolve-apis
chmod +x new-api/mvnw
chmod +x old-api/mvnw
```

### character
>2  In addition, you need to pay attention to the problem of script character set, for example, the solution on `Centos 9`:

```shell
dnf -y install dos2unix 
cd evolve-apis
dos2unix new-api/mvnw
dos2unix old-api/mvnw
```

## Start up
```shell
cd evolve-apis
docker-compose up -d 
```

