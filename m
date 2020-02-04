Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF8515217B
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2020 21:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgBDUbJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Feb 2020 15:31:09 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26178 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727479AbgBDUbI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Feb 2020 15:31:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580848267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KVv5oTo9oIjF1EAA96mw7DyUWW4F6vEy3Btv0E6QdYM=;
        b=IFKJRQOmnXhs/mfrnXVHGMWUNKcF3op3MZpToa56fb4cNhnjKJ/+RkUnD6xQeK3ezzTRR9
        eCWqvJYiByUv2bZcQA9C4+gsW3VGpKq8AGaB+rSy9wT3fQcRyIKudq1TnouEoI99c45J6U
        yx6R0Pxsufu2EEplewtg+i5d/nuoXnA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-QAAxexl7MBy3VUgJp3TYww-1; Tue, 04 Feb 2020 15:31:05 -0500
X-MC-Unique: QAAxexl7MBy3VUgJp3TYww-1
Received: by mail-qt1-f199.google.com with SMTP id m8so13187560qta.20
        for <ceph-devel@vger.kernel.org>; Tue, 04 Feb 2020 12:31:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KVv5oTo9oIjF1EAA96mw7DyUWW4F6vEy3Btv0E6QdYM=;
        b=g05FW/JFeJsIs64b++t6Sflyiuc3TQPq94lAPX59XiqkfO4NDz1b5YLbnT6zEROM2W
         B1knG36VrneSbA9nP0+VM245ckSpgpKMtnsMiY2fHTnkJgOsmPURYUhR8hwYnzRcCMgg
         v8CfG38nHqv7pbdcsVw/50ATYGjija8mFNexZ7OhiW3RRviMzmy2Ur0gKbcXTeAjbA+i
         A6qjLzf2ta5IAld8nGPukQfqQ+J1KCgHVQx0skijwNcBD4E9TRgq+0ArTXqHpm0s7tDJ
         89FVNab0AcxgmQPLzVEKScyeQoyZyT4RZc3kynyzU+XeNMgfzZ36oxI4SYYqzj/4Sqka
         0bfg==
X-Gm-Message-State: APjAAAVysSYYU02ZvjcP1f/3XRP1eczCrwmoArF912zZOO9EC6HdWAmQ
        J1keX7qji9cxRnEe1vx+dP2bgg7nZWHVcwonQzkJK88KLt1TDPlDhHD9cEX0vM0km32DybCQZXn
        x+3dXNblVkEac49Onqh5tjEX7DJVKL31Em9Fo9A==
X-Received: by 2002:a05:620a:23a:: with SMTP id u26mr29669816qkm.426.1580848264352;
        Tue, 04 Feb 2020 12:31:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqwRxksKsgPeRoaIwgKhs25KNoWbC7UmYlOnua3AVcu2L/YcitSiejbJEaci+2OdDRxVlg9rlk1f/edhlYXrx5U=
X-Received: by 2002:a05:620a:23a:: with SMTP id u26mr29669751qkm.426.1580848263627;
 Tue, 04 Feb 2020 12:31:03 -0800 (PST)
MIME-Version: 1.0
References: <20200203165117.5701-1-lhenriques@suse.com> <20200203165117.5701-2-lhenriques@suse.com>
 <0ab59ba87c07ffec6a05b2ed39bc0c112bcf5863.camel@kernel.org>
 <20200204153050.GA18215@suse.com> <0834b616a1c13570bffdf598034f09695362eb00.camel@kernel.org>
