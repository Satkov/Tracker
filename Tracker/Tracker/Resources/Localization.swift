import Foundation

enum Localization {
    // Edit New Tracker
    static let editNewTrackerTitleHabit = localized("editNewTracker.title.habit")
    static let editNewTrackerTitleIrregular = localized("editNewTracker.title.irregular")

    // Onboarding
    static let onboardingButton = localized("onboarding.button")
    static let onboardingFirstPageLabel = localized("onboardingPage.label.firstPage")
    static let onboardingSecondPageLabel = localized("onboardingPage.label.secondPage")

    // Tab Bar
    static let tabBarStatisticTitle = localized("tabbar.title.statistic")

    // Trackers & Statistics
    static let trackersTitle = localized("trackers")
    static let searchPlaceholder = localized("search")
    static let statisticTitle = localized("statistic")
    static let irregularEventTitle = localized("irregularEvent")
    static let trackerListPlaceholder = localized("trackerList.placeholder")
    static let statisticPagePlaceholder = localized("statisticPage.placeholder")
    static let habbit = localized("habit")

    // Tracker Creation
    static let trackerCreationTitle = localized("trackerCreation")
    static let colorTitle = localized("color")
    static let emojiTitle = localized("emoji")
    static let nameFieldMaxLengthWarning = localized("nameFieldMaxLength.warning.label")
    static let cancelButton = localized("cancel")
    static let createButton = localized("create")

    // Category & Schedule
    static let categoryTitle = localized("category")
    static let scheduleTitle = localized("schedule")
    static let createTrackerNamePlaceholder = localized("createTrackerNameField.placeholder")
    static let addCategoryButton = localized("addCategory")
    static let categoryPagePlaceholder = localized("categoryPage.placeholder")
    static let newCategoryTitle = localized("newCategory")
    static let readyButton = localized("ready")
    static let typeCategoryNamePlaceholder = localized("typeCategoryName")

    // Filters
    static let filters = localized("filters")
    static let filter = localized("filter")
    static let allTrackers = localized("allTrackers")
    static let trackersForToday = localized("trackersForToday")
    static let finished = localized("finished")
    static let notFinished = localized("notFinished")
    static let unpin = localized("unpin")
    static let pin = localized("pin")
    static let edit = localized("edit")
    static let delete = localized("delete")
    static let deleteConfirmationMessage = localized("deleteConfirmationMessage")
    static let save = localized("save")

    // MARK: - Helper Method for Localization
    private static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
