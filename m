Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C03E19F6AB
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 15:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgDFNRf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 09:17:35 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:44227 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbgDFNRf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Apr 2020 09:17:35 -0400
Received: by mail-lj1-f180.google.com with SMTP id p14so14608758lji.11
        for <ceph-devel@vger.kernel.org>; Mon, 06 Apr 2020 06:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+eyW5GD6A9ontp7Tvwo4g8WcKlOErnzQLuWOsEiZUzE=;
        b=L4bi6SV4f/diLL3LdXGBcsMaVFYaqbLK3S4vlVEuvnXocdBibXc0CCTg7mPwn+B29T
         xTa+OBevpF1xRvS1VLn9YvWBerEy9obwPhxVpf9tCvNqnJ44UhTWTWWhQnVsw0UOMa5P
         qhvQh0EZa6AuR0BimDqQpTsWrZjjAQ/gmeiL1xsP2RfMCVzGdxASJYZdEPVWVWthZ5tV
         vC4w9spv1bwt+DXn6GUwUPwv1HvnCOLAmjvdwBV/0moj/EgoSKcmTWtfIJSLuY9sD3vE
         emC6ugzwEl0zJs579XX6EabgWK+Wj84SJx3OaSVih1PYm4/YugXcP8opgcAOpusQss+p
         UOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+eyW5GD6A9ontp7Tvwo4g8WcKlOErnzQLuWOsEiZUzE=;
        b=E53WlJSgrpkpWQpuB5OQ6ZSHSkxBpjSN8bSFSQFDbnVYwsf7FZoNhhBNyGatgOM1Vh
         vQm+jSpTCQTg2yimYoPIqVly1BvPf6Kv4BWKhHgGLRriUjSc6HUaN8XD6SAFzBLLip0v
         tjdgdP75E8baGsgK4o4k60DmsAKgxpn/QFdlAKHbg4RHHVK0amk28JDRmjfNFNF1YMot
         rrYhRINAGDb78dEAhGHNjBcprUQ9FAShaTmzf55MPL3oFk9jtJz7G+iMJ3JMfvg4eqZP
         nDF2pCXQs6m39JrN8j5kf7kzj27yaKquoWCHeQz3kfvg9O6IuZcJhs5fETS+If/ak2VK
         1cDQ==
X-Gm-Message-State: AGi0PuY7E0eUrSmM4k8o2QoluBqD9VXUNYlkHvw+ifLbFG5lURcwWTAP
        7FkqbybxO7hnAtYlXBHqmqg9DgK37fhh0V3oninYrw==
X-Google-Smtp-Source: APiQypKpgPh1rkGpRG5wFewau5iOF9A4yA0RvDfrzP+i/YPP/ij9Q3pO52bmcEIHg9Qltqen9xGM97Ia3RI7AyhGceM=
X-Received: by 2002:a05:651c:1108:: with SMTP id d8mr11909443ljo.198.1586179053350;
 Mon, 06 Apr 2020 06:17:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
 <db72c749125519b9c042c9664918eacbe8744985.camel@kernel.org>
In-Reply-To: <db72c749125519b9c042c9664918eacbe8744985.camel@kernel.org>
From:   Jesper Krogh <jesper.krogh@gmail.com>
Date:   Mon, 6 Apr 2020 15:17:22 +0200
Message-ID: <CAED-sie+qsrr3yZVAiB=t6cAzWUwX9Y=32srJY2dwyRpSXvgxg@mail.gmail.com>
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff.

No, because the client "bacula-fd" is reading from the local
filesystem - here CephFS and sending it over the network to the server
with the tape-libraries attached to it.  Thus "ideal" receive == send
- which is also the pattern I see when using larger files (multiple
MB).

Is the per-file overhead many KB?

Jesper

On Mon, Apr 6, 2020 at 1:45 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2020-04-06 at 10:04 +0200, Jesper Krogh wrote:
> > This is a CephFS client - its only purpose is to run the "filedaemon" of bacula
> > and transport data to the tape-library from CephFS - below 2 threads is
> > essentially doing something equivalent to
> >
> > find /cephfs/ -type f | xargs cat | nc server
> >
> > 2 threads only, load exploding and the "net read vs net write" has
> > more than 100x difference.
> >
>
> Makes sense. You're basically just reading in all of the data on this
> cephfs, so the receive is going to be much larger than the send.
>
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
>
> Load average is high, but it looks like it's all just waiting on I/O.
>
> > jk@wombat:~$ w
> >  07:50:56 up 11:25,  1 user,  load average: 221.35, 88.07, 55.02
> > USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
> > jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
> > jk@wombat:~$
> >
> --
> Jeff Layton <jlayton@kernel.org>
>
