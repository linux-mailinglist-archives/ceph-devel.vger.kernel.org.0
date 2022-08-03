Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0E3588BA0
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Aug 2022 13:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiHCL7D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Aug 2022 07:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbiHCL66 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Aug 2022 07:58:58 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6C052DCD
        for <ceph-devel@vger.kernel.org>; Wed,  3 Aug 2022 04:58:57 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id q14so7011917vke.9
        for <ceph-devel@vger.kernel.org>; Wed, 03 Aug 2022 04:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SOaqVUTcL9QFvzzpI6LAy9r+sn3ZJWM3HkHAF7BI/C4=;
        b=Hy66RQs6doEnDbpMc8A07HKxmbzGXACjjeEdQTTwP1xzPmlR4HSngPhox+e0CBze0X
         IZHou9ubJSbfqbvYVMOJGNR8TA9bEDIaWQwiheSedBpg6V3JZiq4oaksxfujBNb3M6JJ
         W8infO/HvJV1pLaUAG8k68L7NZ+4VFC5wHAnQ3eEHI90NCOoRdbS5VIGtRyR9A5u52fJ
         TnqjeYbrhwEs+Q40ZXLJ0splSe3lccqyZ4V6R/gbH+yV36U7zU4PUBp9QqZv2O90O4mM
         pXNxrPi4JqG3CNA/cQvla9VDBkcDg6YjH319IZKCdXF9Hve6dp+wxuvnDcD+ymMfjm9d
         tzyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SOaqVUTcL9QFvzzpI6LAy9r+sn3ZJWM3HkHAF7BI/C4=;
        b=6gJ8DYkEh44cvcgXBfOL0NaAv7Smo12k3gssnYKqoEAy0qhO3zn501knzyE+lGLuzw
         ASztJR2I8KV07+ppJw+RsFvtt5PxYO2rZD+m4vu3GERvf6Kl6ZvJyu1vI45qiig5nNkC
         p8dWZmaIHwCA+WGyXUJnxh4G/crkOixwy/g34wfbkQ3vFtrAykp7Vr9Aa3DQtXtJ0vJu
         Y0dS1YuxMLlFrLP5yYzJS8PRSMpXdlUwP0FcA+GT/6vsNgDnf5gUc6WIXhQj00N9jWUP
         QDay6TcrDHocVMkozpUVlLs7MYdzZ6aGhPp3s24kWz/DRXQ5CKwokt5dRmUaInMhsLFP
         Wfuw==
X-Gm-Message-State: AJIora/UK/UnMDhSiTjrfBXBs3LxARqPvr2mCbFXO3eRah/s9dX19PYW
        wFvwtPI+c7I+JBfbBaVCujSakkYbd4+BpDtdKhA=
X-Google-Smtp-Source: AGRyM1v1nmEmbJLN5JOJme4Zt9I6UEP5ryQI81APxacGN0yb01VWTZVWVWxWg5wGKWCodXQAkfJSMBHH3IS50LQWXfM=
X-Received: by 2002:a1f:5543:0:b0:36f:e4cb:cbd6 with SMTP id
 j64-20020a1f5543000000b0036fe4cbcbd6mr9084460vkb.23.1659527936226; Wed, 03
 Aug 2022 04:58:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220630202150.653547-1-jlayton@kernel.org> <CAOi1vP_PETHhCm3nUm5B_t0tMJQdmdBxsAmMpbPoGTD1WimMpg@mail.gmail.com>
 <95c06864af1704c9752c14e48e80817f363ce450.camel@kernel.org>
