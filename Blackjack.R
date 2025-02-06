#### Preliminaries ####
#Clear Environment
rm(list = ls())
if(!is.null(dev.list())) dev.off()
cat("\014")

#### Create a Deck of Cards ####
#Define Suits and Cards
Suits <- c("Diamonds", "Clubs", "Hearts", "Spades")
SuitSymbols <- c("♦", "♣", "♥", "♠")
Cards <- c("Ace", 2:10, "Jack", "Queen", "King")

#Map suits to their respective symbols
SuitMap <- setNames(SuitSymbols, Suits)

#Create the Deck using expand.grid()
Deck <- expand.grid(Cards = Cards, Suits = Suits)  #Compute all possible combinations of cards and suits
Deck$SuitSymbol <- SuitMap[Deck$Suits]  #Assign symbols to the deck
Deck$CardDisplay <- paste(Deck$Cards, "of", Deck$SuitSymbol)  #Format the card names

#Assign Card Values
Deck$Value <- ifelse(Deck$Cards %in% c("Jack", "Queen", "King"), 10, 
                     ifelse(Deck$Cards == "Ace", 11, as.numeric(Deck$Cards)))

#Shuffle the Deck
Deck <- Deck[sample(nrow(Deck)), ]

#### Function to Draw a Card ####
draw_card <- function(deck) {
  card <- deck[1, ]  #Take the top card
  deck <- deck[-1, ] #Remove from deck
  return(list(card = card, deck = deck))
}

#### Function to Calculate Hand Value ####
calculate_hand_value <- function(hand) {
  total <- sum(hand$Value)
  
  #Adjust Aces if necessary
  num_aces <- sum(hand$Cards == "Ace")
  while (total > 21 & num_aces > 0) {
    total <- total - 10  #Convert one Ace from 11 to 1
    num_aces <- num_aces - 1
  }
  
  return(total)
}

#### Game Setup ####
#Deal Initial Cards
game_deck <- Deck  #Copy deck to use in the game
player_hand <- data.frame()
dealer_hand <- data.frame()

#Draw Two Cards for Player
for (i in 1:2) {
  draw <- draw_card(game_deck)
  player_hand <- rbind(player_hand, draw$card)
  game_deck <- draw$deck
}

#Draw Two Cards for Dealer
for (i in 1:2) {
  draw <- draw_card(game_deck)
  dealer_hand <- rbind(dealer_hand, draw$card)
  game_deck <- draw$deck
}

#### Show Initial Hands ####
cat("\nDealer's Hand: ", dealer_hand$CardDisplay[1], " (Hidden Card)\n")
cat("Player's Hand: ", paste(player_hand$CardDisplay, collapse = ", "), "\n")

#### Player Turn ####
while (TRUE) {
  #Show current hand value
  player_total <- calculate_hand_value(player_hand)
  cat("Your current hand value is:", player_total, "\n")
  
  #Check for Blackjack or Bust
  if (player_total == 21) {
    cat("Blackjack! You win!\n")
    break
  } else if (player_total > 21) {
    cat("You busted! Dealer wins.\n")
    break
  }
  
  #Ask player for action
  action <- readline("Do you want to Hit or Stand? (h/s): ")
  
  if (tolower(action) == "h") {
    draw <- draw_card(game_deck)
    player_hand <- rbind(player_hand, draw$card)
    game_deck <- draw$deck
    cat("You drew:", draw$card$CardDisplay, "\n")
  } else if (tolower(action) == "s") {
    cat("You chose to Stand.\n")
    break
  } else {
    cat("Invalid input. Please enter 'h' to Hit or 's' to Stand.\n")
  }
}

#### Dealer Turn ####
dealer_total <- calculate_hand_value(dealer_hand)
cat("\nDealer's Hand: ", paste(dealer_hand$CardDisplay, collapse = ", "), "\n")

while (dealer_total < 17) {
  cat("Dealer hits...\n")
  draw <- draw_card(game_deck)
  dealer_hand <- rbind(dealer_hand, draw$card)
  game_deck <- draw$deck
  dealer_total <- calculate_hand_value(dealer_hand)
  cat("Dealer's new hand: ", paste(dealer_hand$Cards, collapse = ", "), "\n")
}

#### Determine Winner ####
cat("\nFinal Hands:\n")
cat("Player's Hand: ", paste(player_hand$CardDisplay, collapse = ", "), "- Total:", player_total, "\n")
cat("Dealer's Hand: ", paste(dealer_hand$CardDisplay, collapse = ", "), "- Total:", dealer_total, "\n")

if (player_total > 21) {
  cat("You busted! Dealer wins.\n")
} else if (dealer_total > 21) {
  cat("Dealer busted! You win!\n")
} else if (player_total > dealer_total) {
  cat("You win!\n")
} else if (player_total < dealer_total) {
  cat("Dealer wins!\n")
} else {
  cat("It's a tie!\n")
}