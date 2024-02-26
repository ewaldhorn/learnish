export const isAnagram = (left, right) => {
    if (left.length != right.length) {
        return false;
    }

    const left_sorted = left.split("").sort().join("");
    const right_sorted = right.split("").sort().join("");

    return left_sorted === right_sorted;
}

export const isAnagramByCount = (left, right) => {
    if (left.length != right.length) {
        return false;
    }

    const leftCount = {}, rightCount = {};

    for (const ch of left) {
        if (ch in leftCount) {
            leftCount[ch] += 1;
        } else {
            leftCount[ch] = 1;
        }
    }

    for (const ch of right) {
        if (ch in leftCount == false) {
            return false; // short-circuit
        }
        if (ch in rightCount) {
            rightCount[ch] += 1;
        } else {
            rightCount[ch] = 1;
        }
    }

    for (const ch of left) {
        if (leftCount[ch] != rightCount[ch]) {
            return false;
        }
    }

    return true;
}