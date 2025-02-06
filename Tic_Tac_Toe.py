def initialize_game_board():
    #Initialize a empty 3x3 game board
    return {'A1': ' ', 'A2': ' ', 'A3': ' ',
            'B1': ' ', 'B2': ' ', 'B3': ' ',
            'C1': ' ', 'C2': ' ', 'C3': ' '}

def print_game_board(board):
    #Print the game board
    print("   A   B   C")
    print(f"1  {board['A1']} | {board['B1']} | {board['C1']}")
    print("  ---|---|---")
    print(f"2  {board['A2']} | {board['B2']} | {board['C2']}")
    print("  ---|---|---")
    print(f"3  {board['A3']} | {board['B3']} | {board['C3']}")

def does_position_exist(position):
    #Check if the position exists on the game board
    return position in ['A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3']

def is_position_availible(board, position):
    #Check if the position on the game board is availible
    return board[position] == ' '

def check_for_winner(board, mark):
    #Check if the player has won the game
    win_conditions = [
        ['A1', 'A2', 'A3'],['B1', 'B2', 'B3'],['C1', 'C2', 'C3'],
        ['A1', 'B1', 'C1'],['A2', 'B2', 'C2'],['A3', 'B3', 'C3'],
        ['A1', 'B2', 'C3'],['A3', 'B2', 'C1']                       
    ]
    for condition in win_conditions:
        if all(board[pos] == mark for pos in condition):
            return True
    return False

def is_board_full(board):
    #Check if the board is full
    return all(value != ' ' for value in board.values())

#Main game loop
def choose_position():
    #Initialize the game board and set the starting player
    board = initialize_game_board()
    current_player = 'X'
    
    while True:
        #Print the current board
        print_game_board(board)
        
        #Ask the player to choose a move
        position = input(f"Player {current_player}, choose a position (A1-C3): ").upper()
        
        #Check if the position selected is valid and availible
        if position not in board:
            print("Invalid position, choose from [A1-C3]")
            continue
        if board[position] != ' ':
            print("Position taken, choose another position")
            continue
        
        #Update the board with the current player's move
        board[position] = current_player
        
        #Check if the current player has won the game
        if check_for_winner(board, current_player):
            print_game_board(board)
            print(f"Player {current_player} wins!")
            break
        
        #Check if the board is full and the game will end as a tie
        if all(board[pos] != ' ' for pos in board):
            print_game_board(board)
            print("It's a tie!")
            break
        
        #Switch players
        current_player = 'O' if current_player == 'X' else 'X'

#Function to start a game
choose_position()