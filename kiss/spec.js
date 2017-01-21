/* eslint max-nested-callbacks: 0, no-console: 0 */
/* global require, process, describe, it, afterEach, beforeEach */
(function() {

    'use strict';

    require('app-module-path').addPath(process.cwd());
    require('jsdom-global')();

    var sinon = require('sinon'),
        expect = require('chai').expect,
        // wemap
        Helper = require('src/Helper');

    describe('helper', function() {

        beforeEach(function() {});

        afterEach(function() {});

        describe('Method', function() {

            it('Expect something', function() {
                expect(function() {
                }).to.throw();
            });

        });

    });

}());
