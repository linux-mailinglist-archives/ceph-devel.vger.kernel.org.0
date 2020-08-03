Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AE9239D33
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Aug 2020 03:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgHCBZ0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 2 Aug 2020 21:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgHCBZZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 2 Aug 2020 21:25:25 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750DDC06174A;
        Sun,  2 Aug 2020 18:25:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d18so36993251ion.0;
        Sun, 02 Aug 2020 18:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wVSfXa5Ic9bcSsi1l7jOjJtzRsSr8hAuHXLBgAaKg4Y=;
        b=FQudipL07NEvLgz8nTn96jNAE2t+GE/6dbCq3s/St2AO8HkzFo758+5PskcCIwhlmM
         3PC9+v1r4/vJqZerGpylYkcUbYW9v0GJnOkEcAQDtSMDo12z5V57HoTB5A5CY6w5vBdS
         XaqFVGkz3P1hVAncm8M0WRH7nqRrY8KIJCfLyHixiDHkqgO2k+fJXybCUyAaD0QHcMCy
         SeoAuYY26g25MEXUyZm9Tj4ilZFWANQL+nQ/f6bTDLd4A4LGNdlbG9BOUUI4wtrDevDg
         2E/RPm27a+6fGTPUlKIzQ6UZKtVPCRWIlYoXOBnPCsGD1jhKD1nu8bsztzLeLdK1eJby
         51Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wVSfXa5Ic9bcSsi1l7jOjJtzRsSr8hAuHXLBgAaKg4Y=;
        b=J2vMwaM4vEhItqfVF6RibIhFYL2+MMLlr0bbYQuFgRlhy+Z3ka5/BqF1uPphAaROzW
         t8tC2Rciqn1h2vOoxGunTfvuOL3pbQe3CBWUR0Ccqk0mI8nK8ELKSrhPeUmW4zgu9S2S
         R+hrvgGZ8RDzyphlpuoEgkarF9/sMFNjfK7z/JmbQ/+o7msVKTT6vDtHLSgVS2AK2Hwh
         +Nc8IhIz2wlUYm1+ReR4eocmHtP+aiwCbaB3c2SgeDPrTPYpuE4n5HtGbP9ueNAWEwub
         MZ0AxLmHyPuEELz0LA2mKnMIlRZwvTCwUv9hnkf9v0sDSOP1ctvfVjvzg54MI9X5HSu1
         yvvw==
X-Gm-Message-State: AOAM5326Uh0qDIbWYNu+o6X2WsYiL9VhbcPlZG4ZsEDKJVqVzuxeCKgD
        V8l5bzM+FiV00uH3eG5BKcTG9MvwkGAmZpcekF4=
X-Google-Smtp-Source: ABdhPJzCOzH478zKqYtpOI4VPAcZgDPybIoNUAzpu0NGPN6Yqg1S/KV8K5lvf4H8i53CRT7zzN2e5fIokX234lNTHUU=
X-Received: by 2002:a5d:93c5:: with SMTP id j5mr14700313ioo.161.1596417924507;
 Sun, 02 Aug 2020 18:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200731082513.11806-1-gmayyyha@gmail.com> <8e87954aa5d04dd25330afd68b396ef40ff53398.camel@kernel.org>
In-Reply-To: <8e87954aa5d04dd25330afd68b396ef40ff53398.camel@kernel.org>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Mon, 3 Aug 2020 09:25:13 +0800
Message-ID: <CAB9OAC2x-jTELNSqbmbC-x=VsGmUdHPJQL__vBC8K9PAwW14Mw@mail.gmail.com>
Subject: Re: [v2] ceph: use frag's MDS in either mode
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 31, 2020 at 7:57 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-07-31 at 16:25 +0800, Yanhu Cao wrote:
> > When doing some tests with multiple mds, there are many
> > mds forwarding requests between them and then the client request
> > is resent.
> >
> > If the request is a modification operation and the mode is set to USE_AUTH_MDS.
> > Auth mds should be selected to handle the request, and if auth mds for
> > frag is already set, it can be returned directly without the logic behind it.
> >
> > But the current logic doesn't return directly because the condition
> > 'mode == USE_AUTH_MDS', and sometimes frag's mds is not equal to
> > cap's session mds, which then causes the request to be resent.
> >
> > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > ---
> >  fs/ceph/mds_client.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index a50497142e59..b2255a9be7c0 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -1103,8 +1103,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
> >                                    frag.frag, mds);
> >                               if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=
> >                                   CEPH_MDS_STATE_ACTIVE) {
> > -                                     if (mode == USE_ANY_MDS &&
> > -                                         !ceph_mdsmap_is_laggy(mdsc->mdsmap,
> > +                                     if (!ceph_mdsmap_is_laggy(mdsc->mdsmap,
> >                                                                 mds))
> >                                               goto out;
> >                               }
>
>
> Much better! A good changelog is as important as the patch, esp in code
> like this that is quite non-obvious.
>
> Merged into testing branch. I did clean up the changelog a bit before I
> merged it. Please take a look when you have time and let me know if you
> think I got it wrong.
LGTM.

Thanks.
>
> Thanks!
> --
> Jeff Layton <jlayton@kernel.org>
>
