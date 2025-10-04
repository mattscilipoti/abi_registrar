require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#boolean_tag' do
    it 'returns a span with a check mark for true' do
      expect(helper.boolean_tag(true)).to include('✓')
    end

    it 'returns a span with a cross mark for false' do
      expect(helper.boolean_tag(false)). to include('❌')
    end

    it 'adds the subdued class when specified for true' do
      expect(helper.boolean_tag(true, subdue_if: true)).to include('class="bool_true subdued"')
    end

    it 'does not add the subdued class when specified for false' do
      expect(helper.boolean_tag(true, subdue_if: false)).to include('class="bool_true"')
    end

    it 'adds the subdued class when specified for false' do
      expect(helper.boolean_tag(false, subdue_if: false)).to include('class="bool_false subdued"')
    end

    it 'does not add the subdued class when specified for true' do
      expect(helper.boolean_tag(false, subdue_if: true)).to include('class="bool_false"')
    end

    it 'does not generate a tag when the value matches hide_if' do
      expect(helper.boolean_tag(true, hide_if: true)).to eq('')
      expect(helper.boolean_tag(false, hide_if: false)).to eq('')
    end
  end

  describe '#date_tag' do
    it 'returns a formatted date string with class and tooltip' do
      date = Date.new(2023, 10, 31)
      html = helper.date_tag(date)
      fragment = Capybara.string(html)
      expect(fragment).to have_css('span.date[data-tooltip*="2023-10-31"]', text: 'Tue Oct 31, 2023')
    end
  end

  describe '#datetime_as_boolean_tag' do
    it 'returns a boolean tag with a tooltip for a present datetime' do
      datetime = DateTime.new(2023, 10, 31, 12, 0, 0)
      html = helper.datetime_as_boolean_tag(datetime)
      fragment = Capybara.string(html)
      expect(fragment).to have_text('✓')
      expect(fragment).to have_css('[data-tooltip*="2023-10-31 12:00:00"]')
    end

    it 'returns a boolean tag with a tooltip "No" for a nil datetime' do
      html = helper.datetime_as_boolean_tag(nil)
      fragment = Capybara.string(html)
      expect(fragment).to have_text('❌')
      expect(fragment).to have_css('[data-tooltip="No"]')
    end

    it 'adds the subdued class when specified for a present datetime' do
      datetime = DateTime.new(2023, 10, 31, 12, 0, 0)
      expect(helper.datetime_as_boolean_tag(datetime, subdue_if: true)).to include('class="bool_true subdued"')
    end

    it 'adds the subdued class when specified for a nil datetime' do
      expect(helper.datetime_as_boolean_tag(nil, subdue_if: false)).to include('class="bool_false subdued"')
    end

    it 'does not generate a tag when the value matches hide_if' do
      datetime = DateTime.new(2023, 10, 31, 12, 0, 0)
      expect(helper.datetime_as_boolean_tag(datetime, hide_if: true)).to eq('')
      expect(helper.datetime_as_boolean_tag(nil, hide_if: false)).to eq('')
    end

    it 'returns a boolean tag with options' do
      datetime = DateTime.new(2023, 10, 31, 12, 0, 0)
      options = { class: 'custom-class', data: { custom: 'value' } }
      subject = helper.datetime_as_boolean_tag(datetime, options)
      expect(subject).to include('✓')
      expect(subject).to include('class="custom-class"')
      expect(subject).to include('data-custom="value"')
    end
  end

  describe '#datetime_tag' do
    it 'returns a formatted datetime string with a tooltip' do
      datetime = DateTime.new(2023, 10, 31, 12, 0, 0)
      html = helper.datetime_tag(datetime)
      fragment = Capybara.string(html)
      expect(fragment).to have_css('span.datetime')
      expect(fragment).to have_text('Tue Oct 31 12:00:00 2023')
      expect(fragment).to have_css('[data-tooltip*="2023-10-31 12:00:00"]')
    end

    it 'returns a formatted datetime string with a tooltip, using words' do
      datetime = DateTime.new(2023, 10, 31, 12, 0, 0)
      html = helper.datetime_tag(datetime, format: :in_words)
      fragment = Capybara.string(html)
      expect(fragment).to have_css('span.datetime')
      expect(fragment).to have_text(time_ago_in_words(datetime))
      expect(fragment).to have_css('[data-tooltip*="2023-10-31 12:00:00"]')
    end

    it 'returns an empty string for a blank datetime' do
      expect(helper.datetime_tag(nil)).to eq('')
    end
  end

  describe '#external_link_to' do
    it 'returns a link with target _blank' do
      expect(helper.external_link_to('Google', 'http://google.com')).to include('target="_blank"')
    end
  end

  describe '#icon_for_scope' do
    it 'returns the correct icon for a known scope' do
      expect(helper.icon_for_scope('address')).to eq('location-dot')
    end

    it 'raises an error for an unknown scope' do
      expect { helper.icon_for_scope('unknown') }.to raise_error(NotImplementedError)
    end
  end

  describe '#flash_icon_name' do
    it 'returns the correct icon for alert' do
      expect(helper.flash_icon_name(:alert)).to eq('triangle-exclamation')
    end

    it 'raises an error for an unsupported flash type' do
      expect { helper.flash_icon_name(:unsupported) }.to raise_error(ArgumentError)
    end
  end

  describe '#flash_tag' do
    it 'returns a flash message with the correct icon' do
      expect(helper.flash_tag(:notice, 'This is a notice')).to include('circle-info')
    end
  end

  describe '#list_delimiter' do
    it 'returns a span with a pipe character' do
      expect(helper.list_delimiter).to include('|')
    end
  end

  describe '#menu_list_item' do
    it 'returns a list item with a link' do
      expect(helper.menu_list_item('Home', root_path)).to include('li')
      expect(helper.menu_list_item('Home', root_path)).to include('a')
    end
  end

  describe '#number_with_percentage' do
    it 'returns a number with percentage' do
      expect(helper.number_with_percentage(50, 200)).to include('50')
      expect(helper.number_with_percentage(50, 200)).to include('25.0%')
    end
  end

  describe '#searchbar_tag' do
    it 'returns a search bar with filters' do
      model = double('Model', name: 'UtilityCartPass', scopes: [])
      expect(helper.searchbar_tag(model)).to include('searchbar')
    end
  end

  describe '#search_form_tag' do
    it 'returns a search form' do
      expect(helper.search_form_tag('/search')).to include('form')
      expect(helper.search_form_tag('/search')).to include('search-form')
    end
  end

  describe '#sort_models' do
    it 'sorts models by the specified column and direction' do
      models = [double('Model', name: 'B'), double('Model', name: 'A')]
      sorted_models = helper.sort_models(models, column: :name, direction: :asc)
      expect(sorted_models.map(&:name)).to eq(['A', 'B'])
    end
  end
end
