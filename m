Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED18D152031
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2020 19:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgBDSGX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Feb 2020 13:06:23 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:35026 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgBDSGX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Feb 2020 13:06:23 -0500
Received: by mail-il1-f193.google.com with SMTP id g12so16723842ild.2;
        Tue, 04 Feb 2020 10:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mc62ZSJ2FyEbetH4nweBkjrAs6Ck5WUQW5hhZvQRO50=;
        b=az91qY8K3YfCW0QGFi1FZ/pBdRYotv9Le+rXXqWUZQNr/OGWLGYifvJwzO97uDlxNF
         EHB6INZm/VLtEkppIfPqkV+vJxyUYszv1d5Aevlx+zUCD2vY3eGVxArvUTN19rdJUaEc
         CHL2j/uXpkPq183F50rozETD9JOHr27NNlbnmdb6+ZFnRb+RVDVr2ssZewHcaO8CKJGf
         lOPCjfrKyUrmT2cb/+lOG5eREU2aILHuKjjM+4VQVeh15UXRJg8xX7r4QmKPYtCE1E/t
         OhpQOzWbOXYq/fGb+BPpr6lViSL5aKf1Vwoy9NvsEiVXV3YuNlaHyU78vvOIvfnSYjgT
         iAkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mc62ZSJ2FyEbetH4nweBkjrAs6Ck5WUQW5hhZvQRO50=;
        b=KjDVjws+P3bwn3w+dn9Y75Gk8n+D4RVeTTrheLwEXXh4d3VZzadnl+B0BK+I/IlLzO
         wMWfPnz7PCiivh4oZXPMb2zAMeom4/mkOjXVEZ3goTeff+UcPfO6M8jLIEvd2GuqIdkl
         YD1aMPUkFcm+m308GS6kF7qXKrOseGNkNnRbvrpNNAdNyfR4C079lO+OnaTV4Oawufd6
         JhkDJHLjKi73yy6MPStjql9y2tVSpzMv5/unhrbv5809yXUxw+7AIHq30oj6v7HJb3p1
         Kea/IG2VMfXxBTK81kSeG2a0DFzKSHHOlywsAhLOjjNvwzStwFtTFA8wVBEruAg73ARp
         edSA==
X-Gm-Message-State: APjAAAXDSvcj5Oa4Du6Z3zU15PH5VThd+mfCnnQhNMvEpN94bZR5T4Sd
        5CyR27CE9q5SEmVzBmHR2hIF8laU4iC2sFO7JXA=
X-Google-Smtp-Source: APXvYqxKyl971a5Xqlv2EwzvWwPfaoP5Bparz3CeO839snzSqpxb29ZVRbO7MW2JMyg+DfmWnqO+CoAF5YT0aGoBJvw=
X-Received: by 2002:a92:b749:: with SMTP id c9mr21417293ilm.143.1580839582327;
 Tue, 04 Feb 2020 10:06:22 -0800 (PST)
MIME-Version: 1.0
References: <20200203165117.5701-1-lhenriques@suse.com> <20200203165117.5701-2-lhenriques@suse.com>
 <CAOi1vP8vXeY156baexdZY2FWK_F0jHfWkyNdZ90PA+7txG=Qsw@mail.gmail.com> <20200204151158.GA15992@suse.com>
In-Reply-To: <20200204151158.GA15992@suse.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 4 Feb 2020 19:06:36 +0100
Message-ID: <CAOi1vP-LvJYwAALQ_69rDUaiXYWa-_NPboeZV5zZiw_cokNyfw@mail.gmail.com>
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

