Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9431BEE6B
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Apr 2020 04:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgD3CvJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Apr 2020 22:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726309AbgD3CvJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 22:51:09 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB5DC035494;
        Wed, 29 Apr 2020 19:51:08 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id l78so4330326qke.7;
        Wed, 29 Apr 2020 19:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gcb22CoM1BKj6UuzEDSUucJ6OH1JzdhT0xclshPmx0Q=;
        b=WcSieJrBHge5UFApclx0pHGgVRD8ofAyr5C3TErHchgTZvl6zKcYvzMQEFBYwWO7tf
         Z1poxpWIgm2vxZhZUzIUdHIQ62yg+n8wdrzUWn3AOv0UyEYQPzudoZIUiDUUSuikTKOC
         sWP9naXE1vams9sDCwW4imVLKgPjT/76a6zCpPnS/TqF8s53vuvMnWhOwH1QnhYBbJmo
         vZHoJ5HjpHvTeTsBRWpAVyKfKlU0qkdyR2wnEgKFzNoMlOrRiYnrY6zC8W34op5TgQZi
         nrFRWfm9UUDXhWzCS3qd4wFG0aJ5d7FNgQFym92SnhthDCSX0YdWbnb3zu7fVAK2MOeq
         KV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gcb22CoM1BKj6UuzEDSUucJ6OH1JzdhT0xclshPmx0Q=;
        b=SN/tRXNJVQytjiLuKJPLzFVxnrckB0EW6x8jpp2Bi/70nPCT9Pa9+FrSKEOM8OIqas
         EEoSr3HDQVxiux8U5mqdMt2PLRWVOSGXxy8f6/LUWr+O+WKFScbldKWNT2gE99WeqxGp
         hnHgMJnWecFCVhcMgXAyyXS9psNLAPMGfSPWsubzcqvYBeEDHh24XU1mqq0A2vfrjG3e
         yq9ygR1sz6WT5CSgdykpdZBsSAgqYd5pGSpsTMhRVei4Qnk4jTS3UdQd+g1LNxYrszMg
         7FklkvqN97/ddTB1hwJl6YEf+wZhbcK7NDK+1UFHpozAbHT0itRFxXaUyqXt8RvCruAg
         IL8w==
X-Gm-Message-State: AGi0PuYn8FrVZEnpgZ++lMUMmcqmngEKWhHruHKgF3EjlDf4i6majkcY
        3VU2f9szgqOjjbLXx1MR1zp0yhc4PCXyTc/BrbM=
X-Google-Smtp-Source: APiQypLWXPG9CeboheBCgGYAP4+yqKwc/KL3ZgrfZdgHy87JhcdGS9gN5OXL5bexOGYvqeV3VezNpi5MYjvElXb2rlI=
X-Received: by 2002:a37:414a:: with SMTP id o71mr1495469qka.141.1588215068093;
 Wed, 29 Apr 2020 19:51:08 -0700 (PDT)
MIME-Version: 1.0
References: <1588079622-423774-1-git-send-email-wubo40@huawei.com>
 <e89bd817c69422c85f1945041dd83fbe8d534805.camel@kernel.org> <6c99072a-f92b-b7e8-9aef-509d1a9ee985@huawei.com>
In-Reply-To: <6c99072a-f92b-b7e8-9aef-509d1a9ee985@huawei.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 30 Apr 2020 10:50:57 +0800
Message-ID: <CAAM7YA=OU2jJ9F_p1fAknaxZCDWMY7w9yiRE0z0uqxDNYPG5Mg@mail.gmail.com>
Subject: Re: [PATCH V2] fs/ceph:fix double unlock in handle_cap_export()
To:     Wu Bo <wubo40@huawei.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        liuzhiqiang26@huawei.com, linfeilong@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 29, 2020 at 8:49 AM Wu Bo <wubo40@huawei.com> wrote:
>
> On 2020/4/28 22:48, Jeff Layton wrote:
> > On Tue, 2020-04-28 at 21:13 +0800, Wu Bo wrote:
> >> if the ceph_mdsc_open_export_target_session() return fails,
> >> should add a lock to avoid twice unlocking.
> >> Because the lock will be released at the retry or out_unlock tag.
> >>
> >
> > The problem looks real, but...
> >
> >> --
> >> v1 -> v2:
> >> add spin_lock(&ci->i_ceph_lock) before goto out_unlock tag.
> >>
> >> Signed-off-by: Wu Bo <wubo40@huawei.com>
> >> ---
> >>   fs/ceph/caps.c | 27 +++++++++++++++------------
> >>   1 file changed, 15 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> >> index 185db76..414c0e2 100644
> >> --- a/fs/ceph/caps.c
> >> +++ b/fs/ceph/caps.c
> >> @@ -3731,22 +3731,25 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
> >>
> >>      /* open target session */
> >>      tsession = ceph_mdsc_open_export_target_session(mdsc, target);
> >> -    if (!IS_ERR(tsession)) {
> >> -            if (mds > target) {
> >> -                    mutex_lock(&session->s_mutex);
> >> -                    mutex_lock_nested(&tsession->s_mutex,
> >> -                                      SINGLE_DEPTH_NESTING);
> >> -            } else {
> >> -                    mutex_lock(&tsession->s_mutex);
> >> -                    mutex_lock_nested(&session->s_mutex,
> >> -                                      SINGLE_DEPTH_NESTING);
> >> -            }
> >> -            new_cap = ceph_get_cap(mdsc, NULL);
> >> -    } else {
> >> +    if (IS_ERR(tsession)) {
> >>              WARN_ON(1);
> >>              tsession = NULL;
> >>              target = -1;
> >> +            mutex_lock(&session->s_mutex);
> >> +            spin_lock(&ci->i_ceph_lock);
> >> +            goto out_unlock;
> >
> > Why did you make this case goto out_unlock instead of retrying as it did
> > before?
> >
>
> If the problem occurs, target = -1, and goto retry lable, you need to
> call __get_cap_for_mds() or even call __ceph_remove_cap(), and then jump
> to out_unlock lable. All I think is unnecessary, goto out_unlock instead
> of retrying directly.
>

__ceph_remove_cap() must be called even if opening target session
failed. I think adding a mutex_lock(&session->s_mutex) to the
IS_ERR(tsession) block should be enough.


> Thanks.
> Wu Bo
>
> >> +    }
> >> +
> >> +    if (mds > target) {
> >> +            mutex_lock(&session->s_mutex);
> >> +            mutex_lock_nested(&tsession->s_mutex,
> >> +                                    SINGLE_DEPTH_NESTING);
> >> +    } else {
> >> +            mutex_lock(&tsession->s_mutex);
> >> +            mutex_lock_nested(&session->s_mutex,
> >> +                                    SINGLE_DEPTH_NESTING);
> >>      }
> >> +    new_cap = ceph_get_cap(mdsc, NULL);
> >>      goto retry;
> >>
> >>   out_unlock:
> >
>
>
