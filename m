Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A1E49D248
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jan 2022 20:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243623AbiAZTJz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jan 2022 14:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiAZTJz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jan 2022 14:09:55 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1B2C06161C
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 11:09:54 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id e17so508028uad.9
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 11:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/g+LV4onX8yjqCK/Da7/6s3PAqF35jNCd2Ups5M2qFs=;
        b=eewQ2w8c0NpU9FQmUJK3YAIYaITGR/gcayc1Z5XSL+PXQZ9GrBMS5UPkijKu+lKFQl
         M5cFpDeDZeguiayDrgB4gAWwAW373FwO3O/TPGrMWqYsexuswsjSnAOCHMuIrul7A4D+
         MW7gaTlXa33XIihuQYIPA/qSY7imGMowMp23df5yxXypB5GdqD7gZshjvksFigrLMOdO
         CbWX3vB0XIXfwppd3MkJjM9aOHI3Y5IgBqUrq2Im7k32ZigD461wSptPqMcBZ0XY7U+g
         mCCfdz4cB96b0sN1ublvqqALWPp9GTPnsruyyzMvQSrzgwf/sw6gBQ3EtB4k/gKiwxrK
         Nq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/g+LV4onX8yjqCK/Da7/6s3PAqF35jNCd2Ups5M2qFs=;
        b=vN9zkeMqEAVUXCApTk6n9m+0Py6R0nKumfJJCttVVI3VbHPrrJj1csCuSzY6/UCZ+S
         qH54/3pCDwuis5M1WfIiJ0xLaCOlxozcbcOiU/55O20B/wT6kAq5VOXNacFnhT8bGbeq
         L8OaWWIB39NLR+l70qw9PvWpVxYXeREpoy0kCDzNZ8f9IqC/W16sBfcMm0casUZG6Hd7
         E5a3xL1SQCLDR8x1U+Ver41FwzXnutakXtsz4hzO32TooCm2PZQiaK9eLZ9ncSF/D4U/
         ZvMkyF+TaIE2Nj1lc1qwcU4bqkjVFBfhFsCBkaU28n3c03piW5ETn1ULGGreCF1bUodE
         uSLw==
X-Gm-Message-State: AOAM533SQMnrJXp6ryWLiTqj2jc0yrwRPyEUDh4DWSFLeW3MRM3+enQK
        IQ0lcR8MNwc/PoPhJ3oHoNGKTRggxLF2Hs5Zt0DLNVr4rqY=
X-Google-Smtp-Source: ABdhPJyZ3oWyb0oeD0xLVg8vG77UaTHV7dX1RnF2RLrEvLyAXfIuhhuKBFqgVCPILz9XFYOZrPgPHrHGk6KU+NLyGpc=
X-Received: by 2002:a67:d21e:: with SMTP id y30mr250803vsi.47.1643224194106;
 Wed, 26 Jan 2022 11:09:54 -0800 (PST)
MIME-Version: 1.0
References: <20220126173649.163500-1-jlayton@kernel.org>
In-Reply-To: <20220126173649.163500-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 26 Jan 2022 20:10:02 +0100
Message-ID: <CAOi1vP8vpnF09H42wCSNNRnfziUSnB6-7BrOjNQ98yVso23rrQ@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: set pool_ns in new inode layout for async creates
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan van der Ster <dan@vanderster.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 26, 2022 at 6:36 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Dan reported that he was unable to write to files that had been
> asynchronously created when the client's OSD caps are restricted to a
> particular namespace.
>
> The issue is that the layout for the new inode is only partially being
> filled. Ensure that we populate the pool_ns_data and pool_ns_len in the
> iinfo before calling ceph_fill_inode.
>
> URL: https://tracker.ceph.com/issues/54013
> Reported-by: Dan van der Ster <dan@vanderster.com>
> Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> v2: don't take extra reference, just use rcu_dereference_raw
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index cbe4d5a5cde5..22ca724aef36 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -599,6 +599,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>         struct ceph_inode_info *ci = ceph_inode(dir);
>         struct inode *inode;
>         struct timespec64 now;
> +       struct ceph_string *pool_ns;
>         struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>         struct ceph_vino vino = { .ino = req->r_deleg_ino,
>                                   .snap = CEPH_NOSNAP };
> @@ -648,6 +649,12 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>         in.max_size = cpu_to_le64(lo->stripe_unit);
>
>         ceph_file_layout_to_legacy(lo, &in.layout);
> +       /* lo is private, so pool_ns can't change */
> +       pool_ns = rcu_dereference_raw(lo->pool_ns);
> +       if (pool_ns) {
> +               iinfo.pool_ns_len = pool_ns->len;
> +               iinfo.pool_ns_data = pool_ns->str;
> +       }
>
>         down_read(&mdsc->snap_rwsem);
>         ret = ceph_fill_inode(inode, NULL, &iinfo, NULL, req->r_session,
> --
> 2.34.1
>

There seems to be a gap in nowsync coverage -- do we have a ticket for
adding a test case for namespace-constrained caps or someone is already
on it?

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
