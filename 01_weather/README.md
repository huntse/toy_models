# Background

This comprises implementations of a simple Markov state transition model (MSM) in python and wxmaxima (and Mathematica
too if I get around to it).  The model and background are from Steve Brunton's excellent series on Engineering maths.
This one is from his [Gentle introduction to modelling](https://www.youtube.com/watch?v=K-8F_zDMDUI).  The full playlist
can be found [here](https://www.youtube.com/playlist?list=PLMrJAkhIeNNTYaOnVI3QpH7jgULnAmvPA).

The most information about the maths behind the model is in the jupyter notebook, however in essence the model assumes
some discrete states with known probabilities that describe, at a given discrete time step, the probability of each state
at the next time step.

In general if $`\mathbf{x}_t`$ is the probability of each state at $`t`$ and $`\mathbf{A}`$ is the transition matrix, then
$`x_{t+1}=\mathbf{A}\cdot\mathbf{x}_t`$

Models of this type are known as Markov State Models.

# To run this notebook

I am using nixos and if you are too, then you can simply do

```bash
nix develop
jupyter notebook
```
...and you're done.  Otherwise something like this might work but it depends on whether your local build environment is
correctly configured which tends to be annoying and/or tricky with numpy.

```bash
python -m venv .venv
source .venv/bin/activate
pip install ipython jupyter numpy matplotlib
jupyter notebook
```
