Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E013C2726
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Sep 2019 22:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfI3Ur1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Sep 2019 16:47:27 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:42452 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfI3Ur1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 30 Sep 2019 16:47:27 -0400
Received: by mail-ed1-f54.google.com with SMTP id y91so9854670ede.9
        for <ceph-devel@vger.kernel.org>; Mon, 30 Sep 2019 13:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=croit.io; s=gsuite-croitio;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CKVVSjfNUIgAWsWhET7i+pEPjY7BR+RI05+vCnpfn7A=;
        b=Jh7qVoO67YK6ghYnGuN48fuYIfmoOxvXZgM3g6NOCgpvppJ++azOxi0Fhe2nVQuF0i
         tvCDYm4UKcNf+2ot7mC6NzhskBnE+tNHEfXg163xqD9Bn7mVGN0/qyb5a4S67c17qgBu
         vYKYhN2Z6/f9ezMgbYH5SI8dFn29BVPzxy7F1iJ8IWSXze4o6iCWvNiFrlEAlnA3Cp8b
         /vGX2QHmebeKJ9QMpThcZdhoriqtYqz3fPg2dRd8SwZGfnPLQ7v3hbafhFJKxbxO/iWp
         0CjJScte7FoCKx0uDC2xC4eGBrL4I/6xI6HMweSOOtHAXy8jIIV6MqWu+l5IvGYAu2tP
         DwKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CKVVSjfNUIgAWsWhET7i+pEPjY7BR+RI05+vCnpfn7A=;
        b=p3yXQ9JC+BNtDu9VEuIi0P4kdn7fiu+ZqArHRc+P9F1mV/yji/rBMWI22T/eIUm3nq
         2YsK2oLuncm+1+CHEyMzaGbs+EgzissN2Uud02Vfqs0NMQmP+AdkjyAmqse51kog0nqD
         AvGDv7iYch13NTf9R30FAxXkEPmHPpqumVro4FNeWmVztb1nO4G/POrW2H6tZuRMaBa8
         uEL9ncc3TYQ6F4TnWdWr4d8hKutCO4CibNYBdb+DYL3ok1/5yIWG3NHurTKLR+fwamQN
         rt8x+lBShECm2kwaU47zkG6nX8viDmY7aLA8LfQ8PMi0Xfyi0xbBfNEhco/5S6RVmlJI
         EA5g==
X-Gm-Message-State: APjAAAXlvYv285YvDRh7+K0Zz+vWwBxuHSs1foVyADsjDLwBjsq1S3Ez
        fbgx8e5hhqCpD2+n1s4hN23GaJfvlHETGLNdPw27Gt7fG9w=
X-Google-Smtp-Source: APXvYqwVSOZOF2t0tq2dKO7esp9yI2XTdUOMCY/zdG/XwDGXCPe5Acg3GJ+UNb+UV1v00zLlIP+AmWXOR5lwHnZSgyA=
X-Received: by 2002:a17:906:cec3:: with SMTP id si3mr20777575ejb.145.1569872709081;
 Mon, 30 Sep 2019 12:45:09 -0700 (PDT)
MIME-Version: 1.0
References: <qmq36f$5pap$1@blaine.gmane.org> <H000007100150ea4.1569860022.sx.f1-outsourcing.eu*@MHS>
 <CALi_L4-fNi=gP9sOCWPNcok9tVG=K-rtER68n1s9bkZzwuGhEw@mail.gmail.com>
In-Reply-To: <CALi_L4-fNi=gP9sOCWPNcok9tVG=K-rtER68n1s9bkZzwuGhEw@mail.gmail.com>
From:   Paul Emmerich <paul.emmerich@croit.io>
Date:   Mon, 30 Sep 2019 21:44:58 +0200
Message-ID: <CAD9yTbEzPJwAqVgn2fWtjZCG8zFnAgjvtMOnO-+FJd4XQx364Q@mail.gmail.com>
Subject: Re: [ceph-users] Commit and Apply latency on nautilus
To:     Sasha Litvak <alexander.v.litvak@gmail.com>
Cc:     Marc Roos <M.Roos@f1-outsourcing.eu>,
        ceph-users <ceph-users@lists.ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

BTW: commit and apply latency are the exact same thing since
BlueStore, so don't bother looking at both.

In fact you should mostly be looking at the op_*_latency counters


Paul

--=20
Paul Emmerich

Looking for help with your Ceph cluster? Contact us at https://croit.io

croit GmbH
Freseniusstr. 31h
81247 M=C3=BCnchen
www.croit.io
Tel: +49 89 1896585 90

