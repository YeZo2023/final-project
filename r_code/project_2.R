library(readxl)
library(dplyr)
library(ggplot2)
library(Cairo)
library(ggrepel)

# Load data from an Excel file
data <- read_excel("raw_data/WIF-tis4d.xlsx")

# Clean the data by converting specific columns to lowercase
data_cleaned <- data %>%
  mutate(
    cell_line = tolower(cell_line),
    treatment = tolower(treatment),
    name = tolower(name),
    treatment_color = ifelse(treatment == "activating factor 42", "blue", "goldenrod")
  ) %>%
  group_by(cell_line, treatment) %>%
  mutate(is_last = conc == max(conc)) %>%
  ungroup()

# Create the plot
p <- ggplot(data_cleaned, aes(x = conc, y = gene_expression, color = treatment)) + 
  geom_point() + 
  geom_label_repel(
    data = filter(data_cleaned, is_last), 
    aes(label = name, fill = treatment_color), 
    colour = "white",
    fontface = "bold",
    size = 3.5,
    nudge_x = 0.5,
    nudge_y = 0.5,
    na.rm = TRUE,
    box.padding   = 0.35,
    point.padding = 0.6,
    segment.color = 'grey50'
  ) + 
  coord_cartesian(ylim = c(NA, 50), xlim = c(NA, 12)) +  # Expand boundaries to accommodate labels
  facet_wrap(~ cell_line, scales = 'free') + 
  theme_minimal(base_family = "Times New Roman") + 
  theme(
    panel.background = element_rect(fill = "white"),
    legend.position = "bottom",
    axis.title = element_text(size=12),
    axis.text = element_text(size=10),
    legend.text = element_text(size=10),
    legend.title = element_text(size=12),
    plot.title = element_text(size=14, face="bold"),
    legend.key = element_blank()  # Remove legend background
  ) +
  scale_color_manual(values = c("activating factor 42" = "blue", "placebo" = "goldenrod")) +
  scale_fill_manual(values = c("activating factor 42" = "blue", "placebo" = "goldenrod")) +
  labs(title = "Gene Expression Levels", x = "Concentration (μg/ml)", y = "Gene Expression", color = "Treatment")

# Use Cairo to save as TIFF with correct resolution and dimensions
Cairo(file="figs/gene_expression_plot.tiff", type="tiff", units="in", width=9, height=6, dpi=500)
print(p)
dev.off()
