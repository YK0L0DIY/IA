from utils import *
import copy

if __name__ == '__main__':

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

        pos = int(input(f"P_{p % 2}> "))

        if pos_is_playable(tab, pos, p % 2):
            tab = play(tab, pos, p % 2)
            print_state(tab)
            p += 1
