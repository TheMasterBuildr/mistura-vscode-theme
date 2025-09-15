import fs from 'fs';
import JSON5 from 'json5';

// Correctly parse and access the nested palette object
const paletteFile = JSON5.parse(fs.readFileSync('src/palette.jsonc', 'utf8'));
const palette = paletteFile.palette; 

let theme = JSON5.parse(fs.readFileSync('src/theme.jsonc', 'utf8'));

// Replace $variables with actual colors
function replaceVars(obj) {
  for (const key in obj) {
    if (typeof obj[key] === 'string' && obj[key].startsWith('$')) {
      const varName = obj[key].slice(1);
      // Use the corrected palette variable
      obj[key] = palette[varName] || obj[key];
    } else if (typeof obj[key] === 'object') {
      replaceVars(obj[key]);
    }
  }
}
replaceVars(theme);

fs.writeFileSync('themes/Mistura-color-theme.json', JSON.stringify(theme, null, 2));
console.log('Theme built!');