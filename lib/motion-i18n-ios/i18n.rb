module I18n
  class << self

    def translate(key, substitutions = {})
      String.new((bundle.localizedStringForKey(key, value:"", table:nil))).tap do |result|
        substitutions.each do |key, value|
          result.gsub!("%{#{key}}", value.to_s)
        end
      end
    end

    alias t translate

    def availableLanguages
      @availableLanguages || []
    end

    def setAvailableLanguages(languages)
      @availableLanguages = languages
    end

    def setLanguage(languageLocale)
      NSUserDefaults.standardUserDefaults.setObject(languageLocale, forKey: nsUserDefaultsKey)
      NSUserDefaults.standardUserDefaults.synchronize
      @language = languageLocale
    end

    def language
      @language ||= begin
        NSUserDefaults.standardUserDefaults.objectForKey(nsUserDefaultsKey) || defaultLanguage
      end
    end

    def bundle
      NSBundle.bundleWithPath(bundlePath)
    end

    def bundlePath
      NSBundle.mainBundle.pathForResource(language, ofType: "lproj") || NSBundle.mainBundle.pathForResource(defaultLanguage, ofType: "lproj")
    end

    def defaultLanguage
      if availableLanguages.include?(NSLocale.currentLocale.objectForKey(NSLocaleLanguageCode))
        NSLocale.currentLocale.objectForKey(NSLocaleLanguageCode)
      else
        "en"
      end
    end

    def nsUserDefaultsKey
      "motion-i18n_locale"
    end
  end
end
