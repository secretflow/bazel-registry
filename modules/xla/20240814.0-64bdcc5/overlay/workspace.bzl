load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@tsl//third_party:repo.bzl", "tf_http_archive", "tf_mirror_urls")
load("@tsl//third_party/absl:workspace.bzl", com_google_absl = "repo")
load("@tsl//third_party/gpus:cuda_configure.bzl", "cuda_configure")
load("@tsl//third_party/gpus:rocm_configure.bzl", "rocm_configure")
load("@tsl//third_party/py/ml_dtypes:workspace.bzl", ml_dtypes = "repo")
load("@tsl//third_party/pybind11_bazel:workspace.bzl", pybind11_bazel = "repo")
load("@tsl//third_party/tensorrt:tensorrt_configure.bzl", "tensorrt_configure")
load("@tsl//tools/toolchains/remote:configure.bzl", "remote_execution_configure")

def _xla_workspace_impl(mctx):
    cuda_configure(name = "local_config_cuda")
    remote_execution_configure(name = "local_config_remote_execution")
    rocm_configure(name = "local_config_rocm")
    tensorrt_configure(name = "local_config_tensorrt")
    ml_dtypes()
    pybind11_bazel()
    com_google_absl()
    tf_http_archive(
        name = "farmhash_archive",
        build_file = "//third_party/farmhash:farmhash.BUILD",
        sha256 = "18392cf0736e1d62ecbb8d695c31496b6507859e8c75541d7ad0ba092dc52115",
        strip_prefix = "farmhash-0d859a811870d10f53a594927d0d0b97573ad06d",
        urls = tf_mirror_urls("https://github.com/google/farmhash/archive/0d859a811870d10f53a594927d0d0b97573ad06d.tar.gz"),
    )

    tf_http_archive(
        name = "double_conversion",
        sha256 = "3dbcdf186ad092a8b71228a5962009b5c96abde9a315257a3452eb988414ea3b",
        strip_prefix = "double-conversion-3.2.0",
        system_build_file = "@tsl//third_party/systemlibs:double_conversion.BUILD",
        urls = tf_mirror_urls("https://github.com/google/double-conversion/archive/v3.2.0.tar.gz"),
    )
    http_archive(
        name = "io_bazel_rules_closure",
        sha256 = "5b00383d08dd71f28503736db0500b6fb4dda47489ff5fc6bed42557c07c6ba9",
        strip_prefix = "rules_closure-308b05b2419edb5c8ee0471b67a40403df940149",
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/github.com/bazelbuild/rules_closure/archive/308b05b2419edb5c8ee0471b67a40403df940149.tar.gz",
            "https://github.com/bazelbuild/rules_closure/archive/308b05b2419edb5c8ee0471b67a40403df940149.tar.gz",  # 2019-06-13
        ],
    )
    http_archive(
        name = "rules_proto_grpc",
        sha256 = "2a0860a336ae836b54671cbbe0710eec17c64ef70c4c5a88ccfd47ea6e3739bd",
        strip_prefix = "rules_proto_grpc-4.6.0",
        urls = [
            "https://github.com/rules-proto-grpc/rules_proto_grpc/releases/download/4.6.0/rules_proto_grpc-4.6.0.tar.gz",
        ],
    )
    tf_http_archive(
        name = "snappy",
        build_file = "@tsl//third_party:snappy.BUILD",
        sha256 = "2e458b7017cd58dcf1469ab315389e85e7f445bd035188f2983f81fb19ecfb29",
        strip_prefix = "snappy-984b191f0fefdeb17050b42a90b7625999c13b8d",
        system_build_file = "@tsl//third_party/systemlibs:snappy.BUILD",
        urls = tf_mirror_urls("https://github.com/google/snappy/archive/984b191f0fefdeb17050b42a90b7625999c13b8d.tar.gz"),
    )
    tf_http_archive(
        name = "com_github_grpc_grpc",
        sha256 = "b956598d8cbe168b5ee717b5dafa56563eb5201a947856a6688bbeac9cac4e1f",
        strip_prefix = "grpc-b54a5b338637f92bfcf4b0bc05e0f57a5fd8fadd",
        system_build_file = "@tsl//third_party/systemlibs:grpc.BUILD",
        patch_file = [
            "@tsl//third_party/grpc:generate_cc_env_fix.patch",
            "@tsl//third_party/grpc:register_go_toolchain.patch",
        ],
        system_link_files = {
            "@tsl//third_party/systemlibs:BUILD": "bazel/BUILD",
            "@tsl//third_party/systemlibs:grpc.BUILD": "src/compiler/BUILD",
            "@tsl//third_party/systemlibs:grpc.bazel.grpc_deps.bzl": "bazel/grpc_deps.bzl",
            "@tsl//third_party/systemlibs:grpc.bazel.grpc_extra_deps.bzl": "bazel/grpc_extra_deps.bzl",
            "@tsl//third_party/systemlibs:grpc.bazel.cc_grpc_library.bzl": "bazel/cc_grpc_library.bzl",
            "@tsl//third_party/systemlibs:grpc.bazel.generate_cc.bzl": "bazel/generate_cc.bzl",
            "@tsl//third_party/systemlibs:grpc.bazel.protobuf.bzl": "bazel/protobuf.bzl",
        },
        urls = tf_mirror_urls("https://github.com/grpc/grpc/archive/b54a5b338637f92bfcf4b0bc05e0f57a5fd8fadd.tar.gz"),
    )
    tf_http_archive(
        name = "com_google_protobuf",
        patch_file = ["@tsl//third_party/protobuf:protobuf.patch"],
        sha256 = "f66073dee0bc159157b0bd7f502d7d1ee0bc76b3c1eac9836927511bdc4b3fc1",
        strip_prefix = "protobuf-3.21.9",
        system_build_file = "@tsl//third_party/systemlibs:protobuf.BUILD",
        system_link_files = {
            "@tsl//third_party/systemlibs:protobuf.bzl": "protobuf.bzl",
            "@tsl//third_party/systemlibs:protobuf_deps.bzl": "protobuf_deps.bzl",
        },
        urls = tf_mirror_urls("https://github.com/protocolbuffers/protobuf/archive/v3.21.9.zip"),
    )
    return mctx.extension_metadata(
        reproducible = True,
        root_module_direct_deps = "all",
        root_module_direct_dev_deps = [],
    )

xla_workspace_ext = module_extension(
    implementation = _xla_workspace_impl,
)