In-Reply-To: <0834b616a1c13570bffdf598034f09695362eb00.camel@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 4 Feb 2020 12:30:52 -0800
Message-ID: <CAJ4mKGbED3qRRDJhGE5S3x25inWNJGCQC4JaKXYagSLBO+d7OA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] ceph: parallelize all copy-from requests in copy_file_range
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 4, 2020 at 11:42 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-02-04 at 15:30 +0000, Luis Henriques wrote:
> > On Tue, Feb 04, 2020 at 08:30:03AM -0500, Jeff Layton wrote:
> > > On Mon, 2020-02-03 at 16:51 +0000, Luis Henriques wrote:
> > > > Right now the copy_file_range syscall serializes all the OSDs 'copy-from'
> > > > operations, waiting for each request to complete before sending the next
> > > > one.  This patch modifies copy_file_range so that all the 'copy-from'
> > > > operations are sent in bulk and waits for its completion at the end.  This
> > > > will allow significant speed-ups, specially when sending requests for
> > > > different target OSDs.
> > > >
> > >
> > > Looks good overall. A few nits below:
> > >
> > > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > > ---
> > > >  fs/ceph/file.c                  | 45 +++++++++++++++++++++-----
> > > >  include/linux/ceph/osd_client.h |  6 +++-
> > > >  net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++--------
> > > >  3 files changed, 85 insertions(+), 22 deletions(-)
> > > >
> > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > index 1e6cdf2dfe90..b9d8ffafb8c5 100644
> > > > --- a/fs/ceph/file.c
> > > > +++ b/fs/ceph/file.c
> > > > @@ -1943,12 +1943,15 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > >   struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
> > > >   struct ceph_object_locator src_oloc, dst_oloc;
> > > >   struct ceph_object_id src_oid, dst_oid;
> > > > + struct ceph_osd_request *req;
> > > >   loff_t endoff = 0, size;
> > > >   ssize_t ret = -EIO;
> > > >   u64 src_objnum, dst_objnum, src_objoff, dst_objoff;
> > > >   u32 src_objlen, dst_objlen, object_size;
> > > >   int src_got = 0, dst_got = 0, err, dirty;
> > > > + unsigned int max_copies, copy_count, reqs_complete = 0;
> > > >   bool do_final_copy = false;
> > > > + LIST_HEAD(osd_reqs);
> > > >
> > > >   if (src_inode->i_sb != dst_inode->i_sb) {
> > > >           struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
> > > > @@ -2083,6 +2086,13 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > >                   goto out_caps;
> > > >   }
> > > >   object_size = src_ci->i_layout.object_size;
> > > > +
> > > > + /*
> > > > +  * Throttle the object copies: max_copies holds the number of allowed
> > > > +  * in-flight 'copy-from' requests before waiting for their completion
> > > > +  */
> > > > + max_copies = (src_fsc->mount_options->wsize / object_size) * 4;
> > >
> > > A note about why you chose to multiply by a factor of 4 here would be
> > > good. In another year or two, we won't remember.
> >
> > Sure, but to be honest I just picked an early suggestion from Ilya :-)
> > In practice it means that, by default, 64 will be the maximum requests
> > in-flight.  I tested this value, and it looked OK although in the (very
> > humble) test cluster I've used a value of 16 (i.e. dropping the factor of
> > 4) wasn't much worst.
> >
>
> What happens if you ramp it up to be even more greedy? Does that speed
> things up? It might be worth doing some experimentation with a tunable
> too?
>
> In any case though, we need to consider what the ideal default would be.
> I'm now wondering whether the wsize is the right thing to base this on.
> If you have a 1000 OSD cluster, then even 64 actually sounds a bit weak.
>
> I wonder whether it should it be calculated on the fly from some
> function of the number OSDs or PGs in the data pool? Maybe even
> something like:
>
>     (number of PGs) / 2
>
> ...assuming the copies go between 2 PGs. With a perfect distribution, you'd
> be able to keep all your OSDs busy that way and do the copy really quickly.

No, as I said before, let's not try and set this up so that a single
client can automatically saturate the cluster any more than we already
do with the normal readahead stuff. We're bad enough about throttling
and input limits without aggressively trying to hit them. :)
-Greg

