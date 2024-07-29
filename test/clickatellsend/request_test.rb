require 'test_helper'

class RequestTest < Minitest::Test
  def setup
    @request = Clickatellsend::Request.new
  end

  def test_auth
    response = @request.auth
    assert_includes response, "OK"
  end

  def test_prevent_expiring
    session_id = @request.auth["OK"]
    response = @request.prevent_expiring(session_id: session_id)
    assert_equal "OK", response
  end

  def test_send_msg
    response = @request.send_msg(to: "1234567890", text: "Test message")
    assert_includes response, "ID"
  end

  def test_send_msg_with_delay
    response = @request.send_msg(to: "1234567890", text: "Delayed message", deliv_time: 15)
    assert_includes response, "ID"
  end

  def test_get_balance
    balance = @request.get_balance
    assert_kind_of Numeric, balance
  end

  def test_get_msg_charge
    message = @request.send_msg(to: "1234567890", text: "Charge test")
    charge = @request.get_msg_charge(apimsgid: message["ID"])
    assert_kind_of Numeric, charge
  end

  def test_route_coverage
    coverage = @request.route_coverage(msisdn: "1234567890")
    assert_includes coverage, "OK"
  end

  def test_get_msg_status
    message = @request.send_msg(to: "1234567890", text: "Status test")
    status = @request.get_msg_status(apimsgid: message["ID"])
    assert_includes ["Delivered", "Queued", "Pending"], status
  end

  def test_stop_msg
    message = @request.send_msg(to: "1234567890", text: "Stop test", deliv_time: 15)
    stop = @request.stop_msg(apimsgid: message["ID"])
    assert_equal "OK", stop
  end
end