In-Reply-To: <95c06864af1704c9752c14e48e80817f363ce450.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Aug 2022 13:58:44 +0200
Message-ID: <CAOi1vP_XCcQS5_0opDmvqqR7VPHoJVA3mvU3s-MuL9YOiZi=-A@mail.gmail.com>
Subject: Re: [PATCH] libceph: clean up ceph_osdc_start_request prototype
To:     Jeff Layton <jlayton@kernel.org>
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 3, 2022 at 1:15 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2022-08-03 at 09:13 +0200, Ilya Dryomov wrote:
> > On Thu, Jun 30, 2022 at 10:21 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > This function always returns 0, and ignores the nofail boolean. Drop the
> > > nofail argument, make the function void return and fix up the callers.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  drivers/block/rbd.c             |  6 +++---
> > >  fs/ceph/addr.c                  | 32 ++++++++++++--------------------
> > >  fs/ceph/file.c                  | 32 +++++++++++++-------------------
> > >  include/linux/ceph/osd_client.h |  5 ++---
> > >  net/ceph/osd_client.c           | 15 ++++++---------
> > >  5 files changed, 36 insertions(+), 54 deletions(-)
> > >
> > > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > > index 91e541aa1f64..a8af0329ab77 100644
> > > --- a/drivers/block/rbd.c
> > > +++ b/drivers/block/rbd.c
> > > @@ -1297,7 +1297,7 @@ static void rbd_osd_submit(struct ceph_osd_request *osd_req)
> > >         dout("%s osd_req %p for obj_req %p objno %llu %llu~%llu\n",
> > >              __func__, osd_req, obj_req, obj_req->ex.oe_objno,
> > >              obj_req->ex.oe_off, obj_req->ex.oe_len);
> > > -       ceph_osdc_start_request(osd_req->r_osdc, osd_req, false);
> > > +       ceph_osdc_start_request(osd_req->r_osdc, osd_req);
> > >  }
> > >
> > >  /*
> > > @@ -2081,7 +2081,7 @@ static int rbd_object_map_update(struct rbd_obj_request *obj_req, u64 snap_id,
> > >         if (ret)
> > >                 return ret;
> > >
> > > -       ceph_osdc_start_request(osdc, req, false);
> > > +       ceph_osdc_start_request(osdc, req);
> > >         return 0;
> > >  }
> > >
> > > @@ -4768,7 +4768,7 @@ static int rbd_obj_read_sync(struct rbd_device *rbd_dev,
> > >         if (ret)
> > >                 goto out_req;
> > >
> > > -       ceph_osdc_start_request(osdc, req, false);
> > > +       ceph_osdc_start_request(osdc, req);
> > >         ret = ceph_osdc_wait_request(osdc, req);
> > >         if (ret >= 0)
> > >                 ceph_copy_from_page_vector(pages, buf, 0, ret);
> > > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > > index fe6147f20dee..66dc7844fcc6 100644
> > > --- a/fs/ceph/addr.c
> > > +++ b/fs/ceph/addr.c
> > > @@ -357,9 +357,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
> > >         req->r_inode = inode;
> > >         ihold(inode);
> > >
> > > -       err = ceph_osdc_start_request(req->r_osdc, req, false);
> > > -       if (err)
> > > -               iput(inode);
> > > +       ceph_osdc_start_request(req->r_osdc, req);
> > >  out:
> > >         ceph_osdc_put_request(req);
> > >         if (err)
> >
> > Hi Jeff,
> >
> > I'm confused by this err != 0 check.  Previously err was set to 0
> > by ceph_osdc_start_request() and netfs_subreq_terminated() was never
> > called after an OSD request submission.  Now it is called, but only if
> > len != 0?
> >
> > I see that netfs_subreq_terminated() accepts either the amount of data
> > transferred or an error code but it also has some transferred_or_error
> > == 0 handling which this check effectively disables.  And do we really
> > want to account for transferred data before the transfer occurs?
> >
>
> No we don't. I think you're correct. What I'm not sure of is why this
> doesn't cause test failures all over the place.

This is due to "libceph: add new iov_iter-based ceph_msg_data_type and
ceph_osd_data_type" and "ceph: use osd_req_op_extent_osd_iter for netfs
reads" end up fixing it later by removing iov_iter_get_pages_alloc()
call.  I think because these commits were backed out of testing at one
point and re-added later, the order got messed up by accident.

Thanks,

                Ilya
