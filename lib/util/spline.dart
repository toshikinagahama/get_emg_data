class Spline {
  //スプラインの係数
  List<double> h = [];
  List<double> b = [];
  List<double> d = [];
  List<double> g = [];
  List<double> u = [];
  List<double> r = [];

  Spline(List<double> x, List<double> y) {
    int i1, k;
    int n = y.length - 1;
    h = List.filled(n, 0.0);
    b = List.filled(n, 0.0);
    d = List.filled(n, 0.0);
    g = List.filled(n, 0.0);
    u = List.filled(n, 0.0);
    r = List.filled(n + 1, 0.0);
    // ステップ１
    for (i1 = 0; i1 < n; i1++) {
      h[i1] = x[i1 + 1] - x[i1];
    }
    for (i1 = 1; i1 < n; i1++) {
      b[i1] = 2.0 * (h[i1] + h[i1 - 1]);
      d[i1] =
          3.0 * ((y[i1 + 1] - y[i1]) / h[i1] - (y[i1] - y[i1 - 1]) / h[i1 - 1]);
    }
    // ステップ２
    g[1] = h[1] / b[1];
    for (i1 = 2; i1 < n - 1; i1++) {
      g[i1] = h[i1] / (b[i1] - h[i1 - 1] * g[i1 - 1]);
    }
    u[1] = d[1] / b[1];
    for (i1 = 2; i1 < n; i1++) {
      u[i1] = (d[i1] - h[i1 - 1] * u[i1 - 1]) / (b[i1] - h[i1 - 1] * g[i1 - 1]);
    }
    // ステップ３
    k = 1;
    r[0] = 0.0;
    r[n] = 0.0;
    r[n - 1] = u[n - 1];
    for (i1 = n - 2; i1 >= k; i1--) {
      r[i1] = u[i1] - g[i1] * r[i1 + 1];
    }
  }

  double compute(List<double> x, List<double> y, double x1) {
    int i = -1, i1, k;
    double y1, qi, si, xx;
    int n = x.length - 1;
    // 区間の決定
    for (i1 = 1; i1 < n && i < 0; i1++) {
      if (x1 < x[i1]) i = i1 - 1;
    }
    if (i < 0) i = n - 1;
    xx = x1 - x[i];
    qi = (y[i + 1] - y[i]) / h[i] - h[i] * (r[i + 1] + 2.0 * r[i]) / 3.0;
    si = (r[i + 1] - r[i]) / (3.0 * h[i]);
    y1 = y[i] + xx * (qi + xx * (r[i] + si * xx));
    return y1;
  }
}
