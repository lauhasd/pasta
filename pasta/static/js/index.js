'use strict';

var Elm = require('../../../elm/Main.elm');
var mountNode = document.getElementById('main');

// .embed() can take an optional second argument. This would be an object describing the data we need to start a program, i.e. a userID or some token
var app = Elm.App.embed(mountNode);

app.ports.highlight.subscribe(function(className) {
    hljs.configure({
      tabReplace: '    ',
      classPrefix: '',
    });
    var content = document.querySelector(`.${className}`);
    console.log(content);
    if (content)
      hljs.highlightBlock(content);
});
