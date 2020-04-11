Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5098F1A5334
	for <lists+ceph-devel@lfdr.de>; Sat, 11 Apr 2020 19:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgDKRtL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 11 Apr 2020 13:49:11 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:42304 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgDKRtK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 11 Apr 2020 13:49:10 -0400
Received: by mail-lf1-f42.google.com with SMTP id s13so3533591lfb.9
        for <ceph-devel@vger.kernel.org>; Sat, 11 Apr 2020 10:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=3fDlSEBuR63Wehrqq4za3ie5seC96DiW+ts8d2OMfQo=;
        b=R9HqiSmIawtQXcaFMbkUxIT9swonwzjtPLH4YCL+ASTqRLedJMPSQBAADBU+yUEFaA
         +WTZPxXVKMm/SHEpKjwHETw0Pb4oo4hb2PL7lW0/ORs81jEmPbshlfiSv0D02KS6C/oQ
         Z6v9SsUFc7p4Q9bMIB9Pe2pS1B0mLkzZDe96R9ClvPoUnAYh3SGc6i5ZQfHx6ec7rP/v
         T0iFef9Mkr3bDxjKqXAbmVbSX+G65bi6erPpkpC8BbKl8QCeVB6iLgbwMOeToxe456o3
         D8GR642VG6SSMXSKZ0crTg3CLR6npt7gArvzdupApm2dITMTYUOxm0i7YiwKRUeV3BuV
         VXGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=3fDlSEBuR63Wehrqq4za3ie5seC96DiW+ts8d2OMfQo=;
        b=YF3fHxfb+thspEX3GykXF1Mt/tw3ORScJ6OXz3K4NLd2nqJiKQv98/ALGs9buFBliz
         2qBzrHkd58EoKel8MYoFJViSGD0Tfo6pd0HsYkom677Ly0qMwLL+5xDbQc60etPrRKUB
         uToTIurddfq+dAL+DUp+tKb+84QzjG4ArvAWt7H8TWjq+4HcmUCfQSg9BIvEevgF+EC9
         +VKrSMLYqjDseJ6kcVmz+4+r9ssVm+zLvWQbytG+qdEen5DhIl3zWC0KhSW0xcTIP5Tv
         GJrHVkXXj088eaAdZFm+opBajtNNVC5JGf9vgwkG+w6ZvT2yfiSg5x/sg6veJEkFI6by
         z6cw==
X-Gm-Message-State: AGi0PuZSmrOYoD3NYFulO7qt7t2jodwpB3EDl6z4iln7jCAKko6DKaMj
        bAv8McU/Ko1a7K/XOPwHMxslNRT1Wx7NWiTFLimdHA==
X-Google-Smtp-Source: APiQypIvtYU61hFjcbyZDjz0JVnspyUtHZWk9fDifcWHZGMSWqfYXlcoJrFwjX4iR0JW+PC1RrIYoa1pp6+41lwgOG4=
X-Received: by 2002:a19:3848:: with SMTP id d8mr5699563lfj.44.1586627345937;
 Sat, 11 Apr 2020 10:49:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
 <CAED-sie2zRBnCfEVNknt-0eT_PLUyWCDPS2pL9C6Q9ko8_wNKQ@mail.gmail.com>
In-Reply-To: <CAED-sie2zRBnCfEVNknt-0eT_PLUyWCDPS2pL9C6Q9ko8_wNKQ@mail.gmail.com>
From:   Jesper Krogh <jesper.krogh@gmail.com>
Date:   Sat, 11 Apr 2020 19:48:54 +0200
Message-ID: <CAED-sieBDaWeF3bgBq8uHP__qAFtHaJLrVojaNGCA92AQytcig@mail.gmail.com>
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
To:     ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Pure speculation - could it be "readahead" that somehow ends up
pulling data into the system that are never needed when dealing with
small files? Any ways to demystify this pattern?

