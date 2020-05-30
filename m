Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23B01E925E
	for <lists+ceph-devel@lfdr.de>; Sat, 30 May 2020 17:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgE3Pr2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 May 2020 11:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbgE3Pr2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 30 May 2020 11:47:28 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EADC03E969
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:47:28 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id a13so634573ilh.3
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=89pSDVmoDe4+96kvV3K5xFksKjCi2KlRLYfKqSbPgnY=;
        b=dwZQnXKCUqGgbfCk67xbQaYa5lR05znuDGuuE9oZlPm+XxgCnKtbCdOCWi9WffGQ41
         Fh4dunCN1lCOOpJeDrx+w1dmMGyWVqCQvBijcfSmqbGkItMmkpc/4qtq3JuhJrb5UkNl
         mwLq07PRRTybbJXEk2rvcxaABBn4Qdlwp0xyYtco+QJKtNUvltZ3gzFuXnfTE2RNm23q
         h8WONJBTqP/hB/C/yzUsKiweCwh3Jzj6bw1fmKj5MvNPohOaXYiKkdplUONRGq5ppdXi
         c51MnrKrnwIxVx9cOYJVqniCkEqHJU9Z608m1P0kMHSi1OdxjB6/3+lH8++O8LccGFxr
         pKyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=89pSDVmoDe4+96kvV3K5xFksKjCi2KlRLYfKqSbPgnY=;
        b=uXrERaJnPIa7qgVYZlAoCg3sFRzkcQXyGf59yq4888EraNZ7iikcjGHmEA2y2t0ZFy
         +hFQyb415Q4yWAsFcmuZvcsXXvdy/XHeXHbVjSS6sW8L5cBzW4N9NcL9zgfZknpXE8wy
         lv3aI75iGWQ2TpJmomawlCjshfxjtsz5nkiRj5zJu9dtuwqqKwm12GAzqeiV9nIPwtOj
         XvVGYgjYrIjEogxHULwvW1p6W0DnJBIr0T+BMbhDJtHZ6vkn5YmNG0zBdCdNjN88SF8e
         ivMZTUyvKr7RdI7JJX/8bFVJbdDN8ZwJ6ZFIpomDemB3Fz+Ausol5QXx9PUZwRo0/QBQ
         FFng==
X-Gm-Message-State: AOAM533rc0jVDkM1dfsRFzC/PZFD0nSFkkEkDPSvBVynvtjTtSD67U6/
        Xbn1DzfaSJGPOKhls5aEWkBqoAi0oXebXkg3At7Gkn56BJg=
X-Google-Smtp-Source: ABdhPJxbWeI81LepCVK1qg/mRzx+pEVPxorIJb4YK7S0LRyGTvAcIvAUf+Khex1x0dLAi+BtIvvsTrTVRkMGMKCv2Ac=
X-Received: by 2002:a92:9c89:: with SMTP id x9mr13664519ill.112.1590853647533;
 Sat, 30 May 2020 08:47:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200529151952.15184-1-idryomov@gmail.com> <20200529151952.15184-4-idryomov@gmail.com>
 <adbdcc0f39b050252241c7afab17e7a4a6ba5a43.camel@kernel.org>
 <CAOi1vP-UPktbA7gcx0tQvN9wi1L2DB1zHyb212x5kbErkchR=Q@mail.gmail.com>
 <c76c2f3634898c3618ef536f4c507423196eb876.camel@kernel.org> <CAOi1vP82akP6L4kGyVmBxLYEDxqimPiiP9=DyvuUkHcQ4gawwQ@mail.gmail.com>
In-Reply-To: <CAOi1vP82akP6L4kGyVmBxLYEDxqimPiiP9=DyvuUkHcQ4gawwQ@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sat, 30 May 2020 17:47:32 +0200
Message-ID: <CAOi1vP8gmuxfvZ6zhwy+-_DeGFsRWwam_9a-W9_7oPYj7dnFjQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] libceph: crush_location infrastructure
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 29, 2020 at 10:42 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Fri, May 29, 2020 at 9:10 PM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > On Fri, 2020-05-29 at 20:38 +0200, Ilya Dryomov wrote:
> > > On Fri, May 29, 2020 at 7:27 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > On Fri, 2020-05-29 at 17:19 +0200, Ilya Dryomov wrote:
> > > > > Allow expressing client's location in terms of CRUSH hierarchy as
> > > > > a set of (bucket type name, bucket name) pairs.  The userspace syntax
> > > > > "crush_location = key1=value1 key2=value2" is incompatible with mount
> > > > > options and needed adaptation:
> > > > >
> > > > > - ':' separator
> > > > > - one key:value pair per crush_location option
> > > > > - crush_location options are combined together
> > > > >
> > > > > So for:
> > > > >
> > > > >   crush_location = host=foo rack=bar
> > > > >
> > > > > one would write:
> > > > >
> > > > >   crush_location=host:foo,crush_location=rack:bar
> > > > >
> > > > > As in userspace, "multipath" locations are supported, so indicating
> > > > > locality for parallel hierarchies is possible:
> > > > >
> > > > >   crush_location=rack:foo1,crush_location=rack:foo2,crush_location=datacenter:bar
> > > > >
> > > >
> > > > Blech, that syntax is hideous. It's also problematic in that the options
> > > > are additive -- you can't override an option that was given earlier
> > > > (e.g. in fstab), or in a shell script.
> > > >
> > > > Is it not possible to do something with a single crush_location= option?
> > > > Maybe:
> > > >
> > > >     crush_location=rack:foo1/rack:foo2/datacenter:bar
> > > >
> > > > It's still ugly with the embedded '=' signs, but it would at least make
> > > > it so that the options aren't additive.
> > >
> > > I suppose we could do something like that at the cost of more
> > > parsing boilerplate, but I'm not sure additive options are that
> > > hideous.  I don't think additive options are unprecedented and
> > > more importantly I think many simple boolean and integer options
> > > are not properly overridable even in major filesystems.
> > >
> >
> > That is the long-standing convention though. There are reasons to
> > deviate from it, but I don't see it here. Plus, I think the syntax I
> > proposed above is more readable (and compact) as well.
> >
> > It would mean a bit more parsing code though, granted.
> >
> > > What embedded '=' signs are you referring to?  I see ':' and '/'
> > > in your suggested syntax.
> > >
> >
> > Sorry, yeah... I had originally done one that had '=' chars in it, but
> > converted it to the above. Please disregard that paragraph.
>
> One of the reasons I did it this way is that crush_location is
> inherently additive.  I don't have a strong opinion on this though
> so let's adhere to the convention.
>
> I'll implement the suggested syntax and repost.

I went with '|' instead of '/' for the separator to try to stress
the additivity (in the OR sense).  '/' makes it look like a path to
the root of the tree which it really isn't.

Thanks,

                Ilya
