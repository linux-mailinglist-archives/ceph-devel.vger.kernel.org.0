Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC77819F148
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 10:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgDFIE6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 04:04:58 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:46327 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgDFIE5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Apr 2020 04:04:57 -0400
Received: by mail-lf1-f54.google.com with SMTP id q5so11016457lfb.13
        for <ceph-devel@vger.kernel.org>; Mon, 06 Apr 2020 01:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=l0u0fe2X5uJHRq0SjOGJX47JyvNSOR4RLmAu5+Jv6v0=;
        b=QRe2sbgjRRVojb7Pb/BTScgVtrsuR3Mv+js9ZYRftIiQ0OUGLlo075QVSIYiU5DEq6
         7eKJR+FILYBLoLsIjQ7/7n+ZoFdIa6/42fVumHbIgMncgSms31/tiniHrXT3lYwNt6w9
         kn3VZpx7H0emW54G2jfIr0Fri32z3hz+V6wAWDdZRnnIqioBIcJ6s/fo6zZv2W9kdbmW
         RdaEavPKi1PdiDJN6JMeFea60IEWIPmmStKLdqIBWIZpc4LlkuaTNbOsxEnr2onP9BGH
         bBpyEKU3erI+sLnOO1gEdW799ujI2FmYabSjL/abY3W5TYEbzBAAugqealZPe6fmRh5P
         SYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=l0u0fe2X5uJHRq0SjOGJX47JyvNSOR4RLmAu5+Jv6v0=;
        b=VQiAk9LoDwBeZbFNM+5yd1Bpghgie/u/MZmbfDhNu8AOJ9CeC9TbzdAuF/TGRsvfBI
         brTd7IRd3EMJU4HIu1UxWMakFYfspwvQQ5Z/fM7AppY56ZjlljKjuBmnvgevu/MB/btx
         IsKr20OZarmGNnSXDRHHSvTPrvkHp9aHv6ulA9hUArnxwjFwr+dVhK5Zn3FY8E+RFGhV
         om2F/CpCTf1rj/Y6RJYVKI+3oQ8BEJ1J8RS61Jv4IA+l24UuQ02LkTDu8DwJ9uKj1CtE
         b2YnRo13ErKQHmgCTteJpGKRfW3VDTj7RDU+TusOaA5K4t/aALPdQQphIQST+FkvYaOD
         m2AA==
X-Gm-Message-State: AGi0PuYfW0ozgv4qUm5Q65/bAakKHGF/isj42g0TvQRddyel+XRRa/z3
        kbuBdpwUeYwPPpoaHOxZidEbcE7xpq7ZssuAWcneLXQEV4E=
X-Google-Smtp-Source: APiQypJkKc392gIxhgSn7O216+wkw9PNF4SE4l3EIcFiX/XhohU4v2Y9l08/3a0TiGp0Dac20YMnberQBdTfeSRnX0M=
X-Received: by 2002:ac2:53a6:: with SMTP id j6mr5176611lfh.153.1586160295430;
 Mon, 06 Apr 2020 01:04:55 -0700 (PDT)
MIME-Version: 1.0
From:   Jesper Krogh <jesper.krogh@gmail.com>
Date:   Mon, 6 Apr 2020 10:04:44 +0200
Message-ID: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
Subject: 5.4.20 - high load - lots of incoming data - small data read.
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a CephFS client - its only purpose is to run the "filedaemon" of bacula
and transport data to the tape-library from CephFS - below 2 threads is
essentially doing something equivalent to

find /cephfs/ -type f | xargs cat | nc server

2 threads only, load exploding and the "net read vs net write" has
more than 100x difference.

Can anyone explain this as "normal" behaviour?
Server is a  VM with 16 "vCPU" and 16GB memory running libvirt/qemu

jk@wombat:~$ w
 07:50:33 up 11:25,  1 user,  load average: 206.43, 76.23, 50.58
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
jk@wombat:~$ dstat -ar
--total-cpu-usage-- -dsk/total- -net/total- ---paging-- ---system-- --io/total-
usr sys idl wai stl| read  writ| recv  send|  in   out | int   csw | read  writ
  0   0  98   1   0|  14k   34k|   0     0 |   3B   27B| 481   294 |0.55  0.73
  1   1   0  98   0|   0     0 |  60M  220k|   0     0 |6402  6182 |   0     0
  0   1   0  98   0|   0     0 |  69M  255k|   0     0 |7305  4339 |   0     0
  1   2   0  98   0|   0     0 |  76M  282k|   0     0 |7914  4886 |   0     0
  1   1   0  99   0|   0     0 |  70M  260k|   0     0 |7293  4444 |   0     0
  1   1   0  98   0|   0     0 |  80M  278k|   0     0 |8018  4931 |   0     0
  0   1   0  98   0|   0     0 |  60M  221k|   0     0 |6435  5951 |   0     0
  0   1   0  99   0|   0     0 |  59M  211k|   0     0 |6163  3584 |   0     0
  0   1   0  98   0|   0     0 |  64M  323k|   0     0 |6653  3881 |   0     0
  1   0   0  99   0|   0     0 |  61M  243k|   0     0 |6822  4401 |   0     0
  0   1   0  99   0|   0     0 |  55M  205k|   0     0 |5975  3518 |   0     0
  1   1   0  98   0|   0     0 |  68M  242k|   0     0 |7094  6544 |   0     0
  0   1   0  99   0|   0     0 |  58M  230k|   0     0 |6639  4178 |   0     0
  1   2   0  98   0|   0     0 |  61M  243k|   0     0 |7117  4477 |   0     0
  0   1   0  99   0|   0     0 |  61M  228k|   0     0 |6500  4078 |   0     0
  0   1   0  99   0|   0     0 |  65M  234k|   0     0 |6595  3914 |   0     0
  0   1   0  98   0|   0     0 |  64M  219k|   0     0 |6507  5755 |   0     0
  1   1   0  99   0|   0     0 |  64M  233k|   0     0 |6869  4153 |   0     0
  1   2   0  98   0|   0     0 |  63M  232k|   0     0 |6632  3907 |
0     0 ^C
jk@wombat:~$ w
 07:50:56 up 11:25,  1 user,  load average: 221.35, 88.07, 55.02
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
jk@wombat:~$

Thanks.