>
> > > > + copy_count = max_copies;
> > > >   while (len >= object_size) {
> > > >           ceph_calc_file_object_mapping(&src_ci->i_layout, src_off,
> > > >                                         object_size, &src_objnum,
> > > > @@ -2097,7 +2107,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > >           ceph_oid_printf(&dst_oid, "%llx.%08llx",
> > > >                           dst_ci->i_vino.ino, dst_objnum);
> > > >           /* Do an object remote copy */
> > > > -         err = ceph_osdc_copy_from(
> > > > +         req = ceph_osdc_copy_from(
> > > >                   &src_fsc->client->osdc,
> > > >                   src_ci->i_vino.snap, 0,
> > > >                   &src_oid, &src_oloc,
> > > > @@ -2108,21 +2118,40 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > >                   CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > > >                   dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> > > >                   CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> > > > -         if (err) {
> > > > -                 if (err == -EOPNOTSUPP) {
> > > > -                         src_fsc->have_copy_from2 = false;
> > > > -                         pr_notice("OSDs don't support 'copy-from2'; "
> > > > -                                   "disabling copy_file_range\n");
> > > > -                 }
> > > > +         if (IS_ERR(req)) {
> > > > +                 err = PTR_ERR(req);
> > > >                   dout("ceph_osdc_copy_from returned %d\n", err);
> > > > +
> > > > +                 /* wait for all queued requests */
> > > > +                 ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
> > > > +                 ret += reqs_complete * object_size; /* Update copied bytes */
> > > >                   if (!ret)
> > > >                           ret = err;
> > > >                   goto out_caps;
> > > >           }
> > > > +         list_add(&req->r_private_item, &osd_reqs);
> > > >           len -= object_size;
> > > >           src_off += object_size;
> > > >           dst_off += object_size;
> > > > -         ret += object_size;
> > > > +         /*
> > > > +          * Wait requests if we've reached the maximum requests allowed
> > >
> > > "Wait for requests..."
> > >
> > > > +          * or if this was the last copy
> > > > +          */
> > > > +         if ((--copy_count == 0) || (len < object_size)) {
> > > > +                 err = ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
> > > > +                 ret += reqs_complete * object_size; /* Update copied bytes */
> > > > +                 if (err) {
> > > > +                         if (err == -EOPNOTSUPP) {
> > > > +                                 src_fsc->have_copy_from2 = false;
> > > > +                                 pr_notice("OSDs don't support 'copy-from2'; "
> > > > +                                           "disabling copy_file_range\n");
> > > > +                         }
> > > > +                         if (!ret)
> > > > +                                 ret = err;
> > > > +                         goto out_caps;
> > > > +                 }
> > > > +                 copy_count = max_copies;
> > > > +         }
> > > >   }
> > > >
> > > >   if (len)
> > > > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > > > index 5a62dbd3f4c2..0121767cd65e 100644
> > > > --- a/include/linux/ceph/osd_client.h
> > > > +++ b/include/linux/ceph/osd_client.h
> > > > @@ -496,6 +496,9 @@ extern int ceph_osdc_start_request(struct ceph_osd_client *osdc,
> > > >  extern void ceph_osdc_cancel_request(struct ceph_osd_request *req);
> > > >  extern int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
> > > >                             struct ceph_osd_request *req);
> > > > +extern int ceph_osdc_wait_requests(struct list_head *osd_reqs,
> > > > +                            unsigned int *reqs_complete);
> > > > +
> > > >  extern void ceph_osdc_sync(struct ceph_osd_client *osdc);
> > > >
> > > >  extern void ceph_osdc_flush_notifies(struct ceph_osd_client *osdc);
> > > > @@ -526,7 +529,8 @@ extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
> > > >                           struct timespec64 *mtime,
> > > >                           struct page **pages, int nr_pages);
> > > >
> > > > -int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> > > > +struct ceph_osd_request *ceph_osdc_copy_from(
> > > > +                 struct ceph_osd_client *osdc,
> > > >                   u64 src_snapid, u64 src_version,
> > > >                   struct ceph_object_id *src_oid,
> > > >                   struct ceph_object_locator *src_oloc,
> > > > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > > > index b68b376d8c2f..df9f342f860a 100644
> > > > --- a/net/ceph/osd_client.c
> > > > +++ b/net/ceph/osd_client.c
> > > > @@ -4531,6 +4531,35 @@ int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
> > > >  }
> > > >  EXPORT_SYMBOL(ceph_osdc_wait_request);
> > > >
> > > > +/*
> > > > + * wait for all requests to complete in list @osd_reqs, returning the number of
> > > > + * successful completions in @reqs_complete
> > > > + */
> > >
> > > Maybe consider just having it return a positive reqs_complete value or a
> > > negative error code, and drop the reqs_complete pointer argument? It'd
> > > also be good to note what this function returns.
> >
> > In my (flawed) design I wanted to know that there was an error in a
> > request but also how many successful requests.  But after the last review
> > from Ilya I'll probably need to revisit this anyway.
> >
>
> Sounds good.
>
> > > > +int ceph_osdc_wait_requests(struct list_head *osd_reqs,
> > > > +                     unsigned int *reqs_complete)
> > > > +{
> > > > + struct ceph_osd_request *req;
> > > > + int ret = 0, err;
> > > > + unsigned int counter = 0;
> > > > +
> > > > + while (!list_empty(osd_reqs)) {
> > > > +         req = list_first_entry(osd_reqs,
> > > > +                                struct ceph_osd_request,
> > > > +                                r_private_item);
> > > > +         list_del_init(&req->r_private_item);
> > > > +         err = ceph_osdc_wait_request(req->r_osdc, req);
> > >
> > > ceph_osdc_wait_request calls wait_request_timeout, which uses a killable
> > > sleep. That's better than uninterruptible sleep, but maybe it'd be good
> > > to use an interruptible sleep here instead? Having to send fatal signals
> > > when things are stuck kind of sucks.
> >
> > Good point.  It looks like Zheng changed this to a killable sleep in
> > commit 0e76abf21e76 ("libceph: make ceph_osdc_wait_request()
> > uninterruptible").  I guess you're suggesting to add a new function
> > (wait_request_uninterruptible_timeout) that would be used only here,
> > right?
> >
>
> Yes, basically. We're not dealing with writeback in this function, so
> I'm not so worried about things getting interrupted. If the user wants
> to hit ^c here I don't see any reason to wait.
>
> --
> Jeff Layton <jlayton@kernel.org>
>

