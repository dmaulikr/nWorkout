//
//  StringStyle+Part.swift
//  BonMot
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

extension StringStyle {

    /// Each `Part` encapsulates one setting in a `StringStyle`. It is used
    /// in a DSL for building `StringStyle` across BonMot.
    public enum Part {

        case extraAttributes(StyleAttributes)
        case font(BONFont)
        case link(NSURL)
        case backgroundColor(BONColor)
        case color(BONColor)
        case underline(NSUnderlineStyle, BONColor?)
        case strikethrough(NSUnderlineStyle, BONColor?)
        case baselineOffset(CGFloat)

        #if os(iOS) || os(tvOS) || os(watchOS)

        /// If set to `true`, when the string is read aloud, all punctuation will
        /// be spoken aloud as well.
        case speaksPunctuation(Bool)

        /// The BCP 47 language code that you would like the system to use when
        /// reading this string aloud. A BCP 47 language code is generally of
        /// the form “language-REGION”, e.g. “en-US”. You can see a [list of
        /// languages and regions](http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry)
        /// and learn more about [BCP 47](https://www.rfc-editor.org/rfc/rfc5646.txt).
        case speakingLanguage(String)

        /// The pitch of the voice used to read the text aloud. The range is
        /// 0 to 2, where 0 is the lowest, 2 is the highest, and 1 is the default.
        case speakingPitch(Double)
        #endif

        case ligatures(Ligatures)

        case alignment(NSTextAlignment)
        case tracking(Tracking)
        case lineSpacing(CGFloat)
        case paragraphSpacingAfter(CGFloat)
        case firstLineHeadIndent(CGFloat)
        case headIndent(CGFloat)
        case tailIndent(CGFloat)
        case lineBreakMode(NSLineBreakMode)
        case minimumLineHeight(CGFloat)
        case maximumLineHeight(CGFloat)
        case baseWritingDirection(NSWritingDirection)
        case lineHeightMultiple(CGFloat)
        case paragraphSpacingBefore(CGFloat)

        /// Values from 0 to 1 will result in varying levels of hyphenation,
        /// with higher values resulting in more aggressive (i.e. more frequent)
        /// hyphenation.
        ///
        /// Hyphenation is attempted when the ratio of the text width (as broken
        /// without hyphenation) to the width of the line fragment is less than
        /// the hyphenation factor. When the paragraph’s hyphenation factor is
        /// 0.0, the layout manager’s hyphenation factor is used instead. When
        /// both are 0.0, hyphenation is disabled.
        case hyphenationFactor(Float)

        case xml
        case xmlRules([XMLStyleRule])
        case xmlStyler(XMLStyler)
        #if os(iOS) || os(tvOS) || os(OSX)
        case fontFeature(FontFeatureProvider)

        case numberSpacing(NumberSpacing)
        case numberCase(NumberCase)

        case superscript(Bool)
        case `subscript`(Bool)
        case ordinals(Bool)
        case scientificInferiors(Bool)

        case smallCaps(SmallCaps)

        case stylisticAlternates(StylisticAlternates)
        case contextualAlternates(ContextualAlternates)
        #endif
        #if os(iOS) || os(tvOS)
        case textStyle(BonMotTextStyle)
        #endif
        #if os(iOS) || os(tvOS)
        case adapt(AdaptiveStyle)
        #endif

        // An advanced part that allows combining multiple parts as a single part
        case style(StringStyle)

    }

    /// Create a `StringStyle` from zero or more `Part`s.
    ///
    /// - Parameter parts: Zero or more `Part`s
    public init(_ parts: Part...) {
        self.init(parts)
    }

    /// Create a `StringStyle` from an array of parts
    ///
    /// - Parameter parts: An array of `StylePart`s
    public init(_ parts: [Part]) {
        self.init()
        for part in parts {
            update(part: part)
        }
    }

    #if swift(>=3.0)
    #else
    /// Create a `StringStyle` from a part. This is needed for Swift 2.3
    /// to disambiguate argument type in certain cases.
    ///
    /// - Parameter part: a `Part`
    public init(_ part: Part) {
        self.init()
        update(part: part)
    }
    #endif

    #if swift(>=3.0)
    /// Derive a new `StringStyle` based on this style, updated with zero or
    /// more `Part`s.
    ///
    /// - Parameter parts: Zero or more `Part`s
    /// - Returns: A newly configured `StringStyle`
    public func byAdding(_ parts: Part...) -> StringStyle {
        var style = self
        for part in parts {
            style.update(part: part)
        }
        return style
    }
    #else
    /// Derive a new `StringStyle` based on this style, updated with zero or
    /// more `Part`s.
    ///
    /// - Parameter parts: Zero or more `Part`s
    /// - Returns: A newly configured `StringStyle`
    public func byAdding(parts: Part...) -> StringStyle {
        var style = self
        for part in parts {
            style.update(part: part)
        }
        return style
    }
    #endif

