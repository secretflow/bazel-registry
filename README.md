Bazel Registry for SecretFlow Stack
===================================


# Usage

To use the SecretFlow Bazel Registry, add the following to your `.bazelrc` file.

```
common --registry=https://raw.githubusercontent.com/secretflow/bazel-registry/main
```



## Tools Usage

### Update module integrity

```
# update integrity of module `module_name`
$ bazel run //tools:update_integrity -- <module_name>
```
