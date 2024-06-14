#Load the pwr package
library(pwr)
library(gridExtra)
library(grid)
library(png)
library(ragg)
# Calculate the effect size
R2 <- 0.1
f2 <- R2 / (1 - R2)

# Define the number of predictors
u <- 5

# Define the power and significance level
power <- 0.9
alpha <- 0.05

# Calculate the sample size
result <- pwr.f2.test(u = u, f2 = f2, sig.level = alpha, power = power)

# Total sample size
sample_size <- result$v + u + 1
print(paste("Required sample size:", ceiling(sample_size)))


# Create a table grob (graphical object)
table_grob <- tableGrob(sample_size_table)

# Save the table as a PNG image
agg_png("tabs/sample_size_table.png", width = 1500, height = 400, res = 144)
grid.draw(table_grob)
dev.off()
