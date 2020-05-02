import PropTypes from 'prop-types';
import React from 'react';
import { useTheme, createUseStyles } from 'react-jss';

const useStyles = createUseStyles({
  container: ({ theme }) => ({}),
});

const ReactDumbComponent = () => {
  const theme = useTheme();
  const classes = useStyles({ theme });
  return <div className={classes.container} />;
};

ReactDumbComponent.defaultProps = {};

ReactDumbComponent.propTypes = {};

export default ReactDumbComponent;
