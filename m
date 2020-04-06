Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0388E19F1D9
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 10:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgDFIxa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 04:53:30 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:43261 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgDFIxa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Apr 2020 04:53:30 -0400
Received: by mail-qt1-f182.google.com with SMTP id a5so12155137qtw.10
        for <ceph-devel@vger.kernel.org>; Mon, 06 Apr 2020 01:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LX91VntrYEn9QwH26x8G4FdkrwN5/pJBGjIINz+dtjM=;
        b=kPbC+fDfuTkE87ODwn7r2kf7wuPTsvlDWAtu9E7QWcHGJUCOyPtwZv7j7nrx6P0bmF
         ZW2Wr+WkGFQB+zmbd9h6/BnqWXqlHjY9WgPDVlZkeOB6IEisELghv/gNmKmLdY2fbarf
         dIvEq1PoPC6pLSKAhMY0zLLpyRM2r4FAllypZ3bjUVMx84PyKvnGjNPuMmMg9aVEWbmn
         pQLXJvom3d9xiidIZ7qSFCjt2XFDZa8Sq+j4CTnwq1uADb9fosWMxm/Rh8JcpnMuxfk0
         FrBAs7flmr2WQ322pVeiNFZiPwi/3ZDwN6f0tc9tZFBYqT2+OVU6UAcbcBxC90luxUKz
         EZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LX91VntrYEn9QwH26x8G4FdkrwN5/pJBGjIINz+dtjM=;
        b=XnKq03Kl/JCbbXBy/i9IEui5PCA5D9LUM6YRTJdKB9QjS8jTw4CwsCw/MSbY5IUKhh
         yeUp0Z4AolpKyD14QdPcH0mhKZT5hmCp4DOt3NUl0oIhqqegjp2XhEBacyQqBYu7tRop
         b7vZRGAf8VoncwfE8u2vY4y9rN3oot4fPCYXAc670HmdWG628qH+9HOPArc52gpfwwg3
         XhThMLmLtyzlPg7rl3O2idtuRVmiclZfUBPJ8rPJkdO/n90KLelrFNeni0HHaTCEbgD6
         Zw3LGEz0/y+MiHYB2J9PLSXxurIVmSuQe5xn+PKSPjaj+Sr1tkw25jbgTnd3Ay9uFv3n
         0TyA==
X-Gm-Message-State: AGi0PuYFTXJlm78+OaQ5XbGJ0vo4Dai2DfOvHMaL7h89ryyPbLyDuIt3
        q7L0ARmZooMpgo3cSCMijowBGF4ndluVyE7tLyrPWYpS
X-Google-Smtp-Source: APiQypKcZZ3b5LjdizYfyt7w32/0aMY/ZXBukQ8JOBwDs1sP4K5aAwSqK8GibF8n94yOUTIRNwWKFovxxMKLpceunWA=
X-Received: by 2002:ac8:18f3:: with SMTP id o48mr19991068qtk.368.1586163209205;
 Mon, 06 Apr 2020 01:53:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
In-Reply-To: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 6 Apr 2020 16:53:18 +0800
Message-ID: <CAAM7YAmTxAeiemB4YZzD02i8fu99FGSFwpc7zLuzT1xUO6Cn=Q@mail.gmail.com>
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
To:     Jesper Krogh <jesper.krogh@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 6, 2020 at 4:06 PM Jesper Krogh <jesper.krogh@gmail.com> wrote:
>
> This is a CephFS client - its only purpose is to run the "filedaemon" of bacula
> and transport data to the tape-library from CephFS - below 2 threads is
> essentially doing something equivalent to
>
> find /cephfs/ -type f | xargs cat | nc server
>
> 2 threads only, load exploding and the "net read vs net write" has
> more than 100x difference.
>
> Can anyone explain this as "normal" behaviour?
> Server is a  VM with 16 "vCPU" and 16GB memory running libvirt/qemu
>
> jk@wombat:~$ w
>  07:50:33 up 11:25,  1 user,  load average: 206.43, 76.23, 50.58
> USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
> jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
> jk@wombat:~$ dstat -ar
> --total-cpu-usage-- -dsk/total- -net/total- ---paging-- ---system-- --io/total-
> usr sys idl wai stl| read  writ| recv  send|  in   out | int   csw | read  writ
>   0   0  98   1   0|  14k   34k|   0     0 |   3B   27B| 481   294 |0.55  0.73
>   1   1   0  98   0|   0     0 |  60M  220k|   0     0 |6402  6182 |   0     0
>   0   1   0  98   0|   0     0 |  69M  255k|   0     0 |7305  4339 |   0     0
>   1   2   0  98   0|   0     0 |  76M  282k|   0     0 |7914  4886 |   0     0
>   1   1   0  99   0|   0     0 |  70M  260k|   0     0 |7293  4444 |   0     0
>   1   1   0  98   0|   0     0 |  80M  278k|   0     0 |8018  4931 |   0     0
>   0   1   0  98   0|   0     0 |  60M  221k|   0     0 |6435  5951 |   0     0
>   0   1   0  99   0|   0     0 |  59M  211k|   0     0 |6163  3584 |   0     0
>   0   1   0  98   0|   0     0 |  64M  323k|   0     0 |6653  3881 |   0     0
>   1   0   0  99   0|   0     0 |  61M  243k|   0     0 |6822  4401 |   0     0
>   0   1   0  99   0|   0     0 |  55M  205k|   0     0 |5975  3518 |   0     0
>   1   1   0  98   0|   0     0 |  68M  242k|   0     0 |7094  6544 |   0     0
>   0   1   0  99   0|   0     0 |  58M  230k|   0     0 |6639  4178 |   0     0
>   1   2   0  98   0|   0     0 |  61M  243k|   0     0 |7117  4477 |   0     0
>   0   1   0  99   0|   0     0 |  61M  228k|   0     0 |6500  4078 |   0     0
>   0   1   0  99   0|   0     0 |  65M  234k|   0     0 |6595  3914 |   0     0
>   0   1   0  98   0|   0     0 |  64M  219k|   0     0 |6507  5755 |   0     0
>   1   1   0  99   0|   0     0 |  64M  233k|   0     0 |6869  4153 |   0     0
>   1   2   0  98   0|   0     0 |  63M  232k|   0     0 |6632  3907 |
> 0     0 ^C
> jk@wombat:~$ w
>  07:50:56 up 11:25,  1 user,  load average: 221.35, 88.07, 55.02
> USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
> jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
> jk@wombat:~$
>
> Thanks.

how small these files are?
