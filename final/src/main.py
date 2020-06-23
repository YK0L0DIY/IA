import time
from random import randint
import argparse

from utils import *
from constants import *
import copy
from minimax import minimax
from alphabeta import alphabeta

from sys import setrecursionlimit


def print_scores(state: dict):
    print("SCORES: P_0:", tab['player_0'], " P_1:", tab['player_1'])


plays = 0

if __name__ == '__main__':

    parser = argparse.ArgumentParser(prog='IA_final', description='Final project, OURI game')

    parser.add_argument('-p, --first', action='store_true', dest='first', help='To play first',
                        required=False)
    parser.add_argument('-s, --second', action='store_true', dest='second', help='To play second',
                        required=False)
    parser.add_argument('-t, --board', action='store_true', dest='board', help='To display the board',
                        required=False)
    parser.add_argument('-d, --difficulty', type=str, dest='difficulty',
                        help='The difficulty of the game, a -> 5s, b -> 15s and c -> 30s',
                        required=True)
    parser.add_argument('-e, --state', type=dict, dest='state',
                        help='The difficulty of the game, a -> 5s, b -> 15s and c -> 30s',
                        required=False)
    args = parser.parse_args()

    # funciona como um dicionario, se -p ent args.first vai estar a true e se -s ent args.second vai estar a true
    # charmar com python main.py -f 

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

    print(args)

    if args.first:
        p = 1
    elif args.second:
        p = 0
    else:
        p = 0

    if args.difficulty == 'a':
        difficulty = FIVE_SECONDS_ALPHABETA
    elif args.difficulty == 'b':
        difficulty = FIFTEEN_SECONDS_ALPHABETA
    elif args.difficulty == 'c':
        difficulty = THIRTY_SECONDS_ALPHABETA

    while not final_state(tab):

        if p % 2 == 0:
            start = time.time()
            if plays == 0:
                pos = randint(0, 5)
                plays += 1
            else:
                pos = minimax(tab, THIRTY_SECONDS_MINIMAX)

            end = time.time()
            print('Evaluation time: {}s'.format(round(end - start, 7)))

            print("P_0 PLAYED: ", pos + 1)

        else:

            start = time.time()

            if plays == 1:
                pos = randint(0, 5)
                plays += 1
            else:
                pos = alphabeta(tab, THIRTY_SECONDS_ALPHABETA)

            end = time.time()
            print('Evaluation time: {}s'.format(round(end - start, 7)))

            print("P_1 PLAYED: ", pos + 1)

        tab = play(tab, pos, p % 2)

        if args.board:
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
