Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF02E98BB7
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Aug 2019 08:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfHVGwp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Aug 2019 02:52:45 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34166 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfHVGwp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 22 Aug 2019 02:52:45 -0400
Received: by mail-oi1-f194.google.com with SMTP id g128so3604378oib.1
        for <ceph-devel@vger.kernel.org>; Wed, 21 Aug 2019 23:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M/HV/Oo+tfvII/PK7kisKFDEdfNuyoEpebIIwYhDzgw=;
        b=ZeNS+J/s8ijmvCYCoSWFq2bKOitbyLMbygUeFAHnAwL8IW+p6zPsCLmY6e1zWLeVEK
         5BvLmS9LMeq3GUIaryU+kQSiuwPMtjlKktgRNxww//C26Sim9httuwIV+BoRS1VlMSYC
         Eet8a5xseoRPq/RBrdOncYVPLpSp9tdXDEjwdpegyHKocs5vJchmR5UF5Amczc6gxsDF
         wrR/YG1GYVd4Mj3GbQT6sGOh17d9PDlJlI60fifs4svWLCvhS8S8M6zxHVpdACBfFd7p
         kFm5TMYl24vNfMoyCyb2+YO5NgCHzx/EEY1Je6KB5AL3bvuaPO86dBlKFOb7QHp3s2vl
         gVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M/HV/Oo+tfvII/PK7kisKFDEdfNuyoEpebIIwYhDzgw=;
        b=IRuWe0tLhOlxU44KG91EdDTFgHdUcquYTDYgmA8cbukrTRRESV2pqt+4NQSQ3P09pJ
         Sy6C0/Q1XWmtooPvsrMtuHOU1KgVyvUwfdihWkx5X6Nh6VE61+izwGEUFox7LrlV6COm
         4Vr8Z/azLjyV/LfYQUTWXhnLXArClUXPUP9STg7QQwJEqiF63fqS5R/rePzmAr2Ac7BL
         K006Zmsp/zN3bZyAb5JZErLgHdpsmG0ZIC1zYy+kS2pcxjULT4xCpYkd8fFRB6+LTFl3
         ePAt0qGMrRpJd0NGOoL5o7fYDhbdRkr5YcMvdxTq9XMEN1Y7yGiUoV6i29QHh5xFM0hx
         fZaw==
X-Gm-Message-State: APjAAAVS7XoSikb5xZA5s2/A785ex51lc/VmMWldjqRxB83g1qyow5/W
        rZaeVuf1Na38vTsR5pJjgR48untqvYbfnNHzdQw=
X-Google-Smtp-Source: APXvYqyx8EGdG1Wc5bcKL1APR8LAFnm8NGSNO9GhGSS8A4oHQ2sSHbEs+vutnjxDQ0shSK8d431hJCMszz5YRhemTtI=
X-Received: by 2002:aca:bfd4:: with SMTP id p203mr2718195oif.95.1566456763975;
 Wed, 21 Aug 2019 23:52:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190821120724.23614-1-idryomov@gmail.com> <440be5fd413175262626143db50d9489806986f1.camel@kernel.org>
In-Reply-To: <440be5fd413175262626143db50d9489806986f1.camel@kernel.org>
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Thu, 22 Aug 2019 14:52:29 +0800
Message-ID: <CAKQB+ftFZAs7tesMQ_BgYerGWrPZYoOwJNBES4Vhkd7DzisNtQ@mail.gmail.com>
Subject: Re: [PATCH] libceph: fix PG split vs OSD (re)connect race
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

With this patch, the issue isn't encountered in my environment (more
than 20 runs of tests).

Tested-by: Jerry Lee <leisurelysw24@gmail.com>

Thanks!

On Wed, 21 Aug 2019 at 22:56, Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2019-08-21 at 14:07 +0200, Ilya Dryomov wrote:
> > We can't rely on ->peer_features in calc_target() because it may be
> > called both when the OSD session is established and open and when it's
> > not.  ->peer_features is not valid unless the OSD session is open.  If
> > this happens on a PG split (pg_num increase), that could mean we don't
> > resend a request that should have been resent, hanging the client
> > indefinitely.
> >
> > In userspace this was fixed by looking at require_osd_release and
> > get_xinfo[osd].features fields of the osdmap.  However these fields
> > belong to the OSD section of the osdmap, which the kernel doesn't
> > decode (only the client section is decoded).
> >
> > Instead, let's drop this feature check.  It effectively checks for
> > luminous, so only pre-luminous OSDs would be affected in that on a PG
> > split the kernel might resend a request that should not have been
> > resent.  Duplicates can occur in other scenarios, so both sides should
> > already be prepared for them: see dup/replay logic on the OSD side and
> > retry_attempt check on the client side.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 7de030d6b10a ("libceph: resend on PG splits if OSD has RESEND_ON_SPLIT")
> > Reported-by: Jerry Lee <leisurelysw24@gmail.com>
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  net/ceph/osd_client.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index fed6b0334609..4e78d1ddd441 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -1514,7 +1514,7 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
> >       struct ceph_osds up, acting;
> >       bool force_resend = false;
> >       bool unpaused = false;
> > -     bool legacy_change;
> > +     bool legacy_change = false;
> >       bool split = false;
> >       bool sort_bitwise = ceph_osdmap_flag(osdc, CEPH_OSDMAP_SORTBITWISE);
> >       bool recovery_deletes = ceph_osdmap_flag(osdc,
> > @@ -1602,15 +1602,14 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
> >               t->osd = acting.primary;
> >       }
> >
> > -     if (unpaused || legacy_change || force_resend ||
> > -         (split && con && CEPH_HAVE_FEATURE(con->peer_features,
> > -                                            RESEND_ON_SPLIT)))
> > +     if (unpaused || legacy_change || force_resend || split)
> >               ct_res = CALC_TARGET_NEED_RESEND;
> >       else
> >               ct_res = CALC_TARGET_NO_ACTION;
> >
> >  out:
> > -     dout("%s t %p -> ct_res %d osd %d\n", __func__, t, ct_res, t->osd);
> > +     dout("%s t %p -> %d%d%d%d ct_res %d osd%d\n", __func__, t, unpaused,
> > +          legacy_change, force_resend, split, ct_res, t->osd);
> >       return ct_res;
> >  }
> >
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>
