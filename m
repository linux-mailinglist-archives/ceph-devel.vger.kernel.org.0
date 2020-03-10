Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6981807DE
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 20:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbgCJTUt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 15:20:49 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39634 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgCJTUt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Mar 2020 15:20:49 -0400
Received: by mail-io1-f67.google.com with SMTP id f21so9822175iol.6
        for <ceph-devel@vger.kernel.org>; Tue, 10 Mar 2020 12:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EPEVdWVIQCrfCdA9qxDOZbybgdZs4oEgMJQyMAR4WJI=;
        b=JKQUKJbbTvcARek3ZH8cSe6+NbfEbGUGjkKoM1//RvZykjIkh8M7oOKU1rEhBXu6Wq
         xuKJyrsiTrpz1P5EmrSZkYeGAnE2nKRtVTpaGeXNKgDicGWakTUqf6gNWxhtzkL6J60H
         isdZQkQ+xDhzGe6RIVELMZn2pB9vJ6adMYZBQ1eQrZBuqOjM/X7SOil/xHoWLqIMzDZG
         sbnl3Bs4BM9etvKfP79FjX/kisDaWLD9MOG6gY7QRQyuS5w9EEJMYNlhyC+a5DG7XErP
         swC0YVFZova61Bpn4+xY+xtDN0diG7OEA9KwP8VKRuxm6V177ITTcv6EXUBYBfNOBM41
         Lsrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EPEVdWVIQCrfCdA9qxDOZbybgdZs4oEgMJQyMAR4WJI=;
        b=JKiOq01RVmrz6GttaMbeitE534zgsmKG7rHSMfjyKtmFre9klLtV/jHFxTsabf7lvr
         FtxvWPIiOgT3RScD9gylNTZXFtEuArOVNGukkWCRMkE/9A8I1YDsR4jqqxxv1UhYvSNK
         EYhLrJaoNt2TRaPVPyt7XqMwdykeZCro972bDizS+AAn+S0jIrebkDbcEgDv8kdn8waR
         DBHdjLN0suHEQ4A5GB8zuFZybmSmm8h/zLrnRHcpz3I0k/Lj9U8QsjgxfiSTn9UGl8xm
         EXIMaAedvhZL6ov6iLSS8fh4KJkQSUyq0PrFSMeuz7HxXnWDJrgUPYzIXvZozV2r4ybp
         uIhA==
X-Gm-Message-State: ANhLgQ0i3ynYZVTImi4YOTjVJXemZqbSV0GhtY1a3nkj/7xnBV8R7sak
        HpWkbJYEhs4Imd7FnuVqZ1200t3c2l+KoRBTvJQukaYZsYk=
X-Google-Smtp-Source: ADFU+vs9fbycL7a7Dcjbu7pF8DcaH/SHLdNuDUWYqBMldVtWFHhW+pGYFKcDhpGFbGAzg1AB+KWpHIl8ov8YDxjcPgw=
X-Received: by 2002:a02:b86:: with SMTP id 128mr7351628jad.39.1583868048427;
 Tue, 10 Mar 2020 12:20:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200310090924.49788-1-rpenyaev@suse.de> <CAOi1vP9chc5PZD8SpSKXWMec2jMgESQuoAqkwy5GpF61Qs2Uhg@mail.gmail.com>
 <9998629d1021eb8c2bd3a1bd5c2d87c8@suse.de> <CAOi1vP8S6xTpbNaeRHZ=pKOf4vbw03LxT5RbheDMSHidDPGr+w@mail.gmail.com>
 <5e1f57d6f17b43ea99052a082b584190@suse.de>
In-Reply-To: <5e1f57d6f17b43ea99052a082b584190@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Mar 2020 20:20:49 +0100
Message-ID: <CAOi1vP-Q3JyCPZJi99d3NA_uWhLn4f-_X7cy8jdRQcgniQ8XVw@mail.gmail.com>
Subject: Re: [PATCH 1/1] libceph: fix memory leak for messages allocated with CEPH_MSG_DATA_PAGES
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 10, 2020 at 1:44 PM Roman Penyaev <rpenyaev@suse.de> wrote:
>
> On 2020-03-10 11:40, Ilya Dryomov wrote:
>
> [skip]
>
> >> And seems if the ownership of the ->pages is transferred to
> >> the handle_watch_notify() and freed there, then it should be
> >> fixed by having release in one place: here or there.
> >
> > The problem is that at least at one point CEPH_MSG_DATA_PAGES needed
> > a reference count -- it couldn't be freed it in one place.  pagelists
> > are reference counted, but can't be easily swapped in, hence that TODO.
> >
> > Thanks for reminding me about this.  I'll take a look -- perhaps the
> > reference count is no longer required and we can get away with a simple
> > flag.
>
> To my shallow understanding handle_watch_notify() also has an error
> path which eventually does not free or take ownership of data->pages,
> e.g. callers of 'goto out_unlock_osdc'. Probably code relies on the
> fact, that sender knows what is doing and never sends ->data with
> wrong cookie or opcode, but looks very suspicious to me.
>
> Seems for this particular DATA_PAGES case it is possible just to
> take an ownership by zeroing out data->pages and data->length,
> which prevents double free, something as the following:
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index b68b376d8c2f..15ae6377c461 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -4440,6 +4440,8 @@ static void handle_watch_notify(struct
> ceph_osd_client *osdc,
>
> ceph_release_page_vector(data->pages,
>                                                 calc_pages_for(0,
> data->length));
>                                  }
> +                               data->pages = NULL;
> +                               data->length = 0;
>                          }
>                          lreq->notify_finish_error = return_code;
>
>
> and keeping the current patch with explicit call of
> ceph_release_page_vector from ceph_msg_data_destroy() from
> messenger.c.

Not quite -- that would break all of OSD client, which supplies its
own page vectors.

I'll send a patch in a few.

Thanks,

                Ilya
