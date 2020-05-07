Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34101C966F
	for <lists+ceph-devel@lfdr.de>; Thu,  7 May 2020 18:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgEGQ0E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 May 2020 12:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEGQ0E (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 May 2020 12:26:04 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36330C05BD43;
        Thu,  7 May 2020 09:26:04 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d7so2738953ioq.5;
        Thu, 07 May 2020 09:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DxrpDcEowC2nWijqj13bXtMWCGzq2IqmtnQs3KgvsXI=;
        b=ljddwFgYm/EfJhn50K7SOmOsqWqMR5j/cLfNW11NDz81cwXUjaKQ3mBtGQ0MQ3Czrw
         iuA5Z0o4BBm/uHkO5FszeGeNA+lwcliuRrtyTSNCyA7WnfiTotNo1cZ1xdkstRgvuBVT
         1DSjFDO49P0i88RsSEF4mkyNjxYQ7hWE7Ng5hk+xWZoI3ephe6o2w+ZkFaDMwIzieeWu
         d/CRl5/FdlyfTKiH84PY4GoSBW8ixz1Mc8KdERpywIo2RHCRKiMROAroNg8v+iCgqpY8
         Z9SI8SJa1MVZuiflc2gS6fTvO/a+mu+UZnIfdszf6vcRXvddN37f9+yEO6GnINjpFeE4
         O5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DxrpDcEowC2nWijqj13bXtMWCGzq2IqmtnQs3KgvsXI=;
        b=chOZ0qW3SuKH6nvwzTsy/7kfWhv6HlPYxjFF0cvtTlrb7A9GhIOjBngIJnkoVKS8da
         Pr3V1DdIdxB7OBHA+p08UosrkJ4EUo8WAKsQ05sl0naqolTLLD4OyHX02avCZPAj7on1
         DWDFePoOxY9Ll6PTrJ/R1I/4Rc8T6rd6yLGKovH9GkSK6S2ShUYgiISI9HBvIfb6CVXT
         KL5TU2JN+Zl1jA8trFPu0KF9600c296+TiWOoLa5EMKh98YPJs+iEoMXbHA7tLi5p6al
         ywTw///947qqY/UpEUMF04H4OIddblCzbAt9OmUV72vNX8TFzlFHTMW10DEuxL75gIMg
         E4ZA==
X-Gm-Message-State: AGi0PuZLaQHPB01Dwpkg1U84sriVA9RTy5nlNGx3PzAFoNbIvR8gP3Hn
        0v1b5FOGJ/cQ0OpbGHlLJGaI5bVerBv3H7vW1Nk=
X-Google-Smtp-Source: APiQypKDF58jn4byCgHHNjiVKd2T2f04YumBuTEle19S+IjBAzkjZmg/zOArb9caTa4uMTFbNgwyIY+epItZP9R8RoM=
X-Received: by 2002:a5e:a607:: with SMTP id q7mr14744359ioi.109.1588868762638;
 Thu, 07 May 2020 09:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200505125902.GA10381@suse.com> <e5839bffe4939c6290d74ca2fb39310bd4916c16.camel@kernel.org>
In-Reply-To: <e5839bffe4939c6290d74ca2fb39310bd4916c16.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 7 May 2020 18:26:03 +0200
Message-ID: <CAOi1vP8oO156ZH0Ge3d5V0fu+NTW6LO12bxgy1h-W5X4+9zN=w@mail.gmail.com>
Subject: Re: [PATCH] ceph: demote quotarealm lookup warning to a debug message
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Gregory Farnum <gfarnum@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 7, 2020 at 3:44 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-05-05 at 13:59 +0100, Luis Henriques wrote:
> > A misconfigured cephx can easily result in having the kernel client
> > flooding the logs with:
> >
> >   ceph: Can't lookup inode 1 (err: -13)
> >
> > Change his message to debug level.
> >
> > Link: https://tracker.ceph.com/issues/44546
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> > Hi!
> >
> > This patch should fix some harmless warnings when using cephx to restri=
ct
> > users access to certain filesystem paths.  I've added a comment to the
> > tracker where removing this warning could result (unlikely, IMHO!) in a=
n
> > admin to miss not-so-harmless bogus configurations.
> >
> > Cheers,
> > --
> > Lu=C3=ADs
> >
> >  fs/ceph/quota.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> > index de56dee60540..19507e2fdb57 100644
> > --- a/fs/ceph/quota.c
> > +++ b/fs/ceph/quota.c
> > @@ -159,8 +159,8 @@ static struct inode *lookup_quotarealm_inode(struct=
 ceph_mds_client *mdsc,
> >       }
> >
> >       if (IS_ERR(in)) {
> > -             pr_warn("Can't lookup inode %llx (err: %ld)\n",
> > -                     realm->ino, PTR_ERR(in));
> > +             dout("Can't lookup inode %llx (err: %ld)\n",
> > +                  realm->ino, PTR_ERR(in));
> >               qri->timeout =3D jiffies + msecs_to_jiffies(60 * 1000); /=
* XXX */
> >       } else {
> >               qri->timeout =3D 0;
> >
>
> Ilya,
>
> We've had a number of reports where people get a ton of kernel log spam
> when they hit this problem. I think we probably ought to mark this patch
> for stable and go ahead and send it to Linus for v5.7 -- any objection?

Sure, I'll queue it up.

Thanks,

                Ilya
