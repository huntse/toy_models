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

Models of this type are known as Markov State Models. The Markov property means that the model's state at time $`t+1`$
depends only on the state at time $`t`$, and because the model has discrete time steps and a finite state space it is a
discrete time Markov chain.

# To run these notebooks

## python

I am using nixos and if you are too, then to run the jupyter notebook, you can simply do

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

## wxmaxima

To run the maxima notebook install wxmaxima by either following the instructions [on the
website](https://wxmaxima-developers.github.io/wxmaxima/download.html) or just installing the package for your
distribution, and make sure you install gnuplot also.  Note most Linux distros I've used have a package for wxmaxima,
and on mac homebrew has one.  If you're going to use the terminal version of maxima at all, install `rlwrap` also, and
always run `rlwrap maxima` rather than just `maxima` to have a much more pleasant experience. The `flake.nix` file does
what you need if you use NixOs.

## Mathematica

You'll need a copy of mathematica, then just load `Weather.nb`. This was developed with version 14.1 but honestly it's
not doing anything that fancy so would probably work with just about any version. I deliberately didn't include the
"Wolfram" derivation in the `flake.nix` file so it wouldn't mess with people who don't have it but it's pretty easy to
add. On nixos, the package wants you to download the official installer and then add that to your nix store by hand.  If
you try running the derivation it will tell you what to do.

# Confirming some of the maths

Given the state transition matrix
```math
\mathbf{A} = \begin{pmatrix}
\frac{1}{2} & \frac{1}{2} & \frac{1}{4}\\
\frac{1}{4} & 0 &\frac{1}{4}\\
\frac{1}{2} & \frac{1}{2} & \frac{1}{4}
\end{pmatrix}
```
We need to confirm that one of the eigenvalues is 1, find the corresponding eigenvector and then normalize it, which
should be the steady-state probability of our simulation if everything is correct.

## How to find eigenvalues and eigenvectors

We find the eigenvectors of a matrix using the roots of the characteristic polynomial, which is found in matrix form by
$`\bigl(\mathbf{A}-\lambda\mathbb{I}\bigr)\mathbf{v} = \mathbf{0},`$ where each value of $`\lambda`$ is an eigenvalue
and each value of $`\mathbf{v}`$ is a corresponding eigenvector. Since an eigenvector cannot be the zero vector, the
only way for the left-hand side of this equation to give a zero is for $`\mathbf{A}-\lambda\mathbb{I}`$ to be a singular
matrix, so we are looking in our case for values of $`\lambda`$ such that
$`\mathop{\mathrm{det}}\bigl(\mathbf{A}-\lambda\mathbb{I}\bigr)=0`$. These are the roots of the characteristic
polynomial.

## In our case

### Finding Eigenvalues
```math
\begin{align*}
\begin{vmatrix}
\left(\frac{1}{2}-\lambda\right) & \frac{1}{2} & \frac{1}{4}\\
\frac{1}{4} & -\lambda &\frac{1}{4}\\
\frac{1}{2} & \frac{1}{2} & \left(\frac{1}{4}-\lambda\right)
\end{vmatrix} &= 0\\
\end{align*}
```

To solve this determinant you expand via one of the rows and columns and do a bunch of tedious cancelling.  *Or* you use
a computer algebra system.  Either way you find that the characteristic polynomial is
$`-\frac{1}{16}(\lambda-1)(4\lambda-1)(4\lambda+1)=0`$, so the eigenvalues are $`\lambda_1=1`$, $`\lambda_2=\frac{1}{4}`$,
and $`\lambda_3=-\frac{1}{4}`$.

#### Check on the eigenvalues

The sum of the eigenvalues should be equal to the trace of $`\mathbf{A}`$, so we can see that the sum of our eigenvalues
is 1 and the trace (sum of values on the diagonal) is also 1 so that seems good. You can also check that the product of
the eigenvalues is the determinant of A but that's a bit annoying to compute by hand for a 3x3 matrix so I'm not going
to bother.  I would actually just use a CAS to check the eigenvalues in practise.

### Finding Eigenvectors
Then, to find eigenvectors corresponding to a particular eigenvalue we need to find general solutions to the eigenvector
equations corresponding to the determinant above, bearing in mind that this is a singular matrix. So the equations we
want are

```math
\begin{align*}
\left(\frac{1}{2}-\lambda\right)x + \frac{1}{2}y +\frac{1}{4}z &= 0\\
\frac{1}{4}x -\lambda y + \frac{1}{4} z &= 0\\
\frac{1}{4} x + \frac{1}{2} y + \left(\frac{1}{2} - \lambda\right)z &= 0
\end{align*}
```
Thus, when $`\lambda=1`$ let $`z=k`$ so we have

```math
\begin{align*}
-\frac{1}{2} + \frac{1}{2}y +\frac{1}{4}k &= 0 & R_1\\
\frac{1}{4}x -y + \frac{1}{4} k &= 0 & R_2\\
\frac{1}{4} x + \frac{1}{2} y -\frac{1}{2}k &= 0 & R_3\\
\frac{3}{4}x -\frac{3}{2}y &= 0 & R_2 - R_1\\
\frac{3}{4}x &= \frac{3}{2}y \\
2y &= x\\
\text{Thus}~\frac{1}{2}y + \frac{1}{2}y -\frac{1}{2}k &= 0 & \text{...by substitution into}~R_3\\
y &= \frac{1}{2}k
\end{align*}
```
So we can deduce that any vector of the form
$`\begin{pmatrix}k & \frac{k}{2} & k\end{pmatrix}^T`$ is an eigenvector of $`\mathbf{A}`$ corresponding to $`\lambda =
1`$.  For example, let's choose $`\mathbf{v}_1 = \begin{pmatrix}1 & \frac{1}{2} & 1\end{pmatrix}^T`$.

#### Check

We can confirm this is an eigenvector if $`\mathbf{Av} = \lambda\mathbf{v}`$, so let's check that now.

```math
\begin{pmatrix}
\frac{1}{2} & \frac{1}{2} & \frac{1}{4}\\
\frac{1}{4} & 0 &\frac{1}{4}\\
\frac{1}{2} & \frac{1}{2} & \frac{1}{4}
\end{pmatrix}
\begin{pmatrix}
1 \\ \frac{1}{2} \\ 1
\end{pmatrix} =
\begin{pmatrix}
1 \\ \frac{1}{2} \\ 1
\end{pmatrix} = \lambda
\begin{pmatrix}
1 \\ \frac{1}{2} \\ 1
\end{pmatrix}
```
So
$`\mathbf{Av} = \lambda\mathbf{v}`$, and $`\mathbf{v}_1 = \begin{pmatrix}1 & \frac{1}{2} & 1\end{pmatrix}^T`$ is
confirmed to be an eigenvector of $`\mathbf{A}`$ corresponding to $`\lambda=1`$.

### Normalization

Ok the final step of our pencil and paper confirmation of Steve's model is that the steady state probability found by
the model should lie on this eigenvector.  To check this we will divide $`v`$ by the sum of its components so that the
resulting vector has components that add up to 1 and therefore could be a probability distribution.

```math
\begin{align*}
s &= \sum_{k=1}^3 v_k = 1 + \frac{1}{2} + 1
&= \frac{5}{2}\\
\mathbf{w} &= \frac{\mathbf{v}}{s}\\
&= \begin{pmatrix}
\frac{2}{5} \\ \frac{2}{10} \\ \frac{2}{5}
\end{pmatrix}\\
&= \begin{pmatrix}
0.4 \\ 0.2 \\ 0.4
\end{pmatrix}
\end{align*}
```

We will compare $`\mathbf{w}`$ to the results returned by our simulation.

