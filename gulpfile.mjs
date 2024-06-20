import path from 'path';
import gulp from 'gulp';

const { task, src, dest } = gulp;

task('build:icons', copyIcons);

function copyIcons() {
  const nodeSource = path.resolve('nodes', '**', '*.{png,svg}');
  const nodeDestination = path.resolve('dist', 'nodes');

  src(nodeSource).pipe(dest(nodeDestination));

  const credSource = path.resolve('credentials', '**', '*.{png,svg}');
  const credDestination = path.resolve('dist', 'credentials');

  return src(credSource).pipe(dest(credDestination));
}

export default gulp.series('build:icons');
