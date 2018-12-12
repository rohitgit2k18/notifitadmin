function SearchKeywordEvaluateIsValid(val)
{
    var keyword = document.getElementById(val.controltovalidate).value;
    if (keyword == "" || keyword.length == 0) return true;
    if (val.allowWildCardsInStart.toLowerCase() == "false") {
        if (keyword.indexOf("*") === 0 || keyword.indexOf("?") === 0)
            return false;
    }
    var cleanKeyword = keyword.replace(/[*\s]/g,"");
    var minimumLength = (+val.minimumLength);
    return (cleanKeyword.length >= minimumLength);
}

function SearchKeywordEvaluateIsValidRequired(val)
{
    var keyword = document.getElementById(val.controltovalidate).value;
    if (keyword == "" || keyword.length == 0) return false;
    var cleanKeyword = keyword.replace(/[*\s]/g,"");
    var minimumLength = (+val.minimumLength);
    return (cleanKeyword.length >= minimumLength);
}