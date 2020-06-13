def play(state: dict, pos: int, player: int):
    return state


def print_state(state: dict):
    up_line = state['line_1']
    dow_line = state['line_1']
    print(' P_1 ------------------------P_2\n' +
          f"| {state['palayer_1']} | {up_line[0]} | {up_line[1]} | {up_line[2]} | {up_line[3]} | {up_line[4]} | {up_line[5]} |   |\n" +
          f"|   | {dow_line[0]} | {dow_line[1]} | {dow_line[2]} | {dow_line[3]} | {dow_line[4]} | {dow_line[5]} | {state['palayer_2']} |\n" +
          '---------------------------------')
