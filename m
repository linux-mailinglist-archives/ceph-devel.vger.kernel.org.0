Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCD327C2FB
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 12:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgI2K6r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 06:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgI2K6r (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Sep 2020 06:58:47 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B15BC061755
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 03:58:46 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id o9so4369759ils.9
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 03:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ggiYrtfDxSDd09DJUSpgLyYpiVQbwdPHmK8mNDnhMnU=;
        b=jsjTcyoHDHh4sGAQ+ABFy9OCUGUCGyiyctoK2ABB2anAWUVtLpqbhdCujJdeIpCtSu
         D72uO7lGlKDSMtviu4Oy9dajFGvQR29cwxGbkDLzN6GwIfDfKIhOg3p2/i1p8wyvzBYN
         i7qQ/Xs+qYob2uLrJtSxCqmYwZ8o0ENaWbyjJDj+56W35tbXRPVfEBxeHJqTA0JRI9aI
         Mg2MC6USN4ucouiSwwiw0Rztk/NinjnvyrxsQc5BZc6+mkiBUQIwn8Tysv+/maCEfCBW
         mhEuGo2oDH4+8aDaAL9IAtriyblxB7r3bVL+GjJ97CTRIuDm/PTW6tcuDxs0iIxI4Y1c
         iJ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ggiYrtfDxSDd09DJUSpgLyYpiVQbwdPHmK8mNDnhMnU=;
        b=Whlx+i5tt8bVbYU/cRDFTUqaJfuoI9c1wuni+TcM7pO+nqLfC0+q33R6NB++SY/nZl
         tS/X7D6oKOY/4zJGOYX4T4jKuWm4J5YgT4+P4hLskY1dIybNUCsS3L0k6YnLkmd93VEf
         +qYtSRS7qNlaRABDiDzBBR5tVpvc7IZEcj7CnNUsYbYamGssMv4eZA74HqFElqIohiZY
         WmVcLYRUFWZSTwLTVIctNDWiSbX33efPEcOsa37KOD0k2jRSh27x+zehjFfPxy3F1sYF
         02Su/KIrj6M0mZYOXpPVFrEvP3P79U/YgWnvX2opbylf6zvZjPhFmqqePI778nCVeh+G
         vGUw==
X-Gm-Message-State: AOAM533BtOOJjYuhT/f8OAvTlSEt6brOdtpkX+ffQQ4qd9Y3ecPwu3EZ
        cXR8YyA/fd4Vs2YyTgZzT2GGnTqt7N/+xLtT2CI=
X-Google-Smtp-Source: ABdhPJygI00er6mgQsyd5Kw9TJ/13UID1g2qkYfT44MlfrGpMpOuuePN0oG3sqjsHAXCUouJQqdYRg0bo5S3Yz/5oYs=
X-Received: by 2002:a05:6e02:5cf:: with SMTP id l15mr2398026ils.281.1601377125510;
 Tue, 29 Sep 2020 03:58:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200925140851.320673-1-jlayton@kernel.org> <CAAM7YAmJfNCbt4ON5c44FFVYOUhXu0ipK858aLJK22ZX2E-FdA@mail.gmail.com>
 <CAOi1vP9Nz2Art=rq06qBuU3DvKzZs+RR7pf+qsGxYZkrbSB-1Q@mail.gmail.com> <CAAM7YA=bo-pdnLuxFAyChtZCoP6VZ3oUJEX_+Sn5r6i6bO_+8Q@mail.gmail.com>
In-Reply-To: <CAAM7YA=bo-pdnLuxFAyChtZCoP6VZ3oUJEX_+Sn5r6i6bO_+8Q@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 29 Sep 2020 12:58:34 +0200
Message-ID: <CAOi1vP_E9he3RaTHAZ3qeXGe1xgcSkEXdrCYOY7rjab4-vr=6w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] ceph: fix spurious recover_session=clean errors
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 29, 2020 at 12:44 PM Yan, Zheng <ukernel@gmail.com> wrote:
>
> On Tue, Sep 29, 2020 at 4:55 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > On Tue, Sep 29, 2020 at 10:28 AM Yan, Zheng <ukernel@gmail.com> wrote:
> > >
> > > On Fri, Sep 25, 2020 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > >
> > > > Ilya noticed that he would get spurious EACCES errors on calls done just
> > > > after blocklisting the client on mounts with recover_session=clean. The
> > > > session would get marked as REJECTED and that caused in-flight calls to
> > > > die with EACCES. This patchset seems to smooth over the problem, but I'm
> > > > not fully convinced it's the right approach.
> > > >
> > >
> > > the root is cause is that client does not recover session instantly
> > > after getting rejected by mds. Before session gets recovered, client
> > > continues to return error.
> >
> > Hi Zheng,
> >
> > I don't think it's about whether that happens instantly or not.
> > In the example from [1], the first "ls" would fail even if issued
> > minutes after the session reject message and the reconnect.  From
> > the user's POV it is well after the automatic recovery promised by
> > recover_session=clean.
> >
> > [1] https://tracker.ceph.com/issues/47385
>
> Reconnect should close all old session. It's likely because that
> client didn't detect it's blacklisted.

Sorry, I should have pasted dmesg there as well.  It _does_ detect
blacklisting -- notice that I wrote "after the session reject message
and the reconnect".

Thanks,

                Ilya
