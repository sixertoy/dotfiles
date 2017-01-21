/* global module, require */
(function() {

    'use strict';

    var React = require('react'),
        ObjectClass = React.createClass({

            /* ------------------------------------------------

            Section Template

            ------------------------------------------------ */

            // @see http://facebook.github.io/react/docs/component-specs.html#statics
            statics: {},

            // @see http://facebook.github.io/react/docs/component-specs.html#mixins
            mixins: [],

            propTypes: {
                facade: React.PropTypes.object,
                lang: React.PropTypes.string.isRequired
            },

            getDefaultProps: function() {
                return {
                    lang: 'en'
                };
            },

            // @see http://facebook.github.io/react/docs/component-specs.html#getinitialstate
            getInitialState: function() {
                return {};
            },

            /* ------------------------------------------------

            Section Template

            ------------------------------------------------ */

            // @see http://facebook.github.io/react/docs/component-specs.html#render
            render: function() {
                return (
                    <div></div>
                );
            }

        });

    module.exports = ObjectClass;

}());
