angular.module('t9', [])
	.controller('phoneController', ['$scope', function($scope){

		//the characters on the keypad
		$scope.keypadCharacters = [1, 2, 3, 4, 5, 6, 7, 8, 9, '*', 0, '#'];

		//the number sequence being typed in
		$scope.numberSequence = '';

		//possible words that the number sequence could be
		$scope.possibleWords = [];

		//event handler for keypad press
		$scope.onKeyPadPress = function(keypadCharacter) {

			if (keypadCharacter !== 0
				&& keypadCharacter !== 1
				&& keypadCharacter !== '*'
				&& keypadCharacter !== '#') {

				//concatenate the character that was typed
				$scope.numberSequence = $scope.numberSequence + keypadCharacter;

				//get the possible words
				var words = getPossibleWords(parseInt($scope.numberSequence));

				$scope.possibleWords = words;
			}

		};
	}]);

/* T9 word function */

var getPossibleWords = (function () {

	//a dictionary to store characters corresponding to keypad digit
	var numberLookup = {
		0 : [],
		1 : [],
		2 : [ 'a', 'b', 'c' ],
		3 : [ 'd', 'e', 'f' ],
		4 : [ 'g', 'h', 'i' ],
		5 : [ 'j', 'k', 'l' ],
		6 : [ 'm', 'n', 'o' ],
		7 : [ 'p', 'q', 'r', 's' ],
		8 : [ 't', 'u', 'v' ],
		9 : [ 'w', 'x', 'y', 'z' ]
	};

	//a dictionary to store the results of memoized function calls
	var memo = {};

	//define memoized function
	var getPossibleWordsMemoized = function(numberSequence) {

		numberSequence = parseInt(numberSequence);

		if (nLength(numberSequence) == 1) {

			return numberLookup[numberSequence];

		}

		else {

			//try to retrieve the word list from cache
			var wordList = memo[numberSequence];

			if (typeof wordList !== 'object') {

				//if word list isn't found, try to retrieve the word list for the number sequence corresponding to the previous key press.
				//get the number sequence corresponding to the previous key press by truncating the last number of numberSequence.
				var prevNumberSequence = Math.floor(numberSequence / 10);

				//get word list for previous key press
				wordList = getPossibleWordsMemoized(prevNumberSequence);

				//for each word in list, append characters corresponding to last digit of number sequence to get final word list.
				//first, get last digit of number sequence, then concatenate each word in list with each character corresponding to last digit.
				var lastDigit = numberSequence - Math.floor(numberSequence / 10) * 10;

				wordList = wordList.map(function(word) {
					return numberLookup[lastDigit].map(function(character) {
						return word + character;
					});
				}).reduce(function(a, b) {
					return a.concat(b);
				});

				//cache the wordlist
				memo[numberSequence] = wordList;
			}

			return wordList;
		}
	}

	return getPossibleWordsMemoized;
}( ));

//calculates length of digit n

// @param int the digit to get the length of
var nLength = function(n) { 
	return (Math.log(Math.abs(n + 1)) * 0.43429448190325176 | 0) + 1;
}