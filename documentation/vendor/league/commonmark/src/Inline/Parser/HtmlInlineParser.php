<?php

/*
 * This file is part of the league/commonmark package.
 *
 * (c) Colin O'Dell <colinodell@gmail.com>
 *
 * Original code based on the CommonMark JS reference parser (http://bitly.com/commonmark-js)
 *  - (c) John MacFarlane
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace League\CommonMark\Inline\Parser;

use League\CommonMark\Inline\Element\HtmlInline;
use League\CommonMark\InlineParserContext;
use League\CommonMark\Util\RegexHelper;

class HtmlInlineParser extends AbstractInlineParser
{
    /**
     * @return string[]
     */
    public function getCharacters()
    {
        return ['<'];
    }

    /**
     * @param InlineParserContext $inlineContext
     *
     * @return bool
     */
    public function parse(InlineParserContext $inlineContext)
    {
        $cursor = $inlineContext->getCursor();
        if ($m = $cursor->match(RegexHelper::getInstance()->getHtmlTagRegex())) {
            $inlineContext->getContainer()->appendChild(new HtmlInline($m));

            return true;
        }

        return false;
    }
}
