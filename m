Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAA8D2204
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Oct 2019 09:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733154AbfJJHmi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Oct 2019 03:42:38 -0400
Received: from mail-oi1-f182.google.com ([209.85.167.182]:36901 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733068AbfJJHmi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Oct 2019 03:42:38 -0400
Received: by mail-oi1-f182.google.com with SMTP id i16so4096461oie.4
        for <ceph-devel@vger.kernel.org>; Thu, 10 Oct 2019 00:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aUmRlfgtM8u0N66fgiaf107EXfWAcuzdxnN71UimcCM=;
        b=YelN75fwRFoJyyhcwSBsHWSd8374nnaD7LidMSuzJ1fjm891QXFe0b4J84/VZmrZpv
         zuvht4rjpjdXIpob6RU1ntcVn+FaHfEdfv6LEby8vE00rrJe8jOfXJsRhgWD7W3bZ6Cs
         T37daoFqBYpSKRnpr678g/tZydQ3MNE8xRMSOxHFNWKV7dhnyLyKHS2GCXmDkWeZoKEy
         /t/i5gSy0ASPXcTvhH3cy7Kw54ewzdq9x1W4LrJeEGoLB/wfsohLQKJ/sumyDutGVm6R
         Q0FLTPFuzCEwjmdyu919BqgZpO5eOadXiYzProx37ku2TBk/pdAW411ftVui3QGLZ8/h
         RUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aUmRlfgtM8u0N66fgiaf107EXfWAcuzdxnN71UimcCM=;
        b=ek2MOU+ZOVj0T7bwaIqS6FLOl3FG9BQ5M6+7rCB79iSpiwFMWYQJyYR6shw0Rwi/iu
         Se3pIrB2kEvcy3U6Jor4GKCnWNRtog92ePVBq9FgoNPreV3paSwhx8jeMuBQgEwA3o4Q
         2jvfgT6wvjO1chTJEwPFvfDNoQ3qitpoLsl7tbd7uOmBLiMi4BbqNwxYzZ53sAimDqtL
         h37y9w3MUCFAxAY2okX5AZFz5ukWy7gOHDX74vwTXsGZg4SUwFWHeBvmTIAK5IQU+ZrX
         g908bLfp+ekjxNILDX+eBMdOFdSZg3Qf4otmxWt7KiWEyWS4c3FQUrOU3QZDhav4D8Kk
         rrPQ==
X-Gm-Message-State: APjAAAWpw9ncFBhpjTnhue7eEkGxfF2ktFOqUUuyg5lCFC2YrQ98bfXU
        Ee2nBbixQxjHoiOYJ9qcVF7diVvCB/flSeWC597BIQ==
X-Google-Smtp-Source: APXvYqzlNi8Xk9qV5HfxG3tobM5TX8lH1XPmfUi+xSdDyq8HeG23aiKtu6j2lebk5bZvYexB9FcSx/8X2r35xHaFbZU=
X-Received: by 2002:a05:6808:3bc:: with SMTP id n28mr6249781oie.67.1570693357288;
 Thu, 10 Oct 2019 00:42:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAJACTufSmSphvg4-RDR65KOSWzZsL=3b8mn_yRxSE-YtvDhMAg@mail.gmail.com>
 <alpine.DEB.2.11.1909291528200.5147@piezo.novalocal> <CAJACTuf+_VC=zJxbNP5Au3VUTqSu=jPffRgOjPyQvaoXStLmFg@mail.gmail.com>
In-Reply-To: <CAJACTuf+_VC=zJxbNP5Au3VUTqSu=jPffRgOjPyQvaoXStLmFg@mail.gmail.com>
From:   Xuehan Xu <xxhdx1985126@gmail.com>
Date:   Thu, 10 Oct 2019 15:42:26 +0800
Message-ID: <CAJACTufO-wgKCmJtKs2N8fWwZaRjK7D3EvWMnxe0fgk+7_J-kA@mail.gmail.com>
Subject: Re: Why BlueRocksDirectory::Fsync only sync metadata?
To:     Sage Weil <sage@newdream.net>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

> > My recollection is that rocksdb is always flushing, correct.  There are
> > conveniently only a handful of writers in rocksdb, the main ones being log
> > files and sst files.
> >
> > We could probably put an assertion in fsync() so ensure that the
> > FileWriter buffer is empty and flushed...?
>
> Thanks for your reply, sage:-) I will do that:-)
>
> By the way, I've got another question here:
>        It seems that BlueStore tries to provide some kind of atomic
> I/O mechanism in which data and metadata are either both modified or
> both untouched. To accomplish this, for modifications whose size is
> larger than prefer_defer_size, BlueStore will allocate new space for
> the modifications and release the old storage space. I think, in the
> long run, a initially contiguous stored file in bluestore could become
> scattered if there have been many random modifications to that file.
> Actually, this is what we are experiencing in our test clusters. The
> consequence is that after some period of random modification, the
> sequential read performance of that file is significantly degraded.
> Should we make this atomic I/O mechanism optional? It seems that most
> hard disk only make sure that a sector is never half-modified, for
> which, I think, the deferred I/O is enough. Am I right? Thanks:-)

I mean, in the scenario of RBD, since most real hard disk only
guarantee that a sector is never half-modified, only providing atomic
I/O guarantee for modifications whose are less than or equal to that
of a disk sector, which is guaranteed by deferred io, should be
enough. So, maybe, this atomic I/O guarantee for large size
modifications should be made configurable.
