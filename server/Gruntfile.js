// Generated on 2013-03-27 using generator-webapp 0.1.5
'use strict';
var mountFolder = function (connect, dir) {
    return connect.static(require('path').resolve(dir));
};

// # Globbing
// for performance reasons we're only matching one level down:
// 'test/spec/{,*/}*.js'
// use this if you want to match all subfolders:
// 'test/spec/**/*.js'

module.exports = function (grunt) {
    // load all grunt tasks
    require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

    // configurable paths
    grunt.initConfig({
        watch: {
            test: {
                files: ['test/spec/**/*.coffee', 'app/**/*.coffee'],
                tasks: ['mochaTest']
            }
        },

        mochaTest: {
            options: {
                reporter: 'spec'
            },
            src: ['test/spec/**/*.coffee']
        }
    });

    grunt.registerTask('test', 'watch:test');
};
