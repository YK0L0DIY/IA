from termcolor import colored
from constants import *
import copy


def pos_is_playable(state: dict, pos: int, player: int):
    pos_value = state[f'line_{player}'][pos]
    player_line = state[f'line_{player}']
    opponent_line = state[f'line_{1 if player == 1 else 0}']

    if pos_value == 0:
        return False

    if sum(opponent_line) > 0:
        if pos_value == 1:
            return max(player_line) == 1
        return True

    else:
        return pos_value >= LINE_SIZE - pos


def play(state: dict, pos: int, player: int):
    result_state = copy.deepcopy(state)

    if sum(result_state['line_0']) == 1 and sum(result_state['line_1']) == 1:
        player_1_pos = result_state['line_1'].index(1)
        player_0_pos = result_state['line_0'].index(1)

        if abs(player_1_pos - player_0_pos) == 5:
            result_state['line_0'][pos] = 0
            result_state['line_1'][pos] = 0
            result_state['player_0'] += 1
            result_state['player_1'] += 1

    else:
        number_of_elements = result_state[f'line_{player}'][pos]
        result_state[f'line_{player}'][pos] = 0

        result_state, last_placed = distribute(result_state, pos + 1, number_of_elements, player, (pos, player))

        if player != last_placed['player']:
            result_state, points = collect(result_state, last_placed)
            result_state[f'player_{player}'] += points

    return result_state


def collect(state: dict, last_placed: dict):
    points = 0

    for i in range(last_placed['pos'], -1, -1):
        if MIN_CAPTURE <= state[last_placed['line']][i] <= MAX_CAPTURE:
            points += state[last_placed['line']][i]
            state[last_placed['line']][i] = 0
        else:
            break

    return state, points


def distribute(state: dict, start: int, elements: int, player: int, inicial: tuple):
    last_pos = None
    last_player = None

    if player == 1:
        for i in range(start, LINE_SIZE):
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
        for i in range(start, LINE_SIZE):
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
        return distribute(state, 0, elements, 1 if player != 1 else 0, inicial)
    return state, {'pos': last_pos, 'line': last_player, 'player': player}


def game_over(state: dict):
    return state['player_0'] > MAX_SCORE or state['player_1'] > MAX_SCORE


def final_state(state: dict):
    if not game_over(state):
        for i in range(0, LINE_SIZE):
            if pos_is_playable(state, i, 0) or pos_is_playable(state, i, 1):
                return False
    return True


def print_state(state: dict):
    up_line = state['line_1']
    dow_line = state['line_0']
    print(f"┌{colored('P_1', 'red')}----------------------------┐\n" +
          f"| {colored(state['player_1'], 'red')} | {up_line[5]} | {up_line[4]} | {up_line[3]} | {up_line[2]} | {up_line[1]} | {up_line[0]} |   |\n" +
          f"|   | {dow_line[0]} | {dow_line[1]} | {dow_line[2]} | {dow_line[3]} | {dow_line[4]} | {dow_line[5]} | {colored(state['player_0'], 'blue')} |\n" +
          f"└----------------------------{colored('P_0', 'blue')}┘")


def print_info():
    print('Consider this positions \n' +
          '┌P_1------------------------------┐\n' +
          "| P1 | 5 | 4 | 3 | 2 | 1 | 0 |    | line_1\n" +
          "|    | 0 | 1 | 2 | 3 | 4 | 5 | P0 | line_0\n" +
          '└------------------------------P_0┘ \n')
