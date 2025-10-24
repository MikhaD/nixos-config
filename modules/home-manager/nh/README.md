# Nh Module
This module configures nh, a nix utility tool. It provides a unified set of commands, and improved output for things like updating and garbage collection.

## Update Output Key:

### Status Letters
| Letter | Meaning | Description |
|--------|---------|-----------|
| A | Added | New package/service that wasn't in the previous generation |
| R | Removed | Package/service that was present before but is now gone |
| U | Updated | Package/service that has changed between generations |
| D | Downgraded | Package version has been reduced |
| M | Modified | Configuration or attributes changed without version change |

### Status Symbols
| Symbol | Meaning | Description |
|--------|---------|-----------|
| . (dot) | Minor change | Semver patch or minor version change |
| * (asterisk) | Major change | Semver major version change |
| - (dash) | Dependency change | No direct change, but dependencies have changed |
| + (plus) | Addition with dependencies | New package added along with its dependencies |
| ! (exclamation) | Breaking change | Potentially disruptive update that may require attention |

### Examples
| Status | Meaning |
|--------|---------|
| U.  | Updated with minor changes |
| U*  | Updated with major changes |
| A.  | Added with minor impact |
| R.  | Removed cleanly |
| R-  | Removed with dependency cleanup |
| D!  | Downgraded with breaking changes |
| M+  | Modified with new dependencies |