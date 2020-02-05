Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B22615304A
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Feb 2020 13:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgBEMBk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 07:01:40 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:46419 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgBEMBk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Feb 2020 07:01:40 -0500
Received: by mail-il1-f194.google.com with SMTP id t17so1603616ilm.13;
        Wed, 05 Feb 2020 04:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UTlMr+bm39TdL62d31FlhsetqSonjyzAOVBT6mmPX9E=;
        b=q7h6Xidm3szguswdwiC1d+lQJWd50OhBN+XmvVhlJQOHNtrcWrsjF1QZ3HR/6laKre
         IwSUsSOuzxKqAOXEyRY0QiXbfVVgvVKACE1PrJduL49Ii0MUfzGzOBMd6rZdPdVUFLC7
         kLvQ9M5uMn2fEMixjw7uW3LfKW0obWkAE4CGw1uTUVEhexjvVZ3VUeZmo0P8YSnKgQg6
         BTvrbk/VkUk3GCwpCnnQYPPwsMl/zcOb9aNV007zZ+QAATOrLecO4nekDPtcd98c9VN1
         BUpcVuaOHA1jnwNdTwG8IYAAkSAjOHc7S4C/CTkGmCh599ZIpcDmktlvAqXYwPxrzeTH
         xH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UTlMr+bm39TdL62d31FlhsetqSonjyzAOVBT6mmPX9E=;
        b=Dd3y+mR9enfN2KsCHn+E1g35Q8jVzzccQ+9O+KQ0y959bh/vbH9fpq5V21OtOvzurk
         ej48q+9JQaOOTgPmrVdhC1XG3UIbV2S+s6gbK7KMc12U5sGUqlVHNXTJq7Hf7DjTVUoZ
         L0UAKRy91JsOV5oVHfhKCogWLBAlsU9Nl+8REQpUr/i1FRB9TAlWtPnqGlCoEU6RNl6e
         mlqAceNoWGSydAsKmbcg0HajaXSNks4A2VVuWrSGzbnanNoIeHZM5r8fO4h+OqxBWpCc
         z19rrgvdDanXF6dLKhTpS43NTLUHl+mJZm3iLivCxzEPPPPgNYg7Fq/f9n4liuW940Xq
         f7Zw==
X-Gm-Message-State: APjAAAUBEQb1VJ3SVG0KXD67ShCPuSIS1WYY6tsGK3sYTCf9qUySF/XM
        5pNlb7eJH7/e3PrddhvkeZcB6sLwVPfSK8edYSiSjBezHFc=
X-Google-Smtp-Source: APXvYqxOIHrGzwdzC5SFgayrk9B0L6R4dEMpS9n7Pc9xOcrGysbCxQxsjq0i/+ZfOULyZ8WsSJvBi9jN+4Q2fpI+vcI=
X-Received: by 2002:a92:3a8d:: with SMTP id i13mr4269257ilf.112.1580904098942;
 Wed, 05 Feb 2020 04:01:38 -0800 (PST)
MIME-Version: 1.0
References: <20200203165117.5701-1-lhenriques@suse.com> <20200203165117.5701-2-lhenriques@suse.com>
 <CAOi1vP8vXeY156baexdZY2FWK_F0jHfWkyNdZ90PA+7txG=Qsw@mail.gmail.com>
 <20200204151158.GA15992@suse.com> <CAOi1vP-LvJYwAALQ_69rDUaiXYWa-_NPboeZV5zZiw_cokNyfw@mail.gmail.com>
 <20200205110007.GA11836@suse.com>
