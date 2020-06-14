from math import inf

from constants import LINE_SIZE
from utils import final_state as is_final, play, pos_is_playable


def minimax(state: dict):
    to_play = -1
    value = -inf

    for x in range(0, LINE_SIZE):

        played = play(state, x, 0)
        game_value = minimizer(played)
        if game_value > value:
            value = game_value
            to_play = x

    return to_play


def maximizer(state: dict):
    if is_final(state):
        return state['player_0'] - state['player_1']

    value = -inf

    for x in range(0, LINE_SIZE):
        if pos_is_playable(state, x, 0):
            played = play(state, x, 0)
            value = max(value, minimizer(played))

    return value


def minimizer(state: dict):
    if is_final(state):
        return state['player_0'] - state['player_1']

    value = inf

    for x in range(0, LINE_SIZE):
        if pos_is_playable(state, x, 1):
            played = play(state, x, 1)
            value = min(value, maximizer(played))

    return value
