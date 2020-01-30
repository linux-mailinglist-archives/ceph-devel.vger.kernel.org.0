Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEA614DCAA
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jan 2020 15:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgA3OPo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jan 2020 09:15:44 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:44765 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgA3OPn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jan 2020 09:15:43 -0500
Received: by mail-io1-f67.google.com with SMTP id e7so4103628iof.11;
        Thu, 30 Jan 2020 06:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eDbn66+ZS+nXSxCmLlLabueM3/KUJun483QO8xHqbiQ=;
        b=ayCbSthN1D07Q50RjsKekYgdDnjpXRwpSiTxj8Fg4Wjo601TXnFDYi3ZpQ70TduDzx
         0iO2QzS4IOixGHCqRG8E/uTjChPBkmYzGmHV2MPRYPyVZWLo0IQQrqLQEBdCXEpBVbdf
         YpMDZeLy9IzNAwgjFrlkqOnwMrPGNTxgc9tJcZyNgeLGW4ecrdqwDd3yC9juQ3SAZ7D1
         X2E55fREkV8WE3sOYQnfEE0zg1vfitMMhTEUrBSXNtcnKKPnCMZpy9FFOtXx77kjBYvA
         KI46tnEN8/nKLWtlc4Tp6mI9XwaBPhhE/9A5G0NrPJOLmKKMg6flibX8msO4E7d4HlCU
         qNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eDbn66+ZS+nXSxCmLlLabueM3/KUJun483QO8xHqbiQ=;
        b=bM5xdH7QIpYFXCxjk2qJScOrBAwW6fg9T7kdABTSLAZox1PBJy5//8vVaLJcR3Buy8
         t6e72LAYLg6lc8SOtBerzBYP2BOl6tuNbTXtlRgcrnlE1KvUnXgTeDDbYD9PFTjSoIrp
         PxxILYqcnnJ2iZoww2Aw2N8fefgNRMqlJ8zrhCfVPMzFn3nzO4h/lxK2EAtm4xxZEQ5u
         X4UXsEjifJORki+nCF0qC/tcATPs9owTxelrGPh2mtzvDIF+xB4xUUhxBepMrF5Zsqk4
         tZIluPIurYDcd70P4GPa5zntzhnVlwOAPAhwLn6PW/GNlFOqIHeXUBDbcdkqv4L1GDui
         ARnw==
X-Gm-Message-State: APjAAAWaRFjd055EjcGtqggXvSqCx+wHtRncRdF00ob79VlmWncX9e05
        qZyaeQAqXNXmC0M8wRacbS3tH6YX0tCpgUkhg6SHEyJUL4c=
X-Google-Smtp-Source: APXvYqwwjcKol1eLUrPmgqTQasp3Z+HBWPRDPPc/TV6N1XeGuRauvqRmcmbvoi52aZvuV6+XYUY/yQRVfOIWNmmA8ec=
X-Received: by 2002:a6b:17c4:: with SMTP id 187mr4167678iox.143.1580393742934;
 Thu, 30 Jan 2020 06:15:42 -0800 (PST)
MIME-Version: 1.0
References: <20200129182011.5483-1-lhenriques@suse.com> <20200129182011.5483-2-lhenriques@suse.com>
In-Reply-To: <20200129182011.5483-2-lhenriques@suse.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 30 Jan 2020 15:15:52 +0100
Message-ID: <CAOi1vP92rXoNU7ne-XrOiGH=WzVmMO9h8XnbReeEDO=xAcXHEg@mail.gmail.com>
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

