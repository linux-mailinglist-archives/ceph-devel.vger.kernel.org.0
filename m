Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37521D945D
	for <lists+ceph-devel@lfdr.de>; Tue, 19 May 2020 12:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgESKa0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 May 2020 06:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgESKaZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 May 2020 06:30:25 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BCCC061A0C
        for <ceph-devel@vger.kernel.org>; Tue, 19 May 2020 03:30:21 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id j145so11861247oib.5
        for <ceph-devel@vger.kernel.org>; Tue, 19 May 2020 03:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZyF3Wxa279pogrcfhIXgZMtZRLjP2YRVG26KkBObHpQ=;
        b=UZ6nFcu6o8Ar//izz+FRXvhLKFLEeyq2hYFRhwwBefhWMxwMW7d8hU/ykePm9Je83e
         zuh3VcL+K/0qXnJeCbMUU+IR4XExqoYqNgnHMQSNzkU2EhOKKeZIMuVk984J30pj+Rx/
         imQWoyYxFcRcbKFj1bYhdXKMyEVadcgvXomKGgDiaPRTtxo8HsmqG1U9vIK71aDutd+0
         iorGIwgnJIcTvdVRO32jIZTkmCItrML7FRAC+z1qNw0TA4Uvvwdxn0Gx6seCa4LaCZ5q
         i7BHc0uMnorX/apjTLLgu9lAOsmS16ojj+hgUO0O55hqxSuGTy5bE4HEPilBw9Mw9kpi
         SemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZyF3Wxa279pogrcfhIXgZMtZRLjP2YRVG26KkBObHpQ=;
        b=HOOLaqdkwJEvEr7uyQZ2+scjl6yX2njGv4mZrfo0jN3luEgWrWQh0zHZTtVdfx8B+K
         VaPwb/9JJ6Ztg571tWlhswtbBdC5n2hoi44LMGGXJehxQol1dRUEnZsEeCCWFTrgm8dY
         cCLuIP/Higo5CqH3Vqsqi3pquzVBeV0zvzyFaFkZhm2UrqCaXRBpaxlm6RNFc4Dt9UI2
         Vtr0ShEQqFeDr9RONQGYPIr15j6AdUGtuOsgOwt/gQDOsbsNSuSk1vNTXn52kv6t095K
         y3o9l/tsBevx0lv3ESwFBaf9HqsZpbK3GeVTRdOaT0EFtpfoeVxW5b/hHRmw2W4tNkxa
         eTPQ==
X-Gm-Message-State: AOAM532PSnTD1DLKUPzR9HPMp+AErFOmrlMzYhVVuHjsyhU0giZkbD8Q
        GvHGWgo2W/SyvHQYCONgIz3pllsqeZLKBIc5aJ4=
X-Google-Smtp-Source: ABdhPJwu5gJmeacK0OOf1WY5wLM5wLSf/JO3liHL7w2ShoO4uBwyePU2fkYlwAjmGXqz+MlLNCuZ/qYl91Zu4uGHjps=
X-Received: by 2002:aca:1c1a:: with SMTP id c26mr464473oic.147.1589884220731;
 Tue, 19 May 2020 03:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fug_Y4y8wYe-vG=itf+0BmYFPfDm-ch7DTobtkipQz-yw@mail.gmail.com>
 <CAOi1vP-uF1_0R=5LApR=rdTXSzDWJq3LzuOYPrPmC_TPL909qA@mail.gmail.com>
In-Reply-To: <CAOi1vP-uF1_0R=5LApR=rdTXSzDWJq3LzuOYPrPmC_TPL909qA@mail.gmail.com>
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Tue, 19 May 2020 18:30:08 +0800
Message-ID: <CAKQB+ftbtXv0ET6OmUMsqKUoz5sRHQA35EprTY82_GC34b10XA@mail.gmail.com>
Subject: Re: [PATCH] libceph: add ignore cache/overlay flag if got redirect reply
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 19 May 2020 at 17:14, Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Mon, May 18, 2020 at 10:03 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> >
> > osd client should ignore cache/overlay flag if got redirect reply.
> > Otherwise, the client hangs when the cache tier is in forward mode.
> >
> > Similar issues:
> >    https://tracker.ceph.com/issues/23296
> >    https://tracker.ceph.com/issues/36406
> >
> > Signed-off-by: Jerry Lee <leisurelysw24@gmail.com>
> > ---
> >  net/ceph/osd_client.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index 998e26b..1d4973f 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -3649,7 +3649,9 @@ static void handle_reply(struct ceph_osd *osd,
> > struct ceph_msg *msg)
> >                  * supported.
> >                  */
> >                 req->r_t.target_oloc.pool = m.redirect.oloc.pool;
> > -               req->r_flags |= CEPH_OSD_FLAG_REDIRECTED;
> > +               req->r_flags |= CEPH_OSD_FLAG_REDIRECTED |
> > +                               CEPH_OSD_FLAG_IGNORE_OVERLAY |
> > +                               CEPH_OSD_FLAG_IGNORE_CACHE;
> >                 req->r_tid = 0;
> >                 __submit_request(req, false);
> >                 goto out_unlock_osdc;
>
> Hi Jerry,
>
> Looks good (although the patch was whitespace damaged).  I've fixed
> it up, but check out Documentation/process/email-clients.rst.
Thanks for sharing the doc!
>
> Also, out of curiosity, are you actually using the forward cache mode?
No, we accidentally found the issue when removing a writeback cache.
The kernel client got blocked when the cache mode switched from
writeback to forward and waited for the cache pool to be flushed.

BTW, a warning (Error EPERM: 'forward' is not a well-supported cache
mode and may corrupt your data.) is shown when the cache mode is
changed to forward mode.  Does it mean that the data integrity and IO
ordering cannot be ensured in this mode?

Thanks!

- Jerry
>
> Thanks,
>
>                 Ilya
