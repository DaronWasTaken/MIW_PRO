import numpy as np
import matplotlib.pyplot as plt

# 0 - rock, 1 - paper, 2 - scissors
states = [0, 1, 2]

winning_oponents = {
    0: 1,   # rock < paper
    1: 2,   # paper < scissors
    2: 0    # scissors < rock
}

# Fill the 3x3 transition matrix with equal probabilities
transition_matrix = np.full((3, 3), 1)

# Set the payout rates for each scenario in a matrix
payouts = np.array([[0, -1, 1],
                    [1, 0, -1],
                    [-1, 1, 0]])

# Initialize a list containing current points for each round - it starts with 0
point_balance = [0]

# Set the amount of games to be played
num_games = 50

# Set the learning rate for the most recent outcomes (0-1)
learning_rate = 1

# prev_state is the last choice made by the opponent
prev_state = np.random.choice(states)

# rock => paper => scissors opponent pattern
computer_state = np.random.choice(states)

for i in range(num_games):

    # rock => paper => scissors opponent pattern
    computer_state += 1
    if (computer_state > 2):
        computer_state = 0

    # Equally probable choice for the opponent
    # computer_state = np.random.choice(states)

    # Choosing between 3 states with probabilities depending on the previous move of the oponent (prev_state)
    current_state = np.random.choice(states, p=(
        transition_matrix[prev_state] / transition_matrix[prev_state].sum(axis=0, keepdims=1)))

    # Choosing the payout from the payout matrix and adding it to the lists
    payout = payouts[winning_oponents[current_state], computer_state]
    point_balance.append(point_balance[-1] + payout)

    # Increasing the probability for certain state by value of learning_rate
    transition_matrix[states.index(prev_state), states.index(
        computer_state)] += learning_rate

    # Updating the prev_state at the end of the loop
    prev_state = computer_state

plt.plot(range(num_games + 1), point_balance)
plt.xlabel('Round')
plt.ylabel('Points')
plt.show()
