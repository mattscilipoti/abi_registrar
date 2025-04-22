module ConfirmationHelper
  # Prompts the user for confirmation and returns true if confirmed.
  def confirm_action(action_message)
    print "#{action_message} (y/N): "
    response = STDIN.gets.chomp.downcase
    response == 'y' || response == 'yes'
  end
end
