Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C401C151CFD
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2020 16:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgBDPLz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Feb 2020 10:11:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:44626 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727290AbgBDPLz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 4 Feb 2020 10:11:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 03028AAFD;
        Tue,  4 Feb 2020 15:11:51 +0000 (UTC)
Date:   Tue, 4 Feb 2020 15:11:58 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] ceph: parallelize all copy-from requests in
 copy_file_range
Message-ID: <20200204151158.GA15992@suse.com>
References: <20200203165117.5701-1-lhenriques@suse.com>
 <20200203165117.5701-2-lhenriques@suse.com>
 <CAOi1vP8vXeY156baexdZY2FWK_F0jHfWkyNdZ90PA+7txG=Qsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP8vXeY156baexdZY2FWK_F0jHfWkyNdZ90PA+7txG=Qsw@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 04, 2020 at 11:56:57AM +0100, Ilya Dryomov wrote:
...
> > @@ -2108,21 +2118,40 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >                         CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> >                         dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> >                         CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> > -               if (err) {
> > -                       if (err == -EOPNOTSUPP) {
> > -                               src_fsc->have_copy_from2 = false;
> > -                               pr_notice("OSDs don't support 'copy-from2'; "
> > -                                         "disabling copy_file_range\n");
> > -                       }
> > +               if (IS_ERR(req)) {
> > +                       err = PTR_ERR(req);
> >                         dout("ceph_osdc_copy_from returned %d\n", err);
> > +
> > +                       /* wait for all queued requests */
> > +                       ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
> > +                       ret += reqs_complete * object_size; /* Update copied bytes */
> 
> Hi Luis,
> 
> Looks like ret is still incremented unconditionally?  What happens
> if there are three OSD requests on the list and the first fails but
> the second and the third succeed?  As is, ceph_osdc_wait_requests()
> will return an error with reqs_complete set to 2...
> 
> >                         if (!ret)
> >                                 ret = err;
> 
> ... and we will return 8M instead of an error.

Right, my assumption was that if a request fails, all subsequent requests
would also fail.  This would allow ret to be updated with the number of
successful requests (x object size), even if the OSDs replies were being
delivered in a different order.  But from your comment I see that my
assumption is incorrect.

In that case, when shall ret be updated with the number of bytes already
written?  Only after a successful call to ceph_osdc_wait_requests()?
I.e. only after each throttling cycle, when we don't have any requests
pending completion?  In this case, I can simply drop the extra
reqs_complete parameter to the ceph_osdc_wait_requests.

In your example the right thing to do would be to simply return an error,
I guess.  But then we're assuming that we're loosing space in the storage,
as we may have created objects that won't be reachable anymore.

> 
> >                         goto out_caps;
> >                 }
> > +               list_add(&req->r_private_item, &osd_reqs);
> >                 len -= object_size;
> >                 src_off += object_size;
> >                 dst_off += object_size;
> > -               ret += object_size;
> > +               /*
> > +                * Wait requests if we've reached the maximum requests allowed
> > +                * or if this was the last copy
> > +                */
> > +               if ((--copy_count == 0) || (len < object_size)) {
> > +                       err = ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
> > +                       ret += reqs_complete * object_size; /* Update copied bytes */
> 
> Same here.
> 
> > +                       if (err) {
> > +                               if (err == -EOPNOTSUPP) {
> > +                                       src_fsc->have_copy_from2 = false;
> 
> Since EOPNOTSUPP is special in that it triggers the fallback, it
> should be returned even if something was copied.  Think about a
> mixed cluster, where some OSDs support copy-from2 and some don't.
> If the range is split between such OSDs, copy_file_range() will
> always return short if the range happens to start on a new OSD.

IMO, if we managed to copy some objects, we still need to return the
number of bytes copied.  Because, since this return value will be less
then the expected amount of bytes, the application will retry the
operation.  And at that point, since we've set have_copy_from2 to 'false',
the default VFS implementation will be used.

> 
> > +                                       pr_notice("OSDs don't support 'copy-from2'; "
> > +                                                 "disabling copy_file_range\n");
> 
> This line is over 80 characters but shouldn't be split because it
> is a grepable log message.  Also, this message was slightly tweaked
> in ceph-client.git, so this patch doesn't apply.

Ok.

> > +                               }
> > +                               if (!ret)
> > +                                       ret = err;
> > +                               goto out_caps;
> 
> I'm confused about out_caps.  Since a short copy is still copy which
> may change the size, update mtime and ctime times, etc why aren't we
> dirtying caps in these cases?

Hmm...  yeah, this does look like a bug already present in the code.

> > +                       }
> > +                       copy_count = max_copies;
> > +               }
> >         }
> >
> >         if (len)
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > index 5a62dbd3f4c2..0121767cd65e 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -496,6 +496,9 @@ extern int ceph_osdc_start_request(struct ceph_osd_client *osdc,
> >  extern void ceph_osdc_cancel_request(struct ceph_osd_request *req);
> >  extern int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
> >                                   struct ceph_osd_request *req);
> > +extern int ceph_osdc_wait_requests(struct list_head *osd_reqs,
> > +                                  unsigned int *reqs_complete);
> > +
> >  extern void ceph_osdc_sync(struct ceph_osd_client *osdc);
> >
> >  extern void ceph_osdc_flush_notifies(struct ceph_osd_client *osdc);
> > @@ -526,7 +529,8 @@ extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
> >                                 struct timespec64 *mtime,
> >                                 struct page **pages, int nr_pages);
> >
> > -int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> > +struct ceph_osd_request *ceph_osdc_copy_from(
> > +                       struct ceph_osd_client *osdc,
> >                         u64 src_snapid, u64 src_version,
> >                         struct ceph_object_id *src_oid,
> >                         struct ceph_object_locator *src_oloc,
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index b68b376d8c2f..df9f342f860a 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -4531,6 +4531,35 @@ int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
> >  }
> >  EXPORT_SYMBOL(ceph_osdc_wait_request);
> >
> > +/*
> > + * wait for all requests to complete in list @osd_reqs, returning the number of
> > + * successful completions in @reqs_complete
> > + */
> > +int ceph_osdc_wait_requests(struct list_head *osd_reqs,
> > +                           unsigned int *reqs_complete)
> > +{
> > +       struct ceph_osd_request *req;
> > +       int ret = 0, err;
> > +       unsigned int counter = 0;
> > +
> > +       while (!list_empty(osd_reqs)) {
> > +               req = list_first_entry(osd_reqs,
> > +                                      struct ceph_osd_request,
> > +                                      r_private_item);
> > +               list_del_init(&req->r_private_item);
> > +               err = ceph_osdc_wait_request(req->r_osdc, req);
> > +               if (!err)
> > +                       counter++;
> 
> I think you want to stop incrementing counter after encountering an
> error...
> 
> Thanks,
> 
>                 Ilya

Cheers,
--
Luís