On Tue, Feb 4, 2020 at 4:11 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> On Tue, Feb 04, 2020 at 11:56:57AM +0100, Ilya Dryomov wrote:
> ...
> > > @@ -2108,21 +2118,40 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >                         CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > >                         dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> > >                         CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> > > -               if (err) {
> > > -                       if (err == -EOPNOTSUPP) {
> > > -                               src_fsc->have_copy_from2 = false;
> > > -                               pr_notice("OSDs don't support 'copy-from2'; "
> > > -                                         "disabling copy_file_range\n");
> > > -                       }
> > > +               if (IS_ERR(req)) {
> > > +                       err = PTR_ERR(req);
> > >                         dout("ceph_osdc_copy_from returned %d\n", err);
> > > +
> > > +                       /* wait for all queued requests */
> > > +                       ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
> > > +                       ret += reqs_complete * object_size; /* Update copied bytes */
> >
> > Hi Luis,
> >
> > Looks like ret is still incremented unconditionally?  What happens
> > if there are three OSD requests on the list and the first fails but
> > the second and the third succeed?  As is, ceph_osdc_wait_requests()
> > will return an error with reqs_complete set to 2...
> >
> > >                         if (!ret)
> > >                                 ret = err;
> >
> > ... and we will return 8M instead of an error.
>
> Right, my assumption was that if a request fails, all subsequent requests
> would also fail.  This would allow ret to be updated with the number of
> successful requests (x object size), even if the OSDs replies were being
> delivered in a different order.  But from your comment I see that my
> assumption is incorrect.
>
> In that case, when shall ret be updated with the number of bytes already
> written?  Only after a successful call to ceph_osdc_wait_requests()?

I mentioned this in the previous email: you probably want to change
ceph_osdc_wait_requests() so that the counter isn't incremented after
an error is encountered.

> I.e. only after each throttling cycle, when we don't have any requests
> pending completion?  In this case, I can simply drop the extra
> reqs_complete parameter to the ceph_osdc_wait_requests.
>
> In your example the right thing to do would be to simply return an error,
> I guess.  But then we're assuming that we're loosing space in the storage,
> as we may have created objects that won't be reachable anymore.

Well, that is what I'm getting at -- this needs a lot more
consideration.  How errors are dealt with, how file metadata is
updated, when do we fall back to plain copy, etc.  Generating stray
objects is bad but way better than reporting that e.g. 0..12M were
copied when only 0..4M and 8M..12M were actually copied, leaving
the user one step away from data loss.  One option is to revert to
issuing copy-from requests serially when an error is encountered.
Another option is to fall back to plain copy on any error.  Or perhaps
we just don't bother with the complexity of parallel copy-from requests
at all...

Of course, no matter what we do for parallel copy-from requests, the
existing short copy bug needs to be fixed separately.

>
> >
> > >                         goto out_caps;
> > >                 }
> > > +               list_add(&req->r_private_item, &osd_reqs);
> > >                 len -= object_size;
> > >                 src_off += object_size;
> > >                 dst_off += object_size;
> > > -               ret += object_size;
> > > +               /*
> > > +                * Wait requests if we've reached the maximum requests allowed
> > > +                * or if this was the last copy
> > > +                */
> > > +               if ((--copy_count == 0) || (len < object_size)) {
> > > +                       err = ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
> > > +                       ret += reqs_complete * object_size; /* Update copied bytes */
> >
> > Same here.
> >
> > > +                       if (err) {
> > > +                               if (err == -EOPNOTSUPP) {
> > > +                                       src_fsc->have_copy_from2 = false;
> >
> > Since EOPNOTSUPP is special in that it triggers the fallback, it
> > should be returned even if something was copied.  Think about a
> > mixed cluster, where some OSDs support copy-from2 and some don't.
> > If the range is split between such OSDs, copy_file_range() will
> > always return short if the range happens to start on a new OSD.
>
> IMO, if we managed to copy some objects, we still need to return the
> number of bytes copied.  Because, since this return value will be less
> then the expected amount of bytes, the application will retry the
> operation.  And at that point, since we've set have_copy_from2 to 'false',
> the default VFS implementation will be used.

Ah, yeah, given have_copy_from2 guard, this particular corner case is
fine.

Thanks,

                Ilya
