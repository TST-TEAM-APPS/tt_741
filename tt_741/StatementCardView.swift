import SwiftUI

struct StatementCardView: View {
    let character: Character
    let statement: Statement
    let selectedAnswer: Bool?
    let onSelectTruth: () -> Void
    let onSelectLie: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Character Info
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(character.color.opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Text(String(character.name.prefix(1)))
                        .font(Typography.title3)
                        .foregroundColor(character.color)
                        .fontWeight(.bold)
                }
                
                Text(character.name)
                    .font(Typography.headline)
                    .foregroundColor(Palette.text)
                
                Spacer()
                
                if let answer = selectedAnswer {
                    SelectionBadge(isTruth: answer)
                }
            }
            
            // Statement
            Text(statement.text)
                .font(Typography.body)
                .foregroundColor(Palette.text)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            // Selection Buttons
            HStack(spacing: 12) {
                Button(action: onSelectTruth) {
                    HStack(spacing: 6) {
                        CustomIconView(name: "checkmark", size: 16)
                        Text("Truth")
                            .font(Typography.callout)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedAnswer == true ? .white : Palette.success)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedAnswer == true ? Palette.success : Palette.success.opacity(0.15))
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: onSelectLie) {
                    HStack(spacing: 6) {
                        CustomIconView(name: "xmark", size: 16)
                        Text("Lie")
                            .font(Typography.callout)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedAnswer == false ? .white : Palette.error)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedAnswer == false ? Palette.error : Palette.error.opacity(0.15))
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(20)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Palette.cardBackground)
                
                if let answer = selectedAnswer {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(answer ? Palette.success : Palette.error, lineWidth: 2)
                }
            }
        )
        .shadow(color: Color.black.opacity(selectedAnswer != nil ? 0.1 : 0.05), radius: selectedAnswer != nil ? 15 : 10, x: 0, y: 4)
    }
}

struct SelectionBadge: View {
    let isTruth: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            CustomIconView(name: isTruth ? "checkmark" : "xmark", size: 14)
            Text(isTruth ? "Truth" : "Lie")
                .font(Typography.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(isTruth ? Palette.success : Palette.error)
        )
    }
}
