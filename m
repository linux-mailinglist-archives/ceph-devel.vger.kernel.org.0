Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6381E890B
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 22:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgE2Umz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 16:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgE2Umx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 16:42:53 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F84FC03E969
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 13:42:53 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t8so3279311ilm.7
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 13:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y7ZXI2bFrCtM9btbNaRuAnZFxmfrbZ4Hoh98bW7cR5g=;
        b=JcERkUhESGUgBPH7omZpk3k4rAOlZZLaoCLsIf4qeN6LIq+GuL3nBd6nQUxidPAdSJ
         3tFhlbldhnEoce+ASsHLpNe0+RZL+03i1rv5xQh5lZ40yLPbHqtRutJYXSWTdwuAI6V0
         ecwZx4rRXdYAoGmyZqqiZpxvrneke9YwtOtCYJXGYOsqyZhms89gb9JjwP8N8s7CW7Qa
         yG9WJam866Cfw9ucOiXCSpVzv2Gpd4+P9cEOvYUZ/pI8KISIqZcpk5SaszivjTkmCI3B
         4FPoemTqyUy9hg/rRwuQQd41bJp0CFzXfXb8B/oOxgfVM7MX1l497Y+UY8dY3YeGE6nN
         Eatg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y7ZXI2bFrCtM9btbNaRuAnZFxmfrbZ4Hoh98bW7cR5g=;
        b=VuPf1BipK8nGgXWfjznhLWSMD5NNbs3X+5FJLU///gfLLYagA/9wRzTNUuZjVdf6Xa
         BPpN5CkemHHo3JiYBkzHPUaZyHgg3aQKpwslQt9G0a2We6pPwcSeT64ACrmjNkWgqpFn
         +QjuIgPtT6EV0D+Gn6AaCPn//36/BpK+xwZnZ35W2Yk5BrND9+zB4vk7ZHyKYs9axWp1
         4DLK3XF7rA7WxQShLSl4fi8oqm2DoZTgopn1SW+2t8JrhvsPU8uBHSXi6tP7N+pQpeyX
         HsfneIKnXbNpFy/lE5kTLKsXoG9W0JUYh8oQySY5s0u/YWowzTPNG/ECT6Kp2yrp83vT
         82rg==
X-Gm-Message-State: AOAM5331rsUJU4KU/cr6DH8q5zbVabk9y2NcsEnVUNFGwFhrSPiIy/2O
        UBgYhKQTD3zwU98VT0wZVcIGmqpZryeXl22ioGk=
X-Google-Smtp-Source: ABdhPJwOD9QeZi+YldAvMBlbFsht5+eVRXbs3GnawPe3o/4LfzYy9IEi15QrWIAJ2CdXeM02PDTkGkkGHxU5LYvw/Vw=
X-Received: by 2002:a92:9c89:: with SMTP id x9mr9816105ill.112.1590784972307;
 Fri, 29 May 2020 13:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200529151952.15184-1-idryomov@gmail.com> <20200529151952.15184-4-idryomov@gmail.com>
 <adbdcc0f39b050252241c7afab17e7a4a6ba5a43.camel@kernel.org>
 <CAOi1vP-UPktbA7gcx0tQvN9wi1L2DB1zHyb212x5kbErkchR=Q@mail.gmail.com> <c76c2f3634898c3618ef536f4c507423196eb876.camel@kernel.org>
In-Reply-To: <c76c2f3634898c3618ef536f4c507423196eb876.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 29 May 2020 22:42:57 +0200
Message-ID: <CAOi1vP82akP6L4kGyVmBxLYEDxqimPiiP9=DyvuUkHcQ4gawwQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] libceph: crush_location infrastructure
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 29, 2020 at 9:10 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-05-29 at 20:38 +0200, Ilya Dryomov wrote:
> > On Fri, May 29, 2020 at 7:27 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Fri, 2020-05-29 at 17:19 +0200, Ilya Dryomov wrote:
> > > > Allow expressing client's location in terms of CRUSH hierarchy as
> > > > a set of (bucket type name, bucket name) pairs.  The userspace syntax
> > > > "crush_location = key1=value1 key2=value2" is incompatible with mount
> > > > options and needed adaptation:
> > > >
> > > > - ':' separator
> > > > - one key:value pair per crush_location option
> > > > - crush_location options are combined together
> > > >
> > > > So for:
> > > >
> > > >   crush_location = host=foo rack=bar
> > > >
> > > > one would write:
> > > >
> > > >   crush_location=host:foo,crush_location=rack:bar
> > > >
> > > > As in userspace, "multipath" locations are supported, so indicating
> > > > locality for parallel hierarchies is possible:
> > > >
> > > >   crush_location=rack:foo1,crush_location=rack:foo2,crush_location=datacenter:bar
> > > >
> > >
> > > Blech, that syntax is hideous. It's also problematic in that the options
> > > are additive -- you can't override an option that was given earlier
> > > (e.g. in fstab), or in a shell script.
> > >
> > > Is it not possible to do something with a single crush_location= option?
> > > Maybe:
> > >
> > >     crush_location=rack:foo1/rack:foo2/datacenter:bar
> > >
> > > It's still ugly with the embedded '=' signs, but it would at least make
> > > it so that the options aren't additive.
> >
> > I suppose we could do something like that at the cost of more
> > parsing boilerplate, but I'm not sure additive options are that
> > hideous.  I don't think additive options are unprecedented and
> > more importantly I think many simple boolean and integer options
> > are not properly overridable even in major filesystems.
> >
>
> That is the long-standing convention though. There are reasons to
> deviate from it, but I don't see it here. Plus, I think the syntax I
> proposed above is more readable (and compact) as well.
>
> It would mean a bit more parsing code though, granted.
>
> > What embedded '=' signs are you referring to?  I see ':' and '/'
> > in your suggested syntax.
> >
>
> Sorry, yeah... I had originally done one that had '=' chars in it, but
> converted it to the above. Please disregard that paragraph.

One of the reasons I did it this way is that crush_location is
inherently additive.  I don't have a strong opinion on this though
so let's adhere to the convention.

I'll implement the suggested syntax and repost.

Thanks,

                Ilya
