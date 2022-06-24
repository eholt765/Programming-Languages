grammar csce322h0mework01part02;

@members {
	int playerCount = 0;
	int emptySymCount = 0;
	int allSymCount = 0;
	int rowLength = 9;
	int colCount = 1;
	boolean validSemantics = true;
	boolean uPresnt = false;
	boolean rPresnt = false;
	boolean lPresnt = false;
	boolean dPresnt = false;

}

// tokens
SECTIONBEGIN : '<section>';
SECTIONEND : '</section>';
SECTIONTITLE : ('moves' | 'maze');
ROWEND : '<gr>';
MAZEBEG : '<grid>';
MAZEEND : '</grid>';
LISTBEG : '<list>';
LISTEND : '</list>';
MOVESYM : ('u' | 'd' | 'l' | 'r');
MAZESYM : ('-' | 'x' | [0-9]+);
WS : [ \t\r\n]+ -> skip;
PIPE : '|' ;
OTHER : . ;

// rules
mazeGame : (((moves maze) | (maze moves)) semantics) EOF;

sectionStart : SECTIONTITLE SECTIONBEGIN;

sectionEnd : (MAZEEND | LISTEND) SECTIONEND;

moves : sectionStart LISTBEG movesList sectionEnd;

movesList : (movesChar PIPE movesChar PIPE movesChar PIPE movesChar PIPE movesChar (PIPE movesChar)*);

movesChar : MOVESYM {
		if ($MOVESYM.text.equals("u")) {
			uPresnt = true;
		}
		if ($MOVESYM.text.equals("l")) {
			lPresnt = true;
		}
		if ($MOVESYM.text.equals("r")) {
			rPresnt = true;
		}
		if ($MOVESYM.text.equals("d")) {
			dPresnt = true;
		}
	};


maze : sectionStart MAZEBEG mazeColumn {colCount == rowLength || colCount >= 10}? sectionEnd;

mazeColumn : mazeLayoutStart (mazeLayout {colCount++;})*;

mazeLayoutStart : ((mazeChar mazeChar mazeChar mazeChar mazeChar mazeChar mazeChar mazeChar mazeChar (mazeChar+{rowLength++;}) ROWEND*));			

mazeLayout : ((mazeChar mazeChar mazeChar mazeChar mazeChar mazeChar mazeChar mazeChar mazeChar mazeChar+ ROWEND*));
			
mazeChar : MAZESYM { allSymCount++;
			if ($MAZESYM.text.equals("-")) {
				emptySymCount++;	
			}
			if (!$MAZESYM.text.equals("x") && !$MAZESYM.text.equals("-")) {
				playerCount++;
			}
			};
	
semantics : {
	if (playerCount < 2 | playerCount > 4) {
		System.out.println("SEMANTIC ERROR 1");
		validSemantics = false;
	}
	if ((emptySymCount / allSymCount) > 0.6) {
		System.out.println("SEMANTIC ERROR 2");
		validSemantics = false;		
	}
	if (dPresnt != true || lPresnt != true || uPresnt != true || rPresnt != true) {
		System.out.println("SEMANTIC ERROR 3");
		validSemantics = false;
	}
	if (validSemantics == true) {
		System.out.println("There are " + emptySymCount + " empty spaces in the maze.");	
	}
};




