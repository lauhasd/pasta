'use strict';

const Elm = require('../../../elm/Main.elm');
const mountNode = document.getElementById('main');

// .embed() can take an optional second argument. This would be an object describing the data we need to start a program, i.e. a userID or some token
const app = Elm.App.embed(mountNode);

app.ports.highlight.subscribe(function(content) {
  app.ports.highlighted.send(hljs.highlightAuto(content).value);
});
