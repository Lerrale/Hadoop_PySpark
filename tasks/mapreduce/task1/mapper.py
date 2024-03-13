#!/usr/bin/env python3
import json

import sys
import io
from datetime import timedelta

input_stream = io.TextIOWrapper(
    sys.stdin.buffer, encoding='utf-8'
)
output_stream = io.TextIOWrapper(
    sys.stdout.buffer,
    encoding='utf-8'
)

week_list = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
for line in input_stream:  # читаем данные из stdin
    review = json.loads(line.strip())
    business_id = review['business_id']
    if 'hours' in review and review["hours"] is not None and int(review["is_open"]) == 1:        
        for week_day in week_list:
            if week_day in review["hours"]:
                hours = review["hours"][week_day]
                hours_list = hours.split('-')
                start_time_list = hours_list[0].split(':')
                start_time = timedelta(hours=int(start_time_list[0]), minutes=int(start_time_list[1]))
                end_time_list = hours_list[1].split(':')
                end_time = timedelta(hours=int(end_time_list[0]), minutes=int(end_time_list[1]))
                work_hours = end_time - start_time
                work_hours = int(work_hours.seconds/60)
                print(f'{business_id}\t{work_hours}', file=output_stream)
    else:
        print(f'{business_id}\t0', file=output_stream)

                

        
