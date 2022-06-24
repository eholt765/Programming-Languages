grammar csce322h0mework01part01;

// rules
mazeGame : .* EOF{System.out.println("End the File");};


// tokens
SECTIONBEGIN : '<section>' {System.out.println("Begin the Section");};
SECTIONEND : '</section>' {System.out.println("End the Section");};
SECTIONTITLEA : ('moves') {System.out.println(getText() + " Section");};
SECTIONTITLEB : ('maze') {System.out.println("game Section");};
ROWEND : '<gr>' {System.out.println("End the Row");};
MAZEBEG : '<grid>' {System.out.println("Start the Game");};
MAZEEND : '</grid>' {System.out.println("End the Game");};
LISTBEG : '<list>' {System.out.println("Begin the List");};
LISTEND : '</list>' {System.out.println("End the List");};
MOVESYM : ('u' | 'd' | 'l' | 'r') {System.out.println("Move: " + getText());};
MAZESYMA : ('x' | [0-9]+) {System.out.println("Space: " + getText());};
MAZESYMB : ('-') {System.out.println("Space: Empty");}; 
WS : [ \t\r\n]+ -> skip;
PIPE : '|' ;
OTHER : . {System.out.println("An invalid symbol was seen on Line " + getLine()+"."); System.exit(0);};
