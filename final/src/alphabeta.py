from math import inf

from constants import LINE_SIZE, PLAYER_1, PLAYER_0
from utils import final_state as is_final, play, pos_is_playable


def alphabeta(state: dict, depth: int):
    to_play = -1
    value = -inf
    alpha = -inf
    beta = inf

    for x in range(0, LINE_SIZE):

        if pos_is_playable(state, x, PLAYER_1):
            played = play(state, x, PLAYER_1)
            game_value = minimizer(played, depth, alpha, beta)
            if game_value > value:
                value = game_value
                to_play = x

    return to_play


def maximizer(state: dict, depth: int, alpha: float, beta: float):
    if is_final(state) or depth == 0:
        return heur(state)

    value = -inf

    for x in range(0, LINE_SIZE):
        if pos_is_playable(state, x, PLAYER_1):
            played = play(state, x, PLAYER_1)
            value = max(value, minimizer(played, depth - 1, alpha, beta))

            if value >= beta:
                return value

            alpha = max(alpha, value)

    return value


def minimizer(state: dict, depth: int, alpha: float, beta: float):
    if is_final(state) or depth == 0:
        return heur(state)

    value = inf

    for x in range(0, LINE_SIZE):
        if pos_is_playable(state, x, PLAYER_0):
            played = play(state, x, PLAYER_0)
            value = min(value, maximizer(played, depth - 1, alpha, beta))

            if value <= alpha:
                return value

            beta = min(beta, value)

    return value


def heur(state: dict):
    return state['player_1'] - state['player_0']
