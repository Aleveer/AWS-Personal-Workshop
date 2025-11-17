---
title: "Blog 8"
weight: 1
chapter: false
pre: " <b> 3.8. </b> "
---

# Leveraging LLMs as an Augmentation to Traditional Hyperparameter Tuning

When seeking to improve machine learning model performance, hyperparameter tuning is often the go-to recommendation. However, this approach faces significant limitations, particularly for complex models requiring extensive training times. In this post, we’ll explore a novel approach that combines gradient norm analysis with Large Language Model (LLM) guidance to intelligently redesign neural network architectures. This method can identify and resolve performance bottlenecks without the computational burden of traditional hyperparameter optimization. Through practical examples, we’ll show how our technique leverages LLMs as architecture advisors, providing targeted recommendations that directly address identified weaknesses in network design.

## Background

Traditional hyperparameter tuning typically uses [Bayesian Optimization](https://en.wikipedia.org/wiki/Bayesian_optimization), which builds a mathematical model of parameter-performance relationships to efficiently find optimal solutions with fewer evaluations than alternatives like genetic algorithms.

However, significant practical limitations exist. Without high performance computing, serial execution becomes prohibitively time-consuming—while lightweight models might complete optimization within 24 hours, complex tasks like reinforcement learning or large computer vision datasets often make traditional approaches impractical on local hardware. Cloud solutions like [AWS Batch](https://aws.amazon.com/batch/), [AWS Parallel Computing Service](https://aws.amazon.com/pcs/), or [AWS ParallelCluster](https://aws.amazon.com/hpc/parallelcluster/) enable massive parallelization that can deliver substantial ROI for complex models despite additional costs.

Traditional tuning also requires explicit parameterization of everything you wish to optimize. While simple parameters like learning rate are straightforward to incorporate, evolving entire architectural structures presents significant implementation challenges. Approaches like Neuroevolution of Augmented Topologies ([NEAT](https://en.wikipedia.org/wiki/Neuroevolution_of_augmenting_topologies)) can address architectural optimization but often sacrifice sample efficiency.

This is where Large Language Models (LLMs) offer a compelling alternative. LLMs function as surrogate universal experts, synthesizing knowledge across the entire spectrum of neural network development—effectively interpolating decades of human knowledge across specialized domains like computer vision, NLP, and reinforcement learning. They provide architecture recommendations based on collective wisdom embedded in technical literature rather than computationally intensive empirical searches.

Our approach focuses specifically on using LLMs for neural architecture design and modification based on gradient norm analysis, complementing frameworks like [Liu et al. (2022) AgentHPO](https://arxiv.org/abs/2402.01881) that provide more general hyperparameter optimization across diverse ML tasks.

## An agentic workflow for neural network design

In our exploration of LLM-based code modifications, we implemented an agentic workflow to manage iterative reasoning and execution processes. Figure 1 illustrates the complete architecture of our system, which leverages LangGraph for workflow orchestration and decision routing between agents. Our implementation runs on EC2 g6.24xlarge instances equipped with 4x NVIDIA L4 Tensor Core GPUs to handle neural network training. LLM interactions occur through Python API calls to Amazon Bedrock using [Boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html). We utilize different Claude models for specialized tasks: Claude 3.7 Sonnet for testing agents, Claude 3.7 Sonnet with reasoning activated for code writing, and a smaller/faster model such as Claude 3.0 Haiku for report generation and code validation.

![Multi-agent workflow for in-situ neural network design. LLM icon uses Amazon Bedrock API](/images/3-BlogsTranslated/3.8-Blog8/HPCBlog-361-fig1.png)
_Figure 1: Multi-agent workflow for in-situ neural network design. LLM icon uses Amazon Bedrock API._

Our workflow begins (step 1) with standard mini-batch training while implementing robust error handling—runtime errors are caught and forwarded to an inspector agent for code analysis and correction.

At regular intervals (every 50-100 epochs), we extract (step 2) key training insights including gradient norms (discussed in next section) and standard metrics like loss and accuracy. This state representation is formatted into a prompt (step 3) for an LLM that assesses health: training stability and issue identification.

[LangGraph](https://www.langchain.com/langgraph) is a framework for creating stateful, multi-step workflows with language models. A LangGraph-based decision router (step 4) analyzes the health assessment and directs the workflow toward one of three paths: hyperparameter optimization, neural network structural modifications, or training completion with report generation. For hyperparameter adjustments, the LLM provides recommendations as structured JSON that can be directly applied to training.

For architectural modifications, we employ two collaborating LLMs: a primary LLM generates new Python modules defining the modified network architecture, while a secondary tester/fixer LLM evaluates the generated code by attempting execution. Through an iterative process between the code writer and code tester/fixer, errors are caught, analyzed, and corrected before saving the finalized code. Once successfully validated with dummy inputs, training restarts (step 5) with the improved architecture.

## Neural network design through the lens of gradient norms

While traditional metrics like loss and accuracy provide fundamental insights, gradient norm analysis reveals deeper understanding of architecture efficacy. Gradient norms—the magnitude of weight update signals during training—serve as powerful diagnostics that reveal whether a network is excessively deep, insufficiently wide, poorly normalized, or using suboptimal activation functions. Unusually large or small gradient norms often signal specific architectural problems that LLMs can interpret based on patterns observed across decades of neural network research.

To demonstrate this capability, we’ll experiment with a deliberately flawed computer vision classification model (shown below) trained on [CIFAR](https://www.cs.toronto.edu/~kriz/cifar.html), incorporating intentional design weaknesses with an excessively high learning rate (0.1) and basic SGD optimization without momentum or adaptive components.

By examining how the LLM interprets these gradient norm patterns across training epochs, we’ll observe its ability to diagnose specific architectural deficiencies and recommend appropriate modifications—effectively leveraging the same gradient-based signals that experienced practitioners use to debug network designs.
```python
import torch
import torch.nn as nn

class CNN(nn.Module):
    """
    An extremely simple CNN with a single convolutional layer
    followed by a fully connected layer for classification.
    Uses sigmoid activation instead of ReLU.
    """
    def __init__(self):
        super(CNN, self).__init__()

        # Single convolutional layer
        self.conv1 = nn.Conv2d(3, 16, kernel_size=15, padding=1)

        # With no pooling, feature size remains 32x32, so: 32x32x16 = 16384
        self.fc = nn.Linear(16384, 10)

    def forward(self, x):
        # Single convolutional layer with sigmoid activation
        x = torch.sigmoid(self.conv1(x))

        # No pooling, so dimensions stay the same

        # Flatten for fully connected layer
        x = torch.flatten(x, 1)

        # Classification layer
        x = self.fc(x)

        return x
```

After allowing 50-100 epochs of training to progress, we gave the optimizer sufficient time to locate a suitable optimization valley beyond the initial chaos of weight initialization. At this checkpoint, we presented the training history and gradient norms to Claude 3.7 via Amazon Bedrock, requesting an assessment of model performance and stability (see line 219 here). The LLM responded with a recommendation to alter the neural network architecture, providing the following analysis:

```
"Explanation: While the model shows some minimal improvement (validation accuracy from 17.6% to 19.4% over 50 epochs), progress is extremely slow and erratic. The loss isn't consistently decreasing, and the model appears to be struggling with fundamental architectural issues. The high learning rate (0.1) combined with SGD optimizer is likely causing training instability given the complex architecture. The lack of batch normalization is also problematic."
```

This assessment serves as a critical routing point within our LangGraph workflow. The LLM determined that a complete architectural overhaul was necessary, generating new PyTorch code that introduced significantly greater complexity and modified the loss function. The next code block shows this entirely revised neural network model, which was validated and error-checked by our secondary LLM before implementation.

```python
class ConvBlock(nn.Module):
    """
    A convolutional block with batch normalization and residual connection
    to improve gradient flow and training stability
    """
    def __init__(self, in_channels, out_channels, kernel_size=3, stride=1):
        super(ConvBlock, self).__init__()
        self.conv = nn.Conv2d(in_channels, out_channels, kernel_size=kernel_size, 
                             stride=stride, padding=kernel_size//2, bias=False)
        self.bn = nn.BatchNorm2d(out_channels)
        
        # FIX: More explicit handling of skip connection to ensure dimension matching
        if in_channels == out_channels and stride == 1:
            # Identity shortcut when dimensions match
            self.residual = nn.Identity()
        else:
            # 1x1 conv to match both channel dimensions and spatial dimensions (if stride > 1)
            self.residual = nn.Conv2d(in_channels, out_channels, kernel_size=1, 
                                     stride=stride, bias=False)
        
    def forward(self, x):
        identity = x
        
        # Main branch
        out = self.conv(x)
        out = self.bn(out)
        out = F.relu(out)
        
        # Add residual connection
        out = out + self.residual(identity)
        
        # FIX: Added ReLU after addition (standard in ResNet blocks)
        out = F.relu(out)
        
        return out

class CNN(nn.Module):
    """
    Improved CNN architecture that addresses gradient flow issues:
    1. Replaces large kernel sizes (15x15) with smaller, more efficient 3x3 kernels
    2. Adds batch normalization to stabilize gradients
    3. Uses multiple smaller convolutional layers with residual connections
    4. Balances FC layers to prevent bottlenecks
    5. Implements proper pooling strategy to reduce parameter count
    6. Uses ReLU activations instead of sigmoid for better gradient flow
    7. Adds dropout for regularization
    """
    def __init__(self, num_classes=10):
        super(CNN, self).__init__()
        
        # Initial convolution with moderate number of filters
        self.conv1 = nn.Conv2d(3, 32, kernel_size=3, padding=1, bias=False)
        self.bn1 = nn.BatchNorm2d(32)
        
        # Convolutional blocks with gradually increasing filters
        # Input: 16x16x32, Output: 16x16x64
        self.block1 = ConvBlock(32, 64)
        
        # Input: 8x8x64, Output: 8x8x128
        self.block2 = ConvBlock(64, 128)
        
        # Input: 4x4x128, Output: 4x4x256
        self.block3 = ConvBlock(128, 256)
        
        # Pooling layers to reduce spatial dimensions
        self.pool = nn.MaxPool2d(2, 2)
        
        # More balanced FC layer architecture
        # After 3 pooling operations (32 -> 16 -> 8 -> 4), feature map is 4x4x256 = 4096
        self.fc1 = nn.Linear(4096, 512)
        self.fc2 = nn.Linear(512, 128)
        self.fc3 = nn.Linear(128, num_classes)
        
        # Dropout for regularization
        self.dropout = nn.Dropout(0.3)  # Reduced from 0.5 to prevent too much regularization
        
        # Proper weight initialization for better gradient flow
        self._initialize_weights()
        
    def _initialize_weights(self):
        """Initialize weights using Kaiming initialization for ReLU activations"""
        for m in self.modules():
            if isinstance(m, nn.Conv2d):
                nn.init.kaiming_normal_(m.weight, mode='fan_out', nonlinearity='relu')
            elif isinstance(m, nn.BatchNorm2d):
                nn.init.constant_(m.weight, 1)
                nn.init.constant_(m.bias, 0)
            elif isinstance(m, nn.Linear):
                nn.init.kaiming_normal_(m.weight, mode='fan_out', nonlinearity='relu')
                if m.bias is not None:
                    nn.init.constant_(m.bias, 0)
        
    def forward(self, x):
        """
        Forward pass with explicit shape tracking comments
        Input shape: [batch_size, 3, 32, 32]
        """
        # Initial convolution: [batch_size, 3, 32, 32] -> [batch_size, 32, 32, 32]
        x = self.conv1(x)
        x = self.bn1(x)
        x = F.relu(x)
        
        # First pooling: [batch_size, 32, 32, 32] -> [batch_size, 32, 16, 16]
        x = self.pool(x)
        
        # Block 1: [batch_size, 32, 16, 16] -> [batch_size, 64, 16, 16]
        x = self.block1(x)
        
        # Second pooling: [batch_size, 64, 16, 16] -> [batch_size, 64, 8, 8]
        x = self.pool(x)
        
        # Block 2: [batch_size, 64, 8, 8] -> [batch_size, 128, 8, 8]
        x = self.block2(x)
        
        # Third pooling: [batch_size, 128, 8, 8] -> [batch_size, 128, 4, 4]
        x = self.pool(x)
        
        # Block 3: [batch_size, 128, 4, 4] -> [batch_size, 256, 4, 4]
        x = self.block3(x)
        
        # Flatten: [batch_size, 256, 4, 4] -> [batch_size, 4096]
        x = torch.flatten(x, 1)
        
        # FC layers with dropout
        x = F.relu(self.fc1(x))  # [batch_size, 4096] -> [batch_size, 512]
        x = self.dropout(x)
        
        x = F.relu(self.fc2(x))  # [batch_size, 512] -> [batch_size, 128]
        x = self.dropout(x)
        
        # Output: [batch_size, 128] -> [batch_size, num_classes]
        x = self.fc3(x)
        
        return x
        
    def loss_function(self, outputs, targets):
        """
        Custom loss function that helps with gradient scaling.
        Uses label smoothing to prevent overconfidence and improve gradient flow.
        """
        return nn.CrossEntropyLoss(label_smoothing=0.1)(outputs, targets)
```

Interestingly, when the agentic workflow (an autonomous, self-directed process where the AI system makes independent decisions without human intervention) initiates the training process with its revised model, we observe the loss immediately explodes, halting progress. The LLM detects this instability and autonomously implements critical modifications to the optimization strategy, including adjusting the learning rate and transitioning to the Adam optimizer. From this point forward, the LLM continuously (every 50 – 100 epochs) monitors the training dynamics, making iterative adjustments to either the optimization parameters or neural network architecture until it determines training has stabilized sufficiently for the LangGraph implementation to complete the process without further LLM intervention.

Figure 2 presents a comprehensive analysis of the base model’s performance across 600 training epochs. The top-left panel shows the training loss dropping sharply in the first 25 epochs from approximately 10² to 10¹, after which it flattens completely around 10⁰, indicating the model has stopped meaningful learning despite continued training. This premature convergence is further evidenced in the top-right panel, where training accuracy (blue) oscillates wildly between 7-14% while validation accuracy (orange) remains fixed at approximately 10% throughout the entire training process, confirming no actual learning is occurring.

The bottom panels provide insight into the gradient behavior. The total gradient norm (bottom-left) initially spikes above 10² before rapidly decreasing and stabilizing around 10⁻¹ for the remainder of training. The layer-specific gradient norms (bottom-right) similarly stabilize after the initial epochs, with different layers’ gradients settling at various magnitudes between 10⁻³ and 10⁻¹. While these gradient patterns appear numerically stable, they fail to drive meaningful parameter updates that would improve model performance, suggesting optimization issues beyond simple gradient instability.
![Results when using base CNN with no LLM modifications](/images/3-BlogsTranslated/3.8-Blog8/HPCBlog-361-fig2.png)
_Figure 2: Results when using base CNN with no LLM modifications._

In contrast, Figure 3 showcases the remarkably superior performance of the LLM-designed neural network with its carefully selected optimization hyperparameters. After around 4 LLM design iterations, this model achieves a validation accuracy of approximately 83%, representing a substantial improvement over the baseline. While this is significant progress, it’s worth noting that state-of-the-art models for CIFAR classification currently achieve accuracies above 99% ([EfficientNet-L2](https://arxiv.org/pdf/2010.01412)), demonstrating room for further optimization. The gap between our results and cutting-edge manual human tuned likely stems from advanced techniques that our LLM may not have incorporated or been aware of. For instance, optimization approaches like Sharpness Aware Minimization (SAM) have pushed EfficientNet-L2 to record-breaking accuracies by improving generalization through flat minima optimization. Such specialized techniques might lie outside the LLM’s training data or weren’t considered within our experimental constraints. This suggests our approach could benefit significantly from the addition of a RAG system that incorporates recent academic advancements, allowing the LLM to leverage cutting-edge research that may have emerged after its knowledge cutoff. Nevertheless, the performance differential underscores the efficacy of allowing an LLM to dynamically adjust neural network design and training parameters in response to observed training dynamics.

![Results when using CNN design by LLM and optimization parameters chosen by the LLM](/images/3-BlogsTranslated/3.8-Blog8/HPCBlog-361-fig3.png)
_Figure 3: Results when using CNN design by LLM and optimization parameters chosen by the LLM._

## Conclusion

LLMs offer a powerful alternative to traditional hyperparameter tuning, leveraging synthesized knowledge to improve neural networks without exhaustive parameter searches. Our experimental LLM-designed architecture achieved 83% validation accuracy on CIFAR, substantially outperforming the baseline model. This approach proves especially valuable for practitioners with limited computational resources or those working with models requiring lengthy training cycles.

A complementary strategy could combine LLMs for major architectural decisions with focused traditional hyperparameter tuning for final refinement, potentially offering the best of both worlds. The complete source code for this project, including our multi-agent LangGraph workflow implementation and all neural network models, is available in our [AWS Samples repository on GitHub](https://github.com/aws-samples/sample-Leveraging-LLMs-Augmentation-Traditional-Hyperparameter-Tuning/). We encourage researchers and practitioners to explore and build upon these findings.