# Swamp Conformance Suite

Conformance tests for the [Swamp](https://swamp-lang.org/) compiler and, by extension, the [Marsh VM](https://marshvm.com/).

| Directory  | What it checks                                              |
| ---------- | ----------------------------------------------------------- |
| `passing/` | Valid Swamp compiles and `#[test]` functions run correctly. |
| `failing/` | Invalid Swamp is rejected with the expected diagnostic.     |

Files in `failing/` contain deliberately bad source. A fail test passes when the compiler reports the `code` and `message` declared in the file header.

## Run

```sh
swamp test     # passing/
swamp failtest # failing/ - diagnostic tests
```
