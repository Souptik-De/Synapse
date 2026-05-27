# ============================================================
#  Sleep Health & Lifestyle — Preliminary Analysis
#  Requires: ggplot2 only (base R for all data wrangling)
# ============================================================

# ── 0. Load ggplot2 (install only if truly missing) ───────
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
library(ggplot2)

# ── 1. Load & clean data ──────────────────────────────────
df <- read.csv("Sleep_health_and_lifestyle_dataset.csv",
               stringsAsFactors = FALSE)
names(df) <- gsub("\\.", "_", make.names(names(df)))

df$Sleep_Disorder <- factor(df$Sleep_Disorder,
                            levels = c("None", "Sleep Apnea", "Insomnia"))
df$BMI_Category   <- factor(df$BMI_Category,
                            levels = c("Normal", "Normal Weight",
                                       "Overweight", "Obese"))
df$Stress_Level   <- as.integer(df$Stress_Level)

cat("Dataset:", nrow(df), "rows x", ncol(df), "cols\n")
cat("\nDisorder distribution:\n")
print(table(df$Sleep_Disorder))


# ── 2. Shared theme & palettes ────────────────────────────
pal_disorder <- c("None"        = "#1D9E75",
                  "Sleep Apnea" = "#378ADD",
                  "Insomnia"    = "#E24B4A")

theme_sleep <- function() {
  theme_minimal(base_size = 12) +
    theme(
      plot.title       = element_text(size = 13, face = "bold",
                                      margin = margin(b = 5)),
      plot.subtitle    = element_text(size = 10, color = "grey50",
                                      margin = margin(b = 8)),
      plot.caption     = element_text(size = 8, color = "grey55", hjust = 0),
      axis.title       = element_text(size = 10, color = "grey40"),
      axis.text        = element_text(size = 9,  color = "grey40"),
      legend.title     = element_text(size = 9),
      legend.text      = element_text(size = 9),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "grey92")
    )
}


# ══════════════════════════════════════════════════════════
#  PLOT 1 — Disorder distribution (bar)
# ══════════════════════════════════════════════════════════
d1        <- as.data.frame(table(df$Sleep_Disorder))
names(d1) <- c("Disorder", "Count")
d1$Pct    <- round(d1$Count / sum(d1$Count) * 100, 1)
d1$Label  <- paste0(d1$Count, "\n(", d1$Pct, "%)")

p1 <- ggplot(d1, aes(x = Disorder, y = Count, fill = Disorder)) +
  geom_col(width = 0.55, color = "white") +
  geom_text(aes(label = Label), vjust = -0.4, size = 3.3) +
  scale_fill_manual(values = pal_disorder) +
  scale_y_continuous(limits = c(0, 260)) +
  labs(title   = "Sleep Disorder Distribution",
       subtitle = "n = 374 participants",
       x = NULL, y = "Count", caption = "Fig 1") +
  theme_sleep() +
  theme(legend.position = "none")
p1

# ══════════════════════════════════════════════════════════
#  PLOT 2 — Stress Level vs Sleep Quality & Duration
# ══════════════════════════════════════════════════════════
stress_q <- tapply(df$Quality_of_Sleep, df$Stress_Level, mean)
stress_d <- tapply(df$Sleep_Duration,   df$Stress_Level, mean)
sl       <- as.integer(names(stress_q))

d2 <- data.frame(
  Stress_Level = rep(sl, 2),
  Value        = c(as.numeric(stress_q), as.numeric(stress_d)),
  Metric       = rep(c("Sleep Quality (1-10)", "Sleep Duration (hrs)"),
                     each = length(sl))
)

p2 <- ggplot(d2, aes(x = factor(Stress_Level), y = Value,
                     fill = Metric, group = Metric)) +
  geom_col(position = position_dodge(0.7), width = 0.6,
           color = "white") +
  geom_line(aes(color = Metric),
            position = position_dodge(0.7), linewidth = 0.8) +
  geom_point(aes(color = Metric),
             position = position_dodge(0.7), size = 2.4) +
  scale_fill_manual(values  = c("Sleep Quality (1-10)" = "#378ADD",
                                "Sleep Duration (hrs)" = "#BA7517")) +
  scale_color_manual(values = c("Sleep Quality (1-10)" = "#185FA5",
                                "Sleep Duration (hrs)" = "#854F0B")) +
  scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, 2)) +
  labs(title    = "Stress Level vs Sleep Quality & Duration",
       subtitle = "Both metrics decline steadily as stress increases",
       x = "Stress Level (3 = low  to  8 = high)",
       y = "Score / Hours",
       fill = NULL, color = NULL, caption = "Fig 2") +
  theme_sleep() +
  theme(legend.position = "top")
p2

# ══════════════════════════════════════════════════════════
#  PLOT 3 — BMI Category vs Disorder (stacked 100% bar)
# ══════════════════════════════════════════════════════════
bmi_tbl <- table(df$BMI_Category, df$Sleep_Disorder)
bmi_pct <- prop.table(bmi_tbl, margin = 1)

