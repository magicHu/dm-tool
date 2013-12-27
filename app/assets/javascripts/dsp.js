$(function() {
  $('#search-match-ad-campaign-btn').click(function() {
    $form = $('#search_match_ad_campaign_form');

    $.getJSON($form.attr('action'), $form.serialize(), function(data) {
      $("#ad-campaign-ids").text(data.ad_campaign_ids || ".........");
    });
    return false;
  });
});