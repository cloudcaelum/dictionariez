import $ from "jquery"
import dict from "./dict.coffee"
import message from "./message.coffee"
import storage from "./storage.coffee"
import setting from "./setting.coffee"
import utils from "utils"

parseVocabulary = (text) ->
    return [] unless text and utils.isEnglish(text)

    url = "https://www.vocabulary.com/dictionary/autocomplete?search=#{text}"
    res = await $.get url
    nodes = $(res)
    list = []
    nodes.find('li>.entry').each (i, item) ->
        w = $(item).find('.word').text()
        def = $(item).find('.definition').text()

        list.push({ w, def }) unless i > 11  # at most 12 items
        
    return list

message.on 'autocomplete', ({ text })->
    results = []
    results = results.concat dict.searchDicts text 

    if text.trim().length > 1
        results = results.concat await parseVocabulary(text.trim())
    return results
