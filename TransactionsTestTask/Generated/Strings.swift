// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Common {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "common.cancel", fallback: "Cancel")
    /// Done
    internal static let done = L10n.tr("Localizable", "common.done", fallback: "Done")
    /// Ok
    internal static let ok = L10n.tr("Localizable", "common.ok", fallback: "Ok")
    internal enum Error {
      internal enum Generic {
        /// An unknown error occured. Please try again.
        internal static let message = L10n.tr("Localizable", "common.error.generic.message", fallback: "An unknown error occured. Please try again.")
        /// Error
        internal static let title = L10n.tr("Localizable", "common.error.generic.title", fallback: "Error")
      }
    }
  }
  internal enum Dashboard {
    /// Add transaction
    internal static let addTransactionButton = L10n.tr("Localizable", "dashboard.addTransactionButton", fallback: "Add transaction")
    /// Dashboard
    internal static let title = L10n.tr("Localizable", "dashboard.title", fallback: "Dashboard")
    internal enum Balance {
      /// Refill
      internal static let refillButton = L10n.tr("Localizable", "dashboard.balance.refillButton", fallback: "Refill")
      /// Localizable.strings
      ///   TransactionsTestTask
      /// 
      ///   Created by Stanislav Volskyi on 11.07.2025.
      internal static func title(_ p1: Any) -> String {
        return L10n.tr("Localizable", "dashboard.balance.title", String(describing: p1), fallback: "Balance: %@ BTC")
      }
    }
    internal enum Rate {
      /// 1 BTC = %@ USD
      internal static func btcUsd(_ p1: Any) -> String {
        return L10n.tr("Localizable", "dashboard.rate.btcUsd", String(describing: p1), fallback: "1 BTC = %@ USD")
      }
    }
  }
  internal enum RefillBalance {
    /// Please enter an amount you would like to refill:
    internal static let message = L10n.tr("Localizable", "refillBalance.message", fallback: "Please enter an amount you would like to refill:")
    /// Refill your balance
    internal static let title = L10n.tr("Localizable", "refillBalance.title", fallback: "Refill your balance")
  }
  internal enum Transactions {
    /// Select category:
    internal static let selectCategory = L10n.tr("Localizable", "transactions.selectCategory", fallback: "Select category:")
    internal enum AddTransaction {
      /// New transaction
      internal static let title = L10n.tr("Localizable", "transactions.addTransaction.title", fallback: "New transaction")
    }
    internal enum Btc {
      /// BTC
      internal static let code = L10n.tr("Localizable", "transactions.btc.code", fallback: "BTC")
    }
    internal enum Category {
      /// Electronics
      internal static let electronics = L10n.tr("Localizable", "transactions.category.electronics", fallback: "Electronics")
      /// Groceries
      internal static let groceries = L10n.tr("Localizable", "transactions.category.groceries", fallback: "Groceries")
      /// Other
      internal static let other = L10n.tr("Localizable", "transactions.category.other", fallback: "Other")
      /// Restaurant
      internal static let restaurant = L10n.tr("Localizable", "transactions.category.restaurant", fallback: "Restaurant")
      /// Taxi
      internal static let taxi = L10n.tr("Localizable", "transactions.category.taxi", fallback: "Taxi")
    }
    internal enum Error {
      internal enum EmptyFields {
        /// Please enter amount and select category.
        internal static let message = L10n.tr("Localizable", "transactions.error.emptyFields.message", fallback: "Please enter amount and select category.")
        /// Fields required
        internal static let title = L10n.tr("Localizable", "transactions.error.emptyFields.title", fallback: "Fields required")
      }
      internal enum InsufficientBalance {
        /// Please refill your balance.
        internal static let message = L10n.tr("Localizable", "transactions.error.insufficientBalance.message", fallback: "Please refill your balance.")
        /// Insufficient balance
        internal static let title = L10n.tr("Localizable", "transactions.error.insufficientBalance.title", fallback: "Insufficient balance")
      }
    }
    internal enum Reference {
      /// Description
      internal static let placeholder = L10n.tr("Localizable", "transactions.reference.placeholder", fallback: "Description")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
