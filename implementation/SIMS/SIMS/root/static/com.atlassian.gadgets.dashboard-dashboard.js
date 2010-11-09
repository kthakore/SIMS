/*
    http://www.JSON.org/json2.js
    2008-11-19

    Public Domain.

    NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.

    See http://www.JSON.org/js.html

    This file creates a global JSON object containing two methods: stringify
    and parse.

        JSON.stringify(value, replacer, space)
            value       any JavaScript value, usually an object or array.

            replacer    an optional parameter that determines how object
                        values are stringified for objects. It can be a
                        function or an array of strings.

            space       an optional parameter that specifies the indentation
                        of nested structures. If it is omitted, the text will
                        be packed without extra whitespace. If it is a number,
                        it will specify the number of spaces to indent at each
                        level. If it is a string (such as '\t' or '&nbsp;'),
                        it contains the characters used to indent at each level.

            This method produces a JSON text from a JavaScript value.

            When an object value is found, if the object contains a toJSON
            method, its toJSON method will be called and the result will be
            stringified. A toJSON method does not serialize: it returns the
            value represented by the name/value pair that should be serialized,
            or undefined if nothing should be serialized. The toJSON method
            will be passed the key associated with the value, and this will be
            bound to the object holding the key.

            For example, this would serialize Dates as ISO strings.

                Date.prototype.toJSON = function (key) {
                    function f(n) {
                        // Format integers to have at least two digits.
                        return n < 10 ? '0' + n : n;
                    }

                    return this.getUTCFullYear()   + '-' +
                         f(this.getUTCMonth() + 1) + '-' +
                         f(this.getUTCDate())      + 'T' +
                         f(this.getUTCHours())     + ':' +
                         f(this.getUTCMinutes())   + ':' +
                         f(this.getUTCSeconds())   + 'Z';
                };

            You can provide an optional replacer method. It will be passed the
            key and value of each member, with this bound to the containing
            object. The value that is returned from your method will be
            serialized. If your method returns undefined, then the member will
            be excluded from the serialization.

            If the replacer parameter is an array of strings, then it will be
            used to select the members to be serialized. It filters the results
            such that only members with keys listed in the replacer array are
            stringified.

            Values that do not have JSON representations, such as undefined or
            functions, will not be serialized. Such values in objects will be
            dropped; in arrays they will be replaced with null. You can use
            a replacer function to replace those with JSON values.
            JSON.stringify(undefined) returns undefined.

            The optional space parameter produces a stringification of the
            value that is filled with line breaks and indentation to make it
            easier to read.

            If the space parameter is a non-empty string, then that string will
            be used for indentation. If the space parameter is a number, then
            the indentation will be that many spaces.

            Example:

            text = JSON.stringify(['e', {pluribus: 'unum'}]);
            // text is '["e",{"pluribus":"unum"}]'


            text = JSON.stringify(['e', {pluribus: 'unum'}], null, '\t');
            // text is '[\n\t"e",\n\t{\n\t\t"pluribus": "unum"\n\t}\n]'

            text = JSON.stringify([new Date()], function (key, value) {
                return this[key] instanceof Date ?
                    'Date(' + this[key] + ')' : value;
            });
            // text is '["Date(---current time---)"]'


        JSON.parse(text, reviver)
            This method parses a JSON text to produce an object or array.
            It can throw a SyntaxError exception.

            The optional reviver parameter is a function that can filter and
            transform the results. It receives each of the keys and values,
            and its return value is used instead of the original value.
            If it returns what it received, then the structure is not modified.
            If it returns undefined then the member is deleted.

            Example:

            // Parse the text. Values that look like ISO date strings will
            // be converted to Date objects.

            myData = JSON.parse(text, function (key, value) {
                var a;
                if (typeof value === 'string') {
                    a =
/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}(?:\.\d*)?)Z$/.exec(value);
                    if (a) {
                        return new Date(Date.UTC(+a[1], +a[2] - 1, +a[3], +a[4],
                            +a[5], +a[6]));
                    }
                }
                return value;
            });

            myData = JSON.parse('["Date(09/09/2001)"]', function (key, value) {
                var d;
                if (typeof value === 'string' &&
                        value.slice(0, 5) === 'Date(' &&
                        value.slice(-1) === ')') {
                    d = new Date(value.slice(5, -1));
                    if (d) {
                        return d;
                    }
                }
                return value;
            });


    This is a reference implementation. You are free to copy, modify, or
    redistribute.

    This code should be minified before deployment.
    See http://javascript.crockford.com/jsmin.html

    USE YOUR OWN COPY. IT IS EXTREMELY UNWISE TO LOAD CODE FROM SERVERS YOU DO
    NOT CONTROL.
*/

/*jslint evil: true */

/*global JSON */

/*members "", "\b", "\t", "\n", "\f", "\r", "\"", JSON, "\\", apply,
    call, charCodeAt, getUTCDate, getUTCFullYear, getUTCHours,
    getUTCMinutes, getUTCMonth, getUTCSeconds, hasOwnProperty, join,
    lastIndex, length, parse, prototype, push, replace, slice, stringify,
    test, toJSON, toString, valueOf
*/

// Create a JSON object only if one does not already exist. We create the
// methods in a closure to avoid creating global variables.

