Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C01F376294
	for <lists+ceph-devel@lfdr.de>; Fri,  7 May 2021 11:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbhEGJEK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 May 2021 05:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbhEGJEH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 7 May 2021 05:04:07 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F57C061574;
        Fri,  7 May 2021 02:03:07 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id k25so7358675iob.6;
        Fri, 07 May 2021 02:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dqMtYs3mgKZBJIYGjXyIrPQVg3i2sEc37FkEnl6VjIk=;
        b=I02GMEWMh0/v+3egPoX61FW6zBC9AujHlVkfQyNT8KFbOEpdfz+C1f776tmZV+6e/X
         G12SBJ8kEEnMEk3f/TXqY+NCWOpx3kHTPPxB//qo2poJ+hrVlUPKYYaSCxM7HRtJv2Vw
         wKK9eayqETmG5KfKpbQdlAe4PQcbkEOPFKZKJzsSK0JJrzcvCXezLMAIY/+HXRQFmiKG
         /DBSUxowgHNGRNfKxRyJaa/Qqt4P7BdcxhlywFbqPAbyxD06M5g7U83zEfAbydzk//pD
         mFLGtQoQMBLRYaK6THw1qSLtJnLcM/AiQMtmEMFYIG5tm6KXujdvuv1crtEPOS6dCRx3
         J48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dqMtYs3mgKZBJIYGjXyIrPQVg3i2sEc37FkEnl6VjIk=;
        b=ig8nn2Uk8Ag97k3c/ilFOJnVfop+0cZarKvpf4oeovrVU95oe/Z2NwPhHlTn6cMPcV
         /wOYXiVwdQFpwzrFrGwD2rYKG9UDQw9DjgC1p+R2Vt5wE4J75wZAevDSxy6jkYWZKDpY
         WJeG/hYy+VzoumU9CCzpePfJ850GmM2t7YxFz9UYbNwTIkoMH7xGA9SXk2V1tAxbPbxF
         SmQUkCYNTncSYFqaiJBMag3Wk8CjIkKnz7kjDlyg4YT0T2GnZ6VcHwRUm9kpRfiYqlAT
         JM1byrMwWWhazQf74AD2Hbkv9MYyMZS5W/rlCOI1LAy7u7aH9lWhgWhmGGmFHc9aVHJL
         pUwQ==
X-Gm-Message-State: AOAM532Zj01ibhL50dIP8xZ6y0TcrW3019kUdfoBwsETH5/H4v5ofV3j
        IlVw/PK1pK+gfdB+DLUbRZMCeFUZ4K7j/tw6MxGivfSLLyc06w==
X-Google-Smtp-Source: ABdhPJxfUUFYf6PkzO49y/BKjaEN7uUxaFVLLsSPql/S73UISdBC4P68weO9gpK1EmeHWoYxOTqh7OFRyMmny/a5IKc=
X-Received: by 2002:a6b:d30c:: with SMTP id s12mr6988053iob.191.1620378187198;
 Fri, 07 May 2021 02:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210506143312.22281-1-idryomov@gmail.com> <CAHk-=wgjQgUYrMD_tTm5M1BqeN5Z7h_z5EkU65RXAnEevsTDLA@mail.gmail.com>
In-Reply-To: <CAHk-=wgjQgUYrMD_tTm5M1BqeN5Z7h_z5EkU65RXAnEevsTDLA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 7 May 2021 11:03:14 +0200
Message-ID: <CAOi1vP-iB1vjemw_WsRFEycdm94B8Trg73sPWAxUt+1ZAzPkzg@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 5.13-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 6, 2021 at 7:51 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, May 6, 2021 at 7:33 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > There is a merge conflict in fs/ceph/dir.c because Jeff's inode
> > type handling patch went through the vfs tree together with Al's
> > inode_wrong_type() helper.  for-linus-merged has the resolution.
>
> Actually, the linux-next resolution looks wrong - or at least
> unnecessary - to me.
>
> The conversion to d_splice_alias() means that the IS_ERR() test is now
> pointless, because d_splice_alias() handles an error-pointer natively,
> and just returns the error back with ERR_CAST().
>
> So the proper resolution seems to be to just drop the IS_ERR().
>
> Adding Jeff and Al just as a heads-up.

I did it mechanically and then cross-checked against Jeff's patch:

https://lore.kernel.org/ceph-devel/20210316203919.102346-1-jlayton@kernel.org/T/#u

I guess neither Jeff nor I noticed that ERR_CAST() is redundant
because previously ceph_get_snapdir() didn't have any error handling
and the explicit check (which Jeff added in another patch that went
through Al's tree) felt "precious".

Thanks,

                Ilya
