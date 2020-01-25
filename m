Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5488F1493F7
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Jan 2020 09:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgAYIIA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 25 Jan 2020 03:08:00 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41911 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgAYIIA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 25 Jan 2020 03:08:00 -0500
Received: by mail-io1-f68.google.com with SMTP id m25so4473856ioo.8
        for <ceph-devel@vger.kernel.org>; Sat, 25 Jan 2020 00:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5DRMydi3AcfKfXR4nEsjHzDnQYsNAC9neIbUeZfSZRc=;
        b=Qb1o5J/mLYRrGQGnh6XLv5gXI+QMl5Oq1QSBPykiHIen9rWkapjai4kr6y4eqIo25G
         wJYelSFY0W2C3yhECQAPZR0/2Yp+kvRa7FytsAq/aJ1QSnTvXGvBMUMFCb9tWRzzDOAj
         WqyUiGA1fxA6p3ukMBj4wgjeQy37HR3IPvPxToaI7pMMXtn3GzVilJ6ow7qBiNbPiXAj
         tbpjOBqzaDEeu7PTbhG6nnyh882XUGMqS7boIhp7wfqFjtSjwZnHeaMZ3Szx8OL94kqK
         M29rC5gon5U7ppVimmenCpVP6+VNQLvi7sV3x5yBKlUuWBuXs/e/SWjN0c8D6O5fmMQj
         TSyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5DRMydi3AcfKfXR4nEsjHzDnQYsNAC9neIbUeZfSZRc=;
        b=YtoI5VjpRJeTv+uQKtWwdKCWrApCJMah3X2RZDYW0jPESJChLGv4pt4Gn3qiSmqqbC
         ZsVSeh76ZgjL/62lgBwR5bmf5XB/4oP/76zY4TPqOLdNf7RUZrwPkm5TzL/BAnE/mt6u
         +I9TgNSM/kfWY/99WuxW2FWHFtPc3oFCGAMiOds78kS1LXMtIIl0o01N24SxsuMehUUx
         pGEFQZSYdt/Wzhfl5ryF3ghimmVjX9TWj0NLOACq1rRjd4WWcQOZIwvKL4/0Qqf8KYDr
         yhkSY9ByoTHw8lF2Qtq2K9qM/SuaGOTZHMUHwDs8Wel10u73hujRtINnHJXDIKIsw5j4
         fU2Q==
X-Gm-Message-State: APjAAAW5PRf47A1SNYvppedbZOnrBlUISaNRmZFew0lGds0RpFshC+tz
        HniY1HY7iOO6uuHfKsPdMMr4tfnk4SzLnw3eq6U=
X-Google-Smtp-Source: APXvYqzYPE6JO4uXQvsszZeYrNz2svzmhe1jzPfpE/c4LBCBUPFj3a+RXrIR3riHDijiCU0EQE3qTMKc0WQs2snCjyo=
X-Received: by 2002:a6b:17c4:: with SMTP id 187mr5195666iox.143.1579939679407;
 Sat, 25 Jan 2020 00:07:59 -0800 (PST)
MIME-Version: 1.0
References: <20200121192928.469316-1-jlayton@kernel.org> <20200121192928.469316-2-jlayton@kernel.org>
 <ca86904cc6b03bf5844358ebac6684e88aa8ca11.camel@kernel.org>
In-Reply-To: <ca86904cc6b03bf5844358ebac6684e88aa8ca11.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sat, 25 Jan 2020 09:08:03 +0100
Message-ID: <CAOi1vP82OgP+uxEg9aQuSf-QUGJe6OcF5DkBLeFzY2qrBdewCg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/10] ceph: move net/ceph/ceph_fs.c to fs/ceph/util.c
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        idridryomov@gmail.com, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jan 24, 2020 at 9:59 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-01-21 at 14:29 -0500, Jeff Layton wrote:
> > All of these functions are only called from CephFS, so move them into
> > ceph.ko, and drop the exports.
> >
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/Makefile                     | 2 +-
> >  net/ceph/ceph_fs.c => fs/ceph/util.c | 4 ----
> >  net/ceph/Makefile                    | 2 +-
> >  3 files changed, 2 insertions(+), 6 deletions(-)
> >  rename net/ceph/ceph_fs.c => fs/ceph/util.c (94%)
> >
> > diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
> > index c1da294418d1..0a0823d378db 100644
> > --- a/fs/ceph/Makefile
> > +++ b/fs/ceph/Makefile
> > @@ -8,7 +8,7 @@ obj-$(CONFIG_CEPH_FS) += ceph.o
> >  ceph-y := super.o inode.o dir.o file.o locks.o addr.o ioctl.o \
> >       export.o caps.o snap.o xattr.o quota.o io.o \
> >       mds_client.o mdsmap.o strings.o ceph_frag.o \
> > -     debugfs.o
> > +     debugfs.o util.o
> >
> >  ceph-$(CONFIG_CEPH_FSCACHE) += cache.o
> >  ceph-$(CONFIG_CEPH_FS_POSIX_ACL) += acl.o
> > diff --git a/net/ceph/ceph_fs.c b/fs/ceph/util.c
> > similarity index 94%
> > rename from net/ceph/ceph_fs.c
> > rename to fs/ceph/util.c
> > index 756a2dc10d27..2c34875675bf 100644
> > --- a/net/ceph/ceph_fs.c
> > +++ b/fs/ceph/util.c
> > @@ -39,7 +39,6 @@ void ceph_file_layout_from_legacy(struct ceph_file_layout *fl,
> >           fl->stripe_count == 0 && fl->object_size == 0)
> >               fl->pool_id = -1;
> >  }
> > -EXPORT_SYMBOL(ceph_file_layout_from_legacy);
> >
> >  void ceph_file_layout_to_legacy(struct ceph_file_layout *fl,
> >                               struct ceph_file_layout_legacy *legacy)
> > @@ -52,7 +51,6 @@ void ceph_file_layout_to_legacy(struct ceph_file_layout *fl,
> >       else
> >               legacy->fl_pg_pool = 0;
> >  }
> > -EXPORT_SYMBOL(ceph_file_layout_to_legacy);
> >
> >  int ceph_flags_to_mode(int flags)
> >  {
> > @@ -82,7 +80,6 @@ int ceph_flags_to_mode(int flags)
> >
> >       return mode;
> >  }
> > -EXPORT_SYMBOL(ceph_flags_to_mode);
> >
> >  int ceph_caps_for_mode(int mode)
> >  {
> > @@ -101,4 +98,3 @@ int ceph_caps_for_mode(int mode)
> >
> >       return caps;
> >  }
> > -EXPORT_SYMBOL(ceph_caps_for_mode);
> > diff --git a/net/ceph/Makefile b/net/ceph/Makefile
> > index 59d0ba2072de..ce09bb4fb249 100644
> > --- a/net/ceph/Makefile
> > +++ b/net/ceph/Makefile
> > @@ -13,5 +13,5 @@ libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
> >       auth.o auth_none.o \
> >       crypto.o armor.o \
> >       auth_x.o \
> > -     ceph_fs.o ceph_strings.o ceph_hash.o \
> > +     ceph_strings.o ceph_hash.o \
> >       pagevec.o snapshot.o string_table.o
>
> I've gone ahead and merged this patch into testing, as I think it makes
> sense on its own and it was becoming a hassle when testing.

Yup, sounds good.

Thanks,

                Ilya