if (!this.JSON) {
    JSON = {};
}
(function () {

    function f(n) {
        // Format integers to have at least two digits.
        return n < 10 ? '0' + n : n;
    }

    if (typeof Date.prototype.toJSON !== 'function') {

        Date.prototype.toJSON = function (key) {

            return this.getUTCFullYear()   + '-' +
                 f(this.getUTCMonth() + 1) + '-' +
                 f(this.getUTCDate())      + 'T' +
                 f(this.getUTCHours())     + ':' +
                 f(this.getUTCMinutes())   + ':' +
                 f(this.getUTCSeconds())   + 'Z';
        };

        String.prototype.toJSON =
        Number.prototype.toJSON =
        Boolean.prototype.toJSON = function (key) {
            return this.valueOf();
        };
    }

    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        gap,
        indent,
        meta = {    // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"' : '\\"',
            '\\': '\\\\'
        },
        rep;


    function quote(string) {

// If the string contains no control characters, no quote characters, and no
// backslash characters, then we can safely slap some quotes around it.
// Otherwise we must also replace the offending characters with safe escape
// sequences.

        escapable.lastIndex = 0;
        return escapable.test(string) ?
            '"' + string.replace(escapable, function (a) {
                var c = meta[a];
                return typeof c === 'string' ? c :
                    '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
            }) + '"' :
            '"' + string + '"';
    }


    function str(key, holder) {

// Produce a string from holder[key].

        var i,          // The loop counter.
            k,          // The member key.
            v,          // The member value.
            length,
            mind = gap,
            partial,
            value = holder[key];

// If the value has a toJSON method, call it to obtain a replacement value.

        if (value && typeof value === 'object' &&
                typeof value.toJSON === 'function') {
            value = value.toJSON(key);
        }

// If we were called with a replacer function, then call the replacer to
// obtain a replacement value.

        if (typeof rep === 'function') {
            value = rep.call(holder, key, value);
        }

// What happens next depends on the value's type.

        switch (typeof value) {
        case 'string':
            return quote(value);

        case 'number':

// JSON numbers must be finite. Encode non-finite numbers as null.

            return isFinite(value) ? String(value) : 'null';

        case 'boolean':
        case 'null':

// If the value is a boolean or null, convert it to a string. Note:
// typeof null does not produce 'null'. The case is included here in
// the remote chance that this gets fixed someday.

            return String(value);

// If the type is 'object', we might be dealing with an object or an array or
// null.

        case 'object':

// Due to a specification blunder in ECMAScript, typeof null is 'object',
// so watch out for that case.

            if (!value) {
                return 'null';
            }

// Make an array to hold the partial results of stringifying this object value.

            gap += indent;
            partial = [];

// Is the value an array?

            if (Object.prototype.toString.apply(value) === '[object Array]') {

// The value is an array. Stringify every element. Use null as a placeholder
// for non-JSON values.

                length = value.length;
                for (i = 0; i < length; i += 1) {
                    partial[i] = str(i, value) || 'null';
                }

// Join all of the elements together, separated with commas, and wrap them in
// brackets.

                v = partial.length === 0 ? '[]' :
                    gap ? '[\n' + gap +
                            partial.join(',\n' + gap) + '\n' +
                                mind + ']' :
                          '[' + partial.join(',') + ']';
                gap = mind;
                return v;
            }

// If the replacer is an array, use it to select the members to be stringified.

            if (rep && typeof rep === 'object') {
                length = rep.length;
                for (i = 0; i < length; i += 1) {
                    k = rep[i];
                    if (typeof k === 'string') {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            } else {

// Otherwise, iterate through all of the keys in the object.

                for (k in value) {
                    if (Object.hasOwnProperty.call(value, k)) {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            }

// Join all of the member texts together, separated with commas,
// and wrap them in braces.

            v = partial.length === 0 ? '{}' :
                gap ? '{\n' + gap + partial.join(',\n' + gap) + '\n' +
                        mind + '}' : '{' + partial.join(',') + '}';
            gap = mind;
            return v;
        }
    }

// If the JSON object does not yet have a stringify method, give it one.

    if (typeof JSON.stringify !== 'function') {
        JSON.stringify = function (value, replacer, space) {

// The stringify method takes a value and an optional replacer, and an optional
// space parameter, and returns a JSON text. The replacer can be a function
// that can replace values, or an array of strings that will select the keys.
// A default replacer method can be provided. Use of the space parameter can
// produce text that is more easily readable.

            var i;
            gap = '';
            indent = '';

// If the space parameter is a number, make an indent string containing that
// many spaces.

            if (typeof space === 'number') {
                for (i = 0; i < space; i += 1) {
                    indent += ' ';
                }

// If the space parameter is a string, it will be used as the indent string.

            } else if (typeof space === 'string') {
                indent = space;
            }

// If there is a replacer, it must be a function or an array.
// Otherwise, throw an error.

            rep = replacer;
            if (replacer && typeof replacer !== 'function' &&
                    (typeof replacer !== 'object' ||
                     typeof replacer.length !== 'number')) {
                throw new Error('JSON.stringify');
            }

// Make a fake root object containing our value under the key of ''.
// Return the result of stringifying the value.

            return str('', {'': value});
        };
    }


// If the JSON object does not yet have a parse method, give it one.

    if (typeof JSON.parse !== 'function') {
        JSON.parse = function (text, reviver) {

// The parse method takes a text and an optional reviver function, and returns
// a JavaScript value if the text is a valid JSON text.

            var j;

            function walk(holder, key) {

// The walk method is used to recursively walk the resulting structure so
// that modifications can be made.

                var k, v, value = holder[key];
                if (value && typeof value === 'object') {
                    for (k in value) {
                        if (Object.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v;
                            } else {
                                delete value[k];
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }


// Parsing happens in four stages. In the first stage, we replace certain
// Unicode characters with escape sequences. JavaScript handles many characters
// incorrectly, either silently deleting them, or treating them as line endings.

            cx.lastIndex = 0;
            if (cx.test(text)) {
                text = text.replace(cx, function (a) {
                    return '\\u' +
                        ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                });
            }

// In the second stage, we run the text against regular expressions that look
// for non-JSON patterns. We are especially concerned with '()' and 'new'
// because they can cause invocation, and '=' because it can cause mutation.
// But just to be safe, we want to reject all unexpected forms.

// We split the second stage into 4 regexp operations in order to work around
// crippling inefficiencies in IE's and Safari's regexp engines. First we
// replace the JSON backslash pairs with '@' (a non-JSON character). Second, we
// replace all simple value tokens with ']' characters. Third, we delete all
// open brackets that follow a colon or comma or that begin the text. Finally,
// we look to see that the remaining characters are only whitespace or ']' or
// ',' or ':' or '{' or '}'. If that is so, then the text is safe for eval.

            if (/^[\],:{}\s]*$/.
test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, '@').
replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']').
replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {

// In the third stage we use the eval function to compile the text into a
// JavaScript structure. The '{' operator is subject to a syntactic ambiguity
// in JavaScript: it can begin a block or an object literal. We wrap the text
// in parens to eliminate the ambiguity.

                j = eval('(' + text + ')');

// In the optional fourth stage, we recursively walk the new structure, passing
// each name/value pair to a reviver function for possible transformation.

                return typeof reviver === 'function' ?
                    walk({'': j}, '') : j;
            }

// If the text is not JSON parseable, then a SyntaxError is thrown.

            throw new SyntaxError('JSON.parse');
        };
    }
})();
AJS.clone = function (o) {
    function F() {}
    F.prototype = o;
    return new F();
};


/*global AJS, document, setTimeout */
if (!console.error) {
    console.log = console.warn = console.error = console.time = console.timeEnd = function () {};
}


// Library from http://blog.stevenlevithan.com/archives/parseuri

AJS.parseUri = function (uri, strict) {
    var unesc = window.decodeURIComponent || unescape;
    var esc = window.encodeURIComponent || escape;
    
    function parseUri (str) {
        var	o   = parseUri.options,
            m   = o.parser[o.strictMode ? "strict" : "loose"].exec(str),
            uri = {},
            i   = 14;

        while (i--) uri[o.key[i]] = m[i] || "";

        uri[o.q.name] = {};
        uri[o.key[12]].replace(o.q.parser, function ($0, $1, $2) {
            if ($1) uri[o.q.name][unesc($1)] = unesc($2);
        });

        return uri;
    };

    parseUri.options = {
        strictMode: !!strict,
        key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"],
        q:   {
            name:   "queryKey",
            parser: /(?:^|&)([^&=]*)=?([^&]*)/g
        },
        parser: {
            strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
            loose:  /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
        }
    };

    uri = parseUri(uri);

    uri.toString = function () {
        var params = [];
        AJS.$.each(uri.queryKey, function (name, value) {
            params.push(esc(name) + "=" + esc(value));
        });
        
        return uri.protocol + "://" + uri.authority + uri.path + "?" + params.join("&") + "#" + uri.anchor;
    };
    
    return uri;
};






/**
 * ZParse - Javascript Library for Template Parsing
 * @author Rizqi Ahmad
 *
 * Copyright (c) 2007 Rizqi Ahmad
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
/////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Main Object of ZParse. Acting as a class and a namespace at the same time
 * @param {Object} implementation
 * @example
 * 	<code>
 * 	var parser1 = new ZParse();
 * 	var parser2 = new ZParse(customImplementation);
 *
 * 	parser1.parse(templateString1);
 * 	parser2.parse(templateString2);
 *
 *  var result1 = parser1.process(data);
 *  var result2 = parser2.process(data);
 *	</code>
 */
var ZParse = function(implementation) {
	/*
	 * @type {Object} Rule Object
	 */
	this.implementation = implementation;

	/*
	 * @type {String} Function-Header for the template
	 */
	this.header = 	[	'var $text = [];',
						'var _write = function(text) {',
							'$text.push((typeof text == "number")?text:(text||""));',
						'};',
                        'var top = $data;',
						'with($data){ '
						].join('');

	/*
	 * @type {String} Function-Footer for the template
	 */
	this.footer = '}return $text.join("");';

	/*
	 * @type {Array} Characters to be escaped
	 */
	this.escapeChars = ['\\', '\'', '"', ['\n','\\n'], ['\t','\\t'], ['\r', '\\r']];
};
/////////////////////////////////////////////////////////////////////////////////////////////////////
/*
 *  @type {Object} Default rule object to be used
 */
ZParse.implementation = {};
/////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Parse template string to template function
 * @param {String} Template string to be parsed
 * @return {Boolean} Parsing status, false if failed, true if succeeded
 * @example
 * 	<code>
 * 	var parser = new ZParse;
 * 	parser.parse(myTemplateString);
 *  </code>
 */
ZParse.prototype.parse = function(source) {

	this.sourceArray = ZParse.parseToArray(source, this.implementation);
	this.sourceTree = ZParse.parseToTree(this.sourceArray.all, this.implementation);
	this.functionText = ZParse.parseToScript(this.sourceTree, this.escapeChars, this.implementation, this);

	try {
		this.functionScript = new Function('$data', this.header + this.functionText + this.footer);
        return true;
    } catch(e){
		this.error = e;
		return false;
	}

};


ZParse.clean = function (str) {
    return str.replace(/[\n\r\t](?!.*?<)/gmi,"").replace(/(<\w+?|\"+?)\s{2,}/g,"$1 ");
};

/////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Process created Template with data
 * @param {Object} data that will be used when executing function. You can access data within template
 * @param {Object} 'this'-object to be binded in template
 * @return {String} text result
 * @example
 *  <code>
 *  var parser = new ZParse;
 *  var string = 'my name ist <$name>. Im <$age> years old.'
 *
 *  parser.parse(string);
 *  var result = parser.process({name:'Rizqi', age:17});
 *  // result: "my name is Rizqi. Im 17 years old."
 *  </code>
 */
ZParse.prototype.process = function(data, bind) {
	if(bind)
		return ZParse.clean(this.functionScript.apply(bind, [data]));
	else
		return ZParse.clean(this.functionScript(data));
};

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////    ZParse Global Functions     ////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Escape characters. Needed for parsing template.
 * @param {String} string containing characters to be escaped
 * @param {Array} escape characters list
 * @return {String} parsed string
 * @example
 *  <code>
 *  var escaped = ZParse.escape("lesser < more >", ['<','>']);
 *  // produce: 'lesser \< more \>'
 *  </code>
 */
ZParse.escape = function(source, list) {
	for(var i=0; i<list.length; i++) {
		if(list[i] instanceof Array)
			source =  source.replace(new RegExp(list[i][0],'gi'), list[i][1]);
		else
			source = source.replace(new RegExp('\\'+list[i],'gi'), '\\'+list[i]);
	}
	return source;
};
/////////////////////////////////////////////////////////////////////////////////////////////////////
/*
Function: parseToArray

Parse template string to array

Parameters:
	source -	String, template source
	imp    -	Object, implementation object

Return:
	Array, template array

Example:
	(start code)

	(end)
*/
/**
 * Parse template string to array
 * @param {String} source
 * @param {Object} imp
 */
ZParse.parseToArray = function(source, imp) {
	var opener, closer, delimiter;
	var text = [],
		tags = [],
		all = [];

	while(source) {
		for(var i in imp) {
			if(!delimiter || source.indexOf(imp[delimiter].opener) == -1)
				delimiter = i;
			if(source.indexOf(imp[i].opener) != -1)
				if(source.indexOf(imp[delimiter].opener) > source.indexOf(imp[i].opener))
					delimiter = i;
		}

		opener = source.indexOf(imp[delimiter].opener);
		closer = source.indexOf(imp[delimiter].closer) + imp[delimiter].closer.length;

		if(opener != -1) {
			text.push(source.substring(0,opener));
			tags.push(source.substring(opener,closer));
			source = source.substring(closer);
		} else {
			text.push(source);
			source = '';
		}
	}

	for(var i=0; i<text.length; i++) {
		all.push(text[i]);
		if(tags[i])
			all.push(tags[i]);
	}

	return {text:text, tags:tags, all:all};
};

/////////////////////////////////////////////////////////////////////////////////////////////////////
ZParse.parseArguments = function(source, expr) {

	var args = ZParse.parseToArray(expr, {expr:{opener:'\{',closer:'\}'}}).tags;
	expr = ZParse.escape(expr, ['(' ,')' ,'[' ,']', ',', '.', '<', '>', '*', '$', '@']);
	for(var i=0; i<args.length; i++) {
		expr = expr.replace(args[i],'(.*)');
		args[i] = args[i].replace('\{', '').replace('\}', '');
	}
	var matches = source.match(new RegExp(expr));

	var result = {};
	if(matches)
		for(var i=0; i<args.length; i++)
			result[args[i]] = matches[i+1];

	return result;
};

/////////////////////////////////////////////////////////////////////////////////////////////////////
ZParse.parseTag = function(source, imp) {
	// Parse Tag
	var delimiter;
	for(var i in imp)
		if(source.indexOf(imp[i].opener) == 0) {
			delimiter = i;
			break;
		}
	if(!delimiter)
		return false;
	source =  source.substring(imp[delimiter].opener.length, source.indexOf(imp[delimiter].closer));

	// Parse tag name
	var tagname = '';
	var closer = '';
	if(imp[delimiter].tags) {
		var tagArray = [];
		for(var i in imp[delimiter].tags)
			tagArray.push(i);
		var regex = new RegExp('^(\/){0,1}('+tagArray.join('|')+')\\\s*(.*)');
		var res =  source.match(regex);
		if(!res)
			return false;
		closer = res[1]?true:false;
		tagname = res[2];
		source = res[3];
	}

	// Parse tag type
	if(tagname) {
		if(imp[delimiter].tags[tagname].type == 'single' && closer)
			return false;
		if(imp[delimiter].tags[tagname].type == 'block' && closer)
			return { delimiter:delimiter, tagname:tagname, closer:true};
	}

	// Parse arguments
	var args = {};
	if(tagname && imp[delimiter].tags[tagname].arguments) {
		args = ZParse.parseArguments(source, imp[delimiter].tags[tagname].arguments);
    } else if(!tagname && imp[delimiter].arguments) {
		args = ZParse.parseArguments(source, imp[delimiter].arguments);
    }
	return {delimiter:delimiter, tagname:tagname, source:source, arguments:args};
};

/////////////////////////////////////////////////////////////////////////////////////////////////////
ZParse.parseToTree = function(array, imp) {
	var obj, res, current, nr = 0;
	var doc = {
		isDocument:true,
		innerSource: array.join(''),
		children: []
	};

	var addChild = function(parent,child) {
		child.nr = parent.children.length;
		parent.children.push(child);
	};

	current = doc;
	for(var i=0; i<array.length; i++) {
		res = ZParse.parseTag(array[i], imp);
		if(!res) {
			if(array[i]) {
				array[i].parent = current;
				addChild(current, array[i]);
			}
		} else {
			obj = {};

			obj.i = i;
			obj.tagname = res.tagname;
			obj.delimiter = res.delimiter;
			obj.arguments = res.arguments;
			obj.argSource = res.source;
			obj.parent = current;

			if(res.tagname && imp[res.delimiter].tags[res.tagname].noTextBefore
				&& !res.closer && typeof current.children[current.children.length-1] == 'string')
					current.children.pop();

			if(res.tagname && imp[res.delimiter].tags[res.tagname].type == 'block'){
				if(!res.closer) {
					addChild(current, obj);
					current = obj;
					current.children = [];
				} else if(current.tagname == res.tagname) {
					current.innerSource = '';
					for(var j=current.i+1; j<i; j++){
						current.innerSource += array[j];
					}
					current = current.parent;
				}
			} else
				addChild(current, obj);
		}
	}

	return doc;
};

/////////////////////////////////////////////////////////////////////////////////////////////////////
ZParse.parseToScript = function(tree, escape, imp, caller) {
	if(typeof tree == 'string')
		return '_write(\''+ZParse.escape(tree, escape)+'\');';

	var result, content = [];

	if(tree.children)
		for(var i=0; i<tree.children.length; i++)
			content.push(ZParse.parseToScript(tree.children[i], escape, imp, caller));
	if(!tree.isDocument) {
		if(tree.tagname)
			return imp[tree.delimiter].tags[tree.tagname].handler(tree, content.join(''), caller);
		else
			return imp[tree.delimiter].handler(tree, content.join(''), caller);

	} else
		return content.join('');
};
/////////////////////////////////////////////////////////////////////////////////////////////////////

ZParse.parseXMLToJSON = function(xml) {
	var result;
	if(xml.childNodes && xml.childNodes.length == 1 && xml.childNodes[0].nodeName == "#text") {
		result = xml.childNodes[0].nodeValue;
	} else{
		result = {};
		for(var i=0; i<xml.childNodes.length; i++) {
			if(result[xml.childNodes[i].nodeName]) {
				if(!(result[xml.childNodes[i].nodeName] instanceof Array))
					result[xml.childNodes[i].nodeName] = [result[xml.childNodes[i].nodeName]];
				result[xml.childNodes[i].nodeName].push(ZParse.parseXMLToJSON(xml.childNodes[i]));
			}else if(xml.childNodes[i].nodeName.indexOf('#') == -1)
				result[xml.childNodes[i].nodeName] = ZParse.parseXMLToJSON(xml.childNodes[i]);
		}
	}

	if(xml.attributes)
		for(var i=0; i<xml.attributes.length; i++)
			result['@'+xml.attributes[i].nodeName] = xml.attributes[i].nodeValue;

	return result;
}


var Implementation = {
	statement: {
		opener: '<?',
		closer: '?>',

		tags: {

			'foreach': {
				arguments: '{element} in {object}',
				type: 'block',
				handler: function(tree, content, caller) {
					var element = tree.arguments.element;
					var object = tree.arguments.object;

					//Check whether there are else tag after this tag, if yes, (if) tag will be included
					var cond = (tree.parent.children[tree.nr+1] && tree.parent.children[tree.nr+1].tagname == 'else');
					var iff = ['if( (',object,' instanceof Array && ',object,'.length > 0) || ',
								'(!(',object,' instanceof Array) && ',object,') ) {'].join('');
					return [
						cond?iff:'',
							'var ',element,';',
							'if(',object,' instanceof Array) {',
								'for(var ',element,'_index=0; ',element,'_index<',object,'.length; ',element,'_index++) {',
									element,' = ',object,'[',element,'_index];',
									content,
								'}',
							'} else {',
								'for (var ',element,'_index in ',object,') {',
									element,' = ',object,'[',element,'_index];',
									content,
								'}',
							'}',
						cond?'}':''
					].join('');
				}
			},

			'for': {
				arguments: '{element} in {object}',
				type: 'block',
				handler: function(tree, content, caller) {
					var element = tree.arguments.element;
					var object = tree.arguments.object;

					//Check whether there are else tag after this tag, if yes, (if) tag will be included
					var cond = (tree.parent.children[tree.nr+1] && tree.parent.children[tree.nr+1].tagname == 'else');
					var iff = ['if( (',object,' instanceof Array && ',object,'.length > 0) || ',
								'(!(',object,' instanceof Array) && ',object,') ) {'].join('');
					return [
						cond?iff:'',
							'if(',object,' instanceof Array) {',
								'for(var ',element,'=0; ',element,'<',object,'.length; ',element,'++) {',
									content,
								'}',
							'} else {',
								'for(var ',element,' in ',object,') {',
									content,
								'}',
							'}',
						cond?'}':''
					].join('');
				}
			},

			'if': {
				type: 'block',

				handler: function(tree, content, caller) {


					var condition = tree.argSource;

					return [
                        

                        'if(',condition,') {',
							content,
						'}'
					].join('');
				}
			},

			'elseif': {
				type: 'block',
				noTextBefore: true,

				handler: function(tree, content, caller) {
					var condition = tree.argSource;

					return [
						'else if(',condition,') {',
							content,
						'}'
					].join('');
				}
			},

			'else': {
				type: 'block',
				noTextBefore: true,

				handler: function(tree, content, caller) {
					return [
						'else {',
							content,
						'}'
					].join('');
				}
			},

            

			'macro': {
				arguments: '{name}({args})',
				type: 'block',
				handler: function(tree, content, caller) {
					var name = tree.arguments.name;
					var args = tree.arguments.args;
					var point = (name.indexOf('.') > 0);
					return [
						point?'':'var ', name,' = function(',args,') {',
                                'var top = ' + args + ";",
                                'with (' + args + ') {',
                                    'var $text = [];',
                                    'var _write = function(text) {',
                                        '$text.push((typeof text == "number")?text:(text||""));',
                                    '};',
                                    content,
                                '}',
                                'return $text.join("");',
						    '};'
					    ].join('');
				}
			},

			'cdata': {
				type: 'block',
				handler: function(tree, content, caller) {
					return '_write(\''+ZParse.escape(tree.innerSource, caller.escapeChars)+'\');';
				}
			}
		}
	},

	print: {
		opener: '${',
		closer: '}',
		handler: function(tree, content, caller) {
			return '_write('+tree.argSource+');';
		}
	},

	alternatePrint: {
		opener: '<$',
		closer: ':>',
		handler: function(tree, content, caller) {
			return '_write('+tree.argSource+');';
		}
	},

	script: {
		opener: '<%',
		closer: '%\>',
		handler: function(tree, content, caller) {
			return tree.argSource;
		}
	}
};
/**
 * Manages dashboard. Besides rendering the dashboard menu, this singleton is responsible for delegating actions to
 * layoutManagers.
 *
 * @module dashboard
 * @class DashboardManager
 * @constructor
 * @namespace AG
 */

/*global AJS, console, document*/
/*jslint bitwise: true, eqeqeq: true, immed: true, newcap: true, nomen: true, onevar: true, plusplus: true, regexp: true, undef: true, white: true, indent: 4 */

AG = {}; // set namespace


AG.DashboardManager = (function () {

    var

    dashboard,

    /**
     * Data store of AG.LayoutMangers
     *
     * @property layouts
     * @private
     * @type {Array}
     */
    layouts = [],

    /**
     * Creates dashboard menu
     *
     * @method createMenu
     * @private
     */
    createMenu = function (json) {

        var // local variable declarations
        editButton, /* {jQuery} jQuery wrapped html element, the edit button */
        descriptor; /* {Object} contains dashboard menu properites. Used by templater to render html */

        // Gets attributes to assign event handlers
        descriptor = AG.render.getDescriptor("dashboardMenu", json);

        // Appends rendered html to dashboard. HTML produced by rendering engine, AG.render.
        dashboard.contents.append(AG.render(descriptor));

        // Gets the edit button using the id set in descriptor 'dashboardMenu'.
        editButton = AJS.$("#layout-changer");

        editButton.click(function (e) {
            // stop default link action (do not follow link)
            e.preventDefault();
            // opens edit layout dialog
            AG.DashboardManager.editLayout();
        });

        AJS.$("#dashboard-tools-dropdown").dropDown("standard", {
            trigger: ".aui-dd-link"
        });
    };

    return {


        /**
         * Gets dashboard container. The &lt;div&gt; that serves as the container for all other dashboard HTML.
         *
         * @method getDashboard
         * @return {jQuery} dashboard htmlElement
         */
        getDashboard: function () {
            return dashboard;
        },

        /**
         * Creates a new instance of AG.LayoutManger. On construction the Layout Manager will build the html for the
         * columns, and if descriptors provided, gadgets also. If gadget descriptors are provided, layout will be set to
         * active.
         *
         * <dl>
         *  <dt>Usage</dt>
         *  <dd>
         *      <pre>
         *
         *      // This will create a layout. It will set it to active because you have specified gadgets
         *      AG.DashboardManager.addLayout({
         *           title: "Dashboard for Scott Harwood",
         *           type: "layout-aaa",
         *           gadgets: [
         *               {
         *                   "height": "300",
         *                   "id":"1",
         *                   "title":"All Hidden Prefs test",
         *                   "gadgetSpecUrl":"http://gadgetspeclocation.com",
         *                   "color":"color4",
         *                   "isMaximizable":false,
         *                   "userPrefs":null,
         *                   "renderedGadgetUrl":"http://gadgetlocationrenderlocation.com"
         *               },
         *               {
         *                   "height": "300",
         *                   "id":"1",
         *                   "title":"All Hidden Prefs test",
         *                   "gadgetSpecUrl":"http://gadgetspeclocation.com",
         *                   "color":"color4",
         *                   "isMaximizable":false,
         *                   "userPrefs":null,
         *                   "renderedGadgetUrl":"http://gadgetlocationrenderlocation.com"
         *               }
         *           ]
         *       });
         *      </pre>
         *  </dd>
         *  <dd>
         *      <pre>
         *
         *      // This will create a layout. It will be inactive as you have specifed a url of which to retrieve gadget descriptors from, when selected.
         *      AG.DashboardManager.addLayout({
         *           title: "Dashboard for Scott Harwood",
         *           type: "layout-aaa",
         *           gadgets: "http://gadget-decriptor-url-for-this-layout/
         *      });
         *      </pre>
         *      </pre>
         *  </dd>
         * </dl>
         *
         * @method addLayout
         * @param {Object} descriptor - JSON describing layout <em>type</em>, <em>title</em>, & <em>gadgets</em>.
         * Gadgets can be an array of gadget descriptors or a url that can be requested to retreive them.
         */
        addLayout: function (descriptor) {

            var // local variable declarations
              /* {AG.LayoutManager} Instance of AG.LayoutManager  */
            layout = AG.LayoutManager(descriptor);

                // add instance to collection so we can refer to it later
                layouts.push(layout);

                if (descriptor.active !== false) {
                    // make this layout (tab) the active one
                    this.setLayout(layout);
                }

                layout.init();
        },

        showShims: function () {
            if (!AJS.$("body").hasClass("propagation-blocker")) {
                AJS.$("body").addClass("propagation-blocker");
                this.getDashboard().shim.height(this.getDashboard().outerHeight());
            }
        },

        hideShims: function () {
            if (AJS.$("body").hasClass("propagation-blocker")) {
                AJS.$("body").removeClass("propagation-blocker");
            }

        },

        /**
         * Executes the diagnostics script, or retrieves the result if it has already been executed before.
         */
        doDiagnostics: function() {
            AJS.$.ajax({
                type: "post",
                url : AG.param.get("dashboardDiagnosticsUrl"),
                data: {
                    uri: document.location.href
                },
                error: function(request) {
                    if (request.status == 500) {
                        diagnosticsErrorDisplay(request);
                    }
                },
                success: function(data) {
                    // do not show warning
                    AJS.$("#diagnostic-warning").addClass("hidden");
                }
            });

            var diagnosticsErrorDisplay = function(request) {
                var diagnosticsWarningDiv = AJS.$("#diagnostic-warning");

                diagnosticsWarningDiv.html(request.responseText);

                var learnMoreText = "Click here to learn more";
                var diagnosticsContentDiv = AJS.$("#diagnostic-content", diagnosticsWarningDiv);
                var learnMoreLink = AJS.$("#learn-more-link", diagnosticsWarningDiv);
                var displayErrorLink = AJS.$("#display-error-link", diagnosticsWarningDiv);
                var stackTraceDiv = AJS.$("#error-stack-trace", diagnosticsWarningDiv);

                var closeWarning = function() {
                    diagnosticsWarningDiv.slideUp();
                    diagnosticsWarningDiv.addClass("hidden");
                    AJS.$.ajax({
                        type: "post",
                        url: AG.param.get("dashboardDiagnosticsUrl"),
                        data: {
                            method: "delete"
                        }
                    });
                };

                var setToggleDetails = function(link, detailDiv) {
                    link.click(function(){
                        if (link.text() == "Hide") {
                            link.text(learnMoreText);
                            detailDiv.slideUp();
                            detailDiv.addClass("hidden");
                        } else {
                            detailDiv.removeClass("hidden");
                            detailDiv.slideDown('slow');
                            link.text("Hide");
                        }
                    });
                };

                setToggleDetails(learnMoreLink, diagnosticsContentDiv);
                setToggleDetails(displayErrorLink, stackTraceDiv);

                AJS.$("#diagnostic-warning .close").click(function() {
                    closeWarning();
                });

                diagnosticsWarningDiv.removeClass("hidden");
            };

        },

        /**
         * Displays edit layout dialog. This function evolves. First time it is called will constuct the html and
         * show layout dialog. Subsequent times it will simply toggle it's visibility.
         *
         * @method editLayout
         */
        editLayout: function () {

            var // local variable declarations
            descriptor, /* {Object} contains edit layout dialog properites. Used by templater to render html */
            popup;      /* {AJS.popup} instance of AJS.popup */

            // get properties for layo  ut dialog
            descriptor = AG.render.getDescriptor("layoutDialog", {
                layoutType: AG.DashboardManager.getLayout().getLayout()
            });

            // create instance of AJS.popup. This does NOT show popup.
            popup = AJS.popup(507, 150, "layout-dialog");

            // Appends rendered html to popup element. HTML produced by rendering engine AG.render. Properties used by
            // rendering engine are gatherd from a call to AG.render.getDescriptor("layoutDialog").
            popup.element
                    .html(AG.render(descriptor))
                    .addClass(AG.LayoutManager.getLayoutAttrName(descriptor.layoutType));

            // adds close button & close behaviour
            AJS.$("#" + descriptor.closeId, popup.element).click(function (e) {

                popup.hide();

                // don't follow link
                e.preventDefault();
            });

            // Find all the layout representations in dialog. Assign a click handler to them that will change the
            // current layout.
            AJS.$.each(AG.LayoutManager.layouts, function () {
                var
                layout = this,
                layoutAttrName = AG.LayoutManager.getLayoutAttrName(layout);

                AJS.$("#" + layoutAttrName).click(function (e) {

                    // Find the layout we are going to affect.
                    var activeLayout = AG.DashboardManager.getLayout();
                    // Set the highlighted layout for this dialog. So next time we open the dialog, the correct one is
                    // highlighted.

                    popup.element
                            .removeClass(AG.LayoutManager.getLayoutAttrName(activeLayout.getLayout()))
                            .addClass(layoutAttrName);

                    // Finally display the selected layout.
                    activeLayout.setLayout(layout);
                    popup.hide();

                    AG.Sortable.update();
                    
                    // Don't follow link.
                    e.preventDefault();
                });
            });

            // Re-define this method (thankyou javascript), so that the next time we call editActive layout we do not
            // constuct the html everytime. All we do is toggle it's visibility with a call to the show method.
            this.editLayout = (function () {
                popup.show();
                AJS.$(document).keyup(function (e) {
                    if (e.keyCode === 27) {
                        popup.hide();
                        AJS.$(document).unbind("keyup", arguments.callee);
                        e.preventDefault();
                    }
                });
                return arguments.callee;
            }()); // call myself straight away. Don't worry! I will be restored by returning myself (arguments.callee)


        },


        /**
         * Gets active layout manager
         *
         * @method getLayout
         * @return {AG.LayoutManager}
         */
        getLayout: function () {
            return this.activeLayout;
        },

        markReadOnlyLayouts: function () {
            AJS.$.each(layouts, function () {
                if (!this.isWritable()) {
                    this.markReadOnlyLayout();
                }
            });
        },

        unmarkReadOnlyLayouts: function () {
            AJS.$.each(layouts, function () {
                if (!this.isWritable()) {
                    this.unmarkReadOnlyLayout();
                }
            });
        },

        /**
         * Sets active layout manager
         * @method setLayout
         * @param {AG.LayoutManager} layout
         */
        setLayout: function (layout) {
//            if (this.activeLayout) {
//                this.activeLayout.deactivate();
//                this.activeLayout.tab.removeClass("active");
//                layout.activate();
//            }
            // layout.tab.addClass("active");
            this.activeLayout = layout;
        },

        /**
         * Creates gadget using the provided <em>gadgetDesriptor</em> and appends it to the specified column of the
         * active layout/tab. If column is not specified, will be added as first gadget in the first column.
         *
         * <dl>
         *  <dt>Usage</dt>
         *  <dd>
         *      <pre>
         *      AG.DashboardManager.addGadget({
         *          "height": "300",
         *          "id":"1",
         *          "title":"All Hidden Prefs test",
         *          "gadgetSpecUrl":"http://gadgetspeclocation.com",
         *          "color":"color4",
         *          "isMaximizable":false,
         *          "userPrefs":null,
         *          "renderedGadgetUrl":"http://gadgetlocationrenderlocation.com"
         *       }, 1);
         *       </pre>
         * </dl>
         *
         *
         * @method addGadget
         * @param {Object} gadgetDescriptor - JSON with gadget properites
         * @param {Number} column - Column to append gadget to. (optional)
         */
        addGadget: function (gadget, column) {
            this.activeLayout.addGadget(gadget, column);
        },

        /**
         * Creates furniture & layouts, sets params & il8n strings.
         *
         * @method setup
         * @param options
         */
        setup: function (options) {
            var
            that = this,     /* {AG.DashboardManager} 'this' reference for inside of inner functions */
            securityTokenRefreshRate = AJS.parseUri(document.location.href).queryKey["__st_refresh"] || 1000*60*12;
            
            console.debug = console.debug || function() {};
            
            // add a point cut to the setHeight service so that it refreshes the positioning of our gadgets. They are
            // absolute positioned so a change of height affects their offset.
            AJS.$.aop.after({target: gadgets.IfrGadgetService.prototype, method: "setHeight"}, function () {
                that.getLayout().onInit(function () {
                    that.getLayout().refresh();
                });
            });

            // adds all the il8n and param strings to data store
            AG.param.set(options.params);

            AG.render.ready(function () {
                AJS.$(function () {

                    // creates shim that sits over dashboard to prevent propagation of events during actions like dragging
                    AG.Sortable.init();

                    dashboard = AJS.$("#dashboard");
                    dashboard.header = AJS.$("<div id='dashboard-header' />").appendTo(dashboard);

                    //if there's only one tab, hide the tabs.
                    if (options.layouts.length > 1) {
                        that.getDashboard().addClass("v-tabs");
                        dashboard.tabContainer = AJS.$("<ul class='vertical tabs' />").appendTo(dashboard);
                    }

                    dashboard.contents = AJS.$("<div id='dashboard-content' />").appendTo(dashboard);

                    if(options.menu.items && options.menu.items.length > 0) {
                        dashboard.menu = createMenu(options.menu);
                    }
                    dashboard.shim = AJS.$('<div class="dashboard-shim"> </div>').appendTo(dashboard.contents);


                    AJS.$.each(options.layouts, function () {
                        // creates layout instance and appends gadgets, if provided.
                        that.addLayout(this);
                    });

                    dashboard.removeClass("initializing");

                    function updateSecurityTokens() {
                        var gadgetTokenFrames = new Array(),
                            updateTokenParams = {};
                        console.debug("Updating all gadget security tokens");
                        
                        AJS.$.each(AG.DashboardManager.getLayout().getGadgets(), function(index) {
                            gadgetTokenFrames.push({
                                gadget: this,
                                iframeId: this.getElement().find("iframe").attr("id")
                            });
                            updateTokenParams["st." + index] = this.getSecurityToken();
                        });
                        if (!updateTokenParams["st.0"]) {
                            console.debug("No gadgets on dashboard, so there is no need to update security tokens.")
                            return;
                        }
                        AJS.$.ajax({
                            type: "POST",
                            url: AG.param.get("securityTokensUrl"),
                            data: updateTokenParams,
                            dataType: "json",
                            success: function(newSecurityTokens) {
                                AJS.$.each(gadgetTokenFrames, function(index) {
                                    this.gadget.setSecurityToken(newSecurityTokens["st." + index]);
                                    try {
                                        gadgets.rpc.call(this.iframeId, "update_security_token", null, this.gadget.getSecurityToken());
                                    } catch (e) {
                                        console.debug(
                                            "Unable to update the security token for gadget with iframe id " +
                                            this.iframeId + ".  This likely means that the gadget does not use the " +
                                            "'auth-refresh' feature.  If the gadget uses gadgets.io.makeRequest after its" +
                                            "initial startup, it is a good idea to use the 'auth-refresh' feature " +
                                            "by adding <Optional feature='auth-refresh' /> to your gadget's " +
                                            "<ModulePrefs> section.  Otherwise, the gadget's security token could expire" +
                                            " and subsequent calls to gadgets.io.makeRequest will fail.");
                                    }
                                });
                                console.debug("Updating security tokens complete.");
                            },
                            error: function(request, textStatus, errorThrown) {
                                if (request.status != 200) {
                                   console.debug(
                                       "Failed to get new security tokens. Response was had a status of '" +
                                       request.status + "' saying '" + request.statusText + "'");
                                } else {
                                    console.debug("There was an error processing the response. Error was '" +
                                        textStatus + "'");
                                }
                            }
                        });
                    };

                    console.debug("Security tokens will be refreshed every " + securityTokenRefreshRate + "ms");
                    window.setInterval(updateSecurityTokens, securityTokenRefreshRate);
                    that.doDiagnostics();
                });
            });

            AG.render.initialize();

        }
    };
}());
/**
 * Manages Dashboard layout. This includes organising of gadgets and drag and drop functionality. Dashboard specific
 * methods, NOT gadget specific.
 *
 * @module dashboard
 * @class LayoutManager
 * @constructor
 * @namespace AG
 */

/*jslint bitwise: true, eqeqeq: true, immed: true, newcap: true, nomen: true, onevar: true, plusplus: true, regexp: true, undef: true, white: true, indent: 4 */
/*global AG, AJS, alert, console */

(function () {

    if (typeof Object.create !== 'function') {
        Object.create = function (o) {
            function F() {}
            F.prototype = o;
            return new F();
        };
    }

    var LayoutManager = {

        /**
         * Sends request to server to persist current layout, including gadget ordering and column layout.
         *
         * @method saveLayout
         * @private
         */
        saveLayout: function () {

            var that = this;

            function getData() {
                return AJS.$.extend({
                    method: "put",
                    layout: that.layout
                }, AG.Sortable.serialize());
            }

            AJS.$.ajax({

                type: "post",
                url: AG.param.get("layoutAction"),

                // Self executing function that firstly sets the layout type & method of storge (put). Secondly sets
                // gadget positioning in layout, by looping through, sequentially, all columns and their gadgets,
                // binding gadget id's to column id's.
                data: getData(),

                /* debug */
                success: function () {
                    console.log("AG.LayoutManager.saveLayout: Layout (" + that.layout + ") saved successfully");
                },
                /* debug end */

                // In the case of an error. This can be caused by a timeout (if specified), http error or parseError
                error: function (request) {
                    if (request.status == 403 || request.status == 401) {
                        alert(AG.param.get("dashboardErrorDashboardPermissions"));
                    }
                    else {
                        alert(AG.param.get("dashboardErrorCouldNotSave"));
                    }
                    /* debug */
                    console.log("AG.LayoutManager.saveLayout: Request failed! Printing response object...");
                    console.log(request);
                    /* debug end */
                }
            });
        },

        getColumn: function (idx) {

            var
            that = this,
            i    = parseInt(idx, 16);

            if (arguments.length) {
                return that.columns;
            } else if (!isNaN(i) || !that.columns[i]) {
                return that.columns.eq(i);
            }
            /* debug */
            else {
                console.error("AG.LayoutManager.getColumn: The column index you provided is invalid. " +
                        "Expected a number in the range of 0-" + that.columns.length - 1 + " but recieved " + idx);
            }
            /* debug end */
        },


        /**
         * Sets the type of layout.
         *
         * @method setLayout
         * @param {String} layout - valid layout code
         * @param {Boolean} save (optional) - Flag to presist layout by sending request to server.
         */
		setLayout: function (layout, save) {

            layout = AJS.$.trim(layout);

            // checking if the layout is not the same as current
            if (this.layout === layout) {
                /* debug */
                console.warn("AG.LayoutManager.setLayout: Ignoring! The layout supplied is the same as the current " +
                "layout (" + layout + ")");
                /* debug end */
                return;
            }

            // checking if valid layout
            if (AJS.$.inArray(layout, AG.LayoutManager.layouts) === -1) {
                /* debug */
                console.error("AG.LayoutManager.setLayout: Invalid layout! Was given " + layout + ", but expected " +
                              "either of '" + AG.LayoutManager.layouts.toString() + "'");
                /* debug end */
            }

            this.container.addClass("layout-" + layout.toLowerCase());

            // cannot set layout if it is not writable
            if (!this.isWritable()) {
                /* debug */
                console.log("AG.LayoutManager.setLayout: Can't manipulate layout. Layout is not writable");
                /* debug end */
                return;
            }

            // toggle class that defines column visibility and width's
            if (this.layout) {
                this.container.removeClass("layout-" + this.layout.toLowerCase());
            }

            // move any gadgets in this layout, that are hidden due to layout changes, into the closest visible column.
            AJS.$.each(this.gadgets, function () {

                var
                layoutRep = this.getElement().layoutRep, /* Gadget representaion in column layout */
                prevColumn = layoutRep.parent().prev(); /* Column preceeding gadget's current column */

                if (!layoutRep.is(":visible")) {
                    if (prevColumn.is(":visible")) {
                        prevColumn.append(layoutRep);
                    } else {
                        prevColumn.prev().append(layoutRep);
                    }
                }
            });

            // Add "sortable" classes to columns. AG.Sortable uses these classes to find columns to apply sortable
            // functionality to.
            if (layout === "AB" || layout === "BA" || layout === "AA") {
                this.columns.eq(0).addClass("sortable");
                this.columns.eq(1).addClass("sortable");
                this.columns.eq(2).removeClass("sortable");
            } else if (layout === "A") {
                this.columns.eq(0).addClass("sortable");
                this.columns.eq(1).removeClass("sortable");
                this.columns.eq(2).removeClass("sortable");
            } else if (layout === "AAA") {
                this.columns.eq(0).addClass("sortable");
                this.columns.eq(1).addClass("sortable");
                this.columns.eq(2).addClass("sortable");
            }


            this.layout = layout;
            this.refresh();

            if (save !== false) {
                this.saveLayout();
            }

            /* debug */
            else {
                console.log("AG.LayoutManager.setLayout: Layout successfully set to '" + this.layout + "'");
            }
            /* debug end */
		},

        getGadgets: function () {
            return this.gadgets;
        },

        removeGadget: function (gadget) {
            var that = this;
            AJS.$.each(this.gadgets, function (idx) {
                if (this === gadget) {
                    that.gadgets.splice(idx, 1);
                    return false;
                }
            });
        },

        deactivate: function () {
            this.container.hide();
            AJS.$.each(this.gadgets, function () {
                if (this.getElement().layoutRep.css("display") === "list-item") {
                    this.getElement().hide();
                }
            });
        },

        activate: function () {
            this.container.show();
            AJS.$.each(this.gadgets, function () {
                this.getElement().show();
            });
            this.refresh();
        },

        refresh: function () {

            var that = this, isIE6OrBelow = !!(AJS.$.browser.msie && parseInt(jQuery.browser.version) <= 6);

            function appendEmptyMsgElem(col, idx) {
                var message = AG.param.get("dragHere",
                        "<a class='add-gadget-link' id='add-gadget-" + idx + "' href='#'>", "</a>");
                return AJS.$("<li class='empty-text'>" + message + "</li>").appendTo(col);
            }


            if (!this.initialized) {
                return;
            }

            if (!AG.DashboardManager.getDashboard().hasClass("dragging")) {

                this.columns.css(isIE6OrBelow ? "height" : "minHeight", "");

                this.columns.filter(":visible").each(function (idx) {

                    var column = AJS.$(this);

                    if (AJS.$("li:visible:not(.empty-text)", column).length === 0) {
                        column.addClass("empty");
                        if (that.isWritable()) {
                            if (!this.msgElem) {
                                this.msgElem = appendEmptyMsgElem(column, idx);
                            } else if (this.msgElem) {
                                this.msgElem.show();
                            }
                        }

                    } else if (column.hasClass("empty")) {
                        column.removeClass("empty");
                        if (this.msgElem) {
                            this.msgElem.hide();
                        }
                    }
                });
            }

            AJS.$("li.gadget", this.container).each(function () {
                this.getGadgetInstance().updatePosition();
            });

            if (!AG.DashboardManager.getDashboard().hasClass("dragging")) {
                this.columns.each(function () {
                    var column = AJS.$(this);
                    column.css(isIE6OrBelow ? "height" : "minHeight", column.parent().height());
                });
            }
        },

        /**
         * Adds the gadget to specified column. If the column is not specified then the gadget is added to the first column.
         *
         * @method addGadget
         * @param {AG.Gadget, Object} gadget - Gadget instance to add
         * @param {Number} column - Column in current layout (optionial)
         */
		addGadget: function (gadget, column) {

            var that = this,
                rpctoken;

            function hideGadget () {
                gadget.getElement().layoutRep.addClass("hidden");
                gadget.getElement().hide();
                gadget.getLayoutManager().refresh();
            }

            function showGadget () {
                delete gadget.hasBeenDropped;
                gadget.getElement().layoutRep.removeClass("hidden");
                gadget.getElement().show();
                gadget.getLayoutManager().refresh();
            }

            function validateAdd (numGadgets) {
                if (parseInt(numGadgets) >= AG.param.get("maxGadgets")) {
                    showGadget();
                    alert(AG.param.get("dashboardErrorTooManyGadgets"));
                } else {
                    gadget.move(that.options.resourceUrl);
                }
            }

            function appendToColumn () {

                if (!that.initialized) {
                    that.columns.eq(column).append(gadget.getElement().layoutRep);
                } else {
                    that.columns.eq(column).prepend(gadget.getElement().layoutRep);
                }
            }

            function isFromDifferentLayout () {
                return AJS.$.isFunction(gadget.getLayoutManager);
            }

            function ensureIframeDoesntCache () {
                AJS.$("iframe", gadget.getElement()).each(function() {
                    this.src = this.src;
                    this.contentWindow.location = this.src;
                });
            }

            if (!isFromDifferentLayout()) {
                column = column || gadget.column || 0;

                gadget = gadget.loaded ? gadget : AG.Gadget.getNullGadgetRepresentation(gadget);

                // create the rpctoken that will be used in rpc calls
                rpctoken = Math.round(Math.random() * 10000000);
                if (gadget.renderedGadgetUrl.indexOf("#rpctoken") == -1) {
                    gadget.renderedGadgetUrl += "#rpctoken=" + rpctoken;
                } else {
                    gadget.renderedGadgetUrl = gadget.renderedGadgetUrl.replace(/#rpctoken=\d*/, "#rpctoken=" + rpctoken);
                }

                // extend gadget descriptor with layout descriptor.
                gadget.layout = this.options;

                // constructs gadget object & methods.
                gadget = AG.Gadget(gadget);

                appendToColumn();

                AG.DashboardManager.getDashboard().contents.append(gadget.getElement());
                gadget.updatePosition();

                // setup the iframe to send/receive rpc calls
                gadgets.rpc.setAuthToken(gadget.getElement().find("iframe").attr("id"), rpctoken);

                ensureIframeDoesntCache();

                // adds to sortable control
                AG.Sortable.update();

            } else {
                hideGadget();
                AJS.$.get(this.options.resourceUrl + "/numGadgets", function (numGadgets) {
                    validateAdd(numGadgets);
                });
            }

            // note: only refreshes after all gadgets are appended.
            this.refresh();

            // store reference to instance
            this.gadgets.push(gadget);

            return gadget;
        },

        markReadOnlyLayout: function () {
            if (!this.isWritable()) {
                this.tab.addClass("inactive");
            }
        },
        onInit: function (callback) {
            if (!this.initialized) {
                this.onInit.callbacks = this.onInit.callbacks || [];
                this.onInit.callbacks.push(callback);
            } else {
                callback();
            }
        },
        unmarkReadOnlyLayout: function () {
            if (!this.isWritable() && this.tab.hasClass("inactive")) {
                this.tab.removeClass("inactive");
            }
        },

        isWritable: function () {
            return this.options.writable;
        },

        getPublicInstance: function () {

            var that = this;

            if (!this.publicInterface) {
                this.publicInterface = {
                    unmarkReadOnlyLayout: function () {
                        return that.unmarkReadOnlyLayout.apply(that, arguments);
                    },
                    markReadOnlyLayout: function () {
                        return that.markReadOnlyLayout.apply(that, arguments);
                    },
                    isWritable: function () {
                        return that.isWritable.apply(that, arguments);
                    },
                    activate: function () {
                        return that.activate.apply(that, arguments);
                    },
                    deactivate: function () {
                        return that.deactivate.apply(that, arguments);
                    },
                    getGadgets: function () {
                        return that.getGadgets.apply(that, arguments);
                    },
                    getLayout: function () {
                        return that.layout;
                    },
                    getContainer: function () {
                        return that.container;
                    },
                    getColumn: function () {
                        return that.columns;
                    },
                    setLayout: function () {
                        return that.setLayout.apply(that, arguments);
                    },
                    addGadget: function () {
                        return that.addGadget.apply(that, arguments);
                    },
                    removeGadget: function () {
                        return that.removeGadget.apply(that, arguments);
                    },
                    refresh: function () {
                        return that.refresh.apply(that, arguments);
                    },
                    init: function () {
                        return that.init.apply(that, arguments);
                    },
                    saveLayout: function () {
                        return that.saveLayout.apply(that, arguments);
                    },
                    getId: function () {
                        return that.options.id;
                    },
                    onInit: function () {
                        return that.onInit.apply(that, arguments);
                    }
                };
            }

            return this.publicInterface;
        },



        init: function () {
            var that = this, canvasGadget;
            this.gadgets = [];
            this.options.gadgets = this.options.gadgets || [];


            function getCanvasGadgetRepresentation (gadgets) {
                var canvasGadget;
                 AJS.$.each(that.options.gadgets, function () {
                    if (AG.Gadget.isCanvasView(this.id)) {
                        canvasGadget = this;
                        return false;
                    }
                });
                return canvasGadget;
            }

            /**
             * Auto-adjust the number of characters to truncate in the tab label
             * to fit the capacity of the tab.
             * 
             * @param label The jQuery object of the tab label in a "span".
             * @param capacity The width of the tab avaiable for rendering a tab (pixel).
             */
            function fitTab(label, capacity) {
                var labelText = label.text();

                /*
                 * HtmlUnit doesn't seem to update the element width while executing this, which results in an infinite
                 * loop when running the integration tests against a page with tabs if we don't have a second condition
                 * that terminates the loop.  So, as a failsafe, don't let the label text go below three characters.
                 * (AG-882)
                 */
                while (label.width() >= capacity && labelText.length >= 3) {
                    labelText = labelText.slice(0, labelText.length - 1);
                    label.text(labelText + '...');
                }
            }

            function appendTab () {
                var labelSpan = AJS.$('<span />').text(that.options.title).attr("title", that.options.title),
                    labelStrong = AJS.$("<strong />").append(labelSpan),
                    capacity;

                that.tab = AJS.$("<li />");

                if (that.options.uri) {
                    that.tab.append(AJS.$("<a href='" + that.options.uri + "' />").append(labelStrong));
                } else {
                    that.tab.append(labelStrong);
                    that.tab.addClass("active");
                }

                that.tab.get(0).getLayoutInstance = function () {
                    return that.getPublicInstance();
                };

                that.tab.appendTo(AG.DashboardManager.getDashboard().tabContainer);

                capacity = AG.DashboardManager.getDashboard().tabContainer.innerWidth() -
                               parseInt(labelStrong.css('padding-left')) -
                               parseInt(labelStrong.css('padding-right'));
                fitTab(labelSpan, capacity);

                AJS.$("li:first",  AG.DashboardManager.getDashboard().tabContainer).addClass("first");

                if(that.isWritable() && that.options.active === false) {
                    AG.Sortable.addHotSpot(that.tab, function (gadget) {
                        that.addGadget(gadget);
                    });
                }
            }

            function appendColumns () {
                that.container = AJS.$("<div class='layout' />").appendTo(AG.DashboardManager.getDashboard().contents);
                that.columns = AJS.$("<ul />").addClass("column first")
                .add(AJS.$("<ul />").addClass("column second"))
                .add(AJS.$("<ul />").addClass("column third"))
                .appendTo(that.container);
            }

            function appendGadgets () {
                AJS.$.each(that.options.gadgets, function () {
                    that.addGadget(this);
                });
            }

            function setInitialized () {
                that.initialized = true;
                if (that.onInit.callbacks) {
                    AJS.$.each(that.onInit.callbacks, function () {
                        this();
                    });
                }
                that.refresh();
            }

            if (AG.DashboardManager.getDashboard().tabContainer) {
                appendTab();
            }

            if (this.options.active !== false) {
                appendColumns();

                this.setLayout(this.options.layout, false);

                canvasGadget = getCanvasGadgetRepresentation(this.options.gadgets);

                if (canvasGadget) {
                    canvasGadget = this.addGadget(canvasGadget);
                    canvasGadget.setView("canvas");
                    canvasGadget.updatePosition();

                    AJS.$.aop.after({target: canvasGadget, method: "setView"}, function () {
                        canvasGadget.remove();
                        that.removeGadget(canvasGadget);
                        appendGadgets();
                        setInitialized();
                    });
                } else {
                    appendGadgets();
                    setInitialized();
                }
            }
        }
	};

    AG.LayoutManager = function (options) {

        // Using prototype as there could be many gadgets on the page. This is most memory efficient.
        var layoutManager = Object.create(LayoutManager);


        layoutManager.options = options;

        // define public interface
        return layoutManager.getPublicInstance();

    };


    /**
     * @property layouts
     * @type Array
     * @static
     */
    AG.LayoutManager.layouts = ["A", "AA", "BA", "AB", "AAA"];

    /**
     * @method getLayoutAttrName
     * @static
     * @param layout
     */
    AG.LayoutManager.getLayoutAttrName = function (layout) {
        return "layout-" + layout.toLowerCase();
    };

}());






/**
 * Gadget implementation.
 *
 * @module dashboard
 * @class Gadget
 * @constructor
 * @namespace AG
 */

(function(){

    function FauxList (listContainer) {

        var that = this, ENTER_KEY = 13;

        this.container = AJS.$(listContainer);
        this.values = AJS.$("input.list", this.container).val().split("|");
        this.originalValues = this.values.join("|").split("|"); // creating a separate array - ugly but it works.

        // Create fake form elements and add to container
        this.container.append("<input class=\"text med js\" name=\"add-to-list\" type=\"text\" value=\"\" />"
                + "<button class=\"submit-to-list js\">" + AG.param.get("add") + "</button>");

        // Add list items to list individually
        this.container.children(".submit-to-list").click(function(e) {
            that.addToList();
            e.preventDefault();
        });

        AJS.$("input[name=add-to-list]", this.container).keydown(function(e) {
            if (e.keyCode == ENTER_KEY) {
                that.addToList();
                e.preventDefault();
            }
        });

        // Hide original form elements but leave them available for hijacking. Cannot use comma seperated selector because
        // safari 3 was freaking out and throwing exception. 
        AJS.$("input", this.container).addClass("hidden");
        AJS.$("span", this.container).addClass("hidden");

        this.create(this.values);
    }

    FauxList.prototype = {


        reset: function () {
            this.create(this.originalValues);
        },

        create: function (values) {

            var ul, listItem, that = this;

            // If the list is empty, skip all of this.
            if (values) {

                // Strip empty values
                AJS.$.each(values, function() {
                    if (this == "") {
                        values.splice(values.indexOf(this), 1);
                    }
                });

                // Create UL to hold visible list
                ul = AJS.$("<ul class=\"faux-list\"></ul>");

                // Create list for any list items
                // Else, remove if none
                if (values.length > 0) {
                    for (var i = 0, ii = values.length; i < ii; i++) {

                        // Make LI element with delete functionality
                        listItem = AJS.$("<li class=\"listvalue-" + i + "\"><span>" + values[i] +
                                         "</span><a href=\"#remove-from-list\" title=\"" +
                                         AG.param.get("removeFromList") + "\">x</a></li>");

                        // Remove list items from list individually
                        AJS.$("a", listItem).click(function(e) {

                            // Grab the value to be removed from the array
                            var removeValue = AJS.$(this).parent("li").attr("class").split("-")[1];

                            // Find the index of the value and remove it
                            values.splice(removeValue, 1);

                            if (values.length > 0) {
                                that.create(values);
                            }
                            else {
                                AJS.$("input.list",     this.container).val("");
                            }

                            // Remove LI from visible list
                            listItem.remove();
                            e.preventDefault();
                        });

                        // Add new list items to ul.faux-list
                        ul.append(listItem);
                    }

                    // If no values existed, add ul.faux-list before the old input
                    // Else, replace old .faux-list with new version
                    if (AJS.$("ul.faux-list", this.container).length == 0) {
                        AJS.$("input.list", this.container).before(ul);
                    }
                    else {
                        AJS.$("ul.faux-list", this.container).replaceWith(ul);
                    }
                }
                else {
                    AJS.$("ul.faux-list", this.container).remove();
                }

                // Rewrite the old input value with current array
                AJS.$("input.list", this.container).val(values.join("|"));

                AG.DashboardManager.getLayout().refresh();

            }
        },

        addToList: function () {
            // Stripping pipes from our pipe-delimited input
            var newValue = AJS.$("input[name=add-to-list]", this.container).val().replace(/\|+/g, '%7C');

            //Grab value from new input and add to array
            this.values.push(newValue);

            // Clear new input
            AJS.$("input[name=add-to-list]", this.container).val("");

            // Remake the list
            this.create(this.values);
        }
    };

    var Gadget =  {

        /**
         * Draws gadget, preference form and furniture
         *
         * @method draw
         */
        draw: function (json) {

            var that = this;

            function createElement () {
                json.minimized = that.minimized;
                json.view = that.view;
                that.$ = AJS.$(AG.render("gadget", json));
                that.$.updateShadow = function () {
                    var attrs = {
                        width: that.$.width() + 32,
                        height: that.$.height() + 29
                    };

                    that.$.shadow.sides.css("height", attrs.height - 46);
                    that.$.shadow.bottom.css("width", attrs.width - 58);
                    that.$.shadow.css(attrs);
                };
            }

            function setElementShortcuts () {
                that.$.layoutRep = AJS.$("<li class='gadget' id='rep-" + json.id + "' />").height(that.$.height());
                that.$.shadow = AJS.$("div.shadow", that.$);
                that.$.shadow.bottom = AJS.$("div.b", that.$.shadow);
                that.$.shadow.sides = AJS.$("div.l", that.$.shadow).add(AJS.$("div.r", that.$.shadow));
                that.$.layoutRep.get(0).getGadgetInstance = that.$.get(0).getGadgetInstance = function () {
                    return that.getPublicInstance();
                };
            }

            function applyDropdownControls () {
                
                var
                ACTIVE_CLASS    = "dropdown-active",
                ddParent        = AJS.$("li.aui-dd-parent", that.$);
                
                ddParent.mousedown(function (e) {
                    e.stopPropagation();
                });

                that.$.dropdown = ddParent.dropDown("standard", {
                    selectionHandler: function (e) {
                        e.preventDefault();
                    },
                    item: "> li"
                })[0];

                that.$.dropdown.addCallback("show", function () {
                    that.$.addClass(ACTIVE_CLASS);
                    that.$.updateShadow(); // using shadow as shim.
                    AG.DashboardManager.showShims();
                });

                that.$.dropdown.addCallback("hide", function () {
                    that.$.removeClass(ACTIVE_CLASS);
                    // if we are not dragging
                    AG.DashboardManager.hideShims();
                });

                that.$.hover(function () {}, function () {
                    if (that.$.dropdown.$.is(":visible")) {
                        that.$.dropdown.hide();
                    }
                });
            }

            function applyGadgetHoverControls () {

                var HOVER_CLASS = "gadget-hover";

                that.$.hover(function() {
                    AJS.$(".gadget-container", that.$).addClass(HOVER_CLASS);
                }, function () {
                    AJS.$(".gadget-container", that.$).removeClass(HOVER_CLASS);
                });
            }

            function applyColorControls () {
                AJS.$(".gadget-colors a", that.$).click(function (e) {
                    that.setColor(this.parentNode.className);
                    e.preventDefault();
                });
            }

            function applyMinimizeControls () {

                var
                menuElem    = AJS.$("a.minimization, a.maximization", that.$),
                titleElem   = AJS.$(".dashboard-item-title", that.$),

                maxMinToggle = function (e) {

                    if (that.minimized) that.maximize();
                    else that.minimize();

                    AJS.$(this).one(e.type, function (e) {
                        if (that.minimized) that.maximize();
                        else that.minimize();
                        AJS.$(this).one(e.type, maxMinToggle);
                    });
                };

                titleElem.one("dblclick", maxMinToggle);
                menuElem.one("click", maxMinToggle);

                /* AJS.$.browser is deprecated, for the preferred feature detection. However feature detection cannot detect safari. */
                if (AJS.$.browser.safari) {
                    /* stops double click from selecting title text */
                    titleElem.get(0).onselectstart = function () {
                        return false;
                    };
                }

            }

            function applyFocusControls () {

                var column;

                AJS.$(".dashboard-item-header", that.$).mousedown(function (e) {

                        if (!that.$.hasClass("maximized")) {
                          
                            if (!column) {
                                column = that.$.layoutRep.parent();
                            }

                             // hide dropdown if it is visible
                            that.$.dropdown.hide();

                            that.$.focusTimeout = setTimeout(function() {
                                that.$.updateShadow();
                                that.$.shadow.show();
                                delete that.$.focusTimeout;
                            }, 150);
                            that.$.layoutRep.trigger(e);
                        }

                    });
                    that.$.mouseup(function () {
                        if (that.$.focusTimeout) {
                            clearTimeout(that.$.focusTimeout);
                        } else if (that.$.layoutRep.is(":visible")) {
                            that.$.stop(true, true);
                            that.$.shadow.hide();
                        }
                    });
            }

            function applyUserPrefControls () {

                var
                fauxLists = [],
                prefForm = AJS.$(".userpref-form", that.$),
                prefsChanged = false,
                savePrefForm = function(success) {
                    var submittedState = prefForm.serializeArray();

                    AJS.$(":checkbox:not(:checked)", prefForm).each(function () {
                        submittedState.push({name: this.name, value: false});
                    });

                    AJS.$.ajax({
                        url: prefForm.attr("action"),
                        type: "POST",
                        data: submittedState,
                        success: success
                    });
                };

                if (that.isEditable()) {
                    // Creates a neater form element for adding multiple values
                    AJS.$(".list-container", that.$).each(function() {
                        fauxLists.push(new FauxList(this));
                    });

                    AJS.$(".edit", that.$).click(function (e) {
                        if (!prefForm.is(":visible")) {
                            if (that.minimized) {
                                that.maximize();
                            }
                            prefForm.show();
                            that.getLayoutManager().refresh();
                        } else {
                            prefForm.hide();
                            that.getLayoutManager().refresh();
                        }
                        e.preventDefault();
                    });

                    prefForm.submit(function (e) {
                        savePrefForm(function () {
                            window.location.reload();
                        });

                        e.preventDefault();
                    });

                    AJS.$(":reset", prefForm).click(function () {
                        AJS.$.each(fauxLists, function () {
                            this.reset();
                        });
                        prefForm.hide();
                        that.getLayoutManager().refresh();
                    });
                }

                /*
                 * Event handler for a customed event "setUserPref".  This event
                 * is triggered inside gadgets-dashboard.js -> setUserPref().
                 * It acts like a buffer for all the setPref() calls.
                 * The results are flushed to the server using ajax later.
                 * arguments e is something like [name1, value1, name2, value2]
                 */
                AJS.$("iframe.gadget-iframe", that.$).bind("setUserPref", function (e) {

                    // update the preference form with the given name value pairs
                    for (var i = 1, j = arguments.length; i < j; i += 2) {
                        if (pref_name = arguments[i]) {
                            var pref_value = arguments[i+1];
                            var input = AJS.$(":input[name='up_" + pref_name + "']", prefForm);
                            // checkbox needs a default value of false
                            if (input.attr("type") == "checkbox") {
                                input.attr("checked", pref_value);
                            } else {
                                input.val(pref_value);
                            }
                        }
                    }
                    
                    // flag for whether a flush is scheduled
                    if(!prefsChanged) {
                        setTimeout(function () {
                            savePrefForm(function () {} );
                            prefsChanged = false;
                        }, 100);
                        prefsChanged = true;
                    }
                });


            }

            function applyDeleteControls () {
                AJS.$("a.delete", that.$).bind("click", function (e) {
                    that.destroy();
                    e.preventDefault();
                });
            }

            function applyViewToggleControls () {

                AJS.$("a.maximize", that.$).click(function (e) {
                    if (!AG.Gadget.isCanvasView(that.id)) {
                        that.getPublicInstance().setView("canvas");
                        e.preventDefault();
                    } else {
                        that.getPublicInstance().setView("default");
                        e.preventDefault();
                    }
                });
            }


            function applyErrorMessage () {
                AJS.$("iframe.gadget-iframe", that.$).load(function() {
                    AJS.$("#error-gadget-message", AJS.$(this).contents()).html(that.errorMessage);
                });
            }

            createElement();
            setElementShortcuts();
            applyDropdownControls();
            applyGadgetHoverControls();
            applyMinimizeControls();

            if (this.isMaximizable) {
                applyViewToggleControls();
            }

            if (!this.loaded) {
                applyErrorMessage();
            }

            if (this.getLayoutManager().isWritable()) {
                applyDeleteControls();
                applyFocusControls();
                applyColorControls();
                applyUserPrefControls();
            }
        },

        isEditable: function () {
            return !!(this.getLayoutManager().isWritable() && this.hasNonHiddenUserPrefs);   
        },

        setLayoutManager: function (layoutManager) {
            if (layoutManager) {
                this.layoutManager = layoutManager;
            } else {
                this.layoutManager = AG.DashboardManager.getLayout();
            }
        },

        /**
         *
         * Provides access to gadget's Layout manager. When the gadget
         * needs to know how it's owner is. Such as in the method destroy
         * where we need to also remove it from the layout.
         *
         * @method getLayoutManager
         */
        getLayoutManager: function () {
            if (!this.layoutManager) {
                this.setLayoutManager();
            }
            return this.layoutManager;
        },

        /**
         * Sets gadget chrome colour. Gets chrome and applies associated class and
         * sends preference back to server to persist.
         *
         * @method setColor
         */
        setColor: function (color) {

            var that = this;

            that.$.removeClass(that.color).addClass(color);
            that.color = color;
            AJS.$.ajax({
                type: "post",
                url: that.colorUrl,
                data: {method: "put", color: color},
                error: function(request) {
                    if (request.status == 403 || request.status == 401) {
                        alert(AG.param.get("dashboardErrorDashboardPermissions"));
                    } else {
                        alert(AG.param.get("dashboardErrorCouldNotSave"));
                    }
                }
            });
        },
        
        updatePosition: function () {

            var
            gadgetCSSToUpdate,
            layoutCSSToUpdate,
            that = this;

            function isGadgetBeingDragged () {
                return that.$.hasClass("dragging");
            }

            function getCurrentGadgetCSS () {
                var
                LAYOUT_REP_OFFSET,
                dashboard = AG.DashboardManager.getDashboard().contents,
                DASHBOARD_OFFSET  = dashboard.offset();

                if (!getCurrentGadgetCSS.cache) {
                    LAYOUT_REP_OFFSET = that.$.layoutRep.offset();
                    getCurrentGadgetCSS.cache = {
						left: (LAYOUT_REP_OFFSET.left - DASHBOARD_OFFSET.left) / dashboard.width() * 100 + "%",
						top: LAYOUT_REP_OFFSET.top - DASHBOARD_OFFSET.top,
						width: that.$.layoutRep.width() / dashboard.width() * 100 + "%"
					};
                }
                return getCurrentGadgetCSS.cache;
            }

            function getCurrentLayoutRepCSS () {
                if (!getCurrentLayoutRepCSS.cache) {
                    getCurrentLayoutRepCSS.cache = {
						height: that.$.height()
                    };
                }
                return getCurrentLayoutRepCSS.cache;
            }

            function filterModifiedCSS (lastRecordedCSS, currentCSS) {
                if (lastRecordedCSS)  {
                    AJS.$.each(lastRecordedCSS, function(property){
						if (this === currentCSS[property]) {
							delete currentCSS[property];
						}
					});
                }
                return currentCSS;
            }

            if (!isGadgetBeingDragged()) {
                layoutCSSToUpdate = filterModifiedCSS(this.$.layoutRep.lastRecordedCSS, getCurrentLayoutRepCSS());
                this.$.layoutRep.css(layoutCSSToUpdate);
                this.$.layoutRep.lastRecordedCSS = layoutCSSToUpdate;

                gadgetCSSToUpdate = filterModifiedCSS(this.$.lastRecordedCSS, getCurrentGadgetCSS());
                this.$.css(gadgetCSSToUpdate);
                this.$.lastRecordedCSS = gadgetCSSToUpdate;

                if (this.$.hasClass("hidden")) {
                    this.$.removeClass("hidden");
                }
            }

        },

        /**
         * Minimises gadget. Hides everything but title bar.
         *
         * @method maximize
         */
        maximize: function () {
            var
            MIN_CLASS   = "minimization",
            MAX_CLASS   = "maximization",
            MIN_TEXT    = AG.param.get("minimize"),
            menuElem    = AJS.$("a.minimization, a.maximization", this.$);

            menuElem.removeClass(MAX_CLASS).addClass(MIN_CLASS).text(MIN_TEXT);

            // need to reset height to auto because sortable control sets an explicit pixel height
            this.$.css({height: "auto"});
            AJS.$(".dashboard-item-content", this.$).removeClass(MIN_CLASS);
            // updates positioning of gadgets & their layout references
            this.getLayoutManager().refresh();

            /* erase cookie */
            AG.Cookie.erase(this.COOKIE_MINIMIZE);
            this.minimized = false;
        },

        minimize: function () {

            var
            MIN_CLASS   = "minimization",
            MAX_CLASS   = "maximization",
            MAX_TEXT    = AG.param.get("expand"),
            menuElem    = AJS.$("a.minimization, a.maximization", this.$);

            menuElem.removeClass(MIN_CLASS).addClass(MAX_CLASS).text(MAX_TEXT);

            // need to reset height to auto because sortable control sets an explicit pixel height
            this.$.css({height: "auto"});
            AJS.$(".dashboard-item-content", this.$).addClass(MIN_CLASS);
            this.getLayoutManager().refresh();
            AG.Cookie.save(this.COOKIE_MINIMIZE, "true");
            this.minimized = true;
        },

        remove: function () {
            var that = this;
            window.setTimeout(function () {
                that.$.layoutRep.remove();
                that.$.remove();
                that.getLayoutManager().removeGadget(that.getPublicInstance());
                that.getLayoutManager().refresh();
                 // remove from memory
                AJS.$.each(this, function (name, property) {
                    property = null;
                });
            }, 10);
        },

        /**
         * Moves gadget from the dashboard it's currently on to a new dashboard specified
         * by the target resource URL
         */
        move: function (targetResourceUrl) {
            this.remove();

            AJS.$(AJS.$.ajax({
                type: "post",
                data: {method: "put",
                       id : this.id,
                       title : this.title,
                       titleUrl : this.titleUrl,
                       gadgetSpecUrl : this.gadgetSpecUrl,
                       height : this.$.height(),
                       width : this.$.width(),
                       color : this.color,
                       isMaximizable : this.isMaximizable,
                       userPrefs : this.userPrefs,
                       renderedGadgetUrl : this.renderedGadgetUrl,
                       colorUrl : this.colorUrl,
                       gadgetUrl : this.gadgetUrl,
                       hasNonHiddenUserPrefs : this.hasNonHiddenUserPrefs,
                       column : this.column,
                       loaded : this.loaded
                },
                contentType: "application/json",
                url: targetResourceUrl + "/gadget/" + this.id
            })).throbber({target: AJS.$("#dash-throbber")});
        },

        /**
         * Removes gadget from dashboard and deletes object references
         *
         * @method destroy
         */
        destroy: function () {

            var that = this;

            if (confirm(AG.param.get("areYouSure") + " " + that.title + " " + AG.param.get("gadget"))) {
                AJS.$.ajax({
                    type: "POST",
                    url: this.gadgetUrl,
                    data: {
                        method: "delete"
                    },
                    success: function() {
                        that.$.fadeOut(function () {
                            that.remove();
                            if (that.view === "canvas") {
                                that.setView("default");
                            }
                        });
                    },
                    error: function(request) {
                        if (request.status == 403 || request.status == 401) {
                            alert(AG.param.get("dashboardErrorDashboardPermissions"));
                        }
                        else {
                            alert(AG.param.get("dashboardErrorCouldNotSave"));
                        }
                    }
                });
            }
        },

        /**
         * Sets the layout of the gadget to either canvas or dashboard. Does
         * so by delegating layout actions to LayoutManager.
         *
         * @method setView
         * @param {String} view - Accepts either "canvas" or "dashboard"
         */
        setView: function (view) {
            var
            MAXIMIZED_CLASS = "maximized",
            uri,
            that = this,
            anchor = this.title.replace(/\s/g,"-") + "/" + this.id,
            layoutManager = this.getLayoutManager(),
            rpctoken;


            function toDefaultViewHandler () {
                that.getPublicInstance().setView("default");
            }

            if (this.view === view) {
                return;
            }

            if (view === "canvas" || view === "default") {

                // use rendered url to get latest user prefs and a fresh security token
                AJS.$.ajax({
                    async: false,
                    type: "GET",
                    url: this.gadgetUrl,
                    dataType: "json",
                    success: function(rep){
                        // create the rpctoken that will be used in rpc calls
                        rpctoken = Math.round(Math.random() * 10000000);

                        uri = AJS.parseUri(rep.renderedGadgetUrl + "#rpctoken=" + rpctoken);
                    }
                });

                AJS.$(".operations li", AG.DashboardManager.getDashboard()).toggleClass("hidden");

                // setup the iframe to send/receive rpc calls
                gadgets.rpc.setAuthToken(AJS.$("iframe.gadget-iframe", this.$).attr("id"), rpctoken);

                if (view === "canvas") {

                    AJS.$.extend(uri.queryKey, { view: "canvas" });
                    AJS.$("iframe.gadget-iframe", this.$).attr("src", uri.toString());

                    layoutManager.getContainer().addClass(MAXIMIZED_CLASS);
                    AJS.$(".gadget-container", this.$).addClass(MAXIMIZED_CLASS);
                    AJS.$(".aui-icon",this.$).attr("title", AG.param.get("restoreFromCanvasMode"));
                    this.$.layoutRep.addClass(MAXIMIZED_CLASS);
                    this.$.layoutRep.parent().addClass(MAXIMIZED_CLASS);

                    // Not really sure about this, would prefer to add a class to the body tag. Problem is I can't as I
                    // do not want every gadget to be hidden, in the case of multiple tabs this would cause problems.
                    AJS.$.each(this.getLayoutManager().getGadgets(), function () {
                        if (that.getPublicInstance() !== this) {
                            this.getElement().hide();
                        }
                    });

                    AJS.$.extend(uri.queryKey, { view: "canvas" });
                    AJS.$("iframe.gadget-iframe", this.$).attr("src", uri.toString());
                    
                    this.maximize();
                    // add bookmarking capabilities
                    window.location.href = window.location.href.replace(/#.*/, "") + "#" + anchor;
                    AJS.$(".minimize", AG.DashboardManager.getDashboard()).click(toDefaultViewHandler);
                    this.view = "canvas";

                } else {

                    layoutManager.getContainer().removeClass(MAXIMIZED_CLASS);
                    AJS.$(".gadget-container", this.$).removeClass(MAXIMIZED_CLASS);
                    AJS.$(".aui-icon",this.$).attr("title", AG.param.get("maximize"));
                    this.$.layoutRep.removeClass(MAXIMIZED_CLASS);
                    this.$.layoutRep.parent().removeClass(MAXIMIZED_CLASS);

                    // Not really sure about this, would prefer to add a class to the body tag. Problem is I can't as I
                    // do not want every gadget to be hidden, in the case of multiple tabs this would cause problems.
                    AJS.$.each(this.getLayoutManager().getGadgets(), function () {
                        if (that.getPublicInstance() !== this) {
                            // seems to be a bug so need to recreate jQuery object to be able to toggle classa
                            this.getElement().show();
                        }
                    });

                    AJS.$.extend(uri.queryKey, { view: "default" });
                    AJS.$("iframe.gadget-iframe", this.$).attr("src", uri.toString());
                    this.getLayoutManager().refresh();
                    window.location.href = window.location.href.replace(anchor, "");
                    AJS.$("a.minimize", AG.DashboardManager.getDashboard()).unbind("click", toDefaultViewHandler);
                    this.view = "default";
                }

            }
            /* debug */
            else {
                console.warn("AG.Gadget.setView: Ignored! not a valid view. Was supplied '" + view + "' but expected "
                        + "either 'default' or 'canvas'");
            }
            /* debug end */
        },
    

        /**
         * Displays edit preferences form
         *
         * @method editPrefs
         */
        editPrefs: function () {},

        getPublicInstance: function () {

            var gadget = this;

            if (!this.publicInterface) {
                this.publicInterface = {
                    updatePosition: function () {
                        return gadget.updatePosition.apply(gadget, arguments);
                    },
                    getLayoutManager: function () {
                        return gadget.getLayoutManager.apply(gadget, arguments);
                    },
                    setLayoutManager: function () {
                        return gadget.setLayoutManager.apply(gadget, arguments);
                    },
                    getElement: function () {
                        return gadget.$;
                    },
                    move: function (targetUrl) {
                    	return gadget.move(targetUrl);
                    },
                    remove: function () {
                        return gadget.remove.apply(gadget, arguments);
                    },
                    getId: function () {
                        return gadget.id;
                    },
                    showShim: function () {
                        return gadget.showShim.apply(gadget, arguments);
                    },
                    hideShim: function () {
                        return gadget.hideShim.apply(gadget, arguments);
                    },
                    minimize: function () {
                        return gadget.minimize.apply(gadget, arguments);
                    },
                    maximize: function () {
                        return gadget.minimize.apply(gadget, arguments);
                    },
                    getSecurityToken: function() {
                    	return gadget.securityToken;
                    },
                    setSecurityToken: function(securityToken) {
                    	gadget.securityToken = securityToken;
                    }
                };

                if (this.isMaximizable) {
                    this.publicInterface.setView = function () {
                        return gadget.setView.apply(gadget,  arguments);
                    };
                }
            }

            return this.publicInterface;
        },

        init: function (options) {
            this.COOKIE_MINIMIZE = options.id + ":minimized";
            this.minimized = AG.Cookie.read(this.COOKIE_MINIMIZE) === "true";
            this.title = options.title;
            this.color = options.color;
            this.colorUrl = options.colorUrl;
            this.gadgetUrl = options.gadgetUrl;
            this.id = options.id;
            this.hasNonHiddenUserPrefs = options.hasNonHiddenUserPrefs;
            this.isMaximizable = options.isMaximizable;
            this.titleUrl = options.titleUrl;
            this.gadgetSpecUrl = options.gadgetSpecUrl;
            this.userPrefs = options.userPrefs;
            this.renderedGadgetUrl = options.renderedGadgetUrl;
            this.column = options.column;
            this.loaded = options.loaded;
            this.errorMessage = options.errorMessage;
            this.securityToken = AJS.parseUri(options.renderedGadgetUrl).queryKey["st"];
            this.draw(options);
        }
    };

    AG.Gadget = function (options) {

        // Using prototype as there could be many gadgets on the page. This is most memory efficient.
        var gadget = AJS.clone(Gadget);

        gadget.init(options);

        return gadget.getPublicInstance();
    };

    AG.Gadget.COLORS = [1, 2, 3, 4, 5, 6, 7, 8];

    AG.Gadget.getColorAttrName = function (color) {
        return "color" + color;
    };

    AG.Gadget.isCanvasView = function (gadgetId) {
        var uri = AJS.parseUri(window.location.href);
        return new RegExp(gadgetId).test(uri.anchor);
    };

    AG.Gadget.getNullGadgetRepresentation = function (errorGadget) {
        return AJS.$.extend(errorGadget, {
            title: AG.param.get("errorGadgetTitle"),
            renderedGadgetUrl : AG.param.get("errorGadgetUrl"),
            color: errorGadget.color || "color7"
        });
    };

})();



AG.render = function () {

    var TEMPLATES_IFRAME_ID = "templates", parsers = {},

    setParser = function (template, parser) {
        parsers[template] = parser;
    },

    getParser = function (template) {
        return parsers[template];
    },

    setContext = function () {

        AG.render.ctx = "body";

        /* debug */
        if (AG.render.ctx.length === 0) {
            console.error("AG.render: Rendering Failed! <iframe> storing templates is either not present OR has been" +
                    "included AFTER the call to this method");
        }
        /* debug end */
    },

    bindMacros = function (template, ignore) {

        var str = "", macros = [];

        ignore = ignore || [];

        //can't use string replace here since htmlunit can't handle it.
        var matches = template.match(/(?:\$[\W]*)(\w+)(?:\s*\([^\}]+})/gi);

        if (matches) {
            AJS.$.each(matches, function () {
                var macroName = this.replace(/\$\{([\d\w]*).*/, "$1");
                 if (AJS.$.inArray(macroName, macros) === -1) {
                    if (AJS.$.inArray(macroName, ignore) === -1 ) {
                        macros.push(macroName);
                        ignore.push(macroName);
                    }
                }
            });
        }

        AJS.$.each(macros, function () {
            var macro = AJS.$("#" + this, AG.render.ctx).html();
            str += bindMacros(macro, ignore);
            str += ["<?macro " + this + "(data)?>", macro, "<?/macro?>"].join("");
        });

        if (arguments.length === 1) {
            str += template;
        }

        return str;
    },

    render = function (descriptor) {

        var templateSrc, template = descriptor.useTemplate, parser = getParser(template);

        if (!parser) {
            parser = new ZParse(Implementation);

            templateSrc = AJS.$("#" + template);

            if (template.length > 0) {
                parser.parse(bindMacros(templateSrc.html()));
                setParser(template, parser);
            }
            /* debug */
            else {
                console.error("AG.render: Rendering Failed! Template '" + template + "' does not exist.");
            }
            /* debug end */
        }

        /* debug */
        else {
            console.log("AG.render: Using cached parser");
        }
        /* debug end */

        return parser.process(descriptor);
    };

    return function (descriptor, data) {
        if (typeof descriptor !== "object") {
            descriptor = AG.render.getDescriptor(descriptor, data);
        }

        if (!AG.render.ctx) {
            setContext();
        }

        return render(descriptor);
    };
}();


AG.render.ready = function (func) {
    AG.render.ready.callbacks.push(func);
};

AG.render.ready.callbacks = [];

AG.render.initialize = function () {
    AJS.$.each(AG.render.ready.callbacks, function () {
        this();
    });
};

AG.render.getDescriptor = function () {


    var descriptors = {

        layoutDialog: function (args) {
            return AJS.$.extend({closeId: "dialog-close"}, args);
        },

        gadget: function (args) {

            function generateMenuItems () {

                var menu = [];

                function isEditable () {
                    return !!(isWritable() && args.hasNonHiddenUserPrefs);
                };

                function isWritable () {
                    return args.layout.writable;
                };

                function generateColorList () {
                    var colorList = [];
                    AJS.$.each(AG.Gadget.COLORS, function () {
                        var color = AG.Gadget.getColorAttrName(this);
                        colorList.push({
                            styleClass: color,
                            link: {
                                href: "#",
                                text: AG.param.get(color)
                            }
                        });
                    });
                    return {
                        styleClass: "gadget-colors",
                        items: colorList
                    };
                }
                
                if (isEditable()) {
                    menu.push({
                        link: {
                            styleClass: "edit",
                            href: "#gadget-" + args.id + "-edit",
                            text: AG.param.get("edit")
                        }
                    });
                }

                menu.push({
                    link: {
                        styleClass: args.minimized ? "maximization" : "minimization",
                        href: "#",
                        text: args.minimized ? AG.param.get("expand") : AG.param.get("minimize")
                    }
                });

                if (isWritable()) {
                    menu.push(generateColorList());
                    menu.push({
                        link: {
                            styleClass: "delete",
                            href: "#",
                            text: AG.param.get("remove")
                        }
                    });
                }

                return menu;
            }

            return AJS.$.extend({
                menu: {
                    trigger: {
                        text: "Gadget menu",
                        href: "#"
                    },
                    list: {
                        items: generateMenuItems()
                    }
                }
            }, args);
        },

        dashboardMenu: function (args) {
           return args;
        }
    };


    return function (name, data) {
        var descriptor;

        if (AJS.$.isFunction(descriptors[name])) {
            descriptor = descriptors[name](data);
        } else if (descriptors[name]) {
            descriptor = descriptors[name];
        }

        /* debug */
        else {
            console.error("AG.render.getDescriptor: Could not find descriptor '" + name + "'");
        }
        /* debug end */

        if (descriptor) {
            return AJS.$.extend(descriptor, {
                useTemplate: name
            });
        }

    };

}();







/**
 * <p>Singleton that provides simple get and set mechanism for param strings. Has support for
 * <a href="http://java.sun.com/j2se/1.4.2/docs/api/java/text/MessageFormat.html">Java's MessageFormat</a> syle.</p>
 *
 * <p><strong>Note:</strong> this is a replacement for AJS.params because it is leaner and faster then getting strings
 * form html document. It should <strong>ONLY</strong> be used for <strong>SAFE STRINGS</strong></p>
 *
 * @module dashboard
 * @class param
 * @static
 * @namespace AG
 */

/*global console, AJS*/
/*jslint bitwise: true, eqeqeq: true, immed: true, newcap: true, nomen: true, onevar: true, plusplus: true, regexp: true, undef: true, white: true, indent: 4 */

if (typeof AG === "undefined") {
    var AG = {};
}

AG.param = (function () {

    /**
     * Map containing param strings
     * @property strs
     * @private
     * @type Object
     */
	var strs = {};

	return {

		/**
         * Gets param string of provided key, and if necessary substitutes params using Javas MessageFormat
         *
         * <dl>
         *  <dt>Usage</dt>
         *  <dd>
         *      <pre>AG.param.get ("dashboard.add.message", "simple", "test");</pre>
         *  </dd>
         * </dl>
         *
		 * @method get
		 * @param {String} key of param string
    	 * @param {String} arg replacement value for token 0, with subsequent arguments being 1, etc.
         * @return {String} the param string with tokens replaced with supplied arguments
		 */
		get: function (key) {
            var args = arguments;
            if (strs[key]) {
                if (arguments.length > 1) {
                    args[0] = strs[key];
                    return AJS.format.apply(this, args);
                } else {
                    return strs[key];
                }
			}

			else {
                /* debug */
				console.warn("param.get: Key '" + key + "' does not exist.");
                /* debug end */
                return key;
			}

		},

        /**
         * Sets param strings in bulk or individually
         *
         * <dl>
         *  <dt>Usage</dt>
         *
         * <dd>
         *  <pre>
         *   // bulk
         *   AG.param.set ([
         *      {
         *          key: "help.question",
         *          str: "I need help with my dashboard jim"
         *      },
         *      {
         *          key: "help.response",
         *          str: "No worries, {0}
         *      }
         *   ]);
         * </pre>
         * </dd>
         *
         * <dd>
         * <pre>
         *   // individual
         *   AG.param.set({
         *      key: "help.question",
         *      str: "I need help with my dashboard Jim"
         *   });
         * </pre>
         * </dd>
         * </dl>
         *
         *
		 * @method set
		 * @param {Object, Array} param An object with keys <em>key</em> & <em>str</em> and their associated values,
         * or an array of those objects.
		 */
		set: function (key, str) {
            var setParam = function () {
                key = arguments[0] || key;
                str = arguments[1] || str;
                if (typeof key === "string" && typeof str === "string") {
                    strs[key] = str;
                }
                /* debug */
                else {
                    console.warn("param.set: Ignored key '" + key + "', either it or 'str' is undefined. " +
                            "Printing value...");
                    console.log(str);
                }
                /* debug end */
            };
            if (arguments.length === 1 && typeof arguments[0] === "object") {
                AJS.$.each(arguments[0], function (key, str) {
                    setParam(key, str);
                });
            } else if (arguments.length === 2) {
                setParam();
            }
            /* debug */
            else {
                console.warn("param.set: Expected arguments to be of length 1 or 2, however recieved a length of " + 
                             arguments.length + ". Printing value...");
                console.log(arguments);
            }
            /* debug end */
        },

        /* debug */
        clear: function () {
            strs = {};
        }
        /* debug end */
	};

}());


// A conglomerate cookie, so we don't run out.

(function () {

    // Cookie handling functions

    var COOKIE_NAME = "AG.congolmerate.cookie";


    function getValueFromCongolmerate(name, cookieValue) {
        // a null cookieValue is just the first time through so create it
        if(cookieValue == null) {
            cookieValue = "";
        }
        var eq = name + "=";
        var cookieParts = cookieValue.split('|');
        for(var i = 0; i < cookieParts.length; i++) {
            var cp = cookieParts[i];
            while (cp.charAt(0)==' ') {
                cp = cp.substring(1,cp.length);
            }
            // rebuild the value string exluding the named portion passed in
            if (cp.indexOf(name) == 0) {
                return cp.substring(eq.length, cp.length);
            }
        }
        return null;
    }

    //either append or replace the value in the cookie string
    function addOrAppendToValue(name, value, cookieValue)
    {
        var newCookieValue = "";
        // a null cookieValue is just the first time through so create it
        if(cookieValue == null) {
            cookieValue = "";
        }

        var cookieParts = cookieValue.split('|');
        for(var i = 0; i < cookieParts.length; i++) {
            var cp = cookieParts[i];

            // ignore any empty tokens
            if(cp != "") {
                while (cp.charAt(0)==' ') {
                    cp = cp.substring(1,cp.length);
                }
                // rebuild the value string exluding the named portion passed in
                if (cp.indexOf(name) != 0) {
                    newCookieValue += cp + "|";
                }
            }
        }

        // always append the value passed in if it is not null or empty
        if(value != null && value != '') {
            var pair = name + "=" + value;
            if((newCookieValue.length + pair.length) < 4020) {
                newCookieValue += pair;
            }
        }
        return newCookieValue;
    }

    function getCookieValue(name) {
        var
        eq = name + "=",
        ca = document.cookie.split(';');

        for(var i=0;i<ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') {
                c = c.substring(1,c.length);
            }
            if (c.indexOf(eq) == 0) {
                return c.substring(eq.length,c.length);
            }
        }

        return null;
    }

    function saveCookie(name, value, days) {
      var ex;
      if (days) {
        var d = new Date();
        d.setTime(d.getTime()+(days*24*60*60*1000));
        ex = "; expires="+d.toGMTString();
      } else {
        ex = "";
      }
      document.cookie = name + "=" + value + ex + ";path=/";
    }

    AG.Cookie = {
        save : function (name, value) {
            var cookieValue = getCookieValue(COOKIE_NAME);
            cookieValue = addOrAppendToValue(name, value, cookieValue);
            saveCookie(COOKIE_NAME, cookieValue, 365);
        },

        read : function(name, defaultValue) {
            var cookieValue = getCookieValue(COOKIE_NAME);
            var value = getValueFromCongolmerate(name, cookieValue);
            if(value != null) {
                return value;
            }
            return defaultValue;
        },
        erase: function (name) {
            this.save(name, "");
        }
    };
    
})();


AG.Sortable = function () {

    var

    sortableControl,

    dragGadget,

    hotspots = [],

    options = {
        cursor: "move",
        items: "li.gadget",
        tolerance: "pointer",
        placeholder: "placeholder",
        forcePointerForContainers: true,
        scroll: true,
        // not supporting in safari because it does not work in safari 3.
        // I also cannot find a reliable way to check for version.
        revert: AJS.$.browser.safari ? false : 250,
        scrollSensitivity: 300,
        scrollSpeed: 16,
        zIndex: 10,
        helper: function (event, item) {
            return item.get(0).getGadgetInstance().getElement();
        },
        change: function () {
            AG.DashboardManager.getLayout().refresh();
        },
        start: function (event, obj) {

            dragGadget = obj.item.get(0).getGadgetInstance();

            function preventTextSelection () {
                if (typeof document.onselectstart !== "undefined") {
                    document.onselectstart = function () {
                        return false;
                    };
                }
            }

            function preventHelperRemovalOnDrop () {
                obj.item.removeValidator = AJS.$.aop.around({target: AJS.$, method: "remove"}, function (invocation) {
                   if (obj.helper !== this) {
                       invocation.proceed();
                   }
                });
            }

            function setPlaceholder () {
                 obj.placeholder
                    .height(obj.helper.outerHeight() - 2)
                    .html("<p>" + AG.param.get("dragYourGadgetHere") + "</p>");
            }

            obj.helper.addClass("dragging");

            preventTextSelection();
            preventHelperRemovalOnDrop();
            setPlaceholder();

            AG.DashboardManager.getLayout().refresh();
            AG.DashboardManager.getDashboard().addClass("dragging");
            AG.DashboardManager.showShims();
            AG.DashboardManager.markReadOnlyLayouts();
        },
        stop: function (event, obj) {

            var gadgetElement = dragGadget.getElement();

            function enableTextSelection () {
                if (typeof document.onselectstart !== "undefined") {
                    document.onselectstart = null;
                }
            }

            gadgetElement.layoutRep.css({display: ""});
            gadgetElement.css({height: "auto"}).removeClass("dragging");
            gadgetElement.shadow.hide();
            
            if (!dragGadget.hasBeenDropped) {
                AG.DashboardManager.getLayout().saveLayout();
            } else {
                sortableControl.sortable( 'option' , "revert" , 250);
            }

            enableTextSelection();

            AG.DashboardManager.getDashboard().removeClass("dragging");
            AG.DashboardManager.hideShims();
            AG.DashboardManager.getLayout().refresh();
            AG.DashboardManager.unmarkReadOnlyLayouts();
        }
    };

    return {
        serialize: function () {
            var params = {};
            AJS.$.each(this.columns.filter(":visible"), function (i) {
                params[i] = [];
                AJS.$.each(AJS.$(this).sortable("toArray"), function () {
                    params[i].push(AJS.$("#" + this).get(0).getGadgetInstance().getId());
                });
            });
            return params;
        },
        addHotSpot: function (elem, callback) {
            var offset = elem.offset(), dashboardOffset = AG.DashboardManager.getDashboard().offset();
            hotspots.push(
                AJS.$("<div class='hotspot-shim hidden' />")
                    .hover(function() {
                        dragGadget.getElement().css({opacity: 0.5});
                        elem.addClass("hover");
                    }, function () {
                        dragGadget.getElement().css({opacity: ""});
                        elem.removeClass("hover");
                    })
                    .mouseup(function () {
                        sortableControl.sortable( 'option' , "revert" , false );
                        dragGadget.hasBeenDropped = true;
                        callback(dragGadget);
                    })
                    .css({
                        height: elem.outerHeight(),
                        width: elem.outerWidth(),
                        left: offset.left - dashboardOffset.left,
                        top: offset.top - dashboardOffset.top
                    })
                    .appendTo(AG.DashboardManager.getDashboard())
            );
        },
        update: function () {
            AG.Sortable.init();
        },
        init: function () {
            if (sortableControl) {
                sortableControl.sortable("destroy");
            }
            this.columns = AJS.$(".draggable .column.sortable");
            if (this.columns.length > 0) {
                sortableControl = this.columns.sortable(AJS.$.extend(options, {
                    connectWith: this.columns
                }));
            }
        }
    };
}();


AJS.MacroBrowser = {
    // clones the element specified the selector and removes the id attribute
    // TODO: move this to AJS?
    clone: function(selector) {
        return AJS.$(selector).clone().removeAttr("id");
    }
};

AJS.toInit(function($) {

    AJS.activeColumn = 0;

    // Don't initialize if User can't modify Dashboard
    if (!AG.param.get("writable")) {
        return;
    }

    var dashboardDirectoryResourceUrl = AG.param.get("dashboardDirectoryResourceUrl");
    var dashboardResourceUrl = AG.param.get("dashboardResourceUrl");
    var errorStatus = AG.param.get("defaultErrorMessage");
    var browserContentLoading = false;
    var browserContentLoaded = false;

    var addGadgetToDashboard = function(gadgetUrl, callbacks) {
    	var reqParams = {
            type: "POST",
            url: dashboardResourceUrl + ".json",
            contentType: "application/json",
            dataType: "json",
            data: JSON.stringify({
                url: gadgetUrl,
                columnIndex: AJS.activeColumn
            }),
            processData: false
        };
        $.extend(reqParams, callbacks);
        $.ajax(reqParams);
    };

    var insertGadgetIntoLiveDashboard = function(data) {
        AG.DashboardManager.addGadget(data, AJS.activeColumn);
    };

    var callbacks = function(extraData, success, error) {
        return {
            success: function(data, textStatus) {
                success(extraData, data, textStatus);
            },
            error: function(request, textStatus, errorThrown) {
                error(extraData, request, textStatus, errorThrown);
            }
        };
    };

    var addingEntry = function(button) {
        var button = $(button);

        // re-enable all gadget's  buttons
        $('.macro-button-add').removeAttr("disabled");
        $('.macro-button-remove').removeAttr("disabled");
        button.attr("value", AG.param.get("addItNow"));
        button.parents(".macro-list-item").removeAttr("style");
        button.blur();
    };

    var addGadgetToDashboardSuccess = function(button, data, textStatus) {
        insertGadgetIntoLiveDashboard(data);
        var button = $(button);
        button.parents(".macro-list-item").css("background-color", "#fffe83").animate({
            backgroundColor: "transparent"
        },
        2000, "linear",
        function() {
            addingEntry(button);
        });
    };

    var addGadgetToDashboardError = function(button, request, textStatus, errorThrown) {
    	console.log("addItNowError = " + errorThrown);
    	$(button).removeClass("macro-button-add").addClass("macro-button-add-broken");
    	$(button).siblings('.macro-button-remove').removeClass("macro-button-remove").addClass("macro-button-remove-broken");
    	$(button).parents(".macro-list-item").css("background-color", "#faa");

    	// re-enable other gadget's  buttons
    	$('.macro-button-add').removeAttr("disabled");
    	$('.macro-button-remove').removeAttr("disabled");
    	button.blur();
    };

    var removeGadgetFromDirectorySuccess = function(button, data, textStatus) {
        showError(AG.param.get("gadgetRemovedSuccess"));
        var button = $(button);
        button.parents(".macro-list-item").remove();
    };

    var removeGadgetFromDirectoryError = function(button, request, textStatus, errorThrown) {
        if (request.status == 403 || request.status == 401) {
            showError(AG.param.get("dashboardErrorDirectoryPermissions"));
        } else {
            showError(AG.param.get("dashboardErrorFailedToAdd"));
        }
        console.log("addItNowError = " + errorThrown);
        $(button).siblings('.macro-button-add').removeClass("macro-button-add").addClass("macro-button-add-broken");
        $(button).removeClass("macro-button-remove").addClass("macro-button-remove-broken");
        $(button).parents(".macro-list-item").css("background-color", "#faa");
        button.attr("value", AG.param.get("removeFromDirectory"));
        button.blur();
    };

    // Add a new Gadget to Directory by URL
    var addGadgetToDirectory = function() {
        if ($('#add-gadget-url').attr('value') != "") {
            $('#add-gadget-submit').attr("disabled", "disabled").attr("value", AG.param.get("adding"));
            var xhr = $.ajax({
                type: "POST",
                url: dashboardDirectoryResourceUrl,
                data: JSON.stringify({
                    url: $('#add-gadget-url').attr('value')
                }),
                contentType: "application/json",
                processData: false,
                success: function() {
                    var gadgetUrl = $('#add-gadget-url').attr('value');

                    clearBrowser();
                    loadBrowser(false, gadgetUrl);

                },
                error: function(request, textStatus, errorThrown) {
                    if (request.status == 403 || request.status == 401) {
                        showError(AG.param.get("dashboardErrorDirectoryPermissions"));
                    } else {
                        showError(AG.param.get("dashboardErrorFailedToAdd"));
                    }
                    $('#add-gadget-submit').attr("value", AG.param.get("addGadget")).removeAttr("disabled");
                }
            });

            $(xhr).throbber({target: $("#dir-throbber")});
        }
    };

    // Remove a Gadget from the Directory that was added by URL
    var removeGadgetFromDirectory = function(gadgetUri, callbacks) {
        var reqParams = {
            type: "DELETE",
            url: gadgetUri
        };
        $.extend(reqParams, callbacks);
        $.ajax(reqParams);
    };

    // Scroll to a particular gadget
    var scrollToGadget = function(directoryGadgetElementId) {

        var mb = AJS.MacroBrowser.dialog;
        mb.prevPage();

        var gadgetElement = $('#' + directoryGadgetElementId);
        gadgetElement.css("background-color", "#fffe83").animate({ backgroundColor: "transparent" }, 5000, "linear");

        var divOffset = $('.panel-body').offset().top;
        var pOffset = gadgetElement.offset().top;
        var pScroll = pOffset - divOffset;
        $('.panel-body').animate({scrollTop: '+=' + pScroll + 'px'}, 1000);
    };



    // Fill macro Summary Template
    var fillMacroTemplate = function(gadgetDiv, gadget) {

        var onAdd = function(event) {
            if (AG.DashboardManager.getLayout().getGadgets().length >= AG.param.get("maxGadgets")) {
                showError(AG.param.get("dashboardErrorTooManyGadgets"));
                return false;
            }

            var button = $(".macro-button-add", gadgetDiv);
            button.attr("disabled", "disabled").attr("value", AG.param.get("adding"));

            // disable gadget's  buttons to prevent overlapping calls
            $('.macro-button-add').attr("disabled", "disabled");
            $('.macro-button-remove').attr("disabled", "disabled");
            var gadgetUrl = button.siblings('.macro-hidden-uri').attr("value");
            addGadgetToDashboard(gadgetUrl, callbacks(button, addGadgetToDashboardSuccess, addGadgetToDashboardError));
            return false;
        };

        if (gadget.thumbnailUri && gadget.thumbnailUri != "") {
            gadgetDiv.prepend("<img src='" + gadget.thumbnailUri + "' alt='' width='120' height='60'/>");
        }

        if (gadget.description && gadget.description != "") {
            $(".macro-desc", gadgetDiv).append(gadget.description);
        } else {
            $(".macro-desc", gadgetDiv).append("<span class='unknown'>" + AG.param.get("descriptionNotAvailable") + "</span>");
        }

        if (gadget.authorName && gadget.authorName != "") {
            $(".macro-author", gadgetDiv).append(AJS.format(AG.param.get("gadgetAuthor"), "<a href='mailto:" + gadget.authorEmail + "'>" + gadget.authorName + "</a>"));
        } else {
            $(".macro-author", gadgetDiv).append("<span class='unknown'>" + AG.param.get("authorUnknown") + "</span>");
        }

        $(".macro-title", gadgetDiv).append("<a href=''>" + gadget.title + "</a>");
        $(".macro-title", gadgetDiv).click(onAdd);

        if (gadget.titleUri && gadget.titleUri != "") {
            $(".macro-title-uri-link", gadgetDiv).attr("href", gadget.titleUri);
        } else {
            $(".macro-title-uri", gadgetDiv).hide();
        }

        // add base url to the Gadget URL link if gadgetSpecUri is a relative path
        $(".macro-uri", gadgetDiv).attr("href", (gadget.gadgetSpecUri.match("^https?://") ? "" : AG.param.get("dashboardDirectoryBaseUrl"))
                                                + gadget.gadgetSpecUri);

        $(".macro-hidden-uri", gadgetDiv).attr("value", gadget.gadgetSpecUri);

        $(".macro-button-add", gadgetDiv).click(onAdd);

        // Directory Admins only
        if (AG.param.get("canAddExternalGadgetsToDirectory") == "true") {
            if (gadget.isDeletable) {
                // Make the button visible and hook it up to the remove function
                $(".macro-button-remove", gadgetDiv).css("display", "block").click(function(event) {
                    if (confirm(AG.param.get("removeGadget"))) {
                        var button = $(this);
                        button.attr("disabled", "disabled").attr("value", AG.param.get("removing"));
                        button.siblings('.macro-button-add').attr("disabled", "disabled");
                        var gadgetUrl = button.siblings('.macro-hidden-uri').attr("value");
                        removeGadgetFromDirectory(gadget.self, callbacks(button, removeGadgetFromDirectorySuccess, removeGadgetFromDirectoryError));
                    }
                    return false;
                });

            }
        }
    };

    // Construct the dialog without any data
    var constructBrowser = function() {
        var mb = AJS.MacroBrowser.dialog = new AJS.Dialog(860, 530, "macro-browser-dialog");
        mb.addHeader(AG.param.get("gadgetDirectory"));

        // Add buttons to page one of dialog if the user has perms
        if (AG.param.get("canAddExternalGadgetsToDirectory") == "true") {
            mb.addButton(AG.param.get("addByUrlButtonLabel"),
            function(dialog) {
                dialog.nextPage();
                $('#add-gadget-url').focus();
            },
            "add-by-url left");
        }

        if (!mb.page[0].buttonpanel) {
            mb.page[0].buttonpanel = AJS("div").addClass("button-panel");
            mb.page[0].element.append(mb.page[0].buttonpanel);
        }

        // Add Help Links
        var helpLink = AJS("span").attr("class", "directory-help-link");
        AJS("a").html(AG.param.get("helpLinkLearnMoreAboutGadgets")).css("margin-right", "10px").attr("href", AG.param.get("helpLinkLearnMoreAboutGadgetsUrl")).attr("target", "_blank").appendTo(helpLink);
        AJS("a").html(AG.param.get("helpLinkCreateYourOwnGadget")).css("margin-right", "10px").attr("href", AG.param.get("helpLinkCreateYourOwnGadgetUrl")).attr("target", "_blank").appendTo(helpLink);
        mb.page[0].buttonpanel.append(helpLink);

        mb.addButton(AG.param.get("finishButtonLabel"),
        function(dialog) {
            dialog.hide();
        },
        "finish");

        // Directory Admins only
        if (AG.param.get("canAddExternalGadgetsToDirectory") == "true") {
            // Add 2nd page and buttons - Add by URL
            mb.addPage().addPanel("addByUrl", $("#add-by-url-template")).addButton(AG.param.get("backButtonLabel"),
            function(dialog) {
                dialog.prevPage();
            },
            "back").addButton(AG.param.get("finishButtonLabel"),
            function(dialog) {
                dialog.hide();
            },
            "finish");
            mb.page[1].addHeader(AG.param.get("addGadgetByUrl"));
            // AG-917 : when the user hits 'enter' in the text box, click the add-gadget-submit button
            $('#add-gadget-url').keydown(function(e) {
               if (e.keyCode == 13) {
                   $('#add-gadget-submit').click();
               }
            });
            // Button for adding a gadget by URL
            $('#add-gadget-submit').click(function() {
                addGadgetToDirectory();
            });
        }

        // add search box to top right
        var searchInput =   AJS.$("<input type='search'/>").attr("id", "macro-browser-search").keyup(function(e) {
            var text = AJS.$(e.target).val();
            var macroSummaries = AJS.$("#macro-browser-dialog .panel-body .macro-list-item");
            var withText = ":containsIgnoreCase(" + text + ")";
            if (text !== "") {
                macroSummaries.filter(withText).show();
                macroSummaries.not(withText).hide();
            } else {
                resetSearchResults();
            }
        }).focus(function(e) {
            var searchInput = AJS.$(e.target);
            if (searchInput.hasClass("blank-search")) {
                searchInput.removeClass("blank-search").val("");
            }
        }).blur(function(e) {
            var searchInput = AJS.$(e.target);
            if (searchInput.val() == "") {
                searchInput.addClass("blank-search").val(AG.param.get("blankSearchText"));
            }
        }).blur();
        mb.page[0].header.prepend(searchInput);
    };

    // Loads the categories and macros into the dialog
    var loadBrowserContent = function(data, gadgetUrl) {
        var mb = AJS.MacroBrowser.dialog;

        // sort the categories and macros
        data.categories.sort(function(one, two) {
            return (one.name > two.name ? 1 : -1);
        });
        data.gadgets.sort(function(one, two) {
            return (one.title > two.title ? 1 : -1);
        });

        var makeCategoryList = function(id) {
            return $("#macro-summaries-template").clone().attr("id", "category-" + id);
        };

        // Create and fill each node that contains an item
        var makeGadgetSummary = function(gadget) {
            var macroDiv = AJS.MacroBrowser.clone("#macro-summary-template");
            fillMacroTemplate(macroDiv, gadget);
            return macroDiv;
        };

        // Initialize list of categories
        var categoryDivs = {
            all: makeCategoryList("all")
        };

        // Fill items on the right
        $(data.gadgets).each(function(i, gadget) {
            // Remove all characters that are not valid in an HTML Id.
            var title = gadget.title.replace(/[^A-Za-z0-9_]/g,'');
            var macroDiv = makeGadgetSummary(gadget).attr("id", "macro-" + title);
            categoryDivs.all.append(macroDiv);
            $([gadget.categories]).each(function(i, catKey) {
                if (catKey.constructor == Array) { // if there are multiple categories for this gadget, loop through all of them
                    for (var j = 0; j < catKey.length; ++j) {
                        categoryDivs[catKey[j]] = categoryDivs[catKey[j]] || makeCategoryList(j);
                        categoryDivs[catKey[j]].append(makeGadgetSummary(gadget).attr("id", catKey[j] + "-macro-" + title));
                    }
                } else {
                    categoryDivs[catKey] = categoryDivs[catKey] || makeCategoryList(j);
                    categoryDivs[catKey].append(makeGadgetSummary(gadget).attr("id", catKey + "-macro-" + title));
                }
            });
        });

        // Fill category menu on the left
        mb.page[0].addPanel(AG.param.get("all") + " (" + categoryDivs["all"].children().length + ")", categoryDivs["all"]);

        $(data.categories).each(function() {
            if (categoryDivs[this.name]) {
                mb.page[0].addPanel(this.name + " (" + categoryDivs[this.name].children().length + ")", categoryDivs[this.name], this.name);
            }
        });

        mb.page[0].gotoPanel(0, 0);
        $(mb.page).each( function() {
            this.recalcSize();
        });

        // Highlight and scroll to the added gadget
        if(gadgetUrl != null) {

            // Find the new Gadget
            var gadgetElement = $('.macro-hidden-uri[value='+gadgetUrl+']').parents('.macro-list-item');
            var gadgetId = gadgetElement.attr("id");

            scrollToGadget(gadgetId);

            // Clear the search field
            $('#add-gadget-url').attr('value', "");
        }


        mb.ready = true;
    };

    // Load data from Directory Resource
    var loadBrowser = function(displayDialog, gadgetUrl) {
        browserContentLoading = true;
        var xhr = $.ajax({
                type: "GET",
                dataType: "json",
                cache: false,
                url: dashboardDirectoryResourceUrl + ".json",
                success: function(data) {
                    browserContentLoading = false;
                    browserContentLoaded = true;
                    loadBrowserContent(data, gadgetUrl);
                    if(displayDialog) {
                        showDialog();
                    }
                    $('#add-gadget-submit').attr("value", AG.param.get("addGadget")).removeAttr("disabled");
                },
                error: function(request, textStatus, errorThrown) {
                    browserContentLoading = false;
                    if (request.status == 403 || request.status == 401) {
                        showError(AG.param.get("dashboardErrorDashboardPermissions"));
                    } else {
                        showError(AG.param.get("failedToLoadError"));
                    }
                    $('#add-gadget-submit').attr("value", AG.param.get("addGadget")).removeAttr("disabled");
                }
            });
        //only display the throbber if we're displaying the dialog.
        if(displayDialog) {
            $(xhr).throbber({target: $("#dash-throbber")});
        }
        $(xhr).throbber({target: $("#dir-throbber")});
    };

    // Clear Dialog Content
    var clearBrowser = function() {
        var mb = AJS.MacroBrowser.dialog;
        $(mb.page[0].panel).each(function() {
            this.body.remove();
        });
        $(mb.page[0].panel).each(function() {
            this.remove();
        });
        mb.page[0].curtab = 0;
    };

    var resetSearchResults = function () {
        AJS.$("#macro-browser-dialog .panel-body .macro-list-item").show();
    };

    var showDialog = function() {
        var mb = AJS.MacroBrowser;
        if (mb.dialog && mb.dialog.ready) {
            // bind escape to close dialog
            $(document).keyup(function(e) {
                if (e.keyCode == 27) {
                    mb.dialog.hide();
                    $(document).unbind("keyup", arguments.callee);
                    $("#macro-browser-search").val("");
                    return AJS.stopEvent(e);
                }
            });

            if (mb.selectedMacro) {
                AJS.log("selectedMacro: " + mb.selectedMacro.name);
                replicateSelectMacro(mb.selectedMacro.name);
            } else {
                mb.dialog.show(); // we must show then go to panel - this order is important for IE6
                mb.dialog.gotoPanel(0, 0);
                AJS.$("#macro-browser-search").addClass("blank-search").val(AG.param.get("blankSearchText"));
                resetSearchResults();
            }
        } else {
            showError(errorStatus);
        }
    };

    var showError = function(message) {
        alert(message); // TODO: AG-95 show this in the UI, not an alert.
    };

    // Initialize Everything
    constructBrowser();

    // Hook up the button
    $(".add-gadget-link").live("click", function(e) {

        AJS.activeColumn = 0;
        // button id = "add-gadget-#"
        if($(this).attr("id").substring(11)){
            AJS.activeColumn = $(this).attr("id").substring(11);
        }

        if (browserContentLoaded) {
            showDialog();
        } else if (!browserContentLoading) {
            loadBrowser(true);
        }
        return AJS.stopEvent(e);
    });
})(AJS.$);

//todo move this into AJS
AJS.$.extend(jQuery.expr[':'], {
    containsIgnoreCase: function(a, i, m) {
        return (a.textContent || a.innerText || jQuery(a).text() || '').toLowerCase().indexOf((m[3] || '').toLowerCase()) >= 0;
    }
});
/**
 * Cookie plugin
 *
 * Copyright (c) 2006 Klaus Hartl (stilbuero.de)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 */

/**
 * Create a cookie with the given name and value and other optional parameters.
 *
 * @example $.cookie('the_cookie', 'the_value');
 * @desc Set the value of a cookie.
 * @example $.cookie('the_cookie', 'the_value', { expires: 7, path: '/', domain: 'jquery.com', secure: true });
 * @desc Create a cookie with all available options.
 * @example $.cookie('the_cookie', 'the_value');
 * @desc Create a session cookie.
 * @example $.cookie('the_cookie', null);
 * @desc Delete a cookie by passing null as value. Keep in mind that you have to use the same path and domain
 *       used when the cookie was set.
 *
 * @param String name The name of the cookie.
 * @param String value The value of the cookie.
 * @param Object options An object literal containing key/value pairs to provide optional cookie attributes.
 * @option Number|Date expires Either an integer specifying the expiration date from now on in days or a Date object.
 *                             If a negative value is specified (e.g. a date in the past), the cookie will be deleted.
 *                             If set to null or omitted, the cookie will be a session cookie and will not be retained
 *                             when the the browser exits.
 * @option String path The value of the path atribute of the cookie (default: path of page that created the cookie).
 * @option String domain The value of the domain attribute of the cookie (default: domain of page that created the cookie).
 * @option Boolean secure If true, the secure attribute of the cookie will be set and the cookie transmission will
 *                        require a secure protocol (like HTTPS).
 * @type undefined
 *
 * @name $.cookie
 * @cat Plugins/Cookie
 * @author Klaus Hartl/klaus.hartl@stilbuero.de
 */

/**
 * Get the value of a cookie with the given name.
 *
 * @example $.cookie('the_cookie');
 * @desc Get the value of a cookie.
 *
 * @param String name The name of the cookie.
 * @return The value of the cookie.
 * @type String
 *
 * @name $.cookie
 * @cat Plugins/Cookie
 * @author Klaus Hartl/klaus.hartl@stilbuero.de
 */
jQuery.cookie = function(name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        // CAUTION: Needed to parenthesize options.path and options.domain
        // in the following expressions, otherwise they evaluate to undefined
        // in the packed version for some reason...
        var path = options.path ? '; path=' + (options.path) : '';
        var domain = options.domain ? '; domain=' + (options.domain) : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
};
