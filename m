Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5566382C
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Jul 2019 16:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfGIOuY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Jul 2019 10:50:24 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:38860 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfGIOuY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Jul 2019 10:50:24 -0400
Received: by mail-qt1-f182.google.com with SMTP id n11so21872385qtl.5
        for <ceph-devel@vger.kernel.org>; Tue, 09 Jul 2019 07:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bRFlBLcRuUEhBV2qDL2VsPPolE6dCWD3/lzTDMgYTCI=;
        b=fBPQyFyXPgnVYYqlnz30BHLzutbvWgx7wAJpB5GKdydOoBUkdMggiF+Dk+l1arWkoh
         tfqkqfaLjBI/qUncrIxThWm5BhIueWPa9NYlejpAcvtqH3cIc6Rlyw9IMQTej+9IWclf
         xpUm5tfTpk1fjri8WKyZ7lxXVVQaFtyA6DIvpFyeECf4uRrkd5HUyoXckURNO1jjIWrf
         /KOjfc0GoBrS7vGPodQRjsiTm0aw3xqHaUuxOIsEPfcJyPGFWYk9VkqyAzcwEApISaGk
         Dy8IG/6OUOa0K3S+YOoXERiHFu87MVi7iTNzmX20DHDmsTlsIeuSl/rwE5YFq1vA6BXz
         A7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bRFlBLcRuUEhBV2qDL2VsPPolE6dCWD3/lzTDMgYTCI=;
        b=gotqGESP5x5+iBUipzomlehZVEoMUfqtm01uvWsywQaU8zOV/NK+ILBgD8mgSfjLy+
         FBCE9vSKikFwKe3Bt37bprC6dv4pkWs8kilLyL/zrbAZv3+JO5XwaN67VkTtViM5N3x3
         D5r/1Arcs5SYf58wHTZSk6Rpqxl4IyagaIScabDmoY89LT5ES0yLyR8jEMb1neDmTdb8
         EN3O/yeHSvnaOwSSs8jyf9qlCdqA/kDAlQ4rUrDHfENttD6WFICfHPJAGRH45z6QQAST
         +LSHPQF8e6bz/KL8AIJljIbBEhQc3Bxo276E+60cKV4OxUvxgZgYlEs4VJ27IGfu5Fhd
         mELA==
X-Gm-Message-State: APjAAAVvZqV9z7ThD4xMi6F2jClQUjbxbxiW+nPR0MPU7Bfcu07DV3Ya
        A5rkCfNuBC1kEMifUxlutZBwouKLrq1lBF+lRhdUxuv8bIm+1A==
X-Google-Smtp-Source: APXvYqzl0u0rEgEFaeSCOUwZVXFjn5b6D5L9hWjyrMl3z40boEn2BUEeK0+ox47JUmgQKLahG/gBUIfeQNj3cgqlhOQ=
X-Received: by 2002:a0c:b0a8:: with SMTP id o37mr14849922qvc.76.1562683822926;
 Tue, 09 Jul 2019 07:50:22 -0700 (PDT)
MIME-Version: 1.0
References: <f93a412ecd6b17389622ac7d0ae9b225921e4163.camel@redhat.com>
 <CAAM7YA=DW5jYtWkz-gqZ_Eg8ko-sK8mChMGB7yOV=Xz8o=AhLQ@mail.gmail.com> <35a7c9dce30f557a3be756cfeb15c0e471ae80ce.camel@redhat.com>
In-Reply-To: <35a7c9dce30f557a3be756cfeb15c0e471ae80ce.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 9 Jul 2019 22:50:11 +0800
Message-ID: <CAAM7YA=Cug6x+2m+RVNjmEaJaMsTAufx__yZug5SeREQSfy2tA@mail.gmail.com>
Subject: Re: ceph_fsync race with reconnect?
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@newdream.net>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jul 9, 2019 at 6:13 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Tue, 2019-07-09 at 07:52 +0800, Yan, Zheng wrote:
> > On Tue, Jul 9, 2019 at 3:23 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > I've been working on a patchset to add inline write support to kcephfs,
> > > and have run across a potential race in fsync. I could use someone to
> > > sanity check me though since I don't have a great grasp of the MDS
> > > session handling:
> > >
> > > ceph_fsync() calls try_flush_caps() to flush the dirty metadata back to
> > > the MDS when Fw caps are flushed back.  try_flush_caps does this,
> > > however:
> > >
> > >                 if (cap->session->s_state < CEPH_MDS_SESSION_OPEN) {
> > >                         spin_unlock(&ci->i_ceph_lock);
> > >                         goto out;
> > >                 }
> > >
> >
> > enum {
> >         CEPH_MDS_SESSION_NEW = 1,
> >         CEPH_MDS_SESSION_OPENING = 2,
> >         CEPH_MDS_SESSION_OPEN = 3,
> >         CEPH_MDS_SESSION_HUNG = 4,
> >         CEPH_MDS_SESSION_RESTARTING = 5,
> >         CEPH_MDS_SESSION_RECONNECTING = 6,
> >         CEPH_MDS_SESSION_CLOSING = 7,
> >         CEPH_MDS_SESSION_REJECTED = 8,
> > };
> >
> > the value of reconnect state is larger than 2
> >
>
> Right, I get that. The big question is whether you can ever move from a
> higher state to something less than CEPH_MDS_SESSION_OPEN.
>

I guess it does not happen because closing session happens only when
umounting.

But there is a corner case in handle_cap_export(). It set inode's auth
cap to a place holder cap. the placeholder cap's session can be in
opening state.

> __do_request can do this:
>
>                 if (session->s_state == CEPH_MDS_SESSION_NEW ||
>                     session->s_state == CEPH_MDS_SESSION_CLOSING)
>                         __open_session(mdsc, session);
>
> ...and __open_session does this:
>
>         session->s_state = CEPH_MDS_SESSION_OPENING;
>
> ...so it sort of looks like you can go from CLOSING(7) to OPENING(2).
> That said, I don't have a great feel for the session state transitions,
> and don't know whether this is a real possibility.
>
> >
> > > ...at that point, try_flush_caps will return 0, and set *ptid to 0 on
> > > the way out. ceph_fsync won't see that Fw is still dirty at that point
> > > and won't wait, returning without flushing metadata.
> > >
> > > Am I missing something that prevents this? I can open a tracker bug for
> > > this if it is a problem, but I wanted to be sure it was a bug before I
> > > did so.
> > >
> > > Thanks,
> > > --
> > > Jeff Layton <jlayton@redhat.com>
> > >
>
> --
> Jeff Layton <jlayton@redhat.com>
>
