import { describe, expect, test } from "bun:test";
import { isAnagram, isAnagramByCount } from "./is_anagram";

describe("basic", () => {
    test("test empty string/empty string", () => {
        expect(isAnagram("", "")).toBe(true);
    });

    test("test solos/solos - true", () => {
        expect(isAnagram("solos", "solos")).toBe(true);
    });

    test("test racecar/racecars - false", () => {
        expect(isAnagram("racecar", "racecars")).toBe(false);
    });

    test("test solos/solod - false", () => {
        expect(isAnagram("solos", "solod")).toBe(false);
    });

    test("test rat/tar - true", () => {
        expect(isAnagram("rat", "tar")).toBe(true);
    });

    test("test stale/tales - true", () => {
        expect(isAnagram("stale", "tales")).toBe(true);
    });

    test("test tall/salt - false", () => {
        expect(isAnagram("tall", "salt")).toBe(false);
    });

});

describe("by count", () => {
    test("test empty string/empty string", () => {
        expect(isAnagramByCount("", "")).toBe(true);
    });

    test("test solos/solos - true", () => {
        expect(isAnagramByCount("solos", "solos")).toBe(true);
    });

    test("test racecar/racecars - false", () => {
        expect(isAnagramByCount("racecar", "racecars")).toBe(false);
    });

    test("test solos/solod - false", () => {
        expect(isAnagramByCount("solos", "solod")).toBe(false);
    });

    test("test rat/tar - true", () => {
        expect(isAnagramByCount("rat", "tar")).toBe(true);
    });

    test("test stale/tales - true", () => {
        expect(isAnagramByCount("stale", "tales")).toBe(true);
    });

    test("test tall/salt - false", () => {
        expect(isAnagramByCount("tall", "salt")).toBe(false);
    });

});