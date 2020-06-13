from constants import MIN_CAPTURE, MAX_CAPTURE


def play(state: dict, pos: int, player: int):
    if player == 1:
        number_of_elements = state['line_1'][pos]
        state['line_1'][pos] = 0

    else:
        number_of_elements = state['line_0'][pos]
        state['line_0'][pos] = 0

    result_state, last_placed = distribute(state, pos + 1, number_of_elements, player, (pos, player))

    if player != last_placed['player']:
        #print('Capturing ', last_placed['pos'], last_placed['line'], ' from: ')
        #print_state(result_state)

        result_state, points = collect(result_state, last_placed)
        result_state[f'player_{player}'] += points

    return result_state


def collect(state: dict, last_placed: dict):
    points = 0

    for i in range(0, 6):
        if MIN_CAPTURE <= state[last_placed['line']][last_placed['pos'] - i] <= MAX_CAPTURE:
            points += state[last_placed['line']][last_placed['pos'] - i]
            state[last_placed['line']][last_placed['pos'] - i] = 0
        else:
            break

    return state, points


def distribute(state: dict, start: int, elements: int, player: int, inicial: tuple):
    last_pos = None
    last_player = None

    if player == 1:
        for i in range(start, 6):
            # ignore the start space
            if i == inicial[0] and player == inicial[1]:
                continue

            elif elements > 0:
                state['line_1'][i] += 1
                elements -= 1
                last_pos = i
                last_player = 'line_1'

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
                last_pos = i
                last_player = 'line_0'
            else:
                break

    if elements > 0:
        return distribute(state, 0, elements, -player, inicial)
    return state, {'pos': last_pos, 'line': last_player, 'player': player}


def final_state(state: dict):
    return False


def print_state(state: dict):
    up_line = state['line_1']
    dow_line = state['line_0']
    print('┌P_1----------------------------┐\n' +
          f"| {state['player_1']} | {up_line[5]} | {up_line[4]} | {up_line[3]} | {up_line[2]} | {up_line[1]} | {up_line[0]} |   |\n" +
          f"|   | {dow_line[0]} | {dow_line[1]} | {dow_line[2]} | {dow_line[3]} | {dow_line[4]} | {dow_line[5]} | {state['player_0']} |\n" +
          '└----------------------------P_0┘')


def print_info():
    print('Consider this positions \n' +
          '┌P_1------------------------------┐\n' +
          "| P1 | 5 | 4 | 3 | 2 | 1 | 0 |    | line_1\n" +
          "|    | 0 | 1 | 2 | 3 | 4 | 5 | P0 | line_0\n" +
          '└------------------------------P_0┘ \n')
