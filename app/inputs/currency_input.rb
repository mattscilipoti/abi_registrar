# Custom input for simple_form
# see https://github.com/heartcombo/simple_form#custom-inputs
class CurrencyInput < SimpleForm::Inputs::NumericInput
  # def input(wrapper_options)
  #   merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

  #   "$ #{@builder.text_field(attribute_name, merged_input_options)}".html_safe
  # end
end