In-Reply-To: <20200205110007.GA11836@suse.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 5 Feb 2020 13:01:52 +0100
Message-ID: <CAOi1vP-kLCY+Q2UwpqvJdfeEV6me=FneLhasQrj2nkcu_7tRew@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] ceph: parallelize all copy-from requests in copy_file_range
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 5, 2020 at 12:00 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> On Tue, Feb 04, 2020 at 07:06:36PM +0100, Ilya Dryomov wrote:
> > On Tue, Feb 4, 2020 at 4:11 PM Luis Henriques <lhenriques@suse.com> wrote:
> > >
> > > On Tue, Feb 04, 2020 at 11:56:57AM +0100, Ilya Dryomov wrote:
> > > ...
> > > > > @@ -2108,21 +2118,40 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > > >                         CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > > > >                         dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> > > > >                         CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> > > > > -               if (err) {
> > > > > -                       if (err == -EOPNOTSUPP) {
> > > > > -                               src_fsc->have_copy_from2 = false;
> > > > > -                               pr_notice("OSDs don't support 'copy-from2'; "
> > > > > -                                         "disabling copy_file_range\n");
> > > > > -                       }
> > > > > +               if (IS_ERR(req)) {
> > > > > +                       err = PTR_ERR(req);
> > > > >                         dout("ceph_osdc_copy_from returned %d\n", err);
> > > > > +
> > > > > +                       /* wait for all queued requests */
> > > > > +                       ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
> > > > > +                       ret += reqs_complete * object_size; /* Update copied bytes */
> > > >
> > > > Hi Luis,
> > > >
> > > > Looks like ret is still incremented unconditionally?  What happens
> > > > if there are three OSD requests on the list and the first fails but
> > > > the second and the third succeed?  As is, ceph_osdc_wait_requests()
> > > > will return an error with reqs_complete set to 2...
> > > >
> > > > >                         if (!ret)
> > > > >                                 ret = err;
> > > >
> > > > ... and we will return 8M instead of an error.
> > >
> > > Right, my assumption was that if a request fails, all subsequent requests
> > > would also fail.  This would allow ret to be updated with the number of
> > > successful requests (x object size), even if the OSDs replies were being
> > > delivered in a different order.  But from your comment I see that my
> > > assumption is incorrect.
> > >
> > > In that case, when shall ret be updated with the number of bytes already
> > > written?  Only after a successful call to ceph_osdc_wait_requests()?
> >
> > I mentioned this in the previous email: you probably want to change
> > ceph_osdc_wait_requests() so that the counter isn't incremented after
> > an error is encountered.
>
> Sure, I've seen that comment.  But it doesn't help either because it's not
> guaranteed that we'll receive the replies from the OSDs in the same order
> we've sent them.  Stopping the counter when we get an error doesn't
> provide us any reliable information (which means I can simply drop that
> counter).

The list is FIFO so even though replies may indeed arrive out of
order, ceph_osdc_wait_requests() will process them in order.  If you
stop counting as soon as an error is encountered, you know for sure
that requests 1 through $COUNTER were successful and can safely
multiply it by object size.

>
> > > I.e. only after each throttling cycle, when we don't have any requests
> > > pending completion?  In this case, I can simply drop the extra
> > > reqs_complete parameter to the ceph_osdc_wait_requests.
> > >
> > > In your example the right thing to do would be to simply return an error,
> > > I guess.  But then we're assuming that we're loosing space in the storage,
> > > as we may have created objects that won't be reachable anymore.
> >
> > Well, that is what I'm getting at -- this needs a lot more
> > consideration.  How errors are dealt with, how file metadata is
> > updated, when do we fall back to plain copy, etc.  Generating stray
> > objects is bad but way better than reporting that e.g. 0..12M were
> > copied when only 0..4M and 8M..12M were actually copied, leaving
> > the user one step away from data loss.  One option is to revert to
> > issuing copy-from requests serially when an error is encountered.
> > Another option is to fall back to plain copy on any error.  Or perhaps
> > we just don't bother with the complexity of parallel copy-from requests
> > at all...
>
> To be honest, I'm starting to lean towards this option.  Reverting to
> serializing requests or to plain copy on error will not necessarily
> prevent the stray objects:
>
>   - send a bunch of copy requests
>   - wait for them to complete
>      * 1 failed, the other 63 succeeded
>   - revert to serialized copies, repeating the previous 64 requests
>      * after a few copies, we get another failure (maybe on the same OSDs)
>        and abort, leaving behind some stray objects from the previous bulk
>        request

Yeah, doing it serially makes the accounting a lot easier.  If you
issue any OSD requests before updating the size, stray objects are
bound to happen -- that's why "how file metadata is updated" is one
of the important considerations.

Thanks,

                Ilya
