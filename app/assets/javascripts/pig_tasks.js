$(function() {
  $(document).on('click', '.add-job', function() {
    $this = $(this);
    $this.closest('.danger').removeClass('danger').addClass('success');
    $this.removeClass('add-job').addClass('remove-job').text("Remove from Task");

    $this.siblings(".job-ids").val($this.attr('data-job'));
    return false;
  });

  $(document).on('click','.remove-job', function() {
    $this = $(this);
    $this.closest('.success').removeClass('success').addClass('danger');
    $this.removeClass('remove-job').addClass('add-job').text("Add to Task");

    $this.siblings(".job-ids").val(null);
    return false;
  });

  $(document).on('click', '.job-up', function() {
    $this = $(this);
    $row = $this.closest('tr');
    $row.hide('slow');

    $prev = $row.prev();
    if($prev) {
      $prev.insertAfter($row);
      $row.show('slow');
    }
  });

  $(document).on('click', '.job-down', function() {
    $this = $(this);
    $row = $this.closest('tr');
    $row.hide('slow');

    $next = $row.next();
    if($next) {
      $row.insertAfter($next);
      $row.show('slow');
    }
  });
});
