from utils import *

initial_state = {
    'player_1': 0,
    'player_0': 0,
    'line_1': [4, 4, 4, 4, 4, 4],
    'line_0': [4, 4, 4, 4, 4, 4],
}

if __name__ == '__main__':
    print_info()
    print_state(initial_state)
    print_state(play(initial_state, 5, 1))