d3        <- as.data.frame(bmi_pct)
names(d3) <- c("BMI", "Disorder", "Pct")
d3$Label  <- ifelse(d3$Pct > 0.07, paste0(round(d3$Pct * 100), "%"), "")

p3 <- ggplot(d3, aes(x = BMI, y = Pct, fill = Disorder)) +
  geom_col(color = "white", linewidth = 0.4) +
  geom_text(aes(label = Label),
            position = position_stack(vjust = 0.5),
            size = 3, color = "white", fontface = "bold") +
  scale_fill_manual(values = pal_disorder) +
  scale_y_continuous(labels = function(x) paste0(round(x * 100), "%")) +
  labs(title    = "Sleep Disorder Rate by BMI Category",
       subtitle = "Overweight/Obese groups are almost entirely disorder-positive",
       x = NULL, y = "Proportion", fill = "Disorder", caption = "Fig 3") +
  theme_sleep() +
  theme(legend.position = "top")
p3

# ══════════════════════════════════════════════════════════
#  PLOT 4 — Mean Stress Level by Disorder (bar + error bar)
# ══════════════════════════════════════════════════════════
stress_means <- tapply(df$Stress_Level, df$Sleep_Disorder, mean)
stress_se    <- tapply(df$Stress_Level, df$Sleep_Disorder,
                       function(x) sd(x) / sqrt(length(x)))

d4 <- data.frame(
  Disorder    = factor(names(stress_means),
                       levels = c("None", "Sleep Apnea", "Insomnia")),
  Mean_Stress = as.numeric(stress_means),
  SE          = as.numeric(stress_se)
)

p4 <- ggplot(d4, aes(x = Disorder, y = Mean_Stress, fill = Disorder)) +
  geom_col(width = 0.5, color = "white") +
  geom_errorbar(aes(ymin = Mean_Stress - SE, ymax = Mean_Stress + SE),
                width = 0.18, linewidth = 0.7, color = "grey35") +
  geom_text(aes(label = round(Mean_Stress, 2)),
            vjust = -1.2, size = 3.5, fontface = "bold") +
  scale_fill_manual(values = pal_disorder) +
  scale_y_continuous(limits = c(0, 7.5), breaks = seq(0, 8, 2)) +
  labs(title    = "Average Stress Level by Sleep Disorder",
       subtitle = "Error bars = +/- 1 SE",
       x = NULL, y = "Mean Stress Level", caption = "Fig 4") +
  theme_sleep() +
  theme(legend.position = "none")
p4

# ══════════════════════════════════════════════════════════
#  PLOT 5 — Physical Activity & Daily Steps by Disorder
# ══════════════════════════════════════════════════════════
act_means   <- tapply(df$Physical_Activity_Level, df$Sleep_Disorder, mean)
steps_means <- tapply(df$Daily_Steps,             df$Sleep_Disorder, mean) / 100

d5 <- data.frame(
  Disorder = rep(factor(names(act_means),
                        levels = c("None", "Sleep Apnea", "Insomnia")), 2),
  Value    = c(as.numeric(act_means), as.numeric(steps_means)),
  Metric   = rep(c("Avg Activity (min/day)", "Avg Daily Steps / 100"),
                 each = 3)
)

p5 <- ggplot(d5, aes(x = Disorder, y = Value,
                     fill = Disorder, alpha = Metric)) +
  geom_col(position = position_dodge(0.7), width = 0.55,
           color = "white") +
  geom_text(aes(label = round(Value, 1)),
            position = position_dodge(0.7),
            vjust = -0.5, size = 3.2, fontface = "bold") +
  scale_fill_manual(values = pal_disorder) +
  scale_alpha_manual(values = c("Avg Activity (min/day)" = 1.0,
                                "Avg Daily Steps / 100"  = 0.55)) +
  scale_y_continuous(limits = c(0, 100)) +
  labs(title    = "Physical Activity & Daily Steps by Disorder Group",
       subtitle = "Sleep apnea group has highest activity yet still has disorder",
       x = NULL, y = "Value",
       fill = "Disorder", alpha = "Metric", caption = "Fig 5") +
  theme_sleep() +
  theme(legend.position = "top")
p5

# ══════════════════════════════════════════════════════════
#  PLOT 6 — Correlation heatmap (base R cor, ggplot2 tile)
# ══════════════════════════════════════════════════════════
num_df <- df[, c("Age", "Sleep_Duration", "Quality_of_Sleep",
                 "Physical_Activity_Level", "Stress_Level",
                 "Heart_Rate", "Daily_Steps")]
colnames(num_df) <- c("Age", "Sleep Dur.", "Quality",
                      "Activity", "Stress", "Heart Rate", "Steps")

corr_mat <- cor(num_df, use = "pairwise.complete.obs")
vars     <- colnames(corr_mat)

# Build long-form lower triangle manually
d6 <- expand.grid(Var1 = vars, Var2 = vars, stringsAsFactors = FALSE)
d6$value   <- as.vector(corr_mat)
d6$row_idx <- match(d6$Var1, vars)
d6$col_idx <- match(d6$Var2, vars)
d6         <- d6[d6$row_idx >= d6$col_idx, ]
d6$Var1    <- factor(d6$Var1, levels = vars)
d6$Var2    <- factor(d6$Var2, levels = vars)
d6$label   <- ifelse(d6$row_idx == d6$col_idx, "",
                     sprintf("%.2f", d6$value))