On Mon, Sep 30, 2019 at 8:46 PM Sasha Litvak
<alexander.v.litvak@gmail.com> wrote:
>
> In my case, I am using premade Prometheus sourced dashboards in grafana.
>
> For individual latency, the query looks like that
>
>  irate(ceph_osd_op_r_latency_sum{ceph_daemon=3D~"$osd"}[1m]) / on (ceph_d=
aemon) irate(ceph_osd_op_r_latency_count[1m])
> irate(ceph_osd_op_w_latency_sum{ceph_daemon=3D~"$osd"}[1m]) / on (ceph_da=
emon) irate(ceph_osd_op_w_latency_count[1m])
>
> The other ones use
>
> ceph_osd_commit_latency_ms
> ceph_osd_apply_latency_ms
>
> and graph the distribution of it over time
>
> Also, average OSD op latency
>
> avg(rate(ceph_osd_op_r_latency_sum{cluster=3D"$cluster"}[5m]) / rate(ceph=
_osd_op_r_latency_count{cluster=3D"$cluster"}[5m]) >=3D 0)
> avg(rate(ceph_osd_op_w_latency_sum{cluster=3D"$cluster"}[5m]) / rate(ceph=
_osd_op_w_latency_count{cluster=3D"$cluster"}[5m]) >=3D 0)
>
> Average OSD apply + commit latency
> avg(ceph_osd_apply_latency_ms{cluster=3D"$cluster"})
> avg(ceph_osd_commit_latency_ms{cluster=3D"$cluster"})
>
>
> On Mon, Sep 30, 2019 at 11:13 AM Marc Roos <M.Roos@f1-outsourcing.eu> wro=
te:
>>
>>
>> What parameters are you exactly using? I want to do a similar test on
>> luminous, before I upgrade to Nautilus. I have quite a lot (74+)
>>
>> type_instance=3DOsd.opBeforeDequeueOpLat
>> type_instance=3DOsd.opBeforeQueueOpLat
>> type_instance=3DOsd.opLatency
>> type_instance=3DOsd.opPrepareLatency
>> type_instance=3DOsd.opProcessLatency
>> type_instance=3DOsd.opRLatency
>> type_instance=3DOsd.opRPrepareLatency
>> type_instance=3DOsd.opRProcessLatency
>> type_instance=3DOsd.opRwLatency
>> type_instance=3DOsd.opRwPrepareLatency
>> type_instance=3DOsd.opRwProcessLatency
>> type_instance=3DOsd.opWLatency
>> type_instance=3DOsd.opWPrepareLatency
>> type_instance=3DOsd.opWProcessLatency
>> type_instance=3DOsd.subopLatency
>> type_instance=3DOsd.subopWLatency
>> ...
>> ...
>>
>>
>>
>>
>>
>> -----Original Message-----
>> From: Alex Litvak [mailto:alexander.v.litvak@gmail.com]
>> Sent: zondag 29 september 2019 13:06
>> To: ceph-users@lists.ceph.com
>> Cc: ceph-devel@vger.kernel.org
>> Subject: [ceph-users] Commit and Apply latency on nautilus
>>
>> Hello everyone,
>>
>> I am running a number of parallel benchmark tests against the cluster
>> that should be ready to go to production.
>> I enabled prometheus to monitor various information and while cluster
>> stays healthy through the tests with no errors or slow requests,
>> I noticed an apply / commit latency jumping between 40 - 600 ms on
>> multiple SSDs.  At the same time op_read and op_write are on average
>> below 0.25 ms in the worth case scenario.
>>
>> I am running nautilus 14.2.2, all bluestore, no separate NVME devices
>> for WAL/DB, 6 SSDs per node(Dell PowerEdge R440) with all drives Seagate
>> Nytro 1551, osd spread across 6 nodes, running in
>> containers.  Each node has plenty of RAM with utilization ~ 25 GB during
>> the benchmark runs.
>>
>> Here are benchmarks being run from 6 client systems in parallel,
>> repeating the test for each block size in <4k,16k,128k,4M>.
>>
>> On rbd mapped partition local to each client:
>>
>> fio --name=3Drandrw --ioengine=3Dlibaio --iodepth=3D4 --rw=3Drandrw
>> --bs=3D<4k,16k,128k,4M> --direct=3D1 --size=3D2G --numjobs=3D8 --runtime=
=3D300
>> --group_reporting --time_based --rwmixread=3D70
>>
>> On mounted cephfs volume with each client storing test file(s) in own
>> sub-directory:
>>
>> fio --name=3Drandrw --ioengine=3Dlibaio --iodepth=3D4 --rw=3Drandrw
>> --bs=3D<4k,16k,128k,4M> --direct=3D1 --size=3D2G --numjobs=3D8 --runtime=
=3D300
>> --group_reporting --time_based --rwmixread=3D70
>>
>> dbench -t 30 30
>>
>> Could you please let me know if huge jump in applied and committed
>> latency is justified in my case and whether I can do anything to improve
>> / fix it.  Below is some additional cluster info.
>>
>> Thank you,
>>
>> root@storage2n2-la:~# podman exec -it ceph-mon-storage2n2-la ceph osd df
>> ID CLASS WEIGHT  REWEIGHT SIZE    RAW USE DATA    OMAP    META     AVAIL
>>   %USE VAR  PGS STATUS
>>   6   ssd 1.74609  1.00000 1.7 TiB  93 GiB  92 GiB 240 MiB  784 MiB 1.7
>> TiB 5.21 0.90  44     up
>> 12   ssd 1.74609  1.00000 1.7 TiB  98 GiB  97 GiB 118 MiB  906 MiB 1.7
>> TiB 5.47 0.95  40     up
>> 18   ssd 1.74609  1.00000 1.7 TiB 102 GiB 101 GiB 123 MiB  901 MiB 1.6
>> TiB 5.73 0.99  47     up
>> 24   ssd 3.49219  1.00000 3.5 TiB 222 GiB 221 GiB 134 MiB  890 MiB 3.3
>> TiB 6.20 1.07  96     up
>> 30   ssd 3.49219  1.00000 3.5 TiB 213 GiB 212 GiB 151 MiB  873 MiB 3.3
>> TiB 5.95 1.03  93     up
>> 35   ssd 3.49219  1.00000 3.5 TiB 203 GiB 202 GiB 301 MiB  723 MiB 3.3
>> TiB 5.67 0.98 100     up
>>   5   ssd 1.74609  1.00000 1.7 TiB 103 GiB 102 GiB 123 MiB  901 MiB 1.6
>> TiB 5.78 1.00  49     up
>> 11   ssd 1.74609  1.00000 1.7 TiB 109 GiB 108 GiB  63 MiB  961 MiB 1.6
>> TiB 6.09 1.05  46     up
>> 17   ssd 1.74609  1.00000 1.7 TiB 104 GiB 103 GiB 205 MiB  819 MiB 1.6
>> TiB 5.81 1.01  50     up
>> 23   ssd 3.49219  1.00000 3.5 TiB 210 GiB 209 GiB 168 MiB  856 MiB 3.3
>> TiB 5.86 1.01  86     up
>> 29   ssd 3.49219  1.00000 3.5 TiB 204 GiB 203 GiB 272 MiB  752 MiB 3.3
>> TiB 5.69 0.98  92     up
>> 34   ssd 3.49219  1.00000 3.5 TiB 198 GiB 197 GiB 295 MiB  729 MiB 3.3
>> TiB 5.54 0.96  85     up
>>   4   ssd 1.74609  1.00000 1.7 TiB 119 GiB 118 GiB  16 KiB 1024 MiB 1.6
>> TiB 6.67 1.15  50     up
>> 10   ssd 1.74609  1.00000 1.7 TiB  95 GiB  94 GiB 183 MiB  841 MiB 1.7
>> TiB 5.31 0.92  46     up
>> 16   ssd 1.74609  1.00000 1.7 TiB 102 GiB 101 GiB 122 MiB  902 MiB 1.6
>> TiB 5.72 0.99  50     up
>> 22   ssd 3.49219  1.00000 3.5 TiB 218 GiB 217 GiB 109 MiB  915 MiB 3.3
>> TiB 6.11 1.06  91     up
>> 28   ssd 3.49219  1.00000 3.5 TiB 198 GiB 197 GiB 343 MiB  681 MiB 3.3
>> TiB 5.54 0.96  95     up
>> 33   ssd 3.49219  1.00000 3.5 TiB 198 GiB 196 GiB 297 MiB 1019 MiB 3.3
>> TiB 5.53 0.96  85     up
>>   1   ssd 1.74609  1.00000 1.7 TiB 101 GiB 100 GiB 222 MiB  802 MiB 1.6
>> TiB 5.63 0.97  49     up
>>   7   ssd 1.74609  1.00000 1.7 TiB 102 GiB 101 GiB 153 MiB  871 MiB 1.6
>> TiB 5.69 0.99  46     up
>> 13   ssd 1.74609  1.00000 1.7 TiB 106 GiB 105 GiB  67 MiB  957 MiB 1.6
>> TiB 5.96 1.03  42     up
>> 19   ssd 3.49219  1.00000 3.5 TiB 206 GiB 205 GiB 179 MiB  845 MiB 3.3
>> TiB 5.77 1.00  83     up
>> 25   ssd 3.49219  1.00000 3.5 TiB 195 GiB 194 GiB 352 MiB  672 MiB 3.3
>> TiB 5.45 0.94  97     up
>> 31   ssd 3.49219  1.00000 3.5 TiB 201 GiB 200 GiB 305 MiB  719 MiB 3.3
>> TiB 5.62 0.97  90     up
>>   0   ssd 1.74609  1.00000 1.7 TiB 110 GiB 109 GiB  29 MiB  995 MiB 1.6
>> TiB 6.14 1.06  43     up
>>   3   ssd 1.74609  1.00000 1.7 TiB 109 GiB 108 GiB  28 MiB  996 MiB 1.6
>> TiB 6.07 1.05  41     up
>>   9   ssd 1.74609  1.00000 1.7 TiB 103 GiB 102 GiB 149 MiB  875 MiB 1.6
>> TiB 5.76 1.00  52     up
>> 15   ssd 3.49219  1.00000 3.5 TiB 209 GiB 208 GiB 253 MiB  771 MiB 3.3
>> TiB 5.83 1.01  98     up
>> 21   ssd 3.49219  1.00000 3.5 TiB 199 GiB 198 GiB 302 MiB  722 MiB 3.3
>> TiB 5.56 0.96  90     up
>> 27   ssd 3.49219  1.00000 3.5 TiB 208 GiB 207 GiB 226 MiB  798 MiB 3.3
>> TiB 5.81 1.00  95     up
>>   2   ssd 1.74609  1.00000 1.7 TiB  96 GiB  95 GiB 158 MiB  866 MiB 1.7
>> TiB 5.35 0.93  45     up
>>   8   ssd 1.74609  1.00000 1.7 TiB 106 GiB 105 GiB 132 MiB  892 MiB 1.6
>> TiB 5.91 1.02  50     up
>> 14   ssd 1.74609  1.00000 1.7 TiB  96 GiB  95 GiB 180 MiB  844 MiB 1.7
>> TiB 5.35 0.92  46     up
>> 20   ssd 3.49219  1.00000 3.5 TiB 221 GiB 220 GiB 156 MiB  868 MiB 3.3
>> TiB 6.18 1.07 101     up
>> 26   ssd 3.49219  1.00000 3.5 TiB 206 GiB 205 GiB 332 MiB  692 MiB 3.3
>> TiB 5.76 1.00  92     up
>> 32   ssd 3.49219  1.00000 3.5 TiB 221 GiB 220 GiB  88 MiB  936 MiB 3.3
>> TiB 6.18 1.07  91     up
>>                      TOTAL  94 TiB 5.5 TiB 5.4 TiB 6.4 GiB   30 GiB  89
>> TiB 5.78
>> MIN/MAX VAR: 0.90/1.15  STDDEV: 0.30
>>
>>
>> root@storage2n2-la:~# podman exec -it ceph-mon-storage2n2-la ceph -s
>>    cluster:
>>      id:     9b4468b7-5bf2-4964-8aec-4b2f4bee87ad
>>      health: HEALTH_OK
>>
>>    services:
>>      mon: 3 daemons, quorum storage2n1-la,storage2n2-la,storage2n3-la
>> (age 9w)
>>      mgr: storage2n2-la(active, since 9w), standbys: storage2n1-la,
>> storage2n3-la
>>      mds: cephfs:1 {0=3Dstorage2n6-la=3Dup:active} 1 up:standby-replay 1
>> up:standby
>>      osd: 36 osds: 36 up (since 9w), 36 in (since 9w)
>>
>>    data:
>>      pools:   3 pools, 832 pgs
>>      objects: 4.18M objects, 1.8 TiB
>>      usage:   5.5 TiB used, 89 TiB / 94 TiB avail
>>      pgs:     832 active+clean
>>
>>    io:
>>      client:   852 B/s rd, 15 KiB/s wr, 4 op/s rd, 2 op/s wr
>>
>>
>>
>>
>>
>> _______________________________________________
>> ceph-users mailing list
>> ceph-users@lists.ceph.com
>> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
>>
>>
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
