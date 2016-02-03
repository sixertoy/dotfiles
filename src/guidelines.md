# Wemap Guidelines for JavaScript [ES5](http://es5.github.io)

[I. Philosophy](#philoshophy)
[II. References](#references)
[III. Good Practices](#good_practices)

## I. Philosophy

> "All code in any code-base should look like a single person typed it.<br>No matter how many people contributed."<br><br>[*IdiomaticJS*](https://github.com/rwaldron/idiomatic.js/)

## II. References

- [**Google Styles Guide** - Google](https://google.github.io/styleguide/javascriptguide.xml)
- [**Douglas Crockford Code Conventions** - Creator of JSON Format](http://javascript.crockford.com/code.html)
- [**JSHint Reference** - Over 31.000.000 downloads via NPM in two years](jshint.com/docs/options/)
- [**IdiomaticJS** - A large community of contributors](https://github.com/rwaldron/idiomatic.js)
- [**Airbnb ES5 Guide**](https://github.com/airbnb/javascript/tree/master/es5)

## III. Good Practices

[1. Naming Conventions](#naming_conventions)
[2. Formatting](#formatting)
[3. Comments](#comments)
[4. Declarations](#declarations)
[5. Manipulate Types](#manipulate)
[6. JSHint](#jshint)
[7. Miscellaneous](#miscellaneous)

----------

<a name="naming_conventions"></a>
### 1. Naming Conventions

[1.1 Reserved Word](#naming_reserved)
[1.2 Variables](#naming_variables)
[1.3 Class](#naming_class)
[1.4 Constants](#naming_contants)

<a name="naming_reserved"></a>
#### 1.1 Reserved Words

- All variables, properties, class names **should be descriptive**, human readable
- **Don't use [reserved words](http://es5.github.io/#x7.6.1) as keys.**<br>It can cause issues in some browsers

*Good*
```javascript
var superman = {
  defaults: {clark: 'kent'},
  hidden: true
};
```

*Bad*
```javascript
var superman = {
  default: {clark: 'kent'},
  private: true
};
```

<a name="naming_variables"></a>
#### 1.2 Variables, Properties & Functions

- **Single character variables and uncommon abbreviations should be avoided.**
- Use lowerCamelCase
- Use a leading underscore ```_``` when naming private properties.

*Good*
```javascript
var myVar = 'a value';
```

*Bad*
```javascript
var y = 'a value';
var yx = {x: 0, y: 0};
var my_var = 'a value';
var cowabunga = 'a value';
var somethingShouldPropablyEqualToSomething = 'you\'ve got to understand';
```

<a name="naming_class"></a>
#### 1.3 Class Names

- Use CamelCase

*Good*
```javascript
function MyClass() {}
```

*Bad*
```javascript
function my_Class() {}
```

<a name="naming_contants"></a>
#### 1.4 Constants

- Use UpperCase with SnakeCase

*Good*
```javascript
var MY_SINGLETON_CONSTANT_VAR = 'a value';
function MyClass() {}
MyClass.MY_SINGLETON_CONSTANT_VAR;
```

*Bad*
```javascript
var mySingletonConstantVar = 'a value';
function MyClass() {}
MyClass.mySingletonConstantVar;
```

----------

<a name="formatting"></a>
### 2. Formatting

[2.1 Encoding](#format_encoding)
[2.2 Whitespace](#format_whitespace)
[2.3 Indentation](#format_indentation)
[2.4 Quotes](#format_quotes)
[2.5 Newlines](#format_newlines)
[2.6 Curly](#format_curly)

<a name="format_encoding"></a>
#### 2.1 Encoding

- Make sure your editor uses UTF-8 as character encoding, without a byte order mark.
- Usage of BOM UTF-8 can cause problems in [internationalization](https://www.w3.org/International/questions/qa-byte-order-mark.en.php#problems)

<a name="format_whitespace"></a>
#### 2.2 Whitespace

> "...Deviations from literary style should only be tolerated<br>if there is strong evidence of a significant benefit."<br><br>*Douglas Crockford*

- Clean up any trailing whitespace in your JS files before committing.
- **Blank lines** improve readability by setting off sections of code that are logically related.
- **Blank spaces** should always be used in the following circumstances:
    - A keyword followed by ```(``` should be separated by a space.<br>*ex:* ```while (true) {```<br>*ex:* ```
if (true) {...} else if (false) {...}```
    - The word function is always followed with one space.<br>*ex:* ```var myFunc = function () {}```
    - A blank space should not be used between a function value and its invoking ```(```. This helps to distinguish between keywords and function invocations.<br>*ex:* ```function (param) {}```
    - If a function literal is anonymous, there should be one space between the word function and the ```(```. If the space is omitted, then it can appear that the function's name is function, which is an incorrect reading.
    - There should be one space between the ```)``` and the ```{``` left curly brace that begins the statement body.<br>*ex:* ```function myFunction(a, b) {```
    - Each ```;``` semicolon at the end of a statement should be followed with a line break.
    - Each ```;``` semicolon in the control part of a for statement should be followed with a space.
    ```javascript
    var i;
    for (i = 0; i < 10; i++) {
        ...
    }
    ```
    - Every ```,``` comma should be followed by a space when it's inline.<br>*ex:* ```var object = {prop1: 'value', prop2: 'a value'};```
    - Every ```,``` comma should be followed by a line break it's on block style.
    ```javascript
    var object = {
        prop1: 'value',
        prop2: 'a value'
    };
    ```
    - Every ```:```colon must be followed by a space
	- Set off operators with spaces.
```javascript
var x = 7 + 9;
```

<a name="format_indentation"></a>
#### 2.3 Indentation

> Tabs and spaces should not be mixed. We should pick just one in order to avoid the problems that come from having both. Personal preference is an extremely unreliable criteria.<br>Neither the tab nor the space offers a powerful advantage over the other. Fifty years ago, tab had the advantage of consuming less memory, but [Moore's Law](https://en.wikipedia.org/wiki/Moore%27s_law) has eliminated that advantage.<br>**Space has one clear advantage over tab:** there is still no reliable standard for how many spaces a tab represents, but it is universally accepted that a space occupies a space. So always use spaces. You can edit with tabs if you must, but make sure it is spaces again before you commit.<br>Maybe someday we will finally get a universal standard for tabs, but until that day comes, the better choice is spaces.<br><br>*Douglas Crockford*


- 4 Spaces indentations for a tab and 120 characters max per lines for readability on large screen (desktop)
- 2 Space indentations for a tab and 80 characters max per lines for readability on small screen (laptop)
- Avoid excessively long lines<br>
*Good*
```javascript
var leds = stage.selectAll('.led')
    .data(data)
  .enter().append('svg:svg')
    .classed('led', true)
    .attr('width', (radius + margin) * 2)
  .append('svg:g')
    .call(tron.led);
```

*Bad*
```javascript
var leds = stage.selectAll('.led').data(data).enter().append('svg:svg').classed('led', true).attr('width', (radius + margin) * 2).append('svg:g').call(tron.led);
```
- If ```.``` period is the first character on a line, the indentation is increased by 4/2 spaces.
- Every statement should begin aligned with the current indentation.<br>The outermost level is at the left margin. The indentation increases by 4/2 spaces when the last token on the previous line is ```{```, ```[```, ```(```. The matching closing token will be the first token on a line, restoring the previous indentation.
- Clauses ```case, catch, default, else, finally``` are not statements and so should not be indented like statements.
```javascript
switch (value) {
case 'a string':
    break;
case 'another string':
    break;
default:
    break;
}
```

- The ternary operator can be visually confusing, so ```?``` always begins a line and increase the indentation by 4 spaces, and ```:``` always begins a line, aligned with the ```?``` question mark.

*Good*
```javascript
var isvalid = ('toto' === 'a string')
    ? true
    : false;
isvalid = (typeof value === 'string')
	? true
	: false;
```

*Bad*
```javascript
var value,
    isvalid = (value === 'a string') ? true : (typeof value === 'string') ? true : false;
```

<a name="format_quotes"></a>
#### 2.4 Single & Double Quotes

- Use single quotes for strings, except for a JSON format<br>
- This is helpful when creating strings that include HTML:

*Good*
```javascript
var myString = 'a value';
```

*Bad*
```javascript
var myString = "a value";
```

<a name="format_newslines"></a>
#### 2.5 Newlines

- Use UNIX-style newlines (\n), and a newline character as the last character of a file. Windows-style newlines (\r\n) are forbidden inside any repository.
- End files with a single newline character.

<a name="format_curly"></a>
#### 2.6 Curly

- **Always put braces around blocks**

*Good*
```javascript
while (true) {
    return 'this is not bad';
}
```

*Bad*
```javascript
while (true)
    return 'this is bad';

while(true) return 'this is bad';
```

----------

<a name="comments"></a>
### 3. Comments

> Generally use line comments. Save block comments for formal documentation.<br>Be generous with comments. It is useful to leave information that will be read at a later time by people (possibly your future self) who will need to understand what you have done and why

<a name="comments_variables"></a>
#### 3.1 Variables (inline)

> Inline comment which describes a variable
```javascript
// this variable is used to decribe
// a good usage of comment for a variable
// it can be multiline
var myVariables = 'on top comment';
```

<a name="comments_functions"></a>
#### 3.2 Functions (block)

> Inline comment which describes on option on a variable
```javascript
/**
 *
 * This is a right type of comment
 * for functions
 * ...
 *
 */
function (){
...
```

<a name="comments_blocks"></a>
#### 3.3 Block Comments Options

- Block comments options must be lowercase
- **@todo**: Document tasks to be completed.
- **@see**: Refer to some other documentation for more information, internal/external Link
- **@param**: Document the parameter to a function:
	- *[ParamType] paramName (paramDescription)*
- **@return**: Document the return to a function
	- *[ParamType] paramName (paramDescription)*

[More block tags on Block Tags JSDoc Reference](http://usejsdoc.org)

In Javadoc/JSdoc style
```javascript
/**
 *
 * A long description for this function
 * can be multiline
 * for more readability
 *
 * @see http://usejsdoc.org
 *
 * @param [String] param1 (description)
 * @param [Object] param2 (description)
 * @return Boolean
 *
 */
function (param1, param2) {
	return true;
}
```

----------

<a name="declarations"></a>
### 4. Declarations

[4.1 Object / Array / String](#declarations_array)

<a name="declarations_array"></a>
#### 4.1 Object / Array / String creation

- Do not use type constructor
- Use arrays when the member names would be sequential integers. Use objects when the member names are arbitrary strings or names.

*Good*
```javascript
var obj = {},
	arr = [],
	str = '';
```

*Bad*
```javascript
var obj = new Object(),
	arr = new Array(),
	str = new String();
```

<a name="declarations_pluses"></a>
#### 4.2 Confusing Pluses and Minuses

- Be careful to not follow a ```+``` with ```+``` or ```++```. This pattern can be confusing. Insert ```()``` between them to make your intention clear.

*Good*
```javascript
var total = subtotal + (+myInput.value);
```

*Bad*
```javascript
var total = subtotal + +myInput.value;
```

<a name="declarations_variables"></a>
#### 4.3 Variables

- All variables should be declared before used
- Implied global variables should never be used.
- Use of global variables should be minimized.
- The ```var``` statement should be the first statement in the function body.
- A JavaScript ```var``` does not have block scope, so defining variables in blocks can confuse programmers who are experienced with other C family languages. **Define all variables at the top of the function.**
- Variables must be group at the beginning of a block. Use ```,```comma notation, and indent with 4/2 spaces.
- Use one var declaration per variable. It's easier to add new variable declarations this way, and you never have to worry about swapping out a ```;``` for a ```,``` or introducing punctuation-only diffs.

*Good*

```javascript
(function(){

    'use strict';

    var CONSTANT_1 = 'a string',
        CONSTANT_2 = true,
        CONSTANT_3 = 12345,

		/**
		 *
		 * Constructor
		 */
        MyClass = function ()  {
            this.publicVar = 'a prop';
        }

        MyClass.prototype.aFunction = function () {
            var i,
                valid = false;
            for (i = 0; i < 10; i++) {
                valid = (i === 9);
                ...
            }
        };

}());
```

*Bad*

```javascript
(function(){

    'use strict';

    var CONSTANT_1 = 'a string';
    var CONSTANT_2 = true;
    var CONSTANT_3 = 12345;

        MyClass = function(){
            this.publicVar = 'a prop';
        }

        MyClass.prototype.aFunction = function () {
            for (var i = 0; i < 10; i++) {
                var valid = i === 9;
                ...
            }
        };

}());
```

<a name="declarations_functions"></a>
#### 4.4 Functions

- Use of global functions should be minimized.
- **Never declare a function in a non-function block (if, while, etc). Assign the function to a variable instead. Browsers will allow you to do it, but they all interpret it differently, which is bad news bears.**
- Keep your functions short. A good function fits on a slide that the people in the last row of a big room can comfortably read. So don't count on them having perfect vision and limit yourself to ~15 lines of code per function.
- **Return early from functions.** To avoid deep nesting of if-statements, always return a function's value as early as possible.
- ECMA-262 defines a block as a list of statements. A function declaration is not a statement.
- **All functions should be declared before they are used. **
- Inner functions should follow the var statement. This helps make it clear what variables are included in its scope.
- If a function literal is anonymous, there should be one space between the word function and the ```(```. If the space is omitted, then it can appear that the function's name is function, which is an incorrect reading.
- There should be no space between the name of a function and the ```(``` of its parameter list. There should be one space between the ```)``` and the ```{``` that begins the statement body. The body itself is indented four spaces. The ```}``` is aligned with the line containing the beginning of the declaration of the function.
- When a function is to be invoked immediately, the entire invocation expression should be wrapped in parens so that it is clear that the value being produced is the result of the function and not the function itself.
- Methods can return this to help with method chaining

*Good*
```javascript
var MyConstructor = function () {
	myMethod1: function () {
	}
	myMethod2: function () {
	}
};

MyConstructor.prototype.myFunction = function () {
};

var isAnonFunc = function (param) {
};

function notAnonFunc(param) {
}

var collection = (function () {
	var keys = [],
		values = [];
    return {
	    get: function (key) {
	    },
	    set: function (key, value) {
	    }
    };
}());
```

<a name="declarations_closures"></a>
#### 4.5 Closures

- Name your closures. Feel free to give your closures a name. It shows that you care about them, and will produce better stack traces, heap and cpu profiles.
- No nested closures. Use closures, but don't nest them. Otherwise your code will become a mess.

*Good*
```javascript
// named
req.on('end', function onEnd() {
	console.log('winning');
});

// nested
setTimeout(function() {
  client.connect(afterConnect);
}, 1000);

function afterConnect() {
  console.log('winning');
}
```

*Bad*
```javascript
// no named
req.on('end', function() {
	console.log('losing');
});

// nested
setTimeout(function() {
  client.connect(function() {
    console.log('losing');
  });
}, 1000);
```

<a name="declarations_class"></a>
#### 4.9 Class

- **Use immediately-Invoked Function Expression (IIFE).** Even each file executes in its own module scope, it will be safer in a team work to adopt the safer way to develop. Work with global variables.
- When saving a reference to ```this``` use ```self```

```javascript
(function(){
	'use strict';
	var MyClass = function(){
	};
	module.exports = MyClass;
}());
```

<a name="declarations_strings"></a>
#### 4.7 Strings

- **If overused, long strings with concatenation could impact performance.**
- **Strings longer than 100 characters should be written across multiple lines using string concatenation.**
- When programmatically building up a string, use Array#join instead of string concatenation. Mostly for IE

*Good*
```javascript
var errorMessage = 'This is a super long error that was thrown because ' +
  'of Batman. When you stop to think about how Batman had anything to do ' +
  'with this, you would get nowhere fast.';
```

*Bad*
```javascript
var errorMessage = 'This is a super long error that was thrown because of Batman. When you stop to think about how Batman had anything to do with this, you would get nowhere fast.';

var errorMessage = 'This is a super long error that was thrown because \
of Batman. When you stop to think about how Batman had anything to do \
with this, you would get nowhere \
fast.';
```

<a name="declarations_properties"></a>
#### 4.8 Properties

- Use dot notation when accessing properties.
- Use subscript notation ```[]``` when accessing properties with a variable.

*Good*
```javascript
var isJedi = luke.jedi;

var type = 'jedi',
	isJedi = luke[type];
```

*Bad*
```javascript
var isJedi = luke['jedi'];
```

<a name="declarations_operators"></a>
#### 4.9 Comparison Operators & Equality

- Use === and !== over == and !=
- Conditional statements such as the if statement evaluate their expression using coercion with the ToBoolean abstract method and always follow these simple rules:
	- Objects evaluate to true
	- Undefined evaluates to false
	- Null evaluates to false
	- Booleans evaluate to the value of the boolean
	- Numbers evaluate to false if +0, -0, or NaN, otherwise true
	- Strings evaluate to false if an empty string '', otherwise true
- Use shortcuts

*Good*
```javascript
if (collection.length) {
}
if (name) {
}
```

*Bad*
```javascript
if (collection.length > 0) {
}
if (name == '') {
}
```

[Truth, Equality and JavaScript](javascriptweblog.wordpress.com/2011/02/07/truth-equality-and-javascript)

<a name="declarations_arguments"></a>
#### 4.10 Arguments

- Never name a parameter arguments. This will take precedence over the arguments object that is given to every function scope.

*Good*
```javascript
function yup (name, options, args) {
}
```

*Bad*
```javascript
function nope (name, options, arguments) {
}
```

<a name="declarations_try"></a>
#### 4.11 Try, Catch & Finally

```javascript
try {
} catch (variable) {
} finally {
}
```

#### 4.12 Events

- When attaching data payloads to events (whether DOM events or something more proprietary like Backbone events), pass a hash instead of a raw value. This allows a subsequent contributor to add more data to the event payload without finding and updating every handler for the event.

*Good*
```javascript
$(this).trigger('listingUpdated', listing.id);
```

*Bad*
```javascript
$(this).trigger('listingUpdated', { listingId : listing.id });
```

----------

<a name="manipulate"></a>
### 5.  Manipulate Types / Bitwise

- **Bitwise ```~``` ```^``` ```<<``` ```>>``` operators are fastest but not comprehensive by all. Comment it as possible when it used**

[5.1 Array](#manipulate_array)
[5.2 String](#manipulate_string)
[5.3 Boolean](#manipulate_boolean)
[5.4 Arguments](#manipulate_arguments)

<a name="manipulate_array"></a>
#### 5.1 Array

- Use Array.push instead of direct assignment to add items to an array.
- When you need to copy an array use Array.slice (clone)

*Good*
```javascript
var itemsCopy,
	someStack = [];
someStack.push('abracadabra');

itemsCopy = someStack.slice();
```

*Bad*
```javascript
var someStack = [];
someStack[someStack.length] = 'abracadabra';

var i,
	itemsCopy = [],
	len = someStack.length;
for (i = 0; i < len; i++) {
  itemsCopy[i] = someStack[i];
}
```

<a name="manipulate_string"></a>
#### 5.2 String

- Perform type coercion at the beginning of the statement.
- Use parseInt for Numbers and always with a radix for type casting.
- If for whatever reason you are doing something wild and parseInt is your bottleneck and need to use Bitshift for performance reasons, leave a comment explaining why and what you're doing.
- [Javascript Casting](http://jsperf.com/coercion-vs-casting/3)

*Good*
```javascript
var totalScore = 9 + '';

var val1 = Number(inputValue),
	val2 = parseInt(inputValue, 10),
	// parseInt was the reason my code was slow
	// Bitshifting the String to coerce it to a
	// Number made it a lot faster
	val3 = inputValue >> 0;
```

*Bad*
```javascript
var totalScore = '' + 9;

var val1 = new Number(inputValue),
	val2 = +inputValue,
	val3 = inputValue >> 0,
	val4 = parseInt(inputValue);
```

<a name="manipulate_boolean"></a>
#### 5.3 Boolean

*Good*
```javascript
var hasAge1 = Boolean(age),
	hasAge2 = !!age;
```

*Bad*
```javascript
var hasAge = new Boolean(age);
```

<a name="manipulate_arguments"></a>
#### 5.4 Arguments

- Use snippet below to convert object like argument to array

```javascript
function trigger() {
  var args = Array.prototype.slice.call(arguments);
  ...
}
```

----------

<a name="jshint"></a>
### 6. JSHint

----------

<a name="miscellaneous"></a>
### 7. Miscellaneous

- Use Strict Mode. It will helps you to debug ad apply this rules
```javascript
(function(){
	'use strict';
}());
```
- **Requires At Top.** Always put requires at top of file to clearly illustrate a file's dependencies. Besides giving an overview for others at a quick glance of dependencies and possible memory impact, it allows one to determine if they need a package.json file should they choose to use the file elsewhere.
- **Do not use setters**, they cause more problems for people who try to use your software than they can solve.
- Feel free to use getters that are free from side effects, like providing a length property for a collection class.
- ```eval``` is Evil
- Avoid use of the ```continue``` statement. It tends to obscure the control flow of the function.
- The ```with``` statement [should not be used](http://yuiblog.com/blog/2006/06/01/global-domination/).
- **Do not extend the prototype of native JavaScript objects. Your future self will be forever grateful.**
- Remove additional trailing comma
```javascript
var arr = [
	'a value',
	'a string',
];
```
- Leading commas are tolerated in preprocessor configuration files
