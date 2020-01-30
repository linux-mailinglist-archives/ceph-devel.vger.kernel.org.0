Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C36E14DE46
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jan 2020 16:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgA3P7w (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jan 2020 10:59:52 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:39072 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgA3P7w (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jan 2020 10:59:52 -0500
Received: by mail-il1-f194.google.com with SMTP id f70so3473064ill.6;
        Thu, 30 Jan 2020 07:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h9xiE7btg/VKDmdoMWriAUdoA021pLjPXiRTvTp+Dac=;
        b=FG/NIHDAA1vnW0gjTFOtiJ0uIARPjaf/WJ36Sy+bsFtZZNQMGhzaQ2AI0r0HzeptaP
         iUr1U9ue00WrRmmu56EhzUvtW06OQDnMy0JLQtQtw+aqjiHcSN9Lz4WFbZ7OtvPi57Cq
         ChFKneMWW1k+/2RMKbDIegaVQbAY2HR3edPqK7JB3Yv+7b54CQMC93ZctElsjPCcT8B9
         w8rCuZltK9ud/TPEuUI1uqLaVGY9xzCDAnLzYdwCHRDAPM4g+lTwd7ndZ282rWwx5m2B
         LyfU5YaOcu1GInYzkprf/qcqdcAO3wX86OX71YZE8KAtZsphetQwawfZqGtrMEGmq7cS
         XBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h9xiE7btg/VKDmdoMWriAUdoA021pLjPXiRTvTp+Dac=;
        b=NrM91NZJo98HbX9EuZgWHTJwiO+KkSDeeskO7G4DlhsAZpSAS9924qjT7CSerRnRGH
         UTF8xr0SXlrd1ucRAL8lvCGAJ7K1nPrOB6XZSRtkFNBSqt96rARaPR7DpAw9yk9ma43u
         fqQruYoeSrlXVS7ku1fbnGTS8ihGdKCZfCsn+Oh/5te0YpSWUKtXKYQVLJRBVUJYDQgT
         Ws8giYXgf6hc6seaXxKU+dtCMqVbPqnC9tPe6KWPZT32gdMS9O7Rc2rfnTJTuM++Rytf
         PzDc5xF7joYU6ziA2Ye00VbJOh4gaB1kF10rHk7f+ecryjhVDm+d4CFCIqP05U7wfztq
         xUvQ==
X-Gm-Message-State: APjAAAUM+M8vhCBLEqG1rTTpl85DeXYKGFbvwhv7D0kvLIwdvli7AONg
        8wwLOaUo27eW1QWVOLT0H4lfEZY9AvqFyHdF3XY=
X-Google-Smtp-Source: APXvYqy/QMACcFjOR4mDU/gf+9XAjBrXKSk3u6zwCAdJDeo3+L7+b+Nz3LWjgHn9qLrNbLv8w6ZLwNW4Prc7NOvG+oE=
X-Received: by 2002:a92:b749:: with SMTP id c9mr4956376ilm.143.1580399990020;
 Thu, 30 Jan 2020 07:59:50 -0800 (PST)
MIME-Version: 1.0
References: <20200129182011.5483-1-lhenriques@suse.com> <20200129182011.5483-2-lhenriques@suse.com>
 <CAOi1vP92rXoNU7ne-XrOiGH=WzVmMO9h8XnbReeEDO=xAcXHEg@mail.gmail.com> <20200130153711.GA20170@suse.com>
In-Reply-To: <20200130153711.GA20170@suse.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 30 Jan 2020 16:59:59 +0100
Message-ID: <CAOi1vP9+MkjrsH662zpkNLu2=RJA91dKuPo+ra7rXxFcEqxWLA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ceph: parallelize all copy-from requests in copy_file_range
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

On Thu, Jan 30, 2020 at 4:37 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> On Thu, Jan 30, 2020 at 03:15:52PM +0100, Ilya Dryomov wrote:
> > On Wed, Jan 29, 2020 at 7:20 PM Luis Henriques <lhenriques@suse.com> wrote:
> > >
> > > Right now the copy_file_range syscall serializes all the OSDs 'copy-from'
> > > operations, waiting for each request to complete before sending the next
> > > one.  This patch modifies copy_file_range so that all the 'copy-from'
> > > operations are sent in bulk and wait for its completion at the end.  This
> > > will allow significant speed-ups, specially when sending requests to
> > > different target OSDs.
> > >
> > > There's also a throttling mechanism so that OSDs aren't flooded with
> > > requests when a client performs a big file copy.  Currently the throttling
> > > mechanism simply waits for the requests when the number of in-flight
> > > requests reaches (wsize / object size) * 4.
> > >
> > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > ---
> > >  fs/ceph/file.c                  | 34 ++++++++++++++++++++--
> > >  include/linux/ceph/osd_client.h |  5 +++-
> > >  net/ceph/osd_client.c           | 50 ++++++++++++++++++++++++---------
> > >  3 files changed, 72 insertions(+), 17 deletions(-)
> > >
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 1e6cdf2dfe90..77a16324dcb4 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -1943,12 +1943,14 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >         struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
> > >         struct ceph_object_locator src_oloc, dst_oloc;
> > >         struct ceph_object_id src_oid, dst_oid;
> > > +       struct ceph_osd_request *req;
> > >         loff_t endoff = 0, size;
> > >         ssize_t ret = -EIO;
> > >         u64 src_objnum, dst_objnum, src_objoff, dst_objoff;
> > >         u32 src_objlen, dst_objlen, object_size;
> > > -       int src_got = 0, dst_got = 0, err, dirty;
> > > +       int src_got = 0, dst_got = 0, err, dirty, ncopies;
> > >         bool do_final_copy = false;
> > > +       LIST_HEAD(osd_reqs);
> > >
> > >         if (src_inode->i_sb != dst_inode->i_sb) {
> > >                 struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
> > > @@ -2083,6 +2085,12 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >                         goto out_caps;
> > >         }
> > >         object_size = src_ci->i_layout.object_size;
> > > +
> > > +       /*
> > > +        * Throttle the object copies: ncopies holds the number of allowed
> > > +        * in-flight 'copy-from' requests before waiting for their completion
> > > +        */
> > > +       ncopies = (src_fsc->mount_options->wsize / object_size) * 4;
> > >         while (len >= object_size) {
> > >                 ceph_calc_file_object_mapping(&src_ci->i_layout, src_off,
> > >                                               object_size, &src_objnum,
> > > @@ -2097,7 +2105,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >                 ceph_oid_printf(&dst_oid, "%llx.%08llx",
> > >                                 dst_ci->i_vino.ino, dst_objnum);
> > >                 /* Do an object remote copy */
> > > -               err = ceph_osdc_copy_from(
> > > +               req = ceph_osdc_copy_from(
> > >                         &src_fsc->client->osdc,
> > >                         src_ci->i_vino.snap, 0,
> > >                         &src_oid, &src_oloc,
> > > @@ -2108,7 +2116,8 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >                         CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > >                         dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> > >                         CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> > > -               if (err) {
> > > +               if (IS_ERR(req)) {
> > > +                       err = PTR_ERR(req);
> > >                         if (err == -EOPNOTSUPP) {
> >
> > No point in checking for EOPNOTSUPP here, because ceph_osdc_copy_from()
> > won't ever return that.  This loop needs more massaging and more testing
> > on old OSDs...
>
> Right, I missed that.  Setting src_fsc->have_copy_from2 to false should be
> moved into the two 'if (err)' statements following the calls to
> ceph_osdc_wait_requests.  I'll go fix that.  And test it with on a cluster
> with OSDs that don't have this copy-from2 operation.
>
> > >                                 src_fsc->have_copy_from2 = false;
> > >                                 pr_notice("OSDs don't support 'copy-from2'; "
> > > @@ -2117,14 +2126,33 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >                         dout("ceph_osdc_copy_from returned %d\n", err);
> > >                         if (!ret)
> > >                                 ret = err;
> > > +                       /* wait for all queued requests */
> > > +                       ceph_osdc_wait_requests(&osd_reqs);
> > >                         goto out_caps;
> > >                 }
> > > +               list_add(&req->r_private_item, &osd_reqs);
> > >                 len -= object_size;
> > >                 src_off += object_size;
> > >                 dst_off += object_size;
> > >                 ret += object_size;
> >
> > So ret is incremented here, but you have numerious tests where ret is
> > assigned an error only if ret is 0.  Unless I'm missing something, this
> > interferes with returning errors from __ceph_copy_file_range().
>
> Well, the problem is that an error may occur *after* we have already done
> some copies.  In that case we need to return the number of bytes that have
> been successfully copied instead of an error; eventually, subsequent calls
> to complete the copy_file_range will then return the error.  At least this
> is how I understood the man page (i.e. similar to the write(2) syscall).

AFAICS ret is incremented before you know that *any* of the copies were
successful.  If the first copy fails, how do you report that error?

>
> > > +               if (--ncopies == 0) {
> > > +                       err = ceph_osdc_wait_requests(&osd_reqs);
> > > +                       if (err) {
> > > +                               if (!ret)
> > > +                                       ret = err;
> > > +                               goto out_caps;
> > > +                       }
> > > +                       ncopies = (src_fsc->mount_options->wsize /
> > > +                                  object_size) * 4;
> >
> > The object size is constant within a file, so ncopies should be too.
> > Perhaps introduce a counter instead of recalculating ncopies here?
>
> Not sure I understood your comment.  You would rather have:
>
>  * ncopies initialized only once outside the loop
>  * have a counter counting the number of objects copied
>  * call ceph_osdc_wait_requests() when this counter is a multiple of
>    ncopies

I was thinking of a counter that is initialized to ncopies and reset to
ncopies any time it reaches 0.  This is just a nit though.

Thanks,

                Ilya
