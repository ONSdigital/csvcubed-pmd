# csvcubed - PMD

> Tools to transform a CSV-qb into RDF which is compatible with the [Publish My Data](https://publishmydata.com) platform.

Part of the [csvcubed](https://github.com/GSS-Cogs/csvcubed/) project.

It is anticipated that this library will only be for internal IDP-D usage and does not need to be installed or distributed to external data producers.

## Adding a package

Dependencies are installed in the [Docker container](./Dockerfile) on a container-wide basis. If you're adding a new package, first run:

```bash
poetry add <some-package>
```

And once that has completed, if you are working inside the docker dev container, you must rebuild the container before the packages will be available for your use.