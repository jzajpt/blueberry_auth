module I18nMacros
  def should_not_have_missing_translations
    should "not have missing translations" do
      assert_select '.translation_missing', false
    end
  end
end

Test::Unit::TestCase.extend(I18nMacros)