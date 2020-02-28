Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1035C173991
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Feb 2020 15:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgB1ONj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Feb 2020 09:13:39 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:37310 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgB1ONj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 28 Feb 2020 09:13:39 -0500
Received: by mail-il1-f196.google.com with SMTP id a6so2823810ilc.4;
        Fri, 28 Feb 2020 06:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1vX3IGGP77c2b/3UBHdZdGDWsxibLNsHOtAy3Rk4ea4=;
        b=eb5jF9862cw9ZNPWS2BvKJuITHtXepRuabw7mxV7xRO+8D+2SngMexFxgDTVD+V35t
         oHVN6Ce4xkmFc7ISDc7IMIBCBYRIIwmYsx3NSZqeTVvi9eYu4/zkw81aHP8+AOrfb4aT
         hDmO9chY/TibE2rw06l2pOvmQ5ncep1JWCow0G9ag2U53lTNDYvkL7CHv9726DMOz0GN
         N3J0GghJvjRzRlLex3aSibA70NvsVJo2uw0MCdVVqvR4mThQRMca2LtykoMtRYw1WPPN
         oPGV0iMjabGSrkTDOhgV/0kPT5qNaacw1iGqUPR6TgRk0rTBhiwCx8OYJJJG3pvgHSIe
         SgVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1vX3IGGP77c2b/3UBHdZdGDWsxibLNsHOtAy3Rk4ea4=;
        b=edR4c6MCdhMp2VjeEBa2bbC01g/CwLU0XHrH2OW3GlYwT5WLdrIegAN+ITOfbUD+iO
         LyfGP6ra7lP25bSQZn9g7FiJOAygDRAYyjZ6bWD+uq6wn/M76wijfumomlN+caLNz6iL
         Fa6s5CxXhYNpoK87WuZMHz1fbdytpkCPocvkxqpCP2clkNk6HAA8uIW5vNK9gbMFFe7+
         Gxjn99cAATSmVFjr6YPFiqjKsEtd51y3V9kapT4xzrf8DOzqBuu6n3Dr4gXRUx0QQbjL
         PbfaXqTDVUkgJxWdSAz8AsdQ3Cw29Vcc8L4eQ8IS6zCEis2Aa4gWntxL5X3DmiZA3cmk
         KD4g==
X-Gm-Message-State: APjAAAV+sXyUHvlAuoNBXY2cH+8D2f//3g7HqMwbKxAKJqagdttHtud+
        NatzMV/H6uWOH7acQB1pbgRIm8nsj+mnwaIZIWo=
X-Google-Smtp-Source: APXvYqxv4pjc0mDsPsYIF8OsFcm97Hn8jLb7CSA55Nkj4jwxNpC4wckooDbw1Z4EEjs5UBMaly87MDsrWBLMiCvEa7A=
X-Received: by 2002:a05:6e02:4c:: with SMTP id i12mr4248350ilr.112.1582899217185;
 Fri, 28 Feb 2020 06:13:37 -0800 (PST)
MIME-Version: 1.0
References: <6ea7e486-a3f3-7def-1f88-2e645e3b9780@canonical.com> <6567c8fa690d9f9a0682ee22e528fcd5e3b51212.camel@kernel.org>
In-Reply-To: <6567c8fa690d9f9a0682ee22e528fcd5e3b51212.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 28 Feb 2020 15:13:30 +0100
Message-ID: <CAOi1vP8wYvmngMCig3nJg45J93D2Ah=m3J91YpgRZ9hhscLe6w@mail.gmail.com>
Subject: Re: libceph: follow redirect replies from osds
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Colin Ian King <colin.king@canonical.com>,
        Sage Weil <sage@redhat.co>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Feb 28, 2020 at 3:01 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-02-28 at 12:46 +0000, Colin Ian King wrote:
> > Hi,
> >
> > Static analysis with Coverity has detected a potential issue in the
> > following commit in function ceph_redirect_decode():
> >
> > commit 205ee1187a671c3b067d7f1e974903b44036f270
> > Author: Ilya Dryomov <ilya.dryomov@inktank.com>
> > Date:   Mon Jan 27 17:40:20 2014 +0200
> >
> >     libceph: follow redirect replies from osds
> >
> > The issue is as follows:
> >
> >
> > 3486        len = ceph_decode_32(p);
> >
> > Unused value (UNUSED_VALUE)
> > assigned_pointer: Assigning value from len to *p here, but that stored
> > value is overwritten before it can be used.
> >
> > 3487        *p += len; /* skip osd_instructions */
> > 3488
> > 3489        /* skip the rest */
> >
> > value_overwrite: Overwriting previous write to *p with value from
> > struct_end.
> >
> > 3490        *p = struct_end;
> >
> > The *p assignment in line 3487 is effectively being overwritten by the
> > *p assignment in 3490.  Maybe the following is correct:
> >
> >         len = ceph_decode_32(p);
> > -       p += len; /* skip osd_instructions */
> > +       struct_end = *p + len;  /* skip osd_instructions */
> >
> >         /* skip the rest */
> >         *p = struct_end;
> >
> > I'm not familiar with the ceph structure here, so I'm not sure what the
> > correct fix would be.
> >
>
> Probably something like this? (untested, of course)
>
> ----------------------
>
> [PATCH] libceph: fix up Coverity warning in ceph_redirect_decode
>
> We're going to skip to the end of the msg after checking the
> object_name anyway, so there is no need to separately decode
> the osd instructions that follow it.
>
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  net/ceph/osd_client.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 8ff2856e2d52..51810db4130a 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -3483,9 +3483,6 @@ static int ceph_redirect_decode(void **p, void
> *end,
>                 goto e_inval;
>         }
>
> -       len = ceph_decode_32(p);
> -       *p += len; /* skip osd_instructions */
> -
>         /* skip the rest */
>         *p = struct_end;
>  out:

Yeah, I have had the same patch in a local branch here since last year:

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2092861.html

I'll make sure to push it out this time ;)

Thanks,

                Ilya
