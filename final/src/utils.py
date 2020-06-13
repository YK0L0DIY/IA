def play(state: dict, pos: int, player: int):
    if player == 1:
        number_of_elements = state['line_1'][pos]
        result = distribute(state, pos + 1, number_of_elements, 1, (pos, 1))
        state['line_1'][pos] = 0

    else:
        number_of_elements = state['line_0'][pos]
        result = distribute(state, pos + 1, number_of_elements, -1, (pos, -1))
        state['line_0'][pos] = 0

    return result


def distribute(state: dict, start: int, elements: int, player: int, inicial: tuple):
    if player == 1:
        for i in range(start, 6):
            # ignore the start space
            if i == inicial[0] and player == inicial[1]:
                continue

            elif elements > 0:
                state['line_1'][i] += 1
                elements -= 1

            else:
                break

    else:
        for i in range(start, 6):
            # ignore the start space
            if i == inicial[0] and player == inicial[1]:
                continue
            elif elements > 0:
                state['line_0'][i] += 1
                elements -= 1

            else:
                break

    if elements > 0:
        return distribute(state, 0, elements, -player, inicial)
    return state


def final_state(state: dict):
    return False


def print_state(state: dict):
    print(' P_1 ------------------------P_2\n' +
          f"| {state['palayer_1']} | 5 | 4 | 3 | 2 | 1 | 0 |   |\n" +
          f"|   | 0 | 1 | 2 | 3 | 4 | 5 | {state['palayer_0']} |\n" +
          '---------------------------------')
    up_line = state['line_1']
    dow_line = state['line_0']
    print(' P_1 ------------------------P_2\n' +
          f"| {state['palayer_1']} | {up_line[5]} | {up_line[4]} | {up_line[3]} | {up_line[2]} | {up_line[1]} | {up_line[0]} |   |\n" +
          f"|   | {dow_line[0]} | {dow_line[1]} | {dow_line[2]} | {dow_line[3]} | {dow_line[4]} | {dow_line[5]} | {state['palayer_0']} |\n" +
          '---------------------------------')
