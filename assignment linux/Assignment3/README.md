## Assignment 3 - Star Pattern & Tomcat Utility

Created two shell utilities:

- **drawStar.sh** → Generates different star patterns based on type
- **printTomcat.sh** → Prints output based on divisibility conditions

---

## Part A - drawStar Utility

Generates star patterns using size and type.

### Usage

```bash
./drawStar.sh <size> <type>
```

### Supported Types

- t1 → Right-aligned triangle
- t2 → Left-aligned triangle
- t3 → Pyramid
- t4 → Inverted triangle
- t5 → Right-aligned inverted triangle
- t6 → Inverted pyramid
- t7 → Diamond

### Example Commands

```bash
./drawStar.sh 5 t1
./drawStar.sh 5 t3
./drawStar.sh 5 t7
```

### Screenshots

![](images/1.png)


### Part B - printTomcat Utility

Prints output based on number divisibility.

### Rules

Divisible by 3 → tom
Divisible by 5 → cat
Divisible by 15 → tomcat

### Usage

```bash
./printTomcat.sh <number>
```
### Example Commands

```bash
./printTomcat.sh 9
./printTomcat.sh 10
./printTomcat.sh 15
```

### Screenshots

![](images/2.png)
