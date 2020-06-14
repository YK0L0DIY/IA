from math import inf

from constants import LINE_SIZE, PLAYER_1, PLAYER_0
from utils import final_state as is_final, play, pos_is_playable


def minimax(state: dict, deph: int):
    to_play = -1
    value = -inf

    for x in range(0, LINE_SIZE):

        if pos_is_playable(state, x, PLAYER_1):
            played = play(state, x, PLAYER_1)
            game_value = minimizer(played, deph)
            if game_value >= value:
                value = game_value
                to_play = x

    return to_play


def maximizer(state: dict, deph: int):
    if is_final(state) or deph == 0:
        return heur(state)

    value = -inf

    for x in range(0, LINE_SIZE):
        if pos_is_playable(state, x, PLAYER_1):
            played = play(state, x, PLAYER_1)
            value = max(value, minimizer(played, deph - 1))

    return value


def minimizer(state: dict, deph: int):
    if is_final(state) or deph == 0:
        return heur(state)

    value = inf

    for x in range(0, LINE_SIZE):
        if pos_is_playable(state, x, PLAYER_0):
            played = play(state, x, PLAYER_0)
            value = min(value, maximizer(played, deph - 1))

    return value


def heur(state: dict):
    return state['player_1'] - state['player_0']