On Thu, Apr 9, 2020 at 7:50 PM Jesper Krogh <jesper.krogh@gmail.com> wrote:
>
> Hi. I really dont know if this is related to the issue  (page
> allocation) or a separate. But It really puzzles me that I can see
> dstat -ar output like this:
>
> Keep in mind that this is only a "network backup client" reading from
> CephFS - ideally recv == send as it just "transports data through the
> host.
>
> STARTS OUT OK.
> --total-cpu-usage-- -dsk/total- -net/total- ---paging-- ---system-- --io/total-
> usr sys idl wai stl| read  writ| recv  send|  in   out | int   csw | read  writ
>   2   2  70  25   0|   0     0 | 100M  100M|   0     0 |7690  1944 |   0     0
>   4   2  74  19   0|   0     0 | 156M  154M|   0     0 |  12k 3942 |   0     0
>   4   2  70  24   0|   0     0 | 214M  127M|   0     0 |  12k 3892 |   0     0
>   4   2  65  29   0|   0     0 | 120M  163M|   0     0 |9763  2347 |   0     0
>   5   4  77  14   0|   0     0 | 216M  242M|   0     0 |  15k 4797 |   0     0
> HERE IT BALOONS
>   3  14  20  63   0|   0     0 | 912M 5970k|   0     0 |  33k   16k|   0     0
>   2  14   1  83   0|   0     0 |1121M 4723k|   0     0 |  37k   14k|   0     0
>   3  16   3  78   0|   0    84k|1198M 8738k|   0     0 |  39k   15k|   0  4.00
>   3  14  14  69   0|   0     0 |1244M 5772k|   0     0 |  40k   14k|   0     0
>   2  12  15  71   0|   0    24k|1354M |   0    24k|  41k 8241 |   0  6.00
>   2   9   1  87   0|   0     0 |1271M 1540k|   0     0 |  38k 5887 |   0     0
>   2   7   0  90   0|   0    52k|1222M 1609k|   0     0 |  37k 6359 |   0  6.00
>   2   8   0  90   0|   0    96k|1260M 5676k|   0     0 |  39k 6589 |   0  20.0
>   2   6   0  92   0|   0     0 |1043M 3002k|   0     0 |  33k 6189 |   0     0
>   2   6   0  92   0|   0     0 | 946M 1223k|   0     0 |  30k 6080 |   0     0
>   2   6   0  92   0|   0     0 | 908M 5331k|   0     0 |  29k 9983 |   0     0
>   2   5   0  94   0|   0     0 | 773M 1067k|   0     0 |  26k 6691 |   0     0
>   2   4   0  94   0|   0     0 | 626M 3190k|   0     0 |  21k 5868 |   0     0
>   1   4   0  95   0|   0     0 | 505M   15M|   0     0 |  17k 4686 |   0     0
> and then it move back to normal..
>
> But a pattern of 1000x more on the recieve side than send is really puzzling.
> A VM on 25Gbit interconnect with all ceph nodes.
>
> On Mon, Apr 6, 2020 at 10:04 AM Jesper Krogh <jesper.krogh@gmail.com> wrote:
> >
> > This is a CephFS client - its only purpose is to run the "filedaemon" of bacula
> > and transport data to the tape-library from CephFS - below 2 threads is
> > essentially doing something equivalent to
> >
> > find /cephfs/ -type f | xargs cat | nc server
> >
> > 2 threads only, load exploding and the "net read vs net write" has
> > more than 100x difference.
> >
> > Can anyone explain this as "normal" behaviour?
> > Server is a  VM with 16 "vCPU" and 16GB memory running libvirt/qemu
> >
> > jk@wombat:~$ w
> >  07:50:33 up 11:25,  1 user,  load average: 206.43, 76.23, 50.58
> > USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
> > jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
> > jk@wombat:~$ dstat -ar
> > --total-cpu-usage-- -dsk/total- -net/total- ---paging-- ---system-- --io/total-
> > usr sys idl wai stl| read  writ| recv  send|  in   out | int   csw | read  writ
> >   0   0  98   1   0|  14k   34k|   0     0 |   3B   27B| 481   294 |0.55  0.73
> >   1   1   0  98   0|   0     0 |  60M  220k|   0     0 |6402  6182 |   0     0
> >   0   1   0  98   0|   0     0 |  69M  255k|   0     0 |7305  4339 |   0     0
> >   1   2   0  98   0|   0     0 |  76M  282k|   0     0 |7914  4886 |   0     0
> >   1   1   0  99   0|   0     0 |  70M  260k|   0     0 |7293  4444 |   0     0
> >   1   1   0  98   0|   0     0 |  80M  278k|   0     0 |8018  4931 |   0     0
> >   0   1   0  98   0|   0     0 |  60M  221k|   0     0 |6435  5951 |   0     0
> >   0   1   0  99   0|   0     0 |  59M  211k|   0     0 |6163  3584 |   0     0
> >   0   1   0  98   0|   0     0 |  64M  323k|   0     0 |6653  3881 |   0     0
> >   1   0   0  99   0|   0     0 |  61M  243k|   0     0 |6822  4401 |   0     0
> >   0   1   0  99   0|   0     0 |  55M  205k|   0     0 |5975  3518 |   0     0
> >   1   1   0  98   0|   0     0 |  68M  242k|   0     0 |7094  6544 |   0     0
> >   0   1   0  99   0|   0     0 |  58M  230k|   0     0 |6639  4178 |   0     0
> >   1   2   0  98   0|   0     0 |  61M  243k|   0     0 |7117  4477 |   0     0
> >   0   1   0  99   0|   0     0 |  61M  228k|   0     0 |6500  4078 |   0     0
> >   0   1   0  99   0|   0     0 |  65M  234k|   0     0 |6595  3914 |   0     0
> >   0   1   0  98   0|   0     0 |  64M  219k|   0     0 |6507  5755 |   0     0
> >   1   1   0  99   0|   0     0 |  64M  233k|   0     0 |6869  4153 |   0     0
> >   1   2   0  98   0|   0     0 |  63M  232k|   0     0 |6632  3907 |
> > 0     0 ^C
> > jk@wombat:~$ w
> >  07:50:56 up 11:25,  1 user,  load average: 221.35, 88.07, 55.02
> > USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
> > jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
> > jk@wombat:~$
> >
> > Thanks.