    //swiftlint:disable function_body_length
    //swiftlint:disable cyclomatic_complexity
    /// Update the style with the specified style part.
    ///
    /// - Parameter stylePart: The style part with which to update the receiver.
    mutating func update(part stylePart: Part) {
        switch stylePart {
        case let .extraAttributes(attributes):
            self.extraAttributes = attributes
        case let .font(font):
            self.font = font
        case let .link(link):
            self.link = link
        case let .backgroundColor(backgroundColor):
            self.backgroundColor = backgroundColor
        case let .color(color):
            self.color = color
        case let .underline(underline):
            self.underline = underline
        case let .strikethrough(strikethrough):
            self.strikethrough = strikethrough
        case let .baselineOffset(baselineOffset):
            self.baselineOffset = baselineOffset
        case let .ligatures(ligatures):
            self.ligatures = ligatures
        case let .alignment(alignment):
            self.alignment = alignment
        case let .tracking(tracking):
            self.tracking = tracking
        case let .lineSpacing(lineSpacing):
            self.lineSpacing = lineSpacing
        case let .paragraphSpacingAfter(paragraphSpacingAfter):
            self.paragraphSpacingAfter = paragraphSpacingAfter
        case let .firstLineHeadIndent(firstLineHeadIndent):
            self.firstLineHeadIndent = firstLineHeadIndent
        case let .headIndent(headIndent):
            self.headIndent = headIndent
        case let .tailIndent(tailIndent):
            self.tailIndent = tailIndent
        case let .lineBreakMode(lineBreakMode):
            self.lineBreakMode = lineBreakMode
        case let .minimumLineHeight(minimumLineHeight):
            self.minimumLineHeight = minimumLineHeight
        case let .maximumLineHeight(maximumLineHeight):
            self.maximumLineHeight = maximumLineHeight
        case let .baseWritingDirection(baseWritingDirection):
            self.baseWritingDirection = baseWritingDirection
        case let .lineHeightMultiple(lineHeightMultiple):
            self.lineHeightMultiple = lineHeightMultiple
        case let .paragraphSpacingBefore(paragraphSpacingBefore):
            self.paragraphSpacingBefore = paragraphSpacingBefore
        case .xml:
            self.xmlStyler = NSAttributedString.defaultXMLStyler
        case var .xmlRules(rules):
            rules.append(contentsOf: Special.insertionRules)
            self.xmlStyler = XMLStyleRule.Styler(rules: rules)
        case let .xmlStyler(xmlStyler):
            self.xmlStyler = xmlStyler
        case let .style(style):
            self.add(stringStyle: style)
        default:
            // interaction between `#if` and `switch` is disappointing. This case
            // is in `default:` to remove a warning that default won't be accessed
            // on some platforms.
            switch stylePart {
            case let .hyphenationFactor(hyphenationFactor):
                self.hyphenationFactor = hyphenationFactor
            default:
                #if os(iOS) || os(tvOS) || os(watchOS)
                    switch stylePart {
                    case let .speaksPunctuation(speaksPunctuation):
                        self.speaksPunctuation = speaksPunctuation
                        return
                    case let .speakingLanguage(speakingLanguage):
                        self.speakingLanguage = speakingLanguage
                        return
                    case let .speakingPitch(speakingPitch):
                        self.speakingPitch = speakingPitch
                        return
                    default:
                        break
                    }
                #endif

                #if os(OSX) || os(iOS) || os(tvOS)
                    switch stylePart {
                    case let .numberCase(numberCase):
                        self.numberCase = numberCase
                    case let .numberSpacing(numberSpacing):
                        self.numberSpacing = numberSpacing
                    case let .superscript(superscript):
                        self.superscript = superscript
                    case let .`subscript`(`subscript`):
                        self.`subscript` = `subscript`
                    case let .ordinals(ordinals):
                        self.ordinals = ordinals
                    case let .scientificInferiors(scientificInferiors):
                        self.scientificInferiors = scientificInferiors
                    case let .smallCaps(smallCaps):
                        self.smallCaps.insert(smallCaps)
                    case let .stylisticAlternates(stylisticAlternates):
                        self.stylisticAlternates.add(other: stylisticAlternates)
                    case let .contextualAlternates(contextualAlternates):
                        self.contextualAlternates.add(other: contextualAlternates)
                    case let .fontFeature(featureProvider):
                        self.fontFeatureProviders.append(featureProvider)
                    default:
                        #if os(iOS) || os(tvOS)
                            switch stylePart {
                            case let .adapt(style):
                                self.adaptations.append(style)
                            case let .textStyle(textStyle):
                                self.font = UIFont.bon_preferredFont(forTextStyle: textStyle, compatibleWith: nil)
                            default:
                                fatalError("StylePart \(stylePart) should have been caught by an earlier case.")
                            }
                        #else
                            fatalError("StylePart \(stylePart) should have been caught by an earlier case.")
                        #endif
                    }
                #else
                    fatalError("StylePart \(stylePart) should have been caught by an earlier case.")
                #endif
            }
        }
    }
    //swiftlint:enable function_body_length
    //swiftlint:enable cyclomatic_complexity

}
