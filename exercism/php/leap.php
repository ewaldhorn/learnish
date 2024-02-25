<?php

declare(strict_types=1);

function isLeap(int $year): bool
{
    return ($year % 400 == 0) || ($year % 4 == 0 && $year % 100 != 0);
}

