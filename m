Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CE312798E
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Dec 2019 11:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfLTKqN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Dec 2019 05:46:13 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:32904 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfLTKqN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 20 Dec 2019 05:46:13 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so8950308ioh.0
        for <ceph-devel@vger.kernel.org>; Fri, 20 Dec 2019 02:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0MMaxsTm8AAW2Qa8N37auBD/Ey+/IvPJXyvviQ/jrwA=;
        b=mPrUGvqOl8q6FDrh4uWr3pbjKKs+a3jJ7hOxpX8eh3/jWlrrP8LsZvwNeutYLi2TEQ
         qB1DrDxYVH2JHVW66QMx5Oxlp+mUe0fVLkdfIDrgU9zb9id37vlMtp8Tt9RVQ/tUzsdb
         8+fYjc1rdyyTmYPQcbOIlczP4fKXVoRm0UBDcqZ72MCnEGKxc0l5TQkKFthUzgUAiz7t
         oqUZk7FCNdEynleBQp3blYilxHXsH6Zy63idfWGOSGJM0w2urgezuw15pX7jO/kVWroM
         2u2FakCuuo4NOLIhJdvN4djZkZ2a8jBsCI5gIUd7Bff2gXOTknaFC1GIDpW4luzAACoa
         zfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0MMaxsTm8AAW2Qa8N37auBD/Ey+/IvPJXyvviQ/jrwA=;
        b=s/xwml6GJqbCAjY8LDfhzfs28lth8wBbpPccIKOrvGO4SaOBOGP6U7+DYpegYXlQYX
         xxh67T8CVpecLVIz3pYumtY68R40R6X22bB/Vb0iGkln0dx6Z/Suwoh/tcm6Mi9srybp
         0a6GwNxAJ2bgxXEr72CZrBw2gP5LAJyluL/miECJ/5btqw2nKSphzXjs64yPlKfk2w8W
         2tfiDk+K+6XgBg2FU0n+BUXud4+6LtCg9KCdMli1/NgKkzMeY1spkX4nDCNhBKONL7+I
         MWoMNy3fy10cc1O55+IItPo4YII6GNhtYFKW/ZVWj9Nmo5ucxIpwysICA5k+8JBmN0t0
         UkFw==
X-Gm-Message-State: APjAAAW1HnnZzecpd91KsnCgrj/suuCaFHhaQtK8fIDQYkvusAhNV1+N
        X8jX++CrNhNNi9TxxKEo9XuX4sjjKspGEhYeMxY=
X-Google-Smtp-Source: APXvYqxkiLdtxPQb46Yp771KW303Qz9TugQuB9x8Hjsd7FUidcWfj7POMUVnQ6TDSItq3BxV0tON6INewvbSCTngHsk=
X-Received: by 2002:a05:6602:114:: with SMTP id s20mr9777436iot.131.1576838772553;
 Fri, 20 Dec 2019 02:46:12 -0800 (PST)
MIME-Version: 1.0
References: <20191220004409.12793-1-xiubli@redhat.com> <CAOi1vP85em7ase08xywaOTfaxrsMq7Y9yeYcxcgKz8QH=oxOGQ@mail.gmail.com>
 <ca915587-290a-fb10-2fd6-8a5d5bbb4fc0@redhat.com>
In-Reply-To: <ca915587-290a-fb10-2fd6-8a5d5bbb4fc0@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 20 Dec 2019 11:46:07 +0100
Message-ID: <CAOi1vP-idYF2K-ENT2o6sJko-0b+EzbLF70ipqp3m65uT+pXYw@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: rename get_session and switch to use ceph_get_mds_session
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Dec 20, 2019 at 10:21 AM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2019/12/20 17:11, Ilya Dryomov wrote:
> > On Fri, Dec 20, 2019 at 1:44 AM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> Just in case the session's refcount reach 0 and is releasing, and
> >> if we get the session without checking it, we may encounter kernel
> >> crash.
> >>
> >> Rename get_session to ceph_get_mds_session and make it global.
> >>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>
> >> Changed in V3:
> >> - Clean all the local commit and pull it and rebased again, it is based
> >>    the following commit:
> >>
> >>    commit 3a1deab1d5c1bb693c268cc9b717c69554c3ca5e
> >>    Author: Xiubo Li <xiubli@redhat.com>
> >>    Date:   Wed Dec 4 06:57:39 2019 -0500
> >>
> >>        ceph: add possible_max_rank and make the code more readable
> > Hi Xiubo,
> >
> > The base is correct, but the patch still appears to have been
> > corrupted, either by your email client or somewhere in transit.
>
> Ah, I have no idea of this now, I was doing the following command to
> post it:
>
> # git send-email --smtp-server=... --to=...

Hrm, I've looked through my archives and the last non-mangled patch
I see from you is "[PATCH RFC] libceph: remove the useless monc check"
dated Oct 15.  If you are using the same send-email command as before
and haven't changed anything on your end, it's probably one of the
intermediate servers...

>
> And my git version is:
>
> # git --version
> git version 2.21.0
>
> I attached it or should I post it again ?

You attached the old version ;)  It's not mangled, but it doesn't
apply.

Jeff, are you getting Xiubo's patches intact?

Thanks,

                Ilya
