require('coffee-script/register');

require('chai').Assertion.includeStack = true;

require('./demo');

describe("Transforms", function () {
  require('./transforms/getLanguage_spec');
  require('./transforms/splitCodeAndComments_spec');
  require('./transforms/highlight_spec');
  require('./transforms/renderDocTags_spec');
  require('./transforms/indexFile_spec');
});

require('./utils/processDocTags_spec');

require('./styles_spec');