$ ->
  App = {}
  App.view = new ConstrView
    el: $('.constructor')
    model: ConstrModel


class ConstrModel extends Backbone.Model
  defaults:
    area: null

class ConstrView extends Backbone.View
  events: {
    "change": "render"
  }
  initialize: ()->
    #Top filter
    @$area_input = $('#area')
    @$basement = $('#basement')
    @$box = $('#box')
    @$roof = $('#roof')
    @$hard_loc = $('#hard-loc')
    @$hard_const = $('#hard-const')
    @$no_docs = $('#no-docs')
    #Main
    @$basement_select = $('#basement-sl')
    @$box_type = $('#box-type')
    @$box_mat = $('#box-mat')
    @$roof_type = $('#roof-type')
    @$roof_heat = $('#roof-heat')
    @$waters = $('#waters')
    #Main init
    $('.checkboxes').prop('checked', true)
    $('.modal').modals()
    @render()

  render: ()->
    @count()
    @leftCount()
    $('.checkboxes').each ()->
      target = $('.house').find('.' + $(this).data 'link')
      if $(this).is(':checked')
        $(this).closest('td').siblings('.filter-block').removeClass('_disabled')
        target.removeClass('_disabled')
      else
        $(this).closest('td').siblings('.filter-block').addClass('_disabled')
        target.addClass('_disabled')
    if _.isNumber @total
      @animCount @total
    else
      $('#total-cont').html(@total)
      @prevSum = 0

  leftCount: ()->
    $('.math').find('table').empty()
    if @basement_price isnt 0 then $('.math').find('table').append "<tr><td>Фундамент: </td><td><div>#{ parseInt @basement_price * @basement_koeff * @hard_loc_koeff * @hard_const_koeff * @no_docs_koeff } p/м<sup>2</sup><div class='plus'>+</div></div></td></tr>"
    if @box_price isnt 0 then $('.math').find('table').append "<tr><td>Стены и перекрытия: </td><td><div>#{ parseInt @box_price * @hard_loc_koeff * @hard_const_koeff * @no_docs_koeff} p/м<sup>2</sup><div class='plus'>+</div></div></td></tr>"
    if @roof_price isnt 0 then $('.math').find('table').append "<tr><td>Кровля: </td><td><div>#{ parseInt @roof_price  * @hard_loc_koeff * @hard_const_koeff * @no_docs_koeff} p/м<sup>2</sup><div class='plus'>+</div></div></td></tr>"

  animCount: (sum)->
    $('#total-cont').html(sum + 'р')



  count: ()->
    #values
    @area = @$area_input.val()
    @basement = @$basement_select.val()
    @box_type = @$box_type.val()
    @box_mat = @$box_mat.val()
    @roof_type = @$roof_type.val()
    @roof_heat = @$roof_heat.val()
    #Get all koeffs
    @basement_koeff = do => if @$waters.is(':checked') then koeff['waters'] else 1
    @hard_loc_koeff = do => if @$hard_loc.is(':checked') then koeff['hard_loc'] else 1
    @hard_const_koeff = do => if @$hard_const.is(':checked') then koeff['hard_constr'] else 1
    @no_docs_koeff = do => if @$no_docs.is(':checked') then koeff['no_docs'] else 1
    @basement_price = do => if @$basement.is(':checked') then parseInt prices.basement[@basement] * @basement_koeff else 0
    @box_price = do => if @$box.is(':checked') then prices.house[@box_type][@box_mat] else 0
    @roof_price = do => if @$roof.is(':checked') then prices.roof[@roof_type][@roof_heat] else 0
    @total = do =>
      if @area isnt '' and (@basement_price + @box_price + @roof_price) isnt 0
        parseInt (@basement_price * @basement_koeff * @hard_loc_koeff * @hard_const_koeff * @no_docs_koeff * @area) +
        (@box_price * @hard_loc_koeff * @hard_const_koeff * @no_docs_koeff * @area) +
        (@roof_price * @hard_loc_koeff * @hard_const_koeff * @no_docs_koeff * @area)
      else if @area isnt '' and (@basement_price + @box_price + @roof_price) is 0
        "<span id='count-error'>Пожалуйста выберите виды работ</span>"
      else if @area is ''
        "<span id='count-error'>Пожалуйста введите площадь застройки</span>"



    #Debug
    console.log "Basement: #{@basement_price}"
    console.log "Box: #{@box_price}"
    console.log "Roof: #{@roof_price}"
    console.log "Hard_loc_koeff: #{@hard_loc_koeff}"
    console.log "Hard_const_koeff: #{@hard_const_koeff}"
    console.log "No_docs_koeff: #{@no_docs_koeff}"




prices =
  basement:
    lent_base: 13500
    mono_high: 12150
    mono_low: 10650
    svai_high: 7450
    svai_low: 5900
    lent_high: 6500
    lent_low: 4950
  roof:
    bitum:
      heat: 8650
      cold: 8250
    metall:
      heat: 7800
      cold: 7400
  house:
    1:
      gas_nosiding: 10600
      gas_siding_brick: 12700
      brick_heat: 13500
    2:
      gas_nosiding: 12150
      gas_siding_brick: 14300
      brick_heat: 15250
    3:
      gas_nosiding: 16600
      gas_siding_brick: 19700
      brick_heat: 20900

koeff =
  waters: 1.1
  hard_loc: 1.08
  hard_constr: 1.15
  no_docs: 1.05


