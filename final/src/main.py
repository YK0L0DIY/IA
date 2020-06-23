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

    if state['player_1'] > state['player_0']:
        print("PLAYER 1 WON!")
    elif state['player_0'] > state['player_1']:
        print("PLAYER 0 WON!")
    else:
        print("IT'S A DRAW!")

    print("SCORES: P_0:", state['player_0'], " P_1:", state['player_1'])


if __name__ == '__main__':

    parser = argparse.ArgumentParser(prog='IA_final', description='Final project, OURI game')

    parser.add_argument('-p, --first', action='store_true', dest='first', help='To play first',
                        required=False)
    parser.add_argument('-s, --second', action='store_true', dest='second', help='To play second',
                        required=False)
    parser.add_argument('-t, --board', action='store_true', dest='board', help='To display the board',
                        required=False)
    parser.add_argument('-r, --answer', action='store_true', dest='singleAnswer', help='To display a single an answer',
                        required=False)
    parser.add_argument('-d, --level', type=str, dest='level',
                        help='The level of the game, a -> 5s, b -> 15s and c -> 30s',
                        required=True)

    args = parser.parse_args()

    setrecursionlimit(pow(10, 8))

    # initial_state = {
    #     'player_1': player1 score,
    #     'player_0': player0 score,
    #     'line_1': [1, 2, 3, 4, 5, 6], mirrored view of the opponents side of the board
    #     'line_0': [1, 2, 3, 4, 5, 6],
    # }
    initial_state = {
        'player_1': 0,
        'player_0': 0,
        'line_1': [4, 4, 4, 4, 4, 4],
        'line_0': [4, 4, 4, 4, 4, 4],
    }

    print_state(initial_state)
    tab = copy.deepcopy(initial_state)
    player0_plays = 0
    player1_plays = 0

    if args.singleAnswer:

        if args.level == 'a':
            level = FIVE_SECONDS_ALPHABETA_SA
        elif args.level == 'b':
            level = FIFTEEN_SECONDS_ALPHABETA_SA
        elif args.level == 'c':
            level = THIRTY_SECONDS_ALPHABETA_SA

        start = time.time()

        pos = alphabeta(tab, level)

        end = time.time()
        print('Evaluation time: {}s'.format(round(end - start, 7)))

        tab = play(tab, pos, PLAYER_1)

        print_state(tab)
        print("P_1 PLAYED: ", pos + 1)

    else:

        if args.level == 'a':

            level = FIVE_SECONDS_ALPHABETA
            m_level = FIVE_SECONDS_MINIMAX

        elif args.level == 'b':

            level = FIFTEEN_SECONDS_ALPHABETA
            m_level = FIFTEEN_SECONDS_MINIMAX

        elif args.level == 'c':

            level = THIRTY_SECONDS_ALPHABETA
            m_level = THIRTY_SECONDS_MINIMAX

        if args.first:
            p = 1
        elif args.second:
            p = 0
        else:
            p = 0

        while not final_state(tab):

            if p % 2 == 0:
                pos = int(input("> ")) - 1

                print("P_0 PLAYED: ", pos + 1)

            else:

                start = time.time()

                if player1_plays == 0:
                    pos = randint(0, 5)
                    player1_plays += 1
                else:
                    pos = alphabeta(tab, level)

                end = time.time()
                print('Evaluation time: {}s'.format(round(end - start, 7)))

                print("P_1 PLAYED: ", pos + 1)

            tab = play(tab, pos, p % 2)

            if args.board:
                print_state(tab)
            p += 1

        print_state(tab)
        print_scores(tab)
