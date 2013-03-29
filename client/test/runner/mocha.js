(function() {
  var runner = mocha.run().globals(['LiveReload']);

  if(!window.PHANTOMJS) return;

  runner.on('test', function(test) {
    sendMessage('mocha.testStart', test.title);
  });

  runner.on('test end', function(test) {
    sendMessage('mocha.testDone', test.title, test.state);
  });

  runner.on('suite', function(suite) {
    sendMessage('mocha.suiteStart', suite.title);
  });

  runner.on('suite end', function(suite) {
    if (suite.root) return;
    sendMessage('mocha.suiteDone', suite.title);
  });

  runner.on('fail', function(test, err) {
    sendMessage('mocha.testFail', test.title, err);
  });

  runner.on('end', function() {
    var output = {
      failed  : this.failures,
      passed  : this.total - this.failures,
      total   : this.total
    };

    sendMessage('mocha.done', output.failed,output.passed, output.total);
  });

  function sendMessage() {
    var args = [].slice.call(arguments);
    alert(JSON.stringify(args));
  }
})();