p6 <- ggplot(d6, aes(x = Var2, y = Var1, fill = value)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = label), size = 3, color = "grey20") +
  scale_fill_gradient2(low = "#E24B4A", mid = "white", high = "#378ADD",
                       midpoint = 0, limits = c(-1, 1), name = "r") +
  labs(title = "Correlation Matrix — Key Numeric Variables",
       x = NULL, y = NULL, caption = "Fig 6") +
  theme_sleep() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1),
        panel.grid  = element_blank())
p6

# ══════════════════════════════════════════════════════════
#  PLOT 7 — Sleep Quality boxplots by Disorder
# ══════════════════════════════════════════════════════════
set.seed(42)
df$jx <- as.integer(df$Sleep_Disorder) + runif(nrow(df), -0.18, 0.18)

p7 <- ggplot(df, aes(x = Sleep_Disorder, y = Quality_of_Sleep,
                     fill = Sleep_Disorder)) +
  geom_boxplot(width = 0.45, outlier.shape = NA, alpha = 0.75,
               color = "grey30", linewidth = 0.5) +
  geom_point(aes(x = jx, color = Sleep_Disorder),
             size = 0.9, alpha = 0.35) +
  scale_fill_manual(values  = pal_disorder) +
  scale_color_manual(values = pal_disorder) +
  labs(title    = "Sleep Quality Distribution by Disorder",
       subtitle = "Disorder groups show compressed, lower-quality sleep",
       x = NULL, y = "Quality of Sleep (1-10)", caption = "Fig 7") +
  theme_sleep() +
  theme(legend.position = "none")

p7
# ══════════════════════════════════════════════════════════
#  SAVE — Individual plots
# ══════════════════════════════════════════════════════════
plot_list <- list(
  plot1_disorder_distribution = p1,
  plot2_stress_vs_sleep       = p2,
  plot3_bmi_vs_disorder       = p3,
  plot4_stress_by_disorder    = p4,
  plot5_activity_by_disorder  = p5,
  plot6_correlation_heatmap   = p6,
  plot7_quality_boxplots      = p7
)

for (nm in names(plot_list)) {
  fname <- paste0(nm, ".png")
  ggsave(fname, plot_list[[nm]], width = 6.5, height = 5, dpi = 180)
  cat("Saved:", fname, "\n")
}

# ── Combined dashboard via grid (no patchwork needed) ─────
if (requireNamespace("grid", quietly = TRUE)) {  # grid ships with base R
  library(grid)
  png("sleep_analysis_dashboard.png", width = 2600, height = 3000, res = 180)
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(4, 2)))
  vp <- function(r, c) viewport(layout.pos.row = r, layout.pos.col = c)
  print(p2, vp = vp(1, 1)); print(p3, vp = vp(1, 2))
  print(p4, vp = vp(2, 1)); print(p5, vp = vp(2, 2))
  print(p7, vp = vp(3, 1)); print(p6, vp = vp(3, 2))
  print(p1, vp = vp(4, 1))
  dev.off()
  cat("Saved: sleep_analysis_dashboard.png\n")
}


# ══════════════════════════════════════════════════════════
#  CONSOLE SUMMARY — Slide 3 numbers
# ══════════════════════════════════════════════════════════
cat("\n== SLIDE 3 KEY NUMBERS ==\n")

cat("\n[1] Disorder distribution:\n")
tbl <- table(df$Sleep_Disorder)
print(data.frame(Disorder = names(tbl),
                 Count    = as.integer(tbl),
                 Pct      = paste0(round(tbl / sum(tbl) * 100, 1), "%")))

cat("\n[2] Avg quality & duration by stress level:\n")
sl_lvls <- sort(unique(df$Stress_Level))
print(data.frame(
  Stress_Level = sl_lvls,
  Avg_Quality  = round(tapply(df$Quality_of_Sleep, df$Stress_Level,
                              mean)[as.character(sl_lvls)], 2),
  Avg_Duration = round(tapply(df$Sleep_Duration, df$Stress_Level,
                              mean)[as.character(sl_lvls)], 2),
  n            = as.integer(table(df$Stress_Level)[as.character(sl_lvls)])
))

cat("\n[3] Avg stress by disorder:\n")
print(data.frame(
  Disorder    = levels(df$Sleep_Disorder),
  Mean_Stress = round(tapply(df$Stress_Level,
                             df$Sleep_Disorder, mean), 2)
))

cat("\n[4] Avg physical activity & steps by disorder:\n")
print(data.frame(
  Disorder     = levels(df$Sleep_Disorder),
  Avg_Activity = round(tapply(df$Physical_Activity_Level,
                              df$Sleep_Disorder, mean), 1),
  Avg_Steps    = round(tapply(df$Daily_Steps,
                              df$Sleep_Disorder, mean))
))