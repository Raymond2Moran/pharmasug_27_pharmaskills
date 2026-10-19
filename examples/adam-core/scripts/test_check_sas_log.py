"""Test diagnostic screening only; this does not run or validate SAS."""
import unittest
from check_sas_log import inspect, COMPLETE


class LogReviewTests(unittest.TestCase):
    def test_clean_completed(self):
        self.assertEqual(inspect("NOTE: 12 observations read.\nNOTE: " + COMPLETE)["review_status"],
                         "NO_FLAGGED_DIAGNOSTICS")

    def test_truncated_log_is_not_success(self):
        self.assertEqual(inspect("NOTE: Dataset created.")["review_status"], "NEEDS_REVIEW")

    def test_each_diagnostic_requires_review(self):
        for line in ["ERROR 180-322: Statement is not valid.", "ERROR: Execution failed.",
                     "WARNING: Variable length differs.", "NOTE: Variable ABC is uninitialized.",
                     "NOTE: Invalid data for ADT", "NOTE: Numeric values have been converted",
                     "NOTE: Missing values were generated", "NOTE: MERGE repeats of BY values",
                     "NOTE: Division by zero detected."]:
            with self.subTest(line=line):
                result = inspect(line + "\nNOTE: " + COMPLETE)
                self.assertEqual(result["review_status"], "NEEDS_REVIEW")
                self.assertEqual(result["findings"][0]["line"], 1)


if __name__ == "__main__":
    unittest.main()
