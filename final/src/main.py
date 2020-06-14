from utils import *
import copy
from minimax import minimax

from sys import setrecursionlimit


def print_scores(state: dict):
    print("SCORES: P_0:", tab['player_0'], " P_1:", tab['player_1'])


if __name__ == '__main__':
    setrecursionlimit(pow(10, 8))

    # initial_state = {
    #     'player_1': 25,
    #     'player_0': 0,
    #     'line_1': [0, 0, 0, 0, 0, 2],
    #     'line_0': [2, 1, 0, 0, 0, 2],
    # }
    initial_state = {
        'player_1': 0,
        'player_0': 0,
        'line_1': [4, 4, 4, 4, 4, 4],
        'line_0': [4, 4, 4, 4, 4, 4],
    }

    print_info()
    print_state(initial_state)
    tab = copy.deepcopy(initial_state)
    p = 0

    while not final_state(tab):

        if p % 2 == 0:
            pos = int(input(f"P_{p % 2}> "))

            while not pos_is_playable(tab, pos, p % 2):
                pos = int(input(f"P_{p % 2}> "))

        else:
            pos = minimax(tab, 7)

            # while not pos_is_playable(tab, pos, p % 2):
            #    pos = minimax(tab, 10)

            print("PLAYED: ", pos)

        # else:
        #     pos = int(input(f"P_{p % 2}> "))
        #
        #     while not pos_is_playable(tab, pos, p % 2):
        #         pos = int(input(f"P_{p % 2}> "))

        tab = play(tab, pos, p % 2)
        print_state(tab)
        p += 1

    if tab['player_1'] > tab['player_0']:
        print("PLAYER 1 WON!")
    elif tab['player_0'] > tab['player_1']:
        print("PLAYER 0 WON!")
    else:
        print("IT'S A DRAW!")

    print_scores(tab)
    print_state(tab)
