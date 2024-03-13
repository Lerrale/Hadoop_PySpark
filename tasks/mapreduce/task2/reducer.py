#!/usr/bin/env python3
import sys
import io

input_stream = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')
output_stream = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

current_key = None
sum_count = 0

for line in input_stream:
    try:
        key, count = line.strip().split('\t', 1)
        count = int(count)
    except ValueError as e:
        continue

    if current_key != key:
        if current_key:
            print(f"{current_key}\t{sum_count:}", file=output_stream)
        sum_count = 0
        current_key = key
    sum_count += count

if current_key:
    print(f"{current_key}\t{sum_count}", file=output_stream)
