#!/usr/bin/env python3
"""Flag SAS diagnostics for review; absence of findings is not derivation QC."""
import argparse
import json
import re
from pathlib import Path

DIAGNOSTIC = re.compile(
    r"^\s*(ERROR(?:\s+\d+-\d+)?\s*:|WARNING\s*:)"
    r"|uninitialized|invalid (?:data|argument)|division by zero"
    r"|(?:character|numeric) values have been converted"
    r"|missing values were generated|repeats of BY values|truncat",
    re.IGNORECASE,
)
COMPLETE = "Fixture comparisons completed. Log review and independent review remain required."


def inspect(text):
    lines = text.splitlines()
    findings = [
        {"line": number, "text": line.strip()}
        for number, line in enumerate(lines, 1)
        if DIAGNOSTIC.search(line)
    ]
    completed = any(COMPLETE in line for line in lines)
    return {"completion_marker_present": completed, "findings": findings,
            "review_status": "NEEDS_REVIEW" if findings or not completed else "NO_FLAGGED_DIAGNOSTICS"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("log", type=Path)
    args = parser.parse_args()
    result = inspect(args.log.read_text(encoding="utf-8", errors="replace"))
    print(json.dumps(result, indent=2))
    return 1 if result["review_status"] == "NEEDS_REVIEW" else 0


if __name__ == "__main__":
    raise SystemExit(main())
