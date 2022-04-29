Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3EFA5140B9
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Apr 2022 04:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiD2C4x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 22:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiD2C4w (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 22:56:52 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3A4BF30C
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 19:53:36 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id j8so5965287pll.11
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 19:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tfATRh4KHZFfwO+ifNo4UiQSlu4OWijYsolA1g7VCyA=;
        b=LdFaBk40CrveSNqW/gHl3M8FrrDkkT9AE2d/f0s4CkEvbcYS2xEezbrb5qnTl5FOUn
         EzQ9A2ZrJTOEBN5DwkkxinFh/F9IpYrYHSXi0gAELzRvdkHdHJbUcXXnctp2YqDzzpJ7
         a99mVMVnAm8zLm6CTDIcHax3DE2LHpzZBihhu4wxwHRzsS1Gmoup1GiQdkh8Rzpsnrx4
         xninEXWqeCKToiuFSMUuuYvcNvXBjXCu41kQ73I/KDyaE9Hpa9Mk4URqaiwa8ZCzHavd
         HpetotHDQ23DoSzqfdmBkODskRlOBsMFlbKJbQL052aK1GA6VhMOnYon+ubr1Yswqx/i
         9pBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tfATRh4KHZFfwO+ifNo4UiQSlu4OWijYsolA1g7VCyA=;
        b=crn4/hmZV7G5k7b0aiCwcF5B43n2IXASR+TnD8/LC/SDtWy/genO41auNOybM0z9E0
         NXvAWbVSNfJQbe6cv83VLZ5raMEUltC3inwjQ1LB3+sK86quu3zB1ZvazpWO4VOz79ku
         67AnPSZ1Pl1cjubFwO6GFU6E//pLigkOOhqKKR9wtcVGIj5zXuKZz0QAxNf7eqB6i2gb
         pZjeuA/pWw923yKlJNoyOMuBlU0BoeAxtkejFXQuBHBeeX9emiuu0gaOfvXoJLLL6Uro
         Jj6m1i+rKSpCFCT+td24ziy7kvHI7nnH7OsHWjJe+bUwehcTXROAP1XtQjdtX3S/Xqnk
         UX6A==
X-Gm-Message-State: AOAM532o7oq5RMzxB836zNQkJJycBcx3g7gGFUswlxagojqJO6YD+4VK
        H+CNoxWGMXaudWdP6CuVdAzO+gVanYl84GU63y4=
X-Google-Smtp-Source: ABdhPJz+pOh2h+kOnqNIYSrxrTwUXwtaqWIOB75GU3OIlfDcL+4XZANHzI8FeBUSYC8TnjAeIlcTNbclmYGpC5LKfDk=
X-Received: by 2002:a17:903:2495:b0:15a:a0f7:d779 with SMTP id
 p21-20020a170903249500b0015aa0f7d779mr35872376plw.163.1651200815919; Thu, 28
 Apr 2022 19:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220428121318.43125-1-xiubli@redhat.com> <CAAM7YAkVEEhhPtO7CJd6Cv6-2qc3EDHwAcU=zggxWSyKjm9aRA@mail.gmail.com>
In-Reply-To: <CAAM7YAkVEEhhPtO7CJd6Cv6-2qc3EDHwAcU=zggxWSyKjm9aRA@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 29 Apr 2022 10:53:24 +0800
Message-ID: <CAAM7YAkymccmwUqAYLiFy08LpyBhOJJys9kp4FReK_dvcj0YiQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't retain the caps if they're being revoked and
 not used
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Apr 29, 2022 at 10:46 AM Yan, Zheng <ukernel@gmail.com> wrote:
>
> On Thu, Apr 28, 2022 at 11:42 PM Xiubo Li <xiubli@redhat.com> wrote:
> >
> > For example if the Frwcb caps are being revoked, but only the Fr
> > caps is still being used then the kclient will skip releasing them
> > all. But in next turn if the Fr caps is ready to be released the
> > Fw caps maybe just being used again. So in corner case, such as
> > heavy load IOs, the revocation maybe stuck for a long time.
> >
> This does not make sense. If Frwcb are being revoked, writer can't get
> Fw again. Second, Frwcb are managed by single lock at mds side.
> Partial releasing caps does make lock state transition possible.
>
I mean, does not make lock state transition possible.

>
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/caps.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 0c0c8f5ae3b3..7eb5238941fc 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -1947,6 +1947,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >
> >         /* The ones we currently want to retain (may be adjusted below) */
> >         retain = file_wanted | used | CEPH_CAP_PIN;
> > +
> > +       /*
> > +        * Do not retain the capabilities if they are under revoking
> > +        * but not used, this could help speed up the revoking.
> > +        */
> > +       retain &= ~((revoking & retain) & ~used);
> > +
> >         if (!mdsc->stopping && inode->i_nlink > 0) {
> >                 if (file_wanted) {
> >                         retain |= CEPH_CAP_ANY;       /* be greedy */
> > --
> > 2.36.0.rc1
> >
