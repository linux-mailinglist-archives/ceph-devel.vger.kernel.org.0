Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E3621E563
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jul 2020 03:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgGNB47 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jul 2020 21:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgGNB46 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jul 2020 21:56:58 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723D9C061755
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jul 2020 18:56:58 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id 12so12718238oir.4
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jul 2020 18:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3fx2M/sclCFiaxYtLtXzhfzZUw4ebltoDekVEyar9j8=;
        b=Ba0r0LYZ8D/GUV2VH4GWPjcXAkNu7EAz3y9ClC4sSiO7OlIm6OgvGT8F9noOkEWBqN
         4ALdjPDHKeWKISXonqQ2Rm+rASIanvfwrOMdQFKS6X6WhUyq/hRRW0+iZ4TYtulSsxfF
         DlFn5GNuJHlO0eOQeM0YqS7Dp9VvHhFmmxYSjXrl49YZBw9GFbhld8+5bgAV//P6Xuhj
         Rds40tGHw5gOHn7dWI+ygjR8tykCroTFgtj57G3YLcjDIMHOd1rGYQDg3Zi9m2yI4gAQ
         dDh3BT9NKRqkyoit7WSL8UUTCJgtEfLy8Yl+E4SJGFpm9PPTBkWIppNV6im90p/78ze/
         I0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3fx2M/sclCFiaxYtLtXzhfzZUw4ebltoDekVEyar9j8=;
        b=fMJTRVH2jrZ4UwtY1Kw4OS7GZIu4SZ5l6Y6e7Q3679NoG08flMxi2O5bE6CynmzjlI
         yqfeo+czX1Komk5U3bydkWbuMF/lR3BVB4kVJZPE1N16W2n0sr/Nkenm+zYsUiOmQkvn
         2lJwDmgsy0JCwfh5wnuz7N9fti3J1PDmfGctKgcR1kGH4GgfPoHVW6nbDwzEvQql5k9F
         HS8gFu6cmwjwdz3vMtVpiBemQiyxihwGTfKu9NXE/7uk4a4+8Q+aX/1Fl6fj6hhdS2d6
         3HBYnw/pRb1W/cHOftldWh9S2xB4UYZgVe0W7TvMyS+RF6dCUhD1NtHPnTSZCP/9G0m3
         j8lw==
X-Gm-Message-State: AOAM5302OceSTLgrL9V0LJB/7EpSuzwYQh7unGKaEVVf2FxS5QNJ4ADb
        581HgpCzKdJColwuuLEvUCgkN/5ibiL4yxArz/oFD8wl
X-Google-Smtp-Source: ABdhPJyZt0tcs7I68w07feMpT1PlriPOm/0Vqh8bc+rDwLV3pjsbH8hxnVMQEsYhm/Xav/SDx3/z45JiJPpn+XAiCL0=
X-Received: by 2002:aca:c30e:: with SMTP id t14mr1847095oif.95.1594691817735;
 Mon, 13 Jul 2020 18:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <1594439373-2120-1-git-send-email-simon29rock@gmail.com> <CAOi1vP9Qu4QZcpLBYcpmxfsBFh-p0MxOFKw75qZH6QM=AusSPQ@mail.gmail.com>
In-Reply-To: <CAOi1vP9Qu4QZcpLBYcpmxfsBFh-p0MxOFKw75qZH6QM=AusSPQ@mail.gmail.com>
From:   simon gao <simon29rock@gmail.com>
Date:   Tue, 14 Jul 2020 09:58:24 +0800
Message-ID: <CAGR3woXcQpE_LUuVM54SAqxdXGEJh1Q_koh_6bJHJQ-sfybnUw@mail.gmail.com>
Subject: Re: [PATCH] libceph : client only want latest osdmap. If the gap with
 the latest version exceeds the threshold, mon will send the fullosdmap
 instead of incremental osdmap
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

hi idryomov
I've already replied to you under this patch.
thanks.
gao yu

Ilya Dryomov <idryomov@gmail.com> =E4=BA=8E2020=E5=B9=B47=E6=9C=8813=E6=97=
=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=8810:01=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Jul 11, 2020 at 5:52 AM simon gao <simon29rock@gmail.com> wrote:
> >
> > Fix: https://tracker.ceph.com/issues/43421
> > Signed-off-by: simon gao <simon29rock@gmail.com>
> > ---
> >  include/linux/ceph/ceph_fs.h | 1 +
> >  net/ceph/mon_client.c        | 3 ++-
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.=
h
> > index ebf5ba6..9dcc132 100644
> > --- a/include/linux/ceph/ceph_fs.h
> > +++ b/include/linux/ceph/ceph_fs.h
> > @@ -208,6 +208,7 @@ struct ceph_client_mount {
> >  } __attribute__ ((packed));
> >
> >  #define CEPH_SUBSCRIBE_ONETIME    1  /* i want only 1 update after hav=
e */
> > +#define CEPH_SUBSCRIBE_LATEST_OSDMAP   2  /* i want the latest fullmap=
, for client */
> >
> >  struct ceph_mon_subscribe_item {
> >         __le64 start;
> > diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> > index 3d8c801..8d67671 100644
> > --- a/net/ceph/mon_client.c
> > +++ b/net/ceph/mon_client.c
> > @@ -349,7 +349,8 @@ static bool __ceph_monc_want_map(struct ceph_mon_cl=
ient *monc, int sub,
> >  {
> >         __le64 start =3D cpu_to_le64(epoch);
> >         u8 flags =3D !continuous ? CEPH_SUBSCRIBE_ONETIME : 0;
> > -
> > +       if (CEPH_SUB_OSDMAP =3D=3D sub)
> > +            flags |=3D CEPH_SUBSCRIBE_LATEST_OSDMAP;
> >         dout("%s %s epoch %u continuous %d\n", __func__, ceph_sub_str[s=
ub],
> >              epoch, continuous);
>
> I left my comments in https://github.com/ceph/ceph/pull/32422.
> This patch cannot be considered unless a corresponding change is
> merged into Objecter.
>
> Thanks,
>
>                 Ilya