On Wed, Jan 29, 2020 at 7:20 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> Right now the copy_file_range syscall serializes all the OSDs 'copy-from'
> operations, waiting for each request to complete before sending the next
> one.  This patch modifies copy_file_range so that all the 'copy-from'
> operations are sent in bulk and wait for its completion at the end.  This
> will allow significant speed-ups, specially when sending requests to
> different target OSDs.
>
> There's also a throttling mechanism so that OSDs aren't flooded with
> requests when a client performs a big file copy.  Currently the throttling
> mechanism simply waits for the requests when the number of in-flight
> requests reaches (wsize / object size) * 4.
>
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/file.c                  | 34 ++++++++++++++++++++--
>  include/linux/ceph/osd_client.h |  5 +++-
>  net/ceph/osd_client.c           | 50 ++++++++++++++++++++++++---------
>  3 files changed, 72 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 1e6cdf2dfe90..77a16324dcb4 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1943,12 +1943,14 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>         struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
>         struct ceph_object_locator src_oloc, dst_oloc;
>         struct ceph_object_id src_oid, dst_oid;
> +       struct ceph_osd_request *req;
>         loff_t endoff = 0, size;
>         ssize_t ret = -EIO;
>         u64 src_objnum, dst_objnum, src_objoff, dst_objoff;
>         u32 src_objlen, dst_objlen, object_size;
> -       int src_got = 0, dst_got = 0, err, dirty;
> +       int src_got = 0, dst_got = 0, err, dirty, ncopies;
>         bool do_final_copy = false;
> +       LIST_HEAD(osd_reqs);
>
>         if (src_inode->i_sb != dst_inode->i_sb) {
>                 struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
> @@ -2083,6 +2085,12 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>                         goto out_caps;
>         }
>         object_size = src_ci->i_layout.object_size;
> +
> +       /*
> +        * Throttle the object copies: ncopies holds the number of allowed
> +        * in-flight 'copy-from' requests before waiting for their completion
> +        */
> +       ncopies = (src_fsc->mount_options->wsize / object_size) * 4;
>         while (len >= object_size) {
>                 ceph_calc_file_object_mapping(&src_ci->i_layout, src_off,
>                                               object_size, &src_objnum,
> @@ -2097,7 +2105,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>                 ceph_oid_printf(&dst_oid, "%llx.%08llx",
>                                 dst_ci->i_vino.ino, dst_objnum);
>                 /* Do an object remote copy */
> -               err = ceph_osdc_copy_from(
> +               req = ceph_osdc_copy_from(
>                         &src_fsc->client->osdc,
>                         src_ci->i_vino.snap, 0,
>                         &src_oid, &src_oloc,
> @@ -2108,7 +2116,8 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>                         CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
>                         dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
>                         CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> -               if (err) {
> +               if (IS_ERR(req)) {
> +                       err = PTR_ERR(req);
>                         if (err == -EOPNOTSUPP) {

No point in checking for EOPNOTSUPP here, because ceph_osdc_copy_from()
won't ever return that.  This loop needs more massaging and more testing
on old OSDs...

>                                 src_fsc->have_copy_from2 = false;
>                                 pr_notice("OSDs don't support 'copy-from2'; "
> @@ -2117,14 +2126,33 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>                         dout("ceph_osdc_copy_from returned %d\n", err);
>                         if (!ret)
>                                 ret = err;
> +                       /* wait for all queued requests */
> +                       ceph_osdc_wait_requests(&osd_reqs);
>                         goto out_caps;
>                 }
> +               list_add(&req->r_private_item, &osd_reqs);
>                 len -= object_size;
>                 src_off += object_size;
>                 dst_off += object_size;
>                 ret += object_size;

So ret is incremented here, but you have numerious tests where ret is
assigned an error only if ret is 0.  Unless I'm missing something, this
interferes with returning errors from __ceph_copy_file_range().

> +               if (--ncopies == 0) {
> +                       err = ceph_osdc_wait_requests(&osd_reqs);
> +                       if (err) {
> +                               if (!ret)
> +                                       ret = err;
> +                               goto out_caps;
> +                       }
> +                       ncopies = (src_fsc->mount_options->wsize /
> +                                  object_size) * 4;

The object size is constant within a file, so ncopies should be too.
Perhaps introduce a counter instead of recalculating ncopies here?

> +               }
>         }
>
> +       err = ceph_osdc_wait_requests(&osd_reqs);
> +       if (err) {
> +               if (!ret)
> +                       ret = err;
> +               goto out_caps;
> +       }
>         if (len)
>                 /* We still need one final local copy */
>                 do_final_copy = true;
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 5a62dbd3f4c2..25565dbfd65a 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -526,7 +526,8 @@ extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
>                                 struct timespec64 *mtime,
>                                 struct page **pages, int nr_pages);
>
> -int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> +struct ceph_osd_request *ceph_osdc_copy_from(
> +                       struct ceph_osd_client *osdc,
>                         u64 src_snapid, u64 src_version,
>                         struct ceph_object_id *src_oid,
>                         struct ceph_object_locator *src_oloc,
> @@ -537,6 +538,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>                         u32 truncate_seq, u64 truncate_size,
>                         u8 copy_from_flags);
>
> +int ceph_osdc_wait_requests(struct list_head *osd_reqs);
> +
>  /* watch/notify */
>  struct ceph_osd_linger_request *
>  ceph_osdc_watch(struct ceph_osd_client *osdc,
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index b68b376d8c2f..c123e231eaf4 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5346,23 +5346,47 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
>         return 0;
>  }
>
> -int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> -                       u64 src_snapid, u64 src_version,
> -                       struct ceph_object_id *src_oid,
> -                       struct ceph_object_locator *src_oloc,
> -                       u32 src_fadvise_flags,
> -                       struct ceph_object_id *dst_oid,
> -                       struct ceph_object_locator *dst_oloc,
> -                       u32 dst_fadvise_flags,
> -                       u32 truncate_seq, u64 truncate_size,
> -                       u8 copy_from_flags)
> +int ceph_osdc_wait_requests(struct list_head *osd_reqs)
> +{
> +       struct ceph_osd_request *req;
> +       int ret = 0, err;
> +
> +       while (!list_empty(osd_reqs)) {
> +               req = list_first_entry(osd_reqs,
> +                                      struct ceph_osd_request,
> +                                      r_private_item);
> +               list_del_init(&req->r_private_item);
> +               err = ceph_osdc_wait_request(req->r_osdc, req);
> +               if (err) {
> +                       if (!ret)
> +                               ret = err;
> +                       dout("copy request failed (err=%d)\n", err);

This dout needs updating, but I'd just remove it.  The error code is
there in other messages.

> +               }
> +               ceph_osdc_put_request(req);
> +       }
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL(ceph_osdc_wait_requests);

Move this function after ceph_osdc_wait_request(), so that they are
close to each other (and osd_req_op_copy_from_init() isn't separated
from ceph_osdc_copy_from() by something unrelated).

Thanks,

                Ilya
