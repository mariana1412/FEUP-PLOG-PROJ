# PLOG 2020/2021  

## Group  

| Name             | Number    | E-Mail             |
| ---------------- | --------- | ------------------ |
| Daniel Garcia Lima Sarmento da Silva    | 201806524 |up201806524@fe.up.pt|
| Mariana Almeida Truta    | 201806543 |up201806543@fe.up.pt|

----

## [Greener](https://www.boardgamegeek.com/boardgame/226081/greener)

### Description

**Greener** is one of the three games of the **GreenGreenerGreenest** set. It is a capturing game for 2 players, where both aim to capture the same color, green.
Depending on the set, there should be:

* Basic: a 6×6 board, 15 black pyramids, 20 green pyramids, 15 white pyramids.
* Advanced: a 6×9 – 9×9 board (using one or both pads), 30 black pyramids, 45 green pyramids, 30 white pyramids.

### Setup  

First of all, it is necessary to calculate the **number of pieces** of each color: the number of black and white pyramids must be between a quarter and a third of the board cells and there must be _at least_ as many green pyramids as black/white pieces.  For example, it is recommended to use 9 black, 9 white and 18 green pieces on a 6×6 board.

Secondly, each player will have an allocated color (**black** or **white**) and will alternately place **one piece at a time** on the board. The remaining cells will be filled with **green** pyramids.

### How to play

Usually **black** starts. Players **alternate** turns during the game, moving zero or one piece at a time **orthogonally** (vertically or horizontally). They **must** capture one pyramid or stack of **any** color if possible; otherwise, they have to **pass** the turn. 	

The **game ends** when all players pass in succession. The player with the **most green pyramids** captured (being part of stacks they control) wins the game. In case of a **tie**, the player with the **highest stack** wins. If the tie persists, **play again**.

[Rules Book](https://nestorgames.com/rulebooks/GREENGREENERGREENEST_EN.pdf)

----

## Game State Representation

### **Important information**

At any point during the game, it is crucial that both players know these things:

* Whose **turn** it is;
* For each board space:
    - The **color** of the piece at the top of the stack;
    - The amount of **points** (green pieces in the stack);
    - The stack **height** (number of pieces in the stack).

We also provided the **points** both players currently have.

### **How we did it**

By calling ***play/0***, an initial board is setup (this board is a valid initial board, and was hardcoded) and shown to the players:

![initial Board](images/initial.png)

The ***play/0*** predicate, first of all, calls the ***initial(-GameState)*** predicate, generating the board (a 3d list) that we can see in the image above. Then, it initializes de Player list, composed of two sublists, each with the number of player (**0 for Black**, **1 for White**) and the correspondent current points. This list maintains the next Player as its **head**.

After initializing the game components, the ***play/0*** predicate calls two display predicates, before calling the ***gameLoop*** predicate. These predicates are:

1. ***printPlayersPoints(Player)***, which takes the Player List and prints what can be seen above the board in the image.
2. ***display_game(+GameState, +Player)***, which takes the board initialized previously and the Player list.

#### **Displaying the board**

The ***display_game(+GameState, +Player)*** calls the ***printBoard(GameState, N, Player)*** (in [display.pl](display.pl)) which takes the **Board** (GameState), the **board size** (we are using 6x6) and the **color** of the next player, and calls subsequent recursive predicates in order to produce the result seen in the images. It starts by displaying the **header** (with an accompanying key, to interpret the board cells), and continues by displaying, **line by line**, each cell.

The cells contain the information that we enumerated earlier, in order:

* the color of the top piece (0 for empty, 1 for green, 2 for black and 3 for white). The letter for the colour is obtained from the ***code/2*** predicate.
* the amount of points;
* the stack height.

If we are printing the first board line, we use the ***printInfo/2*** predicate in order to also print the turn information on its side.

A middle and final look to the board isn't that much different from the initial board aspect, but we do have to solve the double digit points/stack height problem that arises from our display method:

![mid](images/mid.png)

![final](images/final.png)

**NOTE**: At this time, the game doesn't have a game over, it has to be **manually** stopped. Move's validation is not complete.
