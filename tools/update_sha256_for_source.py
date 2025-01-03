#! /usr/bin/env python3

# Copyright 2024 Ant Group Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import json
import argparse
import subprocess


def check_and_update_dir(json, dir):
    if os.path.exists(dir):
        parent_name = os.path.basename(dir)
        json[parent_name] = {}
        for file in os.listdir(dir):
            result = subprocess.run(
                f"cat {os.path.join(dir, file)} | openssl dgst --binary -sha256 | openssl base64 -A",
                shell=True,
                stdout=subprocess.PIPE,
            )
            json[parent_name][file] = f"sha256-{result.stdout.decode('utf-8')}"


def main():
    parser = argparse.ArgumentParser(description="Updating sha256 in source.json")

    parser.add_argument(
        "--file",
        metavar="the source.json file in modules to be updated",
        type=str,
        help="e.g: python tools/update_sha256_for_source.py --file=modules/utf8proc/2.7.0/source.json",
        default=".",
        required=True,
    )

    args = parser.parse_args()
    file_path = os.path.abspath(args.file)
    if os.path.basename(file_path) != "source.json":
        print(f"only support update File named source.json")
        return
    if not os.path.exists(file_path):
        print(f"File {file_path} not found")
        return

    content = json.load(open(file_path, "r"))

    parent_path = os.path.dirname(file_path)
    # update overlay
    check_and_update_dir(content, os.path.join(parent_path, "overlay"))

    # update patch
    check_and_update_dir(content, os.path.join(parent_path, "patches"))

    with open(file_path, "w") as file:
        json.dump(content, file, indent=4)


if __name__ == "__main__":
    main()
