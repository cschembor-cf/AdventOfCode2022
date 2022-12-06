
def part1():
    input_lines = get_input_lines("day1_input.txt")
    separator_indices = get_separator_indices(input_lines)
    return max(get_cal_totals(input_lines, separator_indices))

def part2():
    input_lines = get_input_lines("day1_input.txt")
    separator_indices = get_separator_indices(input_lines)
    cal_totals = get_cal_totals(input_lines, separator_indices)
    cal_totals.sort(reverse=True)
    return sum(cal_totals[0:3])

def get_input_lines(filename):
    return list(map(lambda x: x.replace('\n', ''), open(filename, "r").readlines()))

def get_separator_indices(input_lines):
    return [i for i, x in enumerate(input_lines) if x == '']

def get_cal_totals(input_lines, separator_indices):
    total_cals_list = []
    curr_index = 0
    for separator_index in separator_indices:
        curr_slice = input_lines[curr_index:separator_index]
        total_cals_list.append(sum(list(map(lambda x: int(x), curr_slice))))
        curr_index = separator_index+1

    return total_cals_list

# print(part1())
print(part2())
