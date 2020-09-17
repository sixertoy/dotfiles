import PropTypes from 'prop-types';
import React, { useEffect } from 'react';
import { useTheme, createUseStyles } from 'react-jss';

const useStyles = createUseStyles({
  container: ({ theme }) => ({}),
});

function componentWillUnmount() {}

const ReactHookComponent = () => {
  const theme = useTheme();
  const classes = useStyles({ theme });
  useEffect(() => {
    return componentWillUnmount;
  }, []);
  return <div className={classes.container} />;
};

ReactHookComponent.defaultProps = {};

ReactHookComponent.propTypes = {};

export default ReactHookComponent;
