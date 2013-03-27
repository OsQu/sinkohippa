require.config({
    // App will be initialized from main.js
    deps: ['main'],
    paths: {
        jquery: '../components/jquery/jquery',
        'socket.io-client': '../components/socket.io-client/lib/socket.io-client',
        bacon: '../components/bacon/dist/Bacon',
        underscore: '../components/underscore/underscore',
        bootstrap: 'vendor/bootstrap',
        rot: 'vendor/rot.js/rot'
    },
    shim: {
        bootstrap: {
            deps: ['jquery'],
            exports: 'jquery'
        },
        underscore: {
            exports: '_'
        },
        bacon: {
            deps: ['jquery']
        },
        rot: {
          exports: 'ROT'
        }
    }
});
