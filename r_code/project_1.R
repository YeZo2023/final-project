library(readxl)
library(dplyr)
library(ggplot2)

# Read the data from the Excel file
data <- read_excel("raw_data/WIF-tis4d.xlsx")

# Clean the data by converting certain columns to lower case
data_cleaned <- data %>%
  mutate(
    cell_line = tolower(cell_line),
    treatment = tolower(treatment),
    name = tolower(name)
  )

# Generate Categorize data
Categorized_data <- data_cleaned %>%
  group_by(cell_line, treatment, conc) %>%
  summarise(
    Mean_Expression = mean(gene_expression, na.rm = TRUE),
    SD_Expression = sd(gene_expression, na.rm = TRUE),
    .groups = 'drop'  # This option drops the grouping
  )

# Create a line plot with points showing mean gene expression across treatments and concentrations
plot <- ggplot(Categorized_data, aes(x = conc, y = Mean_Expression, group = treatment, color = treatment)) +
  geom_line() +
  geom_point() +
  facet_wrap(~cell_line) +  # Create separate plots for each cell line
  labs(title = "Mean Gene Expression Across Treatments and Conc",
       x = "Conc", y = "Mean Gene Expression") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1") +
  scale_x_continuous(breaks = seq(min(Categorized_data$conc), max(Categorized_data$conc), by = 1))  # Natural number sequence for x-axis



library(randomForest)
library(ggplot2)

# 假设data_cleaned是已清洗的数据
set.seed(123)
rf_model <- randomForest(gene_expression ~ ., data = data_cleaned, importance = TRUE)

# 提取特征重要性
importance_data <- as.data.frame(importance(rf_model))
importance_data$Feature <- rownames(importance_data)

# 绘制特征重要性图
importance_plot <- ggplot(importance_data, aes(x = reorder(Feature, IncNodePurity), y = IncNodePurity)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Feature Importance Plot",
       x = "Features",
       y = "Importance (IncNodePurity)") +
  theme_minimal()

# 保存图表
ggsave("figs/feature_importance_plot.png", importance_plot, width = 10, height = 6, dpi = 300)


# 创建散点图，显示不同处理和浓度下的基因表达
scatter_plot <- ggplot(Categorized_data, aes(x = conc, y = Mean_Expression, group = treatment, color = treatment)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~cell_line) +  # 根据细胞类型分组展示
  labs(title = "Gene Expression vs. Concentration",
       x = "Concentration",
       y = "Gene Expression") +
  theme_minimal()

# 保存图表
ggsave("figs/gene_expression_vs_concentration.png", scatter_plot, width = 10, height = 6, dpi = 300)

# 创建箱线图，显示不同处理和细胞类型下的基因表达
box_plot <- ggplot(data_cleaned, aes(x = treatment, y = gene_expression, fill = treatment)) +
  geom_boxplot() +
  facet_wrap(~cell_line) +  # 根据细胞类型分组展示
  labs(title = "Gene Expression by Treatment and Cell Line",
       x = "Treatment",
       y = "Gene Expression") +
  theme_minimal()

# 保存图表
ggsave("figs/gene_expression_by_treatment_cell_line.png", box_plot, width = 10, height = 6, dpi = 300)
