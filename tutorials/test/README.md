## Test setup container

This container image tests that your docker setup is correct, and that privileged
containers can create [Linux Network namespaces](https://man7.org/linux/man-pages/man7/network_namespaces.7.html).

## How to use it

```
docker run --privileged ghcr.io/bitpuff-io/tutorials.test
```
