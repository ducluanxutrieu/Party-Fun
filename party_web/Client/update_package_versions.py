#!/usr/bin/env python3
import json
import re
import sys
from argparse import ArgumentParser
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.parse import quote
from urllib.request import Request, urlopen


def parse_semver(version: str):
    match = re.match(r"^v?(\d+)\.(\d+)\.(\d+)", version)
    if not match:
        return None
    return tuple(int(part) for part in match.groups())


def is_prerelease(version: str) -> bool:
    return bool(re.search(r"-(alpha|beta|rc|pre|preview|dev|next)\d*", version, re.IGNORECASE))


def get_latest_stable_version(package_name: str) -> str | None:
    encoded_name = quote(package_name, safe="@/")
    url = f"https://registry.npmjs.org/{encoded_name}"
    request = Request(url, headers={"Accept": "application/json"})

    try:
        with urlopen(request, timeout=20) as response:
            data = json.load(response)
    except (HTTPError, URLError, TimeoutError) as exc:
        print(f"[warn] Could not fetch {package_name}: {exc}", file=sys.stderr)
        return None

    versions = data.get("versions", {})
    if isinstance(versions, dict) and versions:
        stable_versions = [v for v in versions.keys() if not is_prerelease(v)]
        if stable_versions:
            stable_versions.sort(key=parse_semver, reverse=True)
            return stable_versions[0]

    dist_tags = data.get("dist-tags", {})
    if isinstance(dist_tags, dict):
        latest = dist_tags.get("latest")
        if latest:
            return latest

    return None


def update_package_file(package_json_path: Path, dry_run: bool = False) -> int:
    with package_json_path.open("r", encoding="utf-8") as handle:
        package_json = json.load(handle)

    sections = ["dependencies", "devDependencies", "peerDependencies", "optionalDependencies"]
    updated = 0

    for section in sections:
        packages = package_json.get(section, {})
        if not isinstance(packages, dict):
            continue

        for name, current_spec in list(packages.items()):
            if not isinstance(current_spec, str) or not current_spec.strip():
                continue

            latest_version = get_latest_stable_version(name)
            if not latest_version:
                continue

            if latest_version == current_spec:
                continue

            packages[name] = latest_version
            updated += 1
            print(f"{name}: {current_spec} -> {latest_version}")

    if updated == 0:
        print("No dependency versions needed updating.")
        return 0

    if dry_run:
        print(f"Dry run complete; {updated} dependency version(s) would be updated.")
        return 0

    with package_json_path.open("w", encoding="utf-8") as handle:
        json.dump(package_json, handle, indent=2)
        handle.write("\n")

    print(f"Updated {updated} dependency version(s) in {package_json_path}.")
    return 1


def main() -> int:
    parser = ArgumentParser(description="Update package.json dependency versions from the npm registry")
    parser.add_argument("package_json", nargs="?", default="package.json", help="Path to package.json")
    parser.add_argument("--dry-run", action="store_true", help="Show what would change without writing the file")
    args = parser.parse_args()

    package_json_path = Path(args.package_json).resolve()
    if not package_json_path.exists():
        print(f"Package file not found: {package_json_path}", file=sys.stderr)
        return 2

    return update_package_file(package_json_path, dry_run=args.dry_run)


if __name__ == "__main__":
    sys.exit(main